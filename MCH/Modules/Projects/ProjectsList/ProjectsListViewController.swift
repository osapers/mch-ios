//
//  ProjectsListViewController.swift
//  MCH
//
//  Created by  a.khodko on 13.06.2021.
//

import UIKit
import Combine

class ProjectsListViewController: UIViewController {
    
    enum Constants {
        static let reuseIdentifier = "EventCollectionViewCell"
        static let shimmerReuseIdentifier = "EventShimmerCollectionViewCell"
    }

    var isLoading = true
    
    lazy var collectionView = UICollectionView(
        frame: view.bounds,
        collectionViewLayout: UICollectionViewLayout.makeTableViewLayout()
    ).configureForAutoLayout()
    let createButton = UIButton().configureForAutoLayout()

    private var cancellableBag: [AnyCancellable] = []
    
    lazy var eventsService = dependencies.eventsService()
    lazy var projectsService = dependencies.projectsService

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        createButton.addTarget(self, action: #selector(handleCreateButtonTap), for: .touchUpInside)
        eventsService
            .eventsChangePublisher
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellableBag)
        let refreshControl = RefreshControl()
        refreshControl.onValueChange { [weak self] _ in
            self?.loadEvents()
        }

        reloadData()
        collectionView.refreshControl = refreshControl
    }
    
    private func loadEvents() {
        eventsService
            .obtainEvents()
            .sink { [weak self] events in
                guard let self = self else {
                    return
                }
                
                self.isLoading = false
                self.createButton.isHidden = false
                self.collectionView.isUserInteractionEnabled = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.collectionView.reloadWithAnimation()
                    self.collectionView.refreshControl?.endRefreshing()
                }
            }
            .store(in: &cancellableBag)
    }

    @objc func searchProject() {
        let projectsTinderViewController = ProjectsTinderViewController()
        projectsTinderViewController
            .participatePublisher
            .sink { [weak self] _ in
                guard let self = self else {
                    return
                }

                self.isLoading = true
                self.collectionView.reloadData()
                self.collectionView.isUserInteractionEnabled = false
                self.loadEvents()
            }
            .store(in: &cancellableBag)
        navigationController?.pushViewController(projectsTinderViewController, animated: true)
    }

    private func reloadData() {
        isLoading = true
        createButton.isHidden = true
        collectionView.reloadWithAnimation()
        collectionView.isUserInteractionEnabled = false
        loadEvents()
    }

    @objc func handleCreateButtonTap() {
        let alert = UIAlertController(title: "Демо режим создания проекта", message: "Здесь должна открывать форма создания", preferredStyle: .alert)
        let createAction = UIAlertAction(title: "Создать шаблонный проект", style: .default) { _ in
            let loadingView = self.startLoading()
            self.projectsService
                .createProject()
                .sink { [weak self] _ in
                    if let self = self {
                        self.stopLoading(loadingView: loadingView)
                        self.reloadData()
                    }
                }
                .store(in: &self.cancellableBag)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .destructive, handler: nil)
        alert.addAction(createAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}
