//
//  UIView+Extensions.swift
//  Muddy
//
//  Created by Bora Erdem on 21.12.2022.
//

import UIKit

extension UIView {
    func setCornerRadius(radius: CGFloat, corners: UIRectCorner) {
      let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
      let mask = CAShapeLayer()
      mask.path = path.cgPath
      self.layer.mask = mask
    }
    
    func insertGradient(colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        
        let cgColors = colors.map { $0.cgColor }
        gradientLayer.colors = cgColors
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        self.layer.addSublayer(gradientLayer)
    }
    
    func withBorder(width: CGFloat, color: UIColor){
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    

}


