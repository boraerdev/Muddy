//
//  SliderMenuCellOnHome.swift
//  Muddy
//
//  Created by Bora Erdem on 22.12.2022.
//

import UIKit
import LBTATools

class SliderMenuCell: UICollectionViewCell {
    static let identifier = "SliderMenuCell"
    
    private lazy var genderTitle = UILabel(font: .systemFont(ofSize: 15), textColor: .white, textAlignment: .center, numberOfLines: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray6
        layer.cornerRadius = 20
        layer.cornerCurve = .continuous
        stack(genderTitle).withMargins(.init(top: 4, left: 20, bottom: 4, right: 20))
        withBorder(width: 1, color: .white)
    }
    
    func configure(_ gender: MovieGender) {
        genderTitle.text = gender.toString
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        genderTitle.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
