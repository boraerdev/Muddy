//
//  DiscoverModels.swift
//  Muddy
//
//  Created by Bora Erdem on 20.12.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum Discover {
    // MARK: Use cases
    enum FetchMovies {
        struct Request {
            var text: String
        }
        struct Response {
            var movies: [Result]
        }
        struct ViewModel {
            var movies: [Result]
        }
    }
}
