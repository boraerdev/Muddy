//
//  MovieCell.swift
//  Muddy
//
//  Created by Bora Erdem on 21.12.2022.
//

import Foundation
import LBTATools
import UIKit
import Kingfisher



class HomeGenderListCell: UICollectionViewCell {
    
    static let identifier = "HomeGenderListCell"
    private lazy var movieImage = UIImageView(image: nil, contentMode: .scaleAspectFill)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        layer.cornerRadius = 8
        layer.cornerCurve = .continuous
        clipsToBounds = true
        stack(movieImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(movie: Result) {
        guard let url = URL(string: APIEndpoint.Image.withQuality(quality: .w154, path: movie.posterPath).toString) else {return}
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

