//
//  AppDelegate.swift
//  MCH
//
//  Created by  a.khodko on 12.06.2021.
//

import UIKit
import NotificationCenter

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
        application.registerForRemoteNotifications()
        return true
    }
    
    @objc private func handleAuthorization() {
        window?.rootViewController = RootTabBarController()
        window?.makeKeyAndVisible()
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let token = deviceToken.reduce("") { string, byte in
            string + String(format: "%02X", byte)
        }
        print(token)
        // отправка на сервер
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(
            (error as NSError).description
        )
        // нет платного аккаунта apple developer
    }
}
