//
//  DiscoverPresenter.swift
//  Muddy
//
//  Created by Bora Erdem on 20.12.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol DiscoverPresentationLogic {
    func presentMovies(response: Discover.FetchMovies.Response)
}

class DiscoverPresenter: DiscoverPresentationLogic {
    
    weak var viewController: DiscoverDisplayLogic?
    
    // MARK: Do something
    func presentMovies(response: Discover.FetchMovies.Response) {
        let viewModel = Discover.FetchMovies.ViewModel(movies: response.movies)
        viewController?.displayMovies(viewModel: viewModel)
    }

}
