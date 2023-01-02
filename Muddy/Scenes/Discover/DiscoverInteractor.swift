//
//  DiscoverInteractor.swift
//  Muddy
//
//  Created by Bora Erdem on 20.12.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol DiscoverBusinessLogic {
    func fetchMovies(request: Discover.FetchMovies.Request) async
}

protocol DiscoverDataStore {
    var movies: [Result] { get set }
}

class DiscoverInteractor: DiscoverBusinessLogic, DiscoverDataStore {
    
    var presenter: DiscoverPresentationLogic?
    var worker: DiscoverWorker?
    var movies: [Result] = []
    
    
    // MARK: Fetch
    func fetchMovies(request: Discover.FetchMovies.Request) async {
        let searchTitles = extractQuotedStrings(from: request.text).map { title in
            title.trimmingCharacters(in: .whitespacesAndNewlines).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        }
        movies = await searchTitles.asyncMap({ title in
            let worker = HomeWorker.shared
            let url = APIEndpoint.Movie.searchMovie(query: title).toString
            let result: SearchResult? = try? await worker.downloadGenericAboutMovie(urlString: url)
            let movie = result?.results?.first ?? MockData.Result
            return movie
        })
        let response = Discover.FetchMovies.Response(movies: movies)
        presenter?.presentMovies(response: response)
    }
    
}


