//
//  NowPlayingMovies.swift
//  Muddy
//
//  Created by Bora Erdem on 21.12.2022.
//

import Foundation

struct NowPlayingMovies: Codable {
    let dates: Dates
    let page: Int
    let results: [Result]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
