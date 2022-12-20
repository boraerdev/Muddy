//
//  HomeWorker.swift
//  Muddy
//
//  Created by Bora Erdem on 20.12.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class HomeWorker {
    func downloadHomeMovies<T: Codable>(urlString: String) async throws -> T? {
        guard let url = URL(string: urlString) else {return nil}
        do {
            let (data,_) = try await URLSession.shared.data(from: url)
            let populars = try JSONDecoder().decode(T.self, from: data)
            if let pop = populars as? PopularMovies {
                print(pop.results.count)
            }
            return populars
        } catch { return nil }
    }
}
