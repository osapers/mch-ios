//
//  User.swift
//  MCH
//
//  Created by  a.khodko on 13.06.2021.
//

import Foundation

struct User: Codable {
    
    enum CodingKeys: String, CodingKey {
        case name = "first_name"
        case surname = "last_name"
        case avatar = "photo"
        case email
        case specializations = "tags"
    }
    
    let name: String
    let surname: String
    let avatar: String?
    let email: String
    var specializations: [String]
}

struct UserResponse: Decodable {
    
    let data: User
}

struct SpecializationsRequest: Encodable {
    
    let query: String
}

struct SpecializationsResponse: Decodable {
    
    let data: [String]
}
