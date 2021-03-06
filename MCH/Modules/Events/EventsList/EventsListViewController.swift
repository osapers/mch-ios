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
    
    lazy var collectionView = UICollectionView(
        frame: view.bounds,
        collectionViewLayout: UICollectionViewLayout.makeTableViewLayout()
    ).configureForAutoLayout()
    private var cancellableBag: [AnyCancellable] = []
    
    lazy var eventsService = dependencies.eventsService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        collectionView.isUserInteractionEnabled = false
        eventsService
            .eventsChangePublisher
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellableBag)
        loadEvents()
        let refreshControl = RefreshControl()
        refreshControl.onValueChange { [weak self] _ in
            self?.loadEvents()
        }
        
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
                self.collectionView.reloadWithAnimation()
                self.collectionView.isUserInteractionEnabled = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.collectionView.refreshControl?.endRefreshing()
                }
            }
            .store(in: &cancellableBag)
    }
}
