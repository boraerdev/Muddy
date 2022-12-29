//
//  Constants.swift
//  Muddy
//
//  Created by Bora Erdem on 20.12.2022.
//

import Foundation


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
