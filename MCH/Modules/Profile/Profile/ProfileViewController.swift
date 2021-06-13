//
//  ProfileViewController.swift
//  MCH
//
//  Created by  a.khodko on 13.06.2021.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    func setupViews() {
        navigationItem.title = "Профиль"
        view.backgroundColor = .white
    }
}
