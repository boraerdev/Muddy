//
//  ExploreInteractor.swift
//  Muddy
//
//  Created by Bora Erdem on 26.12.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ExploreBusinessLogic {
    func fetchDiscover(request: Explore.FetchDiscover.Request) async
    func fetchSearch(request: Explore.FetchSearch.Request) async
    func fetchGenres(request: Explore.FetchGenres.Request) async
    func setSelectedMovie(_ movie: Result)
}

protocol ExploreDataStore {
    var discoverMovies: DiscoverMovies? { get set }
    var searchResult: SearchResult? { get set }
    var genreModel: GenreModel? {get set}
    var selectedMovie: Result? {get set}
    
}

class ExploreInteractor: ExploreBusinessLogic, ExploreDataStore {


    var presenter: ExplorePresentationLogic?
    var worker: ExploreWorker?
    
    var discoverMovies: DiscoverMovies?
    var searchResult: SearchResult?
    var genreModel: GenreModel?
    var selectedMovie: Result?

    // MARK: Funcs
    func fetchDiscover(request: Explore.FetchDiscover.Request) async {
        let worker = HomeWorker.shared
        let url = APIEndpoint.Movie.discoverMovie(params: request.params).toString
        discoverMovies = try? await worker.downloadGenericAboutMovie(urlString: url)
        
        let response = Explore.FetchDiscover.Response(discoverMoviws: discoverMovies)
        presenter?.presentDiscover(response: response)
    }
    
    func fetchSearch(request: Explore.FetchSearch.Request) async {
        let worker = HomeWorker.shared
        let url = APIEndpoint.Movie.searchMovie(query: request.query).toString
        searchResult = try? await worker.downloadGenericAboutMovie(urlString: url)
        
        let response = Explore.FetchSearch.Response(searchResult: searchResult)
        presenter?.presentSearch(response: response)
    }
    
    func fetchGenres(request: Explore.FetchGenres.Request) async {
        let worker = HomeWorker.shared
        let url = APIEndpoint.Movie.genres.toString
        genreModel = try? await worker.downloadGenericAboutMovie(urlString: url)
        
        let response = Explore.FetchGenres.Response(genreModel: genreModel)
        presenter?.presentGenres(response: response)
        
    }
    
    func setSelectedMovie(_ movie: Result) {
        selectedMovie = movie
    }



}
