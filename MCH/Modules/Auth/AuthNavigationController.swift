//
//  AuthNavigationController.swift
//  MCH
//
//  Created by  a.khodko on 12.06.2021.
//

import UIKit

class AuthNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.tintColor = UIColor.Brand.black
        navigationBar.prefersLargeTitles = true

        makeTabBarItem()
    }

    private func makeTabBarItem() {
        let item = UITabBarItem()
        item.title = "Авторизация"
        item.image = UIImage(named: "Event")
        tabBarItem = item
    }
}
