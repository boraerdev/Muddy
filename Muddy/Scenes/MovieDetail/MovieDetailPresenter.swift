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
}

class MovieDetailPresenter: MovieDetailPresentationLogic {
    
    weak var viewController: MovieDetailDisplayLogic?
    
    // MARK: Do something
    func presentMovieDetail(response: MovieDetail.FetchMovieDetail.Response) {
        let viewModel = MovieDetail.FetchMovieDetail.ViewModel(movie: response.movie)
        viewController?.displayMovieDetail(viewModel: viewModel)
    }

}
