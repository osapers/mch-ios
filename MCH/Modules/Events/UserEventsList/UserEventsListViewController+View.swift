//
//  UserEventsListViewController+View.swift
//  MCH
//
//  Created by  a.khodko on 12.06.2021.
//

import UIKit
import PureLayout

extension UserEventsListViewController {

    func setupViews() {
        view.addSubview(collectionView)
        collectionView.autoPinEdgesToSuperviewEdges()
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
        
        navigationItem.title = "Мои мероприятия"
        view.backgroundColor = .white
    }
}

extension UserEventsListViewController:
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        isLoading ? 10 : events.count
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
            cell.bindModel(model: events[indexPath.row])
            cell.didPressHandler = { [weak self] in
                self.map {
                    let controller = EventViewController()
                    let event = $0.events[indexPath.row]
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

