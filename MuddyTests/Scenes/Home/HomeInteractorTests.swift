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
    private var homeBusinessLogic = MockHomeInteractor()
    
    override func setUp() {
        super.setUp()
        homeBusinessLogic = MockHomeInteractor.shared
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_fetchHomeMovies_inwoked() async {
        //Given
        XCTAssertEqual(homeBusinessLogic.invokedFetchHomeMovies, false)
        XCTAssertEqual(homeBusinessLogic.invokedFetchHomeMoviesCount, 0)
        //When
        homeBusinessLogic.fetchHomeMovies(request: .init())
        //Then
        XCTAssertEqual(homeBusinessLogic.invokedFetchHomeMovies, true)
        XCTAssertEqual(homeBusinessLogic.invokedFetchHomeMoviesCount, 1)
    }
    
    func test_setSelectMovie_setSelected_inwokeAndSet(){
        //Given
        XCTAssertNil(homeBusinessLogic.invokedSelectedMovie)
        XCTAssertEqual(homeBusinessLogic.invokedSetSelectedMovie, false)
        XCTAssertEqual(homeBusinessLogic.invokedSetSelectedMovieCount, 0)
        //When
        homeBusinessLogic.setSelectedMovie(movie: MockData.Result)
        //Then
        XCTAssertNotNil(homeBusinessLogic.invokedSelectedMovie)
        XCTAssertEqual(homeBusinessLogic.invokedSetSelectedMovie, true)
        XCTAssertEqual(homeBusinessLogic.invokedSetSelectedMovieCount, 1)
    }
    
    
}

final class MockHomeInteractor: HomeBusinessLogic, HomeDataStore {

    static let shared = MockHomeInteractor()
    
    var invokedPopularMoviesSetter = false
    var invokedPopularMoviesSetterCount = 0
    var invokedPopularMovies: PopularMovies?
    var invokedPopularMoviesList = [PopularMovies?]()
    var invokedPopularMoviesGetter = false
    var invokedPopularMoviesGetterCount = 0
    var stubbedPopularMovies: PopularMovies!

    var popularMovies: PopularMovies? {
        set {
            invokedPopularMoviesSetter = true
            invokedPopularMoviesSetterCount += 1
            invokedPopularMovies = newValue
            invokedPopularMoviesList.append(newValue)
        }
        get {
            invokedPopularMoviesGetter = true
            invokedPopularMoviesGetterCount += 1
            return stubbedPopularMovies
        }
    }

    var invokedUpcomingMoviesSetter = false
    var invokedUpcomingMoviesSetterCount = 0
    var invokedUpcomingMovies: UpcomingMovies?
    var invokedUpcomingMoviesList = [UpcomingMovies?]()
    var invokedUpcomingMoviesGetter = false
    var invokedUpcomingMoviesGetterCount = 0
    var stubbedUpcomingMovies: UpcomingMovies!

    var upcomingMovies: UpcomingMovies? {
        set {
            invokedUpcomingMoviesSetter = true
            invokedUpcomingMoviesSetterCount += 1
            invokedUpcomingMovies = newValue
            invokedUpcomingMoviesList.append(newValue)
        }
        get {
            invokedUpcomingMoviesGetter = true
            invokedUpcomingMoviesGetterCount += 1
            return stubbedUpcomingMovies
        }
    }

    var invokedTopRatedMoviesSetter = false
    var invokedTopRatedMoviesSetterCount = 0
    var invokedTopRatedMovies: TopRatedMovies?
    var invokedTopRatedMoviesList = [TopRatedMovies?]()
    var invokedTopRatedMoviesGetter = false
    var invokedTopRatedMoviesGetterCount = 0
    var stubbedTopRatedMovies: TopRatedMovies!

    var topRatedMovies: TopRatedMovies? {
        set {
            invokedTopRatedMoviesSetter = true
            invokedTopRatedMoviesSetterCount += 1
            invokedTopRatedMovies = newValue
            invokedTopRatedMoviesList.append(newValue)
        }
        get {
            invokedTopRatedMoviesGetter = true
            invokedTopRatedMoviesGetterCount += 1
            return stubbedTopRatedMovies
        }
    }

    var invokedNowPlayingMoviesSetter = false
    var invokedNowPlayingMoviesSetterCount = 0
    var invokedNowPlayingMovies: NowPlayingMovies?
    var invokedNowPlayingMoviesList = [NowPlayingMovies?]()
    var invokedNowPlayingMoviesGetter = false
    var invokedNowPlayingMoviesGetterCount = 0
    var stubbedNowPlayingMovies: NowPlayingMovies!

    var nowPlayingMovies: NowPlayingMovies? {
        set {
            invokedNowPlayingMoviesSetter = true
            invokedNowPlayingMoviesSetterCount += 1
            invokedNowPlayingMovies = newValue
            invokedNowPlayingMoviesList.append(newValue)
        }
        get {
            invokedNowPlayingMoviesGetter = true
            invokedNowPlayingMoviesGetterCount += 1
            return stubbedNowPlayingMovies
        }
    }

    var invokedSelectedMovieSetter = false
    var invokedSelectedMovieSetterCount = 0
    var invokedSelectedMovie: Result?
    var invokedSelectedMovieList = [Result?]()
    var invokedSelectedMovieGetter = false
    var invokedSelectedMovieGetterCount = 0
    var stubbedSelectedMovie: Result!

    var selectedMovie: Result? {
        set {
            invokedSelectedMovieSetter = true
            invokedSelectedMovieSetterCount += 1
            invokedSelectedMovie = newValue
            invokedSelectedMovieList.append(newValue)
        }
        get {
            invokedSelectedMovieGetter = true
            invokedSelectedMovieGetterCount += 1
            return stubbedSelectedMovie
        }
    }

    var invokedFetchHomeMovies = false
    var invokedFetchHomeMoviesCount = 0
    var invokedFetchHomeMoviesParameters: (request: Home.HomeMovies.Request, Void)?
    var invokedFetchHomeMoviesParametersList = [(request: Home.HomeMovies.Request, Void)]()

    func fetchHomeMovies(request: Home.HomeMovies.Request) {
        invokedFetchHomeMovies = true
        invokedFetchHomeMoviesCount += 1
        invokedFetchHomeMoviesParameters = (request, ())
        invokedFetchHomeMoviesParametersList.append((request, ()))
    }

    var invokedSetSelectedMovie = false
    var invokedSetSelectedMovieCount = 0
    var invokedSetSelectedMovieParameters: (movie: Result, Void)?
    var invokedSetSelectedMovieParametersList = [(movie: Result, Void)]()

    func setSelectedMovie(movie: Result) {
        invokedSetSelectedMovie = true
        invokedSetSelectedMovieCount += 1
        invokedSetSelectedMovieParameters = (movie, ())
        invokedSetSelectedMovieParametersList.append((movie, ()))
        selectedMovie = movie
    }
}
