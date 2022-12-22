//
//  HomeHeaderView.swift
//  Muddy
//
//  Created by Bora Erdem on 21.12.2022.
//

import UIKit
import LBTATools
import Kingfisher

@MainActor
class HomeHeaderView: UIViewController {
    
    //DEF
    var movie: Result
    
    //UI
    private lazy var imageView = UIImageView(image: .init(systemName: "house"), contentMode: .scaleAspectFill)
    
    private lazy var showBtn: MainButton = {
        let btn = MainButton(title: "Show",
                             imgName: "playpause.fill",
                             tintColor: .white,
                             backgroundColor: .clear)
        btn.withBorder(width: 1, color: .white)
        return btn
    }()
    
    //CORE
    public init(movie: Result) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        view.addSubview(showBtn)
        imageView.fillSuperview()
        fetchImage()
        layoutViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        insertGradient()
    }
    
    //UI Funcs
    private func layoutViews() {
        let container = UIView()
        let title = UILabel(text: movie.title,
                            font: .systemFont(ofSize: 17, weight: .regular),
                            textColor: .white,
                            textAlignment: .left,
                            numberOfLines: 2)
        
        let relaseDate = UILabel(text: "\(movie.releaseDate)",
                        font: .systemFont(ofSize: 13, weight: .light),
                        textColor: .secondaryLabel,
                        numberOfLines: 1)
        
        let voteAvarage = UILabel(text: "\(movie.voteAverage)",
                        font: .systemFont(ofSize: 13, weight: .light),
                        textColor: .red,
                        numberOfLines: 1)

        let overview = UILabel(text: "\(movie.overview)",
                        font: .systemFont(ofSize: 13, weight: .light),
                        textColor: .secondaryLabel,
                        numberOfLines: 2)
        container.stack(
            container.hstack(title, voteAvarage, spacing: 10),
            overview.withWidth(300),
            showBtn.withSize(.init(width: 150, height: 50)),
            relaseDate,
            spacing: 8,
            alignment: .leading
        )
        
        view.addSubview(container)
        container.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 16, bottom: 16, right: 0))
        
    }
    
    private func insertGradient() {
        imageView.insertGradient(colors: [.black, .clear],
                                 startPoint: .init(x: 0.5, y: 1),
                                 endPoint: .init(x: 0.5, y: 0))
    }
    
    private func fetchImage() {
        guard let url = URL(string: APIEndpoint.Image.orgImage(path: movie.backdropPath).toString) else {return}
        imageView.kf.setImage(with: url)
    }
    
}
