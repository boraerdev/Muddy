//
//  Constants.swift
//  Muddy
//
//  Created by Bora Erdem on 20.12.2022.
//

import Foundation

let BASE_URL = "https://api.themoviedb.org/3"
let KEY = "11a3a258ed1e7a614d3539784ff8e9e9"
let IMAGE_BASE = "https://image.tmdb.org/t/p/original"

enum MovieGender: String, CaseIterable {
    case popular = "popular"
    case upcoming = "upcoming"
    case topRated = "topRated"
    case nowPlaying = "nowPlaying"
}
