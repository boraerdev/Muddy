//
//  HomeInteractorTests.swift
//  MuddyTests
//
//  Created by Bora Erdem on 7.01.2023.
//

import Foundation
import XCTest
@testable import Muddy

final class HomeInteractorTests: XCTestCase {
    private var homeBusinessLogic: HomeBusinessLogic!
    private var homeDataStorage: HomeDataStore!
    
    override func setUp() {
        super.setUp()
        homeBusinessLogic = MockHomeInteractor.shared
        homeDataStorage = MockHomeInteractor.shared
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_nowPlayingMovies_ReturnsNotNil() async {
        //Given
        XCTAssertNil(homeDataStorage.nowPlayingMovies)
        //When
        await homeBusinessLogic.fetchHomeMovies(request: .init())
        //Then
        XCTAssertNotNil(homeDataStorage.nowPlayingMovies)
    }
    
    func test_SelectedMovie_ReturnsNil() {
        XCTAssertNil(homeDataStorage.selectedMovie)
    }
    
    func test_SelectedMovie_SetSelectedMovie_ReturnsNotNil() {
        //Given
        XCTAssertNil(homeDataStorage.selectedMovie)
        //When
        homeBusinessLogic.setSelectedMovie(movie: MockData.Result)
        //Then
        XCTAssertNotNil(homeDataStorage.selectedMovie)
    }
    
}

final class MockHomeInteractor: HomeBusinessLogic, HomeDataStore {
    
    static let shared = MockHomeInteractor()
    
    var popularMovies: Muddy.PopularMovies?
    
    var upcomingMovies: Muddy.UpcomingMovies?
    
    var topRatedMovies: Muddy.TopRatedMovies?
    
    var nowPlayingMovies: Muddy.NowPlayingMovies?
    
    var selectedMovie: Muddy.Result?
    
    func fetchHomeMovies(request: Muddy.Home.HomeMovies.Request) async {
        let nowPlayingMovies: NowPlayingMovies = MockData.NowPlayingMovies
        self.nowPlayingMovies = nowPlayingMovies
    }
    
    func setSelectedMovie(movie: Muddy.Result) {
        selectedMovie = movie
    }
    
    
}
