//
//  UICollectionView.swift
//  MCH
//
//  Created by  a.khodko on 12.06.2021.
//

import UIKit

extension UICollectionViewLayout {
    
    static func makeTableViewLayout() -> UICollectionViewLayout {
        let size = NSCollectionLayoutSize(
            widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
            heightDimension: NSCollectionLayoutDimension.estimated(190)
        )
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
                heightDimension: NSCollectionLayoutDimension.estimated(190)
            ),
            subitem: item,
            count: 1
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16)
        section.interGroupSpacing = 16
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension UICollectionView {
    
    func reloadWithAnimation(completion: (() -> Void)? = nil) {
        performBatchUpdates {
            let indexSet = IndexSet(integersIn: 0...0)
            self.reloadSections(indexSet)
        } completion: { _ in completion?() }
    }
}
