//
//  ExploreInteractorTests.swift
//  MuddyTests
//
//  Created by Bora Erdem on 8.01.2023.
//

@testable import Muddy
import XCTest

final class ExploreInteractorTests: XCTestCase {
    
    var sut: ExploreInterctorMock!
    var presenter: ExplorePresentationLogicMock!
    var worker: ExploreWorkerMock!

    
    override func setUp() {
        presenter = ExplorePresentationLogicMock()
        worker = ExploreWorkerMock()
        sut = ExploreInterctorMock(presenter: presenter, worker: worker)
    }
    
    override func tearDown() {
        
    }
    
    func test_fetchSearch_invokeAndPresent() {
        
        let requet = Explore.FetchSearch.Request(query: "avatar")
        XCTAssertFalse(presenter.invokedPresentSearch)
        XCTAssertNil(sut.invokedFetchSearchParameters.map(\.request))
        
        sut.fetchSearch(request: requet)
        
        XCTAssertTrue(presenter.invokedPresentSearch)
        XCTAssertEqual(presenter.invokedPresentSearchCount, 1)
        XCTAssertEqual(sut.invokedFetchSearchParameters.map(\.request)?.query, "avatar")
        XCTAssertNotNil(sut.invokedFetchSearchParameters.map(\.request))
    }
    
    
}

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

final class ExplorePresentationLogicMock: ExplorePresentationLogic {

    var invokedPresentDiscover = false
    var invokedPresentDiscoverCount = 0
    var invokedPresentDiscoverParameters: (response: Explore.FetchDiscover.Response, Void)?
    var invokedPresentDiscoverParametersList = [(response: Explore.FetchDiscover.Response, Void)]()

    func presentDiscover(response: Explore.FetchDiscover.Response) {
        invokedPresentDiscover = true
        invokedPresentDiscoverCount += 1
        invokedPresentDiscoverParameters = (response, ())
        invokedPresentDiscoverParametersList.append((response, ()))
    }

    var invokedPresentSearch = false
    var invokedPresentSearchCount = 0
    var invokedPresentSearchParameters: (response: Explore.FetchSearch.Response, Void)?
    var invokedPresentSearchParametersList = [(response: Explore.FetchSearch.Response, Void)]()

    func presentSearch(response: Explore.FetchSearch.Response) {
        invokedPresentSearch = true
        invokedPresentSearchCount += 1
        invokedPresentSearchParameters = (response, ())
        invokedPresentSearchParametersList.append((response, ()))
    }

    var invokedPresentGenres = false
    var invokedPresentGenresCount = 0
    var invokedPresentGenresParameters: (response: Explore.FetchGenres.Response, Void)?
    var invokedPresentGenresParametersList = [(response: Explore.FetchGenres.Response, Void)]()

    func presentGenres(response: Explore.FetchGenres.Response) {
        invokedPresentGenres = true
        invokedPresentGenresCount += 1
        invokedPresentGenresParameters = (response, ())
        invokedPresentGenresParametersList.append((response, ()))
    }
}

final class ExploreWorkerMock: ExploreWorker {
    
}
