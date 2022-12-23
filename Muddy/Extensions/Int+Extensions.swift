//
//  Int+Extensions.swift
//  Muddy
//
//  Created by Bora Erdem on 22.12.2022.
//

import Foundation

extension Int {
    func toXhYmin() -> String {
      let hours = self / 60
      let remainingMinutes = self % 60
      return "\(hours)h \(remainingMinutes)min"
    }
}
