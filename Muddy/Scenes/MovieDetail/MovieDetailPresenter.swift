//
//  MovieDetailPresenter.swift
//  Muddy
//
//  Created by Bora Erdem on 22.12.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol MovieDetailPresentationLogic {
    func presentSomething(response: MovieDetail.Something.Response)
}

class MovieDetailPresenter: MovieDetailPresentationLogic {
    weak var viewController: MovieDetailDisplayLogic?
    
    // MARK: Do something
    func presentSomething(response: MovieDetail.Something.Response) {
        let viewModel = MovieDetail.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
}
