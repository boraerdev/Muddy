//
//  MainButton.swift
//  Muddy
//
//  Created by Bora Erdem on 21.12.2022.
//

import UIKit
import LBTATools

class MainButton: UIButton {

    init(title: String, imgName: String? = nil, tintColor: UIColor = .label, backgroundColor: UIColor = .white) {
        super.init(frame: .zero)

        setTitle(title, for: .normal)
        setTitleColor(tintColor, for: .normal)
        self.tintColor = .label
        self.backgroundColor = backgroundColor
        layer.cornerRadius = 8
        layer.cornerCurve = .continuous
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false

        if (imgName != nil) {
            setImage(UIImage(systemName: imgName!), for: .normal)
            setTitle(" \(title)", for: .normal)
        }
        
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
