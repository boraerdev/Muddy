//
//  MovieDetailInteractor.swift
//  Muddy
//
//  Created by Bora Erdem on 22.12.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol MovieDetailBusinessLogic {
    func fetchMovieDetail(request: MovieDetail.FetchMovieDetail.Request) async
    func fetchCredits(request: MovieDetail.FetchCredits.Request) async
}

protocol MovieDetailDataStore {
    var selectedMovie: Result { get set }
    var movie: DetailedMovie? {get set}
    var credits: Credits? {get set}
}

class MovieDetailInteractor: MovieDetailBusinessLogic, MovieDetailDataStore {
   
    
    
    var presenter: MovieDetailPresentationLogic?
    var worker: MovieDetailWorker?
    var selectedMovie: Result = MockData.Result
    var movie: DetailedMovie? = nil
    var credits: Credits?
    
    // MARK: Do something
    func fetchMovieDetail(request: MovieDetail.FetchMovieDetail.Request) async {
        let worker = HomeWorker()
        let url: String = APIEndpoint.Movie.details(id: request.movieId).toString
        movie = try? await worker.downloadGenericAboutMovie(urlString: url)
        
        let response = MovieDetail.FetchMovieDetail.Response(movie: movie)
        presenter?.presentMovieDetail(response: response)
    }
    
    func fetchCredits(request: MovieDetail.FetchCredits.Request) async {
        let worker = HomeWorker()
        let url: String = APIEndpoint.Movie.credits(id: request.movieId).toString
        credits = try? await worker.downloadGenericAboutMovie(urlString: url)
        
        let response = MovieDetail.FetchCredits.Response(credits: credits)
        presenter?.presentCredits(response: response)
    }
    
}
