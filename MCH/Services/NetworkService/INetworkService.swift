//
//  INetworkService.swift
//  MCH
//
//  Created by  a.khodko on 12.06.2021.
//

import Combine
import Foundation
import Alamofire

protocol INetworkService {

    func loadEvents() -> AnyPublisher<[Event], Never>

    func participateInEvent(event: Event) -> AnyPublisher<Void, Never>

    func auth(login: String, password: String) -> AnyPublisher<AuthResponse, AFError>
}
