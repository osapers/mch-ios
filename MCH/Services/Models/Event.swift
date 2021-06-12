//
//  Event.swift
//  MCH
//
//  Created by  a.khodko on 12.06.2021.
//

import Foundation
import UIKit

struct Event: Decodable {

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
    }

    let imageURL: URL
    let name: String
    let shortDescription: String
    let longDescription: String
    let type: EventType
    let date: Date
    let email: String
    let website: String
    let address: EventAddress
    let id: String
    var isParticipating: Bool = false

    enum EventType: String, Decodable {
        case webinar = "webinar"

        var color: UIColor {
            switch self {
            case .webinar:
                return .red
            }
        }

        var description: String {
            switch self {
            case .webinar:
                return "Вебинар"
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
