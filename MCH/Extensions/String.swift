//
//  String.swift
//  MCH
//
//  Created by  a.khodko on 13.06.2021.
//

import Foundation

extension String {

    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}
