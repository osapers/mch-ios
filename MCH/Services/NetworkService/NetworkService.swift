//
//  NetworkService.swift
//  MCH
//
//  Created by  a.khodko on 12.06.2021.
//

import Foundation
import Combine

final class NetworkService: INetworkService {

    func loadEvents() -> AnyPublisher<[Event], Never> {
        Future<[Event], Never> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                promise(
                    .success([Event(), Event(), Event(), Event(), Event(), Event(), Event(), Event(), Event()])
                )
            }
        }.eraseToAnyPublisher()
    }

    func participateInEvent(event: Event) -> AnyPublisher<Void, Never> {
        Future<Void, Never> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                promise(
                    .success(())
                )
            }
        }.eraseToAnyPublisher()
    }
}
