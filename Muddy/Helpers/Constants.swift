//
//  Constants.swift
//  Muddy
//
//  Created by Bora Erdem on 20.12.2022.
//

import Foundation

let BASE_URL = "https://api.themoviedb.org/3"
let KEY = "11a3a258ed1e7a614d3539784ff8e9e9"
let O_IMAGE_BASE = "https://image.tmdb.org/t/p/original"
let L_IMAGE_BASE = "https://image.tmdb.org/t/p/w154"

enum MovieGender: Int, CaseIterable {
    case popular
    case nowPlaying
    case upcoming
    case topRated
}

extension MovieGender {
    var toString: String {
        switch self {
        case .popular:
            return "Popular"
        case .upcoming:
            return "Upcoming"
        case .topRated:
            return "Top Rated"
        case .nowPlaying:
            return "Now Playing"
        }
    }
}
