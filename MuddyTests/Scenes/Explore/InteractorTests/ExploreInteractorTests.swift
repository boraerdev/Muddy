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
    
    func test_fetchSearch_presentSearch() {
        let requet = Explore.FetchSearch.Request(query: "avatar")
        XCTAssertFalse(presenter.invokedPresentSearch)
        XCTAssertNil(sut.invokedFetchSearchParameters.map(\.request))
        
        sut.fetchSearch(request: requet)
        
        XCTAssertTrue(presenter.invokedPresentSearch)
        XCTAssertEqual(presenter.invokedPresentSearchCount, 1)
        XCTAssertEqual(sut.invokedFetchSearchParameters.map(\.request)?.query, "avatar")
        XCTAssertNotNil(sut.invokedFetchSearchParameters.map(\.request))
    }
    
    func test_fetchGenres_presentGenres() {
        XCTAssertFalse(presenter.invokedPresentGenres)
        XCTAssertTrue(presenter.invokedPresentGenresParametersList.isEmpty)
        
        sut.fetchGenres(request: .init())
        
        XCTAssertEqual(presenter.invokedPresentGenresParameters.map(\.response)?.genreModel?.genres?.first?.id, 0)
        XCTAssertEqual(presenter.invokedPresentGenresParameters.map(\.response)?.genreModel?.genres?.first?.name, "action")
    }
    
    func test_fetchDiscover_presentDiscover() {
        XCTAssertFalse(presenter.invokedPresentDiscover)
        
        sut.fetchDiscover(request: .init(params: "paramOne"))
        
        XCTAssertTrue(presenter.invokedPresentDiscover)
        XCTAssertEqual(sut.invokedFetchDiscoverParameters.map(\.request)?.params, "paramOne")
        XCTAssertEqual(presenter.invokedPresentDiscoverParametersList.count, 1)
    }
    
    func test_setSelectedMovie_invoked() {
        XCTAssertFalse(sut.invokedSetSelectedMovie)
        XCTAssertEqual(sut.invokedSetSelectedMovieCount, 0)
        
        sut.setSelectedMovie(MockData.Result)
        
        XCTAssertTrue(sut.invokedSetSelectedMovie)
        XCTAssertEqual(sut.invokedSetSelectedMovieParameters.map(\.movie)?.title, "Mock")
    }
}
