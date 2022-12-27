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
}

protocol ExploreDataStore {
    var discoverMovies: DiscoverMovies? { get set }
    var searchResult: SearchResult? { get set }
    
}

class ExploreInteractor: ExploreBusinessLogic, ExploreDataStore {
    
    
    var presenter: ExplorePresentationLogic?
    var worker: ExploreWorker?
    
    var discoverMovies: DiscoverMovies?
    var searchResult: SearchResult?
    
    // MARK: Do something
    func fetchDiscover(request: Explore.FetchDiscover.Request) async {
        let worker = HomeWorker.shared
        let url = APIEndpoint.Movie.discoverMovie.toString
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
    


}
