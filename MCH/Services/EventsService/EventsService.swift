//
//  EventsService.swift
//  MCH
//
//  Created by  a.khodko on 13.06.2021.
//

import Alamofire
import Combine
import Foundation

final class EventsService {
    
    private let networkService: NetworkService
    private let eventsParticipationService: EventsParticipationService
    private let eventsChangeSubject = PassthroughSubject<Void, Never>()
    
    private(set) var events: [Event] = []
    private var cancellableBag: [AnyCancellable] = []
    
    init(networkService: NetworkService, eventsParticipationService: EventsParticipationService) {
        self.networkService = networkService
        self.eventsParticipationService = eventsParticipationService
        eventsParticipationService
            .eventParticipationPublisher
            .sink { [weak self] eventID in
                if let self = self {
                    self.events = self.events.map { event in
                        if event.id != eventID {
                            return event
                        }
                        
                        var newEvent = event
                        newEvent.isParticipating = true
                        return newEvent
                    }
                    self.eventsChangeSubject.send(())
                }
            }.store(in: &cancellableBag)
    }
}

extension EventsService {
    
    var eventsChangePublisher: AnyPublisher<Void, Never> {
        eventsChangeSubject.eraseToAnyPublisher()
    }
    
    func obtainEvents() -> AnyPublisher<Void, Never> {
        networkService
            .obtainEvents()
            .handleEvents(
                receiveOutput: { [weak self] events in
                    self?.events = events
                }
            )
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}
