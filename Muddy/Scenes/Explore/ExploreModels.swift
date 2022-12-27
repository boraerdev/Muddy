//
//  ExploreModels.swift
//  Muddy
//
//  Created by Bora Erdem on 26.12.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum Explore {
    // MARK: Use cases
    enum FetchDiscover {
        struct Request {
        }
        struct Response {
            var discoverMoviws: DiscoverMovies?
        }
        struct ViewModel {
            var moviesList: [Result]
        }
    }
    
    enum FetchSearch {
        struct Request {
            var query: String
        }
        struct Response {
            var searchResult: SearchResult?
        }
        struct ViewModel {
            var moviesList: [Result]
        }
    }
    
    
}
