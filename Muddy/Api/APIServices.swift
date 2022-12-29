//
//  APIServices.swift
//  Muddy
//
//  Created by Bora Erdem on 21.12.2022.
//

import Foundation


//|  poster  | backdrop |  still   | profile  |   logo   |
//| :------: | :------: | :------: | :------: | :------: |
//| -------- | -------- | -------- |    w45   |    w45   |
//|    w92   | -------- |    w92   | -------- |    w92   |
//|   w154   | -------- | -------- | -------- |   w154   |
//|   w185   | -------- |   w185   |   w185   |   w185   |
//| -------- |   w300   |   w300   | -------- |   w300   |
//|   w342   | -------- | -------- | -------- | -------- |
//|   w500   | -------- | -------- | -------- |   w500   |
//| -------- | -------- | -------- |   h632   | -------- |
//|   w780   |   w780   | -------- | -------- | -------- |
//| -------- |  w1280   | -------- | -------- | -------- |
//| original | original | original | original | original |

let BASE_URL = "https://api.themoviedb.org/3"
let IMAGE_BASE = "https://image.tmdb.org/t/p/"
let KEY = "11a3a258ed1e7a614d3539784ff8e9e9"

//You can add case to enum
enum ImageQuality: String {
    case original
    case w154
    case w185
    case w300
    case w780
}

enum APIEndpoint {
    
    enum Movie {
        case popularMovies
        case upcomingMovies
        case nowPlayingMovies
        case topRatedMovies
        case details(id: Int)
        case credits(id: Int)
        case getRecommendations(id: Int)
        case discoverMovie(params: String)
        case searchMovie(query: String)
        case genres
    }
    
    enum Image {
        case withQuality(quality: ImageQuality, path: String)
    }
    
}

//TODO: Refactor this endpoint
extension APIEndpoint.Movie {
    var toString: String {
        switch self {
        case .popularMovies:
            return BASE_URL + "/movie/popular" + "?api_key=" + KEY
        case .upcomingMovies:
            return BASE_URL + "/movie/upcoming" + "?api_key=" + KEY
        case .nowPlayingMovies:
            return BASE_URL + "/movie/now_playing" + "?api_key=" + KEY
        case .topRatedMovies:
            return BASE_URL + "/trending/movie/day" + "?api_key=" + KEY
        case .details(let id):
            return BASE_URL + "/movie/\(id)" + "?api_key=" + KEY
        case .credits(let id):
            return BASE_URL + "/movie/\(id)/credits" + "?api_key=" + KEY
        case .getRecommendations(let id):
            return BASE_URL + "/movie/\(id)/recommendations" + "?api_key=" + KEY
        case .discoverMovie(let params):
            return BASE_URL + "/discover/movie" + "?api_key=" + KEY + params
        case .searchMovie(let query):
            return BASE_URL + "/search/movie" + "?api_key=" + KEY + "&query=" + query
        case .genres:
            return BASE_URL + "/genre/movie/list" + "?api_key=" + KEY
        }
    }
}

extension APIEndpoint.Image {
    var toString: String {
        switch self {
        case .withQuality(quality: let quality, path: let path):
            return IMAGE_BASE + quality.rawValue + path
        }
    }
}
