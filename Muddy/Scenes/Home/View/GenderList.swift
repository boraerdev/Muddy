//
//  MovieCell.swift
//  Muddy
//
//  Created by Bora Erdem on 21.12.2022.
//

import Foundation
import LBTATools
import UIKit

class MovieInGenderCell: LBTAListCell<Result> {
    
    private lazy var movieTitle = UILabel(textColor: .black)
    
    override var item: Result! {
        didSet {
            movieTitle.text = item.title
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieTitle.text = nil
    }
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .white
    }
}

class GenderList: LBTAListController<MovieInGenderCell, Result>, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        view.backgroundColor = .yellow
        items = [MockData.Result,MockData.Result,MockData.Result]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
}
