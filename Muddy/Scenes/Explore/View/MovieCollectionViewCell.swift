//
//  MovieCollectionViewCell.swift
//  Muddy
//
//  Created by Bora Erdem on 26.12.2022.
//

import UIKit
import LBTATools
import Kingfisher
import CollectionViewSlantedLayout

final class MovieCollectionViewCell: CollectionViewSlantedCell {
    
    static let identifier = "MovieCollectionViewCell"
    
    private lazy var movieImage = UIImageView(image: nil, contentMode: .scaleAspectFill)
    
    private lazy var title: UILabel = {
        let label =  UILabel(text: nil, font: .systemFont(ofSize: 17, weight: .light), textColor: .white, textAlignment: .left, numberOfLines: 2)
        label.transform = .init(rotationAngle: -Double.pi / 20)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let pad: CGFloat = 60
        addSubview(movieImage)
        movieImage.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: -pad, left: -pad, bottom: -pad, right: -pad), size: .init(width: frame.width * 1.2, height: frame.height * 1.2))
        stack(
            UIView(),
            hstack(title.withWidth(200)).withMargins(.init(top: 0, left: 20, bottom: 50, right: 80))
        )
        
    }
    
    func offset(_ offset: CGPoint) {
        movieImage.frame = movieImage.bounds.offsetBy(dx: offset.x, dy: offset.y)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var imageHeight: CGFloat {
        return (movieImage.image?.size.height) ?? 300
    }
    
    var imageWidth: CGFloat {
        return (movieImage.image?.size.width) ?? 400
    }
    
    public func configure(movie: Result) {
        guard let url = URL(string: APIEndpoint.Image.mediumBackdropImage(path: movie.backdropPath).toString) else {return}
        movieImage.kf.setImage(
            with: url,
            options: [.memoryCacheExpiration(.expired), .diskCacheExpiration(.expired)]
        )
        title.text = movie.title
        DispatchQueue.main.async { [unowned self] in
            movieImage.insertGradient(colors: [.black, .clear], startPoint: .init(x: 0.5, y: 1), endPoint: .init(x: 0.5, y: 0))
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImage.image = nil
        title.text = nil
        movieImage.layer.sublayers?.forEach({ l in
            l.removeFromSuperlayer()
        })
    }
    
}
