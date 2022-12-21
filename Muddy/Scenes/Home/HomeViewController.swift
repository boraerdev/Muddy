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
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()

    //DEF
    lazy var movies = CurrentValueSubject<[MovieGender : [Result]], Never>([:])
    let cancellable = Set<AnyCancellable>()
    
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
        
        DispatchQueue.main.async { [unowned self] in
            addHeader()
        }
        
    }
}

//MARK: UI Funcs
extension HomeViewController {
    
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
            searchImage.withSize(.init(width: 25, height: 25))
        ).withMargins(.init(top: 0, left: 16, bottom: 0, right: 16))
        
    }
    
    private func addHeader() {
        let vc = HomeHeaderView(movie: movies[.popular]?.first ?? MockData.Result)
        addChild(vc)
        vc.didMove(toParent: self)
        let container = UIView(backgroundColor: .clear)
        
        lazy var popularList: GenderList = {
            let list = GenderList(scrollDirection: .horizontal)
            
            return list
        }()
        
        container.stack(
            popularList.view.withHeight(200)
        )
        
        scrollView.stack(
            vc.view.withSize(.init(width: self.view.frame.width, height: 500)),
            container,
            spacing: 10
        )
        
    }

}

