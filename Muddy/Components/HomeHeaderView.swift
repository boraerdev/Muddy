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
                             imgName: "play.fill",
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
    
    private func insertGradient() {
        imageView.insertGradient(colors: [.black, .clear],
                                 startPoint: .init(x: 0.5, y: 1),
                                 endPoint: .init(x: 0.5, y: 0))
        
        imageView.insertGradient(colors: [.black,.clear],
                                 startPoint: .init(x: 0.5, y: 0),
                                 endPoint: .init(x: 0.5, y: 0.2))
    }
    
    private func layoutViews() {
        NSLayoutConstraint.activate([
            showBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        showBtn.withSize(.init(width: 150, height: 50))
    }
    
    private func fetchImage() {
        guard let url = URL(string: APIEndpoint.image(path: movie.backdropPath).toString) else {return}
        imageView.kf.setImage(with: url)
    }
    
}
