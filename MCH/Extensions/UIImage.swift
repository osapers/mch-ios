//
//  File.swift
//  MCH
//
//  Created by  a.khodko on 13.06.2021.
//

import UIKit

extension UIImage {
    convenience init?(base64String: String) {
        guard !base64String.isEmpty else { return nil }
        guard let data = Data(base64Encoded: base64String) else { return nil }
        self.init(data: data)
    }
}
