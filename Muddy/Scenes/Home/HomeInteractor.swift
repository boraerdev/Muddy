//
//  HomeInteractor.swift
//  Muddy
//
//  Created by Bora Erdem on 20.12.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol HomeBusinessLogic {
    func fetchHomeMovies(request: Home.HomeMovies.Request) async
    func setSelectedMovie(movie: Result)
}

protocol HomeDataStore {
    var popularMovies: PopularMovies? {get set}
    var upcomingMovies: UpcomingMovies? {get set}
    var topRatedMovies: TopRatedMovies? {get set}
    var nowPlayingMovies: NowPlayingMovies? {get set}
    var selectedMovie: Result? {get set}
}

class HomeInteractor: HomeBusinessLogic, HomeDataStore {
    
    var presenter: HomePresentationLogic?
    var worker: HomeWorker?

    var nowPlayingMovies: NowPlayingMovies?
    var upcomingMovies: UpcomingMovies?
    var topRatedMovies: TopRatedMovies?
    var popularMovies: PopularMovies?
    var selectedMovie: Result?
    
    func fetchHomeMovies(request: Home.HomeMovies.Request) async {
        let worker = HomeWorker()
        popularMovies = try? await worker.downloadMovieList(urlString: APIEndpoint.Movie.popularMovies.toString)
        
        topRatedMovies = try? await worker.downloadMovieList(urlString: APIEndpoint.Movie.topRatedMovies.toString)
        
        upcomingMovies = try? await worker.downloadMovieList(urlString: APIEndpoint.Movie.upcomingMovies.toString)
        
        nowPlayingMovies = try? await worker.downloadMovieList(urlString: APIEndpoint.Movie.nowPlayingMovies.toString)
        
        let response = Home.HomeMovies.Response(popularMovies: popularMovies, upcomingMovies: upcomingMovies, topRatedMovies: topRatedMovies, nowPlayingMovies: nowPlayingMovies)
        presenter?.presentMovies(response: response)
    }
    
    func setSelectedMovie(movie: Result) {
        selectedMovie = movie
    }
    
}
