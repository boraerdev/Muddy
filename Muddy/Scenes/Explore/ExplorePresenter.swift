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
    func presentGenres(response: Explore.FetchGenres.Response)
}

class ExplorePresenter: ExplorePresentationLogic {
    
    weak var viewController: ExploreDisplayLogic?
    
    // MARK: Do something
    func presentDiscover(response: Explore.FetchDiscover.Response) {
        var movies = response.discoverMoviws?.results ?? []
        movies = clearResults(for: movies)
        let viewModel = Explore.FetchDiscover.ViewModel(moviesList: movies)
        viewController?.displayDiscover(viewModel: viewModel)
    }
    
    func presentSearch(response: Explore.FetchSearch.Response) {
        var movies = response.searchResult?.results ?? []
        movies = clearResults(for: movies)
        let viewModel = Explore.FetchSearch.ViewModel(moviesList: movies)
        viewController?.displaySearcg(viewModel: viewModel)
    }
    
    func presentGenres(response: Explore.FetchGenres.Response) {
        let genres = response.genreModel?.genres ?? []
        let viewModel = Explore.FetchGenres.ViewModel(genres: genres)
        viewController?.displayGenres(viewModel: viewModel)
    }
    
    func clearResults(for movies: [Result]) -> [Result] {
        return movies.compactMap({ res in
            if res.backdropPath != nil {
                return res
            } else {
                return nil
            }
        })
    }


}
