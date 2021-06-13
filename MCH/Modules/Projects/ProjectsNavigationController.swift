//
//  ProjectsNavigationController.swift
//  MCH
//
//  Created by  a.khodko on 13.06.2021.
//

import UIKit

class ProjectsNavigationController: UINavigationController {
    
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
        item.title = "Проекты"
        item.image = UIImage(named: "Projects")
        tabBarItem = item
    }
}

