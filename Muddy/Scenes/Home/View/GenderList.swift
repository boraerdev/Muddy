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

class MainHomeHeader: UICollectionReusableView {
    
    static let identifier = "MainHomeHeader"
    
    private lazy var genderTitle = UILabel(font: .systemFont(ofSize: 17, weight: .bold), textColor: .white, textAlignment: .left)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        
    }
    
    func prepareForMainHeader(movie: Result) {
        
        let container = UIView(backgroundColor: .black)
        
        container.hstack(UIView().withWidth(16), genderTitle.withHeight(50), UIView())
        
        DispatchQueue.main.async { [unowned self] in
            genderTitle.text = "Popular"
            let vc = HomeHeaderView(movie: movie)
            let homeView = HomeViewController()
            vc.goDetail = {
                homeView.prepareGoDetailForHeaderView(movie: movie)
            }
            stack(
                vc.view,
                container.withHeight(50)
            )
        }
        
    }
    
    func prepareForTitle(gender: MovieGender) {
        DispatchQueue.main.async { [unowned self] in
            genderTitle.text = gender.toString
            hstack(UIView().withWidth(16), genderTitle, UIView())
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

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
        guard let url = URL(string: APIEndpoint.Image.lowPosterImage(path: movie.posterPath).toString) else {return}
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

