//
//  DependenciesFactory.swift
//  MCH
//
//  Created by  a.khodko on 12.06.2021.
//

import Foundation

final class DependenciesFactory {

    static let shared = DependenciesFactory()

    private init() { }

    func networkService() -> INetworkService {
        NetworkService()
    }

    func authStorage() -> AuthStorage {
        AuthStorage()
    }
}
