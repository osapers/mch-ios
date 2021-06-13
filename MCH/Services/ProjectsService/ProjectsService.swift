//
//  ProjectsService.swift
//  MCH
//
//  Created by  a.khodko on 13.06.2021.
//

import Alamofire
import Combine
import Foundation

final class ProjectsService {
    
    private let networkService: NetworkService
    private let projectsChangeSubject = PassthroughSubject<Void, Never>()
    
    private(set) var events: [Event] = []
    private var cancellableBag: [AnyCancellable] = []
        
    init(networkService: NetworkService) {
        self.networkService = networkService

    }
}

extension ProjectsService {
    
    var projectsChangePublisher: AnyPublisher<Void, Never> {
        projectsChangeSubject.eraseToAnyPublisher()
    }

    func obtainProjects() -> AnyPublisher<Void, Never> {
        networkService
            .obtainEvents()
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}

