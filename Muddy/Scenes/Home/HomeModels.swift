//
//  HomeModels.swift
//  Muddy
//
//  Created by Bora Erdem on 20.12.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum Home {
    // MARK: Use cases
    enum HomeMovies {
        struct Request {
        }
        struct Response {
            var popularMovies: PopularMovies?
            var upcomingMovies: UpcomingMovies?
            var topRatedMovies: TopRatedMovies?
            var nowPlayingMovies: NowPlayingMovies?
        }
        struct ViewModel {
            var popularMovies: PopularMovies?
            var upcomingMovies: UpcomingMovies?
            var topRatedMovies: TopRatedMovies?
            var nowPlayingMovies: NowPlayingMovies?
        }
    }
}
