//
//  RecommendationsCollectionViewCell.swift
//  Muddy
//
//  Created by Bora Erdem on 25.12.2022.
//

import UIKit
import LBTATools

final class RecommendationsCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecommendationsCollectionViewCell"
    
    private lazy var movieImage = UIImageView(image: nil, contentMode: .scaleAspectFill)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        movieImage.layer.cornerRadius = 8
        movieImage.layer.cornerCurve = .continuous
        addSubview(movieImage)
        movieImage.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(movie: Result) {
        guard let url = URL(string: APIEndpoint.Image.lowPosterImage(path: movie.posterPath).toString) else {
            return
        }
        movieImage.kf.setImage(
            with: url,
            options: [.memoryCacheExpiration(.expired), .diskCacheExpiration(.expired)]
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImage.image = nil
    }
}
