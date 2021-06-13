//
//  AuthStorage.swift
//  MCH
//
//  Created by  a.khodko on 12.06.2021.
//

import Foundation

final class AuthStorage {
    
    private enum Constants {
        static let kAuthorized = "kAuthorized"
        static let kToken = "kToken"
    }
    
    private lazy var defaults = UserDefaults.standard
    
    var isAuthorized: Bool {
        get {
            defaults.bool(forKey: Constants.kAuthorized)
        }
        set {
            defaults.setValue(newValue, forKey: Constants.kAuthorized)
        }
    }
    
    var token: String? {
        get {
            defaults.string(forKey: Constants.kToken)
        }
        set {
            defaults.setValue(newValue, forKey: Constants.kToken)
        }
    }
}
