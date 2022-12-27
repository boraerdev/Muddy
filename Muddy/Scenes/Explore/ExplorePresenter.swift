//
//  ExplorePresenter.swift
//  Muddy
//
//  Created by Bora Erdem on 26.12.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ExplorePresentationLogic {
    func presentDiscover(response: Explore.FetchDiscover.Response)
    func presentSearch(response: Explore.FetchSearch.Response)
}

class ExplorePresenter: ExplorePresentationLogic {
    
    weak var viewController: ExploreDisplayLogic?
    
    // MARK: Do something
    func presentDiscover(response: Explore.FetchDiscover.Response) {
        let movies = response.discoverMoviws?.results ?? []
        let viewModel = Explore.FetchDiscover.ViewModel(moviesList: movies)
        viewController?.displayDiscover(viewModel: viewModel)
    }
    
    func presentSearch(response: Explore.FetchSearch.Response) {
        let movies = response.searchResult?.results ?? []
        let viewModel = Explore.FetchSearch.ViewModel(moviesList: movies)
        viewController?.displaySearcg(viewModel: viewModel)
    }

}
