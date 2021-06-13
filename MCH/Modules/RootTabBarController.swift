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
    lazy var projectsNavigationController = ProjectsNavigationController()
    lazy var profileNavigationController = ProfileNavigationController()

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = .white
        tabBar.tintColor = UIColor.Brand.green
        viewControllers = [
            eventsNavigationController,
            userEventsNavigationController,
            projectsNavigationController,
            profileNavigationController
        ]

        let eventsListViewController = EventsListViewController()
        eventsNavigationController.viewControllers = [eventsListViewController]
        let _ = eventsListViewController.view
        let _ = eventsNavigationController.view

        let userEventsViewController = UserEventsListViewController()
        userEventsNavigationController.viewControllers = [userEventsViewController]

        projectsNavigationController.viewControllers = [ProjectsListViewController()]
        profileNavigationController.viewControllers = [ProfileViewController()]
    }
}
