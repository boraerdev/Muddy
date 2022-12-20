//
//  APIServices.swift
//  Muddy
//
//  Created by Bora Erdem on 21.12.2022.
//

import Foundation

enum APIEndpoint {
    case popularMovies
    case upcomingMovies
    case nowPlayingMovies
    case topRatedMovies
}

extension APIEndpoint {
    var toString: String {
        switch self {
        case .popularMovies:
            return BASE_URL + "/movie/popular" + "?api_key=" + KEY
        case .upcomingMovies:
            return BASE_URL + "/movie/upcoming" + "?api_key=" + KEY
        case .nowPlayingMovies:
            return BASE_URL + "/movie/now_playing" + "?api_key=" + KEY
        case .topRatedMovies:
            return BASE_URL + "/movie/top_rated" + "?api_key=" + KEY
        }
        
    }
}
