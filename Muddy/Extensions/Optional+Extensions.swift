//
//  Optional+Extensions.swift
//  Muddy
//
//  Created by Bora Erdem on 3.01.2023.
//

import Foundation

extension Optional where Wrapped == String {
    var orNil: String {
        self ?? ""
    }
}
