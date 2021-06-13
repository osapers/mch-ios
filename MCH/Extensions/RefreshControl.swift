//
//  RefreshControl.swift
//  MCH
//
//  Created by  a.khodko on 13.06.2021.
//

import Foundation
import UIKit

public final class RefreshControl: UIRefreshControl {

    public typealias ValueChangedHandler = (_ sender: RefreshControl) -> Void

    private var valueChangedHandler: ValueChangedHandler?

    public func onValueChange(handler: @escaping ValueChangedHandler) {
        removeTarget(
            self,
            action: #selector(valueChanged),
            for: .valueChanged
        )

        valueChangedHandler = handler

        addTarget(
            self,
            action: #selector(valueChanged),
            for: .valueChanged
        )
    }

    @objc private func valueChanged() {
        valueChangedHandler?(self)
    }
}

