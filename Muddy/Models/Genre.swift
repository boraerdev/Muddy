//
//  Genre.swift
//  Muddy
//
//  Created by Bora Erdem on 29.12.2022.
//

import Foundation

// MARK: - Genre
struct GenreModel: Codable {
    let genres: [Genre]?
}

// MARK: - GenreElement
struct Genre: Codable {
    let id: Int?
    let name: String?
}
