//
//  GenreHeaderCollectionReusableView.swift
//  Muddy
//
//  Created by Bora Erdem on 24.12.2022.
//

import UIKit

class GenreHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "GenreHeaderCollectionReusableView"
    
    private lazy var genreTitle = UILabel(
        text: nil,
        font: .systemFont(ofSize: 17, weight: .bold),
        textColor: .white,
        textAlignment: .left,
        numberOfLines: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        hstack(
            UIView().withWidth(16),
            genreTitle,
            UIView()
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with genre: MovieGender) {
        genreTitle.text = genre.toString
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        genreTitle.text = nil
    }
    
}
