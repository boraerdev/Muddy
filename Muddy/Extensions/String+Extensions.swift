//
//  String+Extensions.swift
//  Muddy
//
//  Created by Bora Erdem on 21.12.2022.
//

import UIKit
import LBTATools

extension String {
    func toGenderTitle() -> UILabel {
        return UILabel(text: self, font: .systemFont(ofSize: 17, weight: .bold), textColor: .white, textAlignment: .left, numberOfLines: 1)
    }
}
