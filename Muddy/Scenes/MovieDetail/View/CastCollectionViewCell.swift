//
//  CastCollectionViewCell.swift
//  Muddy
//
//  Created by Bora Erdem on 24.12.2022.
//

import UIKit
import Kingfisher

final class CastCollectionViewCell: UICollectionViewCell {
    static let identifier = "CastCollectionViewCell"
    
    private lazy var castImage = UIImageView(image: .init(systemName: "person"), contentMode: .scaleAspectFill)
    
    private lazy var orgName = UILabel(
        text: nil,
        font: .systemFont(ofSize: 13, weight: .semibold),
        textColor: .white,
        textAlignment: .center,
        numberOfLines: 1
    )
    
    private lazy var characterName = UILabel(
        text: nil,
        font: .systemFont(ofSize: 11, weight: .light),
        textColor: .secondaryLabel,
        textAlignment: .center,
        numberOfLines: 1
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        castImage.layer.cornerRadius = 8
        castImage.layer.cornerCurve = .continuous
        
        stack(
            castImage.withSize(.init(width: 100, height: 100)),
            orgName,
            characterName,
            distribution: .equalSpacing
        )
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(cast: Cast) {
        orgName.text = cast.name
        characterName.text = cast.character
        guard let url = URL(string: APIEndpoint.Image.mediumCastImage(path: cast.profilePath ?? "").toString) else {return}
        castImage.kf.setImage(with: url)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        castImage.image = nil
        orgName.text = nil
        characterName.text = nil
    }
}
