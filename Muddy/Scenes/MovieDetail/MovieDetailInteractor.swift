//
//  MovieDetailInteractor.swift
//  Muddy
//
//  Created by Bora Erdem on 22.12.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol MovieDetailBusinessLogic {
    func doSomething(request: MovieDetail.Something.Request)
}

protocol MovieDetailDataStore {
    var selectedMovie: Result { get set }
}

class MovieDetailInteractor: MovieDetailBusinessLogic, MovieDetailDataStore {
    var presenter: MovieDetailPresentationLogic?
    var worker: MovieDetailWorker?
    var selectedMovie: Result = MockData.Result
    
    // MARK: Do something
    func doSomething(request: MovieDetail.Something.Request) {
        worker = MovieDetailWorker()
        worker?.doSomeWork()
        
        let response = MovieDetail.Something.Response()
        presenter?.presentSomething(response: response)
    }
    
}
