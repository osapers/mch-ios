//
//  EventsParticipationService.swift
//  MCH
//
//  Created by  a.khodko on 13.06.2021.
//

import Alamofire
import Combine
import Foundation

final class EventsParticipationService {
    
    private let networkService: NetworkService
    
    private let eventParticipationSubject = PassthroughSubject<String, Never>()
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension EventsParticipationService {
    
    var eventParticipationPublisher: AnyPublisher<String, Never> {
        eventParticipationSubject.eraseToAnyPublisher()
    }
    
    func participateInEvent(_ event: Event) -> AnyPublisher<Void, AFError> {
        networkService
            .participateInEvent(eventID: event.id)
            .handleEvents(
                receiveOutput: { [weak self] in
                    self?.eventParticipationSubject.send(event.id)
                }
            )
            .eraseToAnyPublisher()
    }
}
