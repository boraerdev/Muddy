//
//  PopularMoview.swift
//  Muddy
//
//  Created by Bora Erdem on 20.12.2022.
//

import Foundation

struct PopularMovies: Codable {
    let page: Int
    let results: [Result]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

