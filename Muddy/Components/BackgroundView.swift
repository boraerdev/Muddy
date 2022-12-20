//
//  BackgroundView.swift
//  Muddy
//
//  Created by Bora Erdem on 20.12.2022.
//

import Foundation
import LBTATools
import UIKit

final class BackgrounView: UIView {
    
    let circleSize: CGFloat = 500
    private lazy var circle1 = CircleView(color: .gray.withAlphaComponent(0.4))
    private lazy var circle2 = CircleView(color: .gray)
    private lazy var blackView = UIView(backgroundColor: .black.withAlphaComponent(0.5))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(circle1)
        addSubview(circle2)
        circle1.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: -50), size: .init(width: circleSize, height: circleSize))
        circle2.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: -50, bottom: 0, right: 0), size: .init(width: circleSize, height: circleSize))
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
        stack(blurView)
        addSubview(blackView)
        blackView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class CircleView: UIView {
    var color: UIColor?
    
    init(color: UIColor) {
        super.init(frame: .zero)
        self.color = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        color!.setFill()
        path.fill()
    }
}

