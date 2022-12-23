//
//  MovieDetailPresenter.swift
//  Muddy
//
//  Created by Bora Erdem on 22.12.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol MovieDetailPresentationLogic {
    func presentMovieDetail(response: MovieDetail.FetchMovieDetail.Response)
    func presentCredits(response: MovieDetail.FetchCredits.Response)
}

class MovieDetailPresenter: MovieDetailPresentationLogic {
    
    weak var viewController: MovieDetailDisplayLogic?
    
    // MARK: Do something
    func presentMovieDetail(response: MovieDetail.FetchMovieDetail.Response) {
        let viewModel = MovieDetail.FetchMovieDetail.ViewModel(movie: response.movie)
        viewController?.displayMovieDetail(viewModel: viewModel)
    }
    
    func presentCredits(response: MovieDetail.FetchCredits.Response) {
        let cast = response.credits?.cast?.filter({$0.knownForDepartment == .acting})
        let viewModel = MovieDetail.FetchCredits.ViewModel(cast: cast)
        viewController?.displayCast(viewModel: viewModel)
    }

}
