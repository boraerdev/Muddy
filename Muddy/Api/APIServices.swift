//
//  APIServices.swift
//  Muddy
//
//  Created by Bora Erdem on 21.12.2022.
//

import Foundation

enum APIEndpoint {
    
    enum Movie {
        case popularMovies
        case upcomingMovies
        case nowPlayingMovies
        case topRatedMovies
        case details(id: Int)
        case credits(id: Int)
    }
    
    enum Image {
        case orgImage(path: String)
        case lowPosterImage(path: String)
        case mediumBackdropImage(path: String)
        case mediumCastImage(path: String)
    }
    
}


extension APIEndpoint.Movie {
    var toString: String {
        switch self {
        case APIEndpoint.Movie.popularMovies:
            return BASE_URL + "/movie/popular" + "?api_key=" + KEY
        case .upcomingMovies:
            return BASE_URL + "/movie/upcoming" + "?api_key=" + KEY
        case .nowPlayingMovies:
            return BASE_URL + "/movie/now_playing" + "?api_key=" + KEY
        case .topRatedMovies:
            return BASE_URL + "/movie/top_rated" + "?api_key=" + KEY
        case .details(let id):
            return BASE_URL + "/movie/\(id)" + "?api_key=" + KEY
        case .credits(let id):
            return BASE_URL + "/movie/\(id)/credits" + "?api_key=" + KEY
        }
    }
}

extension APIEndpoint.Image {
    var toString: String {
        switch self {
        case .orgImage(let path):
            return O_IMAGE_BASE + path
        case .lowPosterImage(let path):
            return L_IMAGE_BASE + path
        case .mediumBackdropImage(path: let path):
            return M_IMAGE_BASE_BACKDROP + path
        case .mediumCastImage(let path):
            return M_IMAGE_BASE_CAST + path
        }
    }
}
