//
//  ProjectsTinderViewController.swift
//  MCH
//
//  Created by  a.khodko on 13.06.2021.
//

import UIKit
import Shuffle_iOS
import Combine

class ProjectsTinderViewController: UIViewController {

    private let cardStack = SwipeCardStack().configureForAutoLayout()
    private let shadowView = UIView().configureForAutoLayout()

    private var cancellableBag: [AnyCancellable] = []
    private let participateSubject = PassthroughSubject<Void, Never>()
    private lazy var projectsService = dependencies.projectsService
    private var zeroScreen: UIView?

    var dataSource: [Project] = []
    var participatePublisher: AnyPublisher<Void, Never> {
        participateSubject.eraseToAnyPublisher()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Проекты"
        view.backgroundColor = .white
        view.addSubview(cardStack)
        cardStack.autoPinEdgesToSuperviewMargins(with: UIEdgeInsets(top: 16, left: 0, bottom: 8, right: 0))
        cardStack.clipsToBounds = false
        cardStack.frame = view.safeAreaLayoutGuide.layoutFrame
        cardStack.dataSource = self
        cardStack.delegate = self
        setupShadowView()

        cardStack.isHidden = true
        shadowView.isHidden = true
        let loadingView = startLoading()
        projectsService
            .obtainProjects()
            .sink { [weak self] result in
                guard let self = self else {
                    return
                }
                
                self.dataSource = result
                self.cardStack.isHidden = false
                self.shadowView.isHidden = false
                self.cardStack.reloadData()
                self.handleZeroScreen()
                self.stopLoading(loadingView: loadingView)
            }
            .store(in: &cancellableBag)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        shadowView.layer.shadowPath = UIBezierPath(
            roundedRect: shadowView.bounds,
            byRoundingCorners: .allCorners,
            cornerRadii: CGSize(width: 8, height: 8)
        ).cgPath
    }

    private func setupShadowView() {
        view.addSubview(shadowView)
        view.sendSubviewToBack(shadowView)
        shadowView.backgroundColor = .white
        shadowView.autoPinEdgesToSuperviewMargins(with: UIEdgeInsets(top: 16, left: 0, bottom: 8, right: 0))
        shadowView.layer.shadowPath = UIBezierPath(
            roundedRect: shadowView.bounds,
            byRoundingCorners: .allCorners,
            cornerRadii: CGSize(width: 8, height: 8)
        ).cgPath
        shadowView.clipsToBounds = false
        shadowView.layer.shouldRasterize = true
        shadowView.layer.cornerRadius = 8
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 8)
        shadowView.layer.shadowColor = UIColor.Brand.black.cgColor
        shadowView.layer.shadowOpacity = 0.08
        shadowView.layer.shadowRadius = 10
        shadowView.layer.masksToBounds = false
        shadowView.layer.rasterizationScale = UIScreen.main.scale
    }

    private func handleZeroScreen() {
        if !dataSource.isEmpty {
            zeroScreen?.removeFromSuperview()
            return
        }
        
        shadowView.isHidden = true
        cardStack.isHidden = true
        let zeroScreen = UIView().configureForAutoLayout()
        zeroScreen.backgroundColor = .white
        let noResultLabel = UILabel().configureForAutoLayout()
        zeroScreen.addSubview(noResultLabel)
        noResultLabel.attributedText = "На данный момент\nнет подходящих проектов".styled(.label)
        noResultLabel.textAlignment = .center
        noResultLabel.numberOfLines = 0
        noResultLabel.autoCenterInSuperview()
        view.addSubview(zeroScreen)
        zeroScreen.autoPinEdgesToSuperviewMargins()
        view.bringSubviewToFront(zeroScreen)
        self.zeroScreen = zeroScreen
    }

    @objc private func makeCard(for index: Int) -> SwipeCard {
        let project = dataSource[index]
        let view = ProjectTinderView().configureForAutoLayout()
        let card = SwipeCard()
        card.swipeDirections = [.left, .right]
        card.addSubview(view)
        view.autoPinEdgesToSuperviewEdges()
        view.bindModel(model: project)
        let content = UIView()
        content.backgroundColor = .white
        
        card.content = content

        let leftOverlay = UIView()
        leftOverlay.layer.cornerRadius = 8
        leftOverlay.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        
        let rightOverlay = UIView()
        rightOverlay.layer.cornerRadius = 8
        rightOverlay.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        
        card.setOverlays([.left: leftOverlay, .right: rightOverlay])
        
        return card
    }
}

extension ProjectsTinderViewController: SwipeCardStackDataSource, SwipeCardStackDelegate {

    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        makeCard(for: index)
    }

    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        dataSource.count
    }

    func cardStack(_ cardStack: SwipeCardStack, didSelectCardAt index: Int) {
        let alert = UIAlertController(title: "Демо режим просмотра проекта", message: "Здесь должна открываться полная информация о проекте", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
        projectsService
            .markProjectAsViewed(projectID: dataSource[index].id)
            .sink { _ in }
            .store(in: &cancellableBag)
        switch direction {
        case .right:
            projectsService
                .applyToProject(projectID: dataSource[index].id)
                .sink { [weak self] _ in
                    self?.participateSubject.send(())
                }.store(in: &cancellableBag)
        default:
            break
        }
    }

    func didSwipeAllCards(_ cardStack: SwipeCardStack) {
        dataSource = []
        handleZeroScreen()
    }
}
