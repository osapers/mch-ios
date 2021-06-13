//
//  NetworkService.swift
//  MCH
//
//  Created by  a.khodko on 12.06.2021.
//

import Alamofire
import Foundation
import Combine

final class NetworkService {
    
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
    
    func obtainEvents() -> AnyPublisher<[Event], Never> {
        let endpoint = baseURL.appending("api/v1/events")
        let headers = self.headers
        return Future<EventsResponse, AFError> { [weak self] promise in
            self?.session.request(
                endpoint,
                method: .get,
                headers: headers
            )
            .responseDecodable(of: EventsResponse.self) { response in
                promise(response.result)
            }
        }
        .map { $0.data }
        .replaceError(with: [])
        .eraseToAnyPublisher()
    }
    
    func auth(login: String, password: String) -> AnyPublisher<AuthResponse, AFError> {
        let endpoint = baseURL.appending("api/v1/auth")
        let headers = self.headers
        return Future<AuthResponse, AFError> { [weak self] promise in
            self?.session.request(
                endpoint,
                method: .post,
                parameters: AuthParameters(email: login, password: password),
                encoder: JSONParameterEncoder.default,
                headers: headers
            )
            .responseDecodable(of: AuthResponse.self) { response in
                promise(response.result)
            }
        }.eraseToAnyPublisher()
    }
    
    func participateInEvent(eventID: String) -> AnyPublisher<Void, AFError> {
        let endpoint = baseURL.appending("api/v1/events/\(eventID)/participate")
        let headers = self.headers
        
        return Future<Void, AFError> { [weak self] promise in
            self?.session.request(
                endpoint,
                method: .post,
                headers: headers
            )
            .response { response in
                if let error = response.error {
                    return promise(.failure(error))
                }
                
                promise(.success(()))
            }
        }.eraseToAnyPublisher()
    }
    
    func obtainUser() -> AnyPublisher<User, AFError> {
        let endpoint = baseURL.appending("api/v1/users/me")
        let headers = self.headers
        
        return Future<UserResponse, AFError> { [weak self] promise in
            self?.session.request(
                endpoint,
                method: .get,
                headers: headers
            )
            .responseDecodable(of: UserResponse.self) { response in
                promise(response.result)
            }
        }
        .map { $0.data }
        .eraseToAnyPublisher()
    }
    
    func updateUser(_ user: User) -> AnyPublisher<User, AFError> {
        let endpoint = baseURL.appending("api/v1/users/me")
        let headers = self.headers
        
        return Future<User, AFError> { [weak self] promise in
            self?.session.request(
                endpoint,
                method: .put,
                parameters: user,
                encoder: JSONParameterEncoder.default,
                headers: headers
            )
            .responseDecodable(of: User.self) { response in
                promise(response.result)
            }
        }.eraseToAnyPublisher()
    }
}
