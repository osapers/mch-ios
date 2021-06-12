//
//  AppDelegate.swift
//  MCH
//
//  Created by  a.khodko on 12.06.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let rootViewContoller = DependenciesFactory.shared.authStorage().isAuthorized
            ? RootTabBarController() as UIViewController
            : {
                let stack = AuthNavigationController()
                stack.viewControllers = [AuthViewController()]
                return stack
            }()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootViewContoller
        window?.makeKeyAndVisible()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAuthorization),
            name: .userAuthorized,
            object: nil
        )
        return true
    }

    @objc private func handleAuthorization() {
        window?.rootViewController = RootTabBarController()
        window?.makeKeyAndVisible()
    }
}
