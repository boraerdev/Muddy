//
//  HomePresenter.swift
//  Muddy
//
//  Created by Bora Erdem on 20.12.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol HomePresentationLogic {
    func presentMovies(response: Home.HomeMovies.Response)
}

class HomePresenter: HomePresentationLogic {
    weak var viewController: HomeDisplayLogic?
    
    // MARK: Do something
    func presentMovies(response: Home.HomeMovies.Response) {
        let viewModel = Home.HomeMovies.ViewModel(popularMovies: response.popularMovies, upcomingMovies: response.upcomingMovies, topRatedMovies: response.topRatedMovies, nowPlayingMovies: response.nowPlayingMovies)
        viewController?.displayMovies(viewModel: viewModel)
    }
}
