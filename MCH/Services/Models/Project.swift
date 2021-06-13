//
//  Project.swift
//  MCH
//
//  Created by  a.khodko on 13.06.2021.
//

import Foundation
import UIKit

struct Project: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "image"
        case name
        case shortDescription = "short_description"
        case longDescription = "description"
        case type = "category"
        case date
        case email
        case website
        case address
        case id
        case isParticipating = "is_participant"
    }
    
    let imageURL: URL
    let name: String
    let shortDescription: String
    let longDescription: String
    let type: ReadinessStage
    let date: Date
    let email: String
    let website: String
    let address: EventAddress
    let id: String
    var isParticipating: Bool = false
    
    enum ReadinessStage: String, Decodable {
        case idea
        case demo
        case product
        case scaling
    
        var color: UIColor {
            switch self {
            case .idea:
                return UIColor.Brand.backgroundRed
            case .demo:
                return UIColor.Brand.backgroundYellow
            case .product:
                return UIColor.Brand.backgroundOrange
            case .scaling:
                return UIColor.Brand.backgroundGreen
            }
        }
        
        var description: String {
            switch self {
            case .idea:
                return "Идея"
            case .demo:
                return "Демонстрационный образец"
            case .product:
                return "Продукт"
            case .scaling:
                return "Масштабирование"
            }
        }
    }
    
    struct EventAddress: Decodable {
        enum CodingKeys: String, CodingKey {
            case longitude = "lon"
            case latitude = "lat"
            case description = "raw"
        }
        let longitude: Double
        let latitude: Double
        let description: String
    }
}

struct ProjectResponse: Decodable {
    
    let data: [Project]
}

