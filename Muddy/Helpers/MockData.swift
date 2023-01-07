//
//  MockData.swift
//  Muddy
//
//  Created by Bora Erdem on 21.12.2022.
//

import Foundation

struct MockData {
    static let Result: Result = .init(adult: false, backdropPath: "", genreIDS: [], id: 0, originalLanguage: "", originalTitle: "", overview: "", popularity: 0, posterPath: "", releaseDate: "", title: "Mock", video: false, voteAverage: 0, voteCount: 0)
    
    static let NowPlayingMovies: NowPlayingMovies = .init(dates: .init(maximum: "", minimum: ""), page: 0, results: [], totalPages: 0, totalResults: 0)
}
