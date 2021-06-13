//
//  Project.swift
//  MCH
//
//  Created by  a.khodko on 13.06.2021.
//

import Foundation
import UIKit

struct Project: Decodable {
    
    // тэги ()
    // отрасль industy
    // автор owner
    // члены member
    // дата запсука launch_date
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "image"
        case name
        case description = "description"
        case id
        case readinessStage = "readiness_stage"
        case launchDate = "launch_date"
        case industry
        case tagsIntersection = "tags_intersection"
    }
    
    let imageURL: URL
    let name: String
    let description: String
    let id: String
    let readinessStage: ReadinessStage
    let launchDate: Date
    let industry: String
    let tagsIntersection: [String]?

    let owner = Owner(image: nil, firstName: "Александр", lastName: "Ходько")
    
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

    struct Owner {
        let image: String?
        let firstName: String
        let lastName: String
    }
}

struct ProjectResponse: Decodable {
    
    let data: [Project]
}

