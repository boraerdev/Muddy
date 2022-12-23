//
//  MovieDetailModels.swift
//  Muddy
//
//  Created by Bora Erdem on 22.12.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum MovieDetail {
    // MARK: Use cases
    
    enum FetchMovieDetail {
        struct Request {
            var movieId: Int
        }
        struct Response {
            var movie: DetailedMovie?
        }
        struct ViewModel {
            var movie: DetailedMovie?
        }
    }
    
    enum FetchCredits {
        struct Request {
            var movieId: Int
        }
        struct Response {
            var credits: Credits?
        }
        struct ViewModel {
            var cast: [Cast]?
        }
    }
    
}
