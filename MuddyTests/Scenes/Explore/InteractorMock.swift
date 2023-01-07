//
//  InteractorMock.swift
//  MuddyTests
//
//  Created by Bora Erdem on 8.01.2023.
//

import Foundation
@testable import Muddy

final class ExploreInterctorMock: ExploreBusinessLogic {
    
    
    var presenter: ExplorePresentationLogic?
    var worker: ExploreWorker?
    
    init(presenter: ExplorePresentationLogic? = nil, worker: ExploreWorker? = nil) {
        self.presenter = presenter
        self.worker = worker
    }
    

    var invokedFetchDiscover = false
    var invokedFetchDiscoverCount = 0
    var invokedFetchDiscoverParameters: (request: Explore.FetchDiscover.Request, Void)?
    var invokedFetchDiscoverParametersList = [(request: Explore.FetchDiscover.Request, Void)]()

    func fetchDiscover(request: Explore.FetchDiscover.Request) {
        invokedFetchDiscover = true
        invokedFetchDiscoverCount += 1
        invokedFetchDiscoverParameters = (request, ())
        invokedFetchDiscoverParametersList.append((request, ()))
        
        presenter?.presentDiscover(response: .init())
    }

    var invokedFetchSearch = false
    var invokedFetchSearchCount = 0
    var invokedFetchSearchParameters: (request: Explore.FetchSearch.Request, Void)?
    var invokedFetchSearchParametersList = [(request: Explore.FetchSearch.Request, Void)]()

    func fetchSearch(request: Explore.FetchSearch.Request) {
        invokedFetchSearch = true
        invokedFetchSearchCount += 1
        invokedFetchSearchParameters = (request, ())
        invokedFetchSearchParametersList.append((request, ()))
        
        presenter?.presentSearch(response: .init())
    }

    var invokedFetchGenres = false
    var invokedFetchGenresCount = 0
    var invokedFetchGenresParameters: (request: Explore.FetchGenres.Request, Void)?
    var invokedFetchGenresParametersList = [(request: Explore.FetchGenres.Request, Void)]()

    func fetchGenres(request: Explore.FetchGenres.Request) {
        invokedFetchGenres = true
        invokedFetchGenresCount += 1
        invokedFetchGenresParameters = (request, ())
        invokedFetchGenresParametersList.append((request, ()))
        
        presenter?.presentGenres(response: .init(genreModel: .init(genres: [.init(id: 0, name: "action")])))
    }

    var invokedSetSelectedMovie = false
    var invokedSetSelectedMovieCount = 0
    var invokedSetSelectedMovieParameters: (movie: Result, Void)?
    var invokedSetSelectedMovieParametersList = [(movie: Result, Void)]()

    func setSelectedMovie(_ movie: Result) {
        invokedSetSelectedMovie = true
        invokedSetSelectedMovieCount += 1
        invokedSetSelectedMovieParameters = (movie, ())
        invokedSetSelectedMovieParametersList.append((movie, ()))
    }
}
