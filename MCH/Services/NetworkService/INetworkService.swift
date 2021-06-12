//
//  INetworkService.swift
//  MCH
//
//  Created by  a.khodko on 12.06.2021.
//

import Combine
import Foundation

protocol INetworkService {

    func loadEvents() -> AnyPublisher<[Event], Never>

    func participateInEvent(event: Event) -> AnyPublisher<Void, Never>
}
