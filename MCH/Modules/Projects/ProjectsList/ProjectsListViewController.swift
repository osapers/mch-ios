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
        static let reuseIdentifier = "ProjectCollectionViewCell"
        static let shimmerReuseIdentifier = "EventShimmerCollectionViewCell"
    }

    var isLoading = true
    
    lazy var collectionView = UICollectionView(
        frame: view.bounds,
        collectionViewLayout: UICollectionViewLayout.makeTableViewLayout()
    ).configureForAutoLayout()
    let createButton = UIButton().configureForAutoLayout()

    private var cancellableBag: [AnyCancellable] = []
    
    lazy var projectsService = dependencies.projectsService
    var projects: [Project] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        createButton.addTarget(self, action: #selector(handleCreateButtonTap), for: .touchUpInside)
        let refreshControl = RefreshControl()
        refreshControl.onValueChange { [weak self] _ in
            self?.loadEvents()
        }

        reloadData()
        collectionView.refreshControl = refreshControl
    }
    
    private func loadEvents() {
        projectsService
            .obtainMyProjects()
            .sink { [weak self] projects in
                guard let self = self else {
                    return
                }
                
                self.projects = projects
                self.isLoading = false
                self.createButton.isHidden = false
                self.collectionView.isUserInteractionEnabled = true
                self.collectionView.reloadWithAnimation()
                self.collectionView.refreshControl?.endRefreshing()
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

                self.projects = []
                self.isLoading = true
                self.collectionView.reloadData()
                self.collectionView.isUserInteractionEnabled = false
                self.projectsService
                    .obtainMyProjects()
                    .sink { [weak self] projects in
                        guard let self = self else {
                            return
                        }
                        
                        self.projects = projects
                        self.isLoading = false
                        self.createButton.isHidden = false
                        self.collectionView.isUserInteractionEnabled = true
                        self.collectionView.reloadData()
                    }
                    .store(in: &self.cancellableBag)
            }
            .store(in: &cancellableBag)
        navigationController?.pushViewController(projectsTinderViewController, animated: true)
    }

    private func reloadData() {
        projects = []
        isLoading = true
        createButton.isHidden = true
        collectionView.reloadWithAnimation()
        collectionView.isUserInteractionEnabled = false
        loadEvents()
    }

    @objc func handleCreateButtonTap() {
        let alert = UIAlertController(title: "Демо режим создания проекта", message: "Здесь должна открываться форма создания", preferredStyle: .alert)
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

extension ProjectsListViewController: ProjectCollectionViewCellDelegate {

    func didTapDeleteAtProject(_ projectID: String) {
        let loadingView = startLoading()
        projectsService
            .removeProject(projectID: projectID)
            .sink { [weak self] _ in
                guard let self = self else {
                    return
                }

                self.stopLoading(loadingView: loadingView)
                self.reloadData()
            }
            .store(in: &cancellableBag)
    }

    func didTapEditAtProject(_ projectID: String) {
        let alert = UIAlertController(title: "Демо режим проекта", message: "Здесь должна открываться форма редактирования", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ОК", style: .destructive, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    func didTapFindUserAtProject(_ projectID: String) {
        
    }

    func didTapChatAtProject(_ projectID: String) {
        let alert = UIAlertController(title: "Демо режим проекта", message: "Здесь должна открываться комната проекта с подтверждением пользователей/чатом", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ОК", style: .destructive, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
