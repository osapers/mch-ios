//
//  DependenciesFactory.swift
//  MCH
//
//  Created by  a.khodko on 12.06.2021.
//

import Foundation

final class DependenciesFactory {

    static let shared = DependenciesFactory()
    lazy var eventsParticipationService = EventsParticipationService(networkService: networkService())

    private init() { }

    func networkService() -> NetworkService {
        NetworkService(authStorage: authStorage())
    }

    func authStorage() -> AuthStorage {
        AuthStorage()
    }

    func eventsService() -> EventsService {
        EventsService(
            networkService: networkService(),
            eventsParticipationService: eventsParticipationService
        )
    }
}
