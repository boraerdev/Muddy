//
//  HomeHeaderReusableView.swift
//  Muddy
//
//  Created by Bora Erdem on 24.12.2022.
//

import Foundation
import Kingfisher
import LBTATools
import UIKit

protocol MainHomeHeaderReusableViewDelegate: AnyObject {
    func didTapGoHeaderMovie(movie:Result)
}

class MainHomeHeaderReusableView: UICollectionReusableView {

    static let identifier = "MainHomeHeader"
    weak var delegate: MainHomeHeaderReusableViewDelegate?
    lazy var headerVC = HomeHeaderView(movie: MockData.Result)
    
    private lazy var genderTitle = UILabel(text: "Popular", font: .systemFont(ofSize: 17, weight: .bold), textColor: .white, textAlignment: .left)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
    }

    func prepareForMainHeader(movie: Result) {
        
        let container = UIView(backgroundColor: .black)
        
        container.hstack(UIView().withWidth(16), genderTitle.withHeight(50), UIView())
        
        DispatchQueue.main.async { [unowned self] in
            headerVC = HomeHeaderView(movie: movie)
            headerVC.delegate = self
            stack(
                headerVC.view,
                container.withHeight(50)
            )
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainHomeHeaderReusableView: HomeHeaderViewDelegate {
    func didTapGoHeaderDetail(movie: Result) {
        print("a")
        delegate?.didTapGoHeaderMovie(movie: movie)
    }
}
