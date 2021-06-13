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
        case isParticipating = "is_participant"
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
        case forum = "forum"
        case session = "session"
        case exhibition = "exhibition"
        case lecture = "lecture"
        case onlineLecture = "online_lecture"
        case demoDay = "demo_day"
        case roundTable = "round_table"
        case strategicSession = "strategic_session"
        
        var color: UIColor {
            switch self {
            case .webinar:
                return UIColor.Brand.backgroundRed
            case .forum:
                return UIColor.Brand.backgroundBlue
            case .session:
                return UIColor.Brand.backgroundGreen
            case .exhibition:
                return UIColor.Brand.backgroundViolet
            case .lecture:
                return UIColor.Brand.backgroundOrange
            case .onlineLecture:
                return UIColor.Brand.backgroundYellow
            case .demoDay:
                return UIColor.Brand.backgroundRed
            case .roundTable:
                return UIColor.Brand.backgroundGreen
            case .strategicSession:
                return UIColor.Brand.backgroundBlue
            }
        }
        
        var description: String {
            switch self {
            case .webinar:
                return "Вебинар"
            case .forum:
                return "Форум"
            case .session:
                return "Сессия"
            case .exhibition:
                return "Выставка"
            case .lecture:
                return "Лекция"
            case .onlineLecture:
                return "On-line лекция"
            case .demoDay:
                return "Демо-день"
            case .roundTable:
                return "Круглый стол"
            case .strategicSession:
                return "Стратегическая сессия"
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

struct EventsResponse: Decodable {
    
    let data: [Event]
}
