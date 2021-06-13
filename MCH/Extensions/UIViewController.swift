//
//  UIViewController.swift
//  MCH
//
//  Created by  a.khodko on 12.06.2021.
//

import UIKit
import Alamofire

extension UIViewController {
    
    var dependencies: DependenciesFactory {
        DependenciesFactory.shared
    }
    
    func startLoading() -> UIViewController {
        let child = SpinnerViewController()
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        return child
    }
    
    func stopLoading(loadingView: UIViewController) {
        loadingView.willMove(toParent: nil)
        loadingView.view.removeFromSuperview()
        loadingView.removeFromParent()
    }
    
    func showError(error: AFError) {
        let alert = UIAlertController(title: "Ошибка", message: error.errorDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "ОК", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func handleError(error: AFError, loadingView: UIViewController) {
        stopLoading(loadingView: loadingView)
        showError(error: error)
    }
}
