//
//  ProjectListViewController+View.swift
//  MCH
//
//  Created by  a.khodko on 13.06.2021.
//

import UIKit
import PureLayout

extension ProjectsListViewController {
    
    func setupViews() {
        view.addSubview(collectionView)
        collectionView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        collectionView.register(
            EventCollectionViewCell.self,
            forCellWithReuseIdentifier: Constants.reuseIdentifier
        )
        collectionView.register(
            EventShimmerCollectionViewCell.self,
            forCellWithReuseIdentifier: Constants.shimmerReuseIdentifier
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        collectionView.backgroundColor = .white
        setupCreateButton()
        createButton.autoPinEdge(.top, to: .bottom, of: collectionView, withOffset: 16)
        
        navigationItem.title = "Проекты"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Найти",
            style: .plain,
            target: self,
            action: #selector(searchProject)
        )
        view.backgroundColor = .white
    }

    private func setupCreateButton() {
        view.addSubview(createButton)
        createButton.autoSetDimension(.height, toSize: 48)
        createButton.tintColor = .white
        createButton.layer.cornerRadius = 8
        createButton.setTitle("Создать проект", for: .normal)
        createButton.backgroundColor = UIColor.Brand.green
        createButton.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
        createButton.autoPinEdge(toSuperviewEdge: .right, withInset: 16)
        createButton.autoPinEdge(toSuperviewMargin: .bottom, withInset: 16)
    }
}

extension ProjectsListViewController:
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        isLoading ? 10 : eventsService.events.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: isLoading ? Constants.shimmerReuseIdentifier : Constants.reuseIdentifier,
            for: indexPath
        )
        
        (cell as? EventCollectionViewCell).map { cell in
            cell.bindModel(model: eventsService.events[indexPath.row])
            cell.didPressHandler = { [weak self] in
                self.map {
                    let controller = EventViewController()
                    let event = $0.eventsService.events[indexPath.row]
                    controller.event = event
                    controller.hidesBottomBarWhenPushed = true
                    $0.navigationController?.pushViewController(
                        controller,
                        animated: true
                    )
                }
            }
        }
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        (cell as? EventShimmerCollectionViewCell).map { cell in
            cell.setTemplateWithSubviews(true, animate: true, viewBackgroundColor: .systemBackground)
        }
    }
}
