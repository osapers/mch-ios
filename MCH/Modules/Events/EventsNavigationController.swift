//
//  EventsNavigationController.swift
//  MCH
//
//  Created by  a.khodko on 12.06.2021.
//

import UIKit

class EventsNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.tintColor = UIColor.Brand.black
        navigationBar.prefersLargeTitles = true
        
        makeTabBarItem()
    }
    
    private func makeTabBarItem() {
        let item = UITabBarItem()
        item.title = "Мероприятия"
        item.image = UIImage(named: "Event")
        tabBarItem = item
    }
}
