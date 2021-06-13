//
//  AuthModels.swift
//  MCH
//
//  Created by  a.khodko on 13.06.2021.
//

import Foundation

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
//            case isNotExists = "is_not_exists"
        }
        let token: String
        let isWrongPassword: Bool
//        let isNotExists: Bool
    }
}
