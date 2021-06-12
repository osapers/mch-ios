//
//  RootTabBarController.swift
//  MCH
//
//  Created by  a.khodko on 12.06.2021.
//

import UIKit

class RootTabBarController: UITabBarController {

    lazy var eventsNavigationController = EventsNavigationController()
    lazy var userEventsNavigationController = UserEventsNavigationController()

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = .white
        tabBar.tintColor = UIColor.Brand.green
        viewControllers = [eventsNavigationController, userEventsNavigationController]

        let eventsListViewController = EventsListViewController()
        eventsNavigationController.viewControllers = [eventsListViewController]
        let _ = eventsListViewController.view
        let _ = eventsNavigationController.view

        let userEventsViewController = UserEventsListViewController()
        userEventsNavigationController.viewControllers = [userEventsViewController]
        let _ = userEventsNavigationController.view
        let _ = userEventsViewController.view
    }
}
