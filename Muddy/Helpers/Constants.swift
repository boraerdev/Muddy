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
let M_IMAGE_BASE_BACKDROP = "https://image.tmdb.org/t/p/w780"
let M_IMAGE_BASE_CAST = "https://image.tmdb.org/t/p/w185"

let yOffsetSpeed: CGFloat = 100
let xOffsetSpeed: CGFloat = 30


enum MovieGender: Int, CaseIterable {
    case popular
    case trendsToday
    case nowPlaying
    case upcoming
    
}

extension MovieGender {
    var toString: String {
        switch self {
        case .popular:
            return "Popular"
        case .upcoming:
            return "Upcoming"
        case .trendsToday:
            return "Today's Trends"
        case .nowPlaying:
            return "Now Playing"
        }
    }
}
