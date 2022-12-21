//
//  HomeViewController.swift
//  Muddy
//
//  Created by Bora Erdem on 20.12.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import LBTATools
import Swinflate
import Combine


protocol HomeDisplayLogic: AnyObject {
    func displayMovies(viewModel: Home.HomeMovies.ViewModel)
}

final class HomeViewController: UIViewController {
    var interactor: HomeBusinessLogic?
    var router: (NSObjectProtocol & HomeRoutingLogic & HomeDataPassing)?
    
    //UI
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.contentSize = .init(width: view.frame.width, height: 3000)
        scroll.isScrollEnabled = true
        scroll.showsVerticalScrollIndicator = true
        return scroll
    }()
    
    private lazy var collectionView: UICollectionView = {
        
        let cv = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        
        cv.delegate = self
        cv.dataSource = self
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()

    //DEF
    lazy var movies = PassthroughSubject<[MovieGender : [Result]], Never>()
    var cancellable = Set<AnyCancellable>()
    
    
    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    private func setup() {
        let viewController = self
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMovies()
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        topNavigaion()
        bindData()
    }
    
    
    // MARK: Fetch Movies
    func fetchMovies() {
        let request = Home.HomeMovies.Request()
        Task { await interactor?.fetchHomeMovies(request: request) }
    }
    
}

extension HomeViewController: HomeDisplayLogic {
    func displayMovies(viewModel: Home.HomeMovies.ViewModel) {

        var list: [MovieGender: [Result]] = [:]
        list[.popular] = viewModel.popularMovies?.results
        list[.nowPlaying] = viewModel.nowPlayingMovies?.results
        list[.topRated] = viewModel.topRatedMovies?.results
        list[.upcoming] = viewModel.upcomingMovies?.results
        movies.send(list)
        
    }
}

//MARK: UI Funcs
extension HomeViewController {
    
    private func bindData() {
        movies.sink { [unowned self] result in
            DispatchQueue.main.async {
                self.addHeader(resultMovies: result)
            }
        }.store(in: &cancellable)
    }
    
    private func topNavigaion() {
        let container = UIView()
        view.addSubview(container)
        container.anchor(
            top: scrollView.topAnchor,
            leading: scrollView.leadingAnchor,
            bottom: nil,
            trailing: scrollView.trailingAnchor,
            size: .init(width: view.frame.width, height: 100)
        )
        
        let titleLabel = UILabel(
            text: "Welcome Back",
            font: .systemFont(ofSize: 22, weight: .bold),
            textColor: .white,
            textAlignment: .center,
            numberOfLines: 1
        )
        
        let searchImage = UIImageView(
            image: .init(systemName: "magnifyingglass"),
            contentMode: .scaleAspectFit)
        searchImage.tintColor = .white
        
        container.hstack(
            titleLabel,
            UIView(),
            searchImage.withWidth(25)
        ).withMargins(.init(top: 0, left: 16, bottom: 0, right: 16))
        
    }
    
    private func addHeader(resultMovies: [MovieGender:[Result]]) {
        
        let vc = HomeHeaderView(movie: resultMovies[.popular]?.first ?? MockData.Result)
        addChild(vc)
        vc.didMove(toParent: self)
        let container = UIView(backgroundColor: .yellow)
        
        container.stack(
            collectionView
        )
        
        scrollView.stack(
            vc.view.withSize(.init(width: self.view.frame.width, height: 500)),
            container.withSize(.init(width: view.frame.width, height: 1000)),
            UIView(),
            spacing: 10
            
        )
        
    }

}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
    
    
}

