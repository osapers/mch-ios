//
//  EventsListViewController.swift
//  MCH
//
//  Created by  a.khodko on 12.06.2021.
//

import UIKit
import Combine

class EventsListViewController: UIViewController {

    enum Constants {
        static let reuseIdentifier = "EventCollectionViewCell"
        static let shimmerReuseIdentifier = "EventShimmerCollectionViewCell"
    }

    var isLoading = true
    var events: [Event] = []

    lazy var collectionView = UICollectionView(
        frame: view.bounds,
        collectionViewLayout: UICollectionViewLayout.makeTableViewLayout()
    ).configureForAutoLayout()
    private var cancellableBag: [AnyCancellable] = []

    private lazy var networkService = dependencies.networkService()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        collectionView.isUserInteractionEnabled = false
        loadEvents()
        let refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(loadEvents), for: .valueChanged)
    }

    @objc private func loadEvents() {
        networkService
            .loadEvents()
            .sink { [weak self] events in
                guard let self = self else {
                    return
                }
                
                self.isLoading = false
                self.events = events
                self.collectionView.refreshControl?.endRefreshing()
                self.collectionView.reloadWithAnimation()
                self.collectionView.isUserInteractionEnabled = true
            }
            .store(in: &cancellableBag)
    }
}
