//
//  DiscoverMoviesCollectionViewCell.swift
//  Muddy
//
//  Created by Bora Erdem on 3.01.2023.
//

import UIKit
import Kingfisher

final class DiscoverMoviesCollectionViewCell: UICollectionViewCell {
    static let identifier = "DiscoverMoviesCollectionViewCell"
    
    private lazy var imageView = UIImageView(image: nil, contentMode: .scaleAspectFill)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray5.withAlphaComponent(0.5)
        layer.cornerRadius = 8
        layer.cornerCurve = .continuous
        clipsToBounds = true
        stack(imageView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(movie: Result) {
        let url = URL(string: APIEndpoint.Image.withQuality(quality: .w154, path: movie.posterPath ?? "").toString)
        imageView.kf.setImage(
            with: url,
            options: [.memoryCacheExpiration(.expired), .diskCacheExpiration(.expired)]
            
        )
    }
    
}
