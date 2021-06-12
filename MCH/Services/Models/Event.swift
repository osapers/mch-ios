//
//  Event.swift
//  MCH
//
//  Created by  a.khodko on 12.06.2021.
//

import Foundation
import UIKit

struct Event: Decodable {

    let imageURL: URL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/3/33/Vanamo_Logo.png")!
    let name: String = "Название события"
    let shortDescription: String = "Короткое описание"
    let longDescription: String = "Длинное описание +79000000000"
    let type: EventType = .webinar
    let date: Date = Date()
    let email: String = "juicyfru@gmail.com"
    let website: String = "www.yandex.ru"
    let address: EventAddress = EventAddress()
    let id: String = "1"
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
        let longitude: Double = 55.4
        let latitude: Double = 33.76
        let description: String = "Улица строителей, дом 56"
    }
}
