//
//  UserService.swift
//  MCH
//
//  Created by  a.khodko on 13.06.2021.
//

import Foundation
import UIKit
import Combine
import Alamofire

final class UserService {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func obtainUser() -> AnyPublisher<User, AFError> {
        networkService.obtainUser()
    }
    
    func updateUser(
        name: String,
        surname: String,
        image: UIImage?,
        email: String
    ) -> AnyPublisher<User, AFError> {
        let resizedImage = image?.resized(toWidth: 300)
        let base64Image = resizedImage?.convertToBase64()
        let user = User(name: name, surname: surname, avatar: base64Image, email: email)
        return networkService.updateUser(user)
    }
}

fileprivate extension UIImage {
    
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func convertToBase64() -> String? {
        return pngData()?.base64EncodedString()
    }
}
