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
}

protocol HomeDataStore {
    var popularMovies: PopularMovies? {get set}
    var upcomingMovies: UpcomingMovies? {get set}
    var topRatedMovies: TopRatedMovies? {get set}
    var nowPlayingMovies: NowPlayingMovies? {get set}
}

class HomeInteractor: HomeDataStore {
    
    var presenter: HomePresentationLogic?
    var worker: HomeWorker?

    var nowPlayingMovies: NowPlayingMovies?
    var upcomingMovies: UpcomingMovies?
    var topRatedMovies: TopRatedMovies?
    var popularMovies: PopularMovies?
    
}

extension HomeInteractor: HomeBusinessLogic {
    func fetchHomeMovies(request: Home.HomeMovies.Request) async {
        let worker = HomeWorker()
        popularMovies = try? await worker.downloadHomeMovies(urlString: APIEndpoint.popularMovies.toString)
        
        topRatedMovies = try? await worker.downloadHomeMovies(urlString: APIEndpoint.topRatedMovies.toString)
        
        upcomingMovies = try? await worker.downloadHomeMovies(urlString: APIEndpoint.upcomingMovies.toString)
        
        nowPlayingMovies = try? await worker.downloadHomeMovies(urlString: APIEndpoint.nowPlayingMovies.toString)
        
        let response = Home.HomeMovies.Response(popularMovies: popularMovies, upcomingMovies: upcomingMovies, topRatedMovies: topRatedMovies, nowPlayingMovies: nowPlayingMovies)
        presenter?.presentMovies(response: response)
        
    }
    
}
