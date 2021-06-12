//
//  UIViewController.swift
//  MCH
//
//  Created by  a.khodko on 12.06.2021.
//

import UIKit

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
}
