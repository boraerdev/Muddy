//
//  AnimatedBgView.swift
//  Muddy
//
//  Created by Bora Erdem on 1.01.2023.
//

import Foundation
import UIKit
import LBTATools

final class AnimatedBgView: UIView {
    
    lazy var size: CGFloat = 400
    let dark = UIView(backgroundColor: .black.withAlphaComponent(0.5))
    var blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterialDark))

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let  c1 = drawCircle(size: size, color: .red.withAlphaComponent(0.2))
        let  c2 = drawCircle(size: size - 100, color: .red.withAlphaComponent(0.25))
        let  c3 = drawCircle(size: size - 200, color: .red.withAlphaComponent(0.3))
        
        let  c1blue = drawCircle(size: size, color: .blue.withAlphaComponent(0.2))
        let  c2blue = drawCircle(size: size - 100, color: .blue.withAlphaComponent(0.25))
        let  c3blue = drawCircle(size: size - 200, color: .blue.withAlphaComponent(0.3))
        
        let  c1green = drawCircle(size: size, color: .purple.withAlphaComponent(0.2))
        let  c2green = drawCircle(size: size - 100, color: .purple.withAlphaComponent(0.25))
        let  c3green = drawCircle(size: size - 200, color: .purple.withAlphaComponent(0.3))
        
        let container = UIView()
        let reds = UIView()
        let blues = UIView()
        let greens = UIView()
        addSubview(container)
        container.fillSuperview()
        reds.addSubview(c1)
        reds.addSubview(c2)
        reds.addSubview(c3)
        blues.addSubview(c1blue)
        blues.addSubview(c2blue)
        blues.addSubview(c3blue)
        greens.addSubview(c1green)
        greens.addSubview(c2green)
        greens.addSubview(c3green)
        addSubview(greens)
        addSubview(reds)
        addSubview(blues)
        
        
        [c1,c2,c3,c1blue,c2blue,c3blue,c1green,c2green,c3green, reds,blues, greens].forEach { v in
            v.translatesAutoresizingMaskIntoConstraints = false
        }

        reds.anchor(.top(topAnchor, constant: 120), .leading(leadingAnchor, constant: -20))
        NSLayoutConstraint.activate([
            
            c1.centerXAnchor.constraint(equalTo: reds.centerXAnchor),
            c1.centerYAnchor.constraint(equalTo: reds.centerYAnchor),

            
            c2.centerXAnchor.constraint(equalTo: reds.centerXAnchor),
            c2.centerYAnchor.constraint(equalTo: reds.centerYAnchor),
            
            c3.centerXAnchor.constraint(equalTo: reds.centerXAnchor),
            c3.centerYAnchor.constraint(equalTo: reds.centerYAnchor)
        ])
        
        blues.anchor(.trailing(trailingAnchor,constant: -50), .bottom(bottomAnchor,constant: 80))
        NSLayoutConstraint.activate([
            
            c1blue.centerXAnchor.constraint(equalTo: blues.centerXAnchor),
            c1blue.centerYAnchor.constraint(equalTo: blues.centerYAnchor),

            
            c2blue.centerXAnchor.constraint(equalTo: blues.centerXAnchor),
            c2blue.centerYAnchor.constraint(equalTo: blues.centerYAnchor),
            
            c3blue.centerXAnchor.constraint(equalTo: blues.centerXAnchor),
            c3blue.centerYAnchor.constraint(equalTo: blues.centerYAnchor)
        ])
        
        greens.anchor(.trailing(trailingAnchor))
        NSLayoutConstraint.activate([
            
            c1green.centerXAnchor.constraint(equalTo: greens.centerXAnchor),
            c1green.centerYAnchor.constraint(equalTo: greens.centerYAnchor),

            
            c2green.centerXAnchor.constraint(equalTo: greens.centerXAnchor),
            c2green.centerYAnchor.constraint(equalTo: greens.centerYAnchor),
            
            c3green.centerXAnchor.constraint(equalTo: greens.centerXAnchor),
            c3green.centerYAnchor.constraint(equalTo: greens.centerYAnchor)
        ])
        
        makeAnimation(for: reds)
        makeAnimation(for: blues)
        makeAnimation(for: greens)
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [unowned self] timer in
            makeAnimation(for: reds)
            makeAnimation(for: blues)
            makeAnimation(for: greens)
        }
        
        addSubview(blur)
        addSubview(dark)
        dark.fillSuperview()
        blur.fillSuperview()
        clipsToBounds = true
    }
    
    private func makeAnimation(for view: UIView)  {
        let randomY = Int(arc4random() % (UInt32(frame.height)+1))
        let randomX = Int(arc4random() % (UInt32(frame.width)+1))
        
        let newX = randomX - Int(view.frame.width) / 2
        let newY = randomY - Int(view.frame.height) / 2
        
            DispatchQueue.main.async {
                UIView.animate(withDuration: 2, delay: 0) {
                    view.frame = .init(x: CGFloat(newX) , y: CGFloat(newY), width: view.frame.width, height: view.frame.height)
                }
            }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
