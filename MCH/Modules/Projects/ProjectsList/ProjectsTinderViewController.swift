//
//  ProjectsTinderViewController.swift
//  MCH
//
//  Created by  a.khodko on 13.06.2021.
//

import UIKit
import Shuffle_iOS

class ProjectsTinderViewController: UIViewController {

    let cardStack = SwipeCardStack().configureForAutoLayout()
    let shadowView = UIView().configureForAutoLayout()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Проекты"
        view.backgroundColor = .white
        view.addSubview(cardStack)
        cardStack.autoPinEdgesToSuperviewMargins(with: UIEdgeInsets(top: 16, left: 0, bottom: 8, right: 0))
        cardStack.clipsToBounds = false
        cardStack.frame = view.safeAreaLayoutGuide.layoutFrame
        cardStack.dataSource = self
        setupShadowView()

        cardStack.isHidden = true
        shadowView.isHidden = true
        let loadingView = startLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.cardStack.isHidden = false
            self.shadowView.isHidden = false
            self.stopLoading(loadingView: loadingView)
        }
    
        // id
        // тэги ()
        // отрасль industy
        // название name
        // имейдж image
        // автор owner
        // члены member
        // описание description
        // readiness_stage -
        // дата запсука launch_date
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        shadowView.layer.shadowPath = UIBezierPath(
            roundedRect: shadowView.bounds,
            byRoundingCorners: .allCorners,
            cornerRadii: CGSize(width: 8, height: 8)
        ).cgPath
    }
    
    @objc func card() -> SwipeCard {
        let card = SwipeCard()
        card.clipsToBounds = false
        card.swipeDirections = [.left, .right]
        let content = UIView()
        content.backgroundColor = .white
        let label = UILabel().configureForAutoLayout()
        label.text = "hello world"
        content.addSubview(label)
        label.autoCenterInSuperview()
        
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
}

extension ProjectsTinderViewController: SwipeCardStackDataSource, SwipeCardStackDelegate {

    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
      return card()
    }

    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        return 50
    }

    func cardStack(_ cardStack: SwipeCardStack, didSelectCardAt index: Int) { }
    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) { }
    func cardStack(_ cardStack: SwipeCardStack, didUndoCardAt index: Int, from direction: SwipeDirection) { }
    func didSwipeAllCards(_ cardStack: SwipeCardStack) { }
}
