//
//  String.swift
//  MCH
//
//  Created by  a.khodko on 13.06.2021.
//

import UIKit
import Foundation

extension String {
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}

extension Optional where Wrapped == String {
    
    var isEmptyOrNil: Bool {
        self == nil || self?.replacingOccurrences(of: " ", with: "") == ""
    }
    
    var isEmail: Bool {
        guard let self = self else {
            return false
        }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}

public extension String {

    func styled(
        _ textStyle: TextStyle,
        textColor: UIColor? = nil,
        backgroundColor: UIColor? = nil,
        alignment: NSTextAlignment? = nil,
        lineBreakMode: NSLineBreakMode? = nil
    ) -> NSAttributedString {
        return NSAttributedString(
            string: self,
            attributes: textStyle.attributes(
                textColor: textColor,
                backgroundColor: backgroundColor,
                alignment: alignment,
                lineBreakMode: lineBreakMode
            )
        )
    }
}
