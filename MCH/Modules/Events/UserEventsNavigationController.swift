//
//  UserEventsNavigationControllerController.swift
//  MCH
//
//  Created by  a.khodko on 12.06.2021.
//

import UIKit

class UserEventsNavigationController: UINavigationController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        makeTabBarItem()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.tintColor = UIColor.Brand.black
        navigationBar.prefersLargeTitles = true
    }
    
    private func makeTabBarItem() {
        let item = UITabBarItem()
        item.title = "Мои мероприятия"
        item.image = UIImage(named: "UserEvents")
        tabBarItem = item
    }
}
