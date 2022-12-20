//
//  HomeViewController.swift
//  Muddy
//
//  Created by Bora Erdem on 20.12.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import LBTATools

protocol HomeDisplayLogic: AnyObject {
    func displayMovies(viewModel: Home.HomeMovies.ViewModel)
}

final class HomeViewController: UIViewController {
    var interactor: HomeBusinessLogic?
    var router: (NSObjectProtocol & HomeRoutingLogic & HomeDataPassing)?
    
    //UI
    let bgView = BackgrounView()
    var Movies: [[Result]] = [[]]

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
        view.addSubview(bgView)
        bgView.fillSuperview()
        
    }
    
    // MARK: Do something
    func fetchMovies() {
        let request = Home.HomeMovies.Request()
        Task { await interactor?.fetchHomeMovies(request: request) }
    }
    
}

extension HomeViewController: HomeDisplayLogic {
    func displayMovies(viewModel: Home.HomeMovies.ViewModel) {

        Movies.append(viewModel.nowPlayingMovies?.results ?? [])
        Movies.append(viewModel.popularMovies?.results ?? [])
        Movies.append(viewModel.upcomingMovies?.results ?? [])
        Movies.append(viewModel.topRatedMovies?.results ?? [])
        
    }
}

