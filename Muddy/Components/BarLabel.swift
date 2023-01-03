//
//  BarLabel.swift
//  Muddy
//
//  Created by Bora Erdem on 3.01.2023.
//

import UIKit

class BarLabel: UILabel {

    override var intrinsicContentSize: CGSize {
        let superSize = super.intrinsicContentSize
        return .init(width: superSize.width+20, height: superSize.height+10)
    }
    
    public init(text: String, textColor: UIColor = .white) {
        super.init(frame: .zero)
        self.text = text
        textAlignment = .center
        self.textColor = textColor
        backgroundColor = .systemGray5.withAlphaComponent(0.5)
        withBorder(width: 1, color: .systemGray5)
        layer.cornerRadius = 8
        layer.cornerCurve = .continuous
        font = .systemFont(ofSize: 13, weight: .light)
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
