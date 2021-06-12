//
//  NetworkService.swift
//  MCH
//
//  Created by  a.khodko on 12.06.2021.
//

import Alamofire
import Foundation
import Combine

final class NetworkService: INetworkService {

    private let baseURL = "http://192.168.1.7:8080/"
    private let session = Session(
        eventMonitors: [AlamofireLogger()]
    )
    private let authStorage: AuthStorage

    init(authStorage: AuthStorage) {
        self.authStorage = authStorage
    }

    private var headers: HTTPHeaders {
        [
            .authorization(bearerToken: authStorage.token ?? ""),
            .contentType("application/json"),
            .accept("application/json")
        ]
    }

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

    func auth(login: String, password: String) -> AnyPublisher<AuthResponse, AFError> {
        Future<AuthResponse, AFError> { [weak self] promise in
            guard let self = self else {
                return
            }

            self.session.request(
                self.baseURL.appending("api/v1/auth"),
                method: .post,
                parameters: AuthParameters(email: login, password: password),
                encoder: JSONParameterEncoder.default,
                headers: self.headers
            )
            .responseDecodable(of: AuthResponse.self) { response in
                promise(response.result)
            }
        }.eraseToAnyPublisher()
    }
}

struct AuthParameters: Encodable {
    let email: String
    let password: String
}

struct AuthResponse: Decodable {

    let data: Data

    struct Data: Decodable {
        enum CodingKeys: String, CodingKey {
            case token
            case isWrongPassword = "is_wrong_password"
            case isNotExists = "is_not_exists"
        }
        let token: String
        let isWrongPassword: Bool
        let isNotExists: Bool
    }
}
