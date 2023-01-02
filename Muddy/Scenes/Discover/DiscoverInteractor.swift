//
//  DiscoverInteractor.swift
//  Muddy
//
//  Created by Bora Erdem on 20.12.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol DiscoverBusinessLogic {
    func fetchMovies(request: Discover.FetchMovies.Request) async
}

protocol DiscoverDataStore {
    var movies: [Result] { get set }
}

class DiscoverInteractor: DiscoverBusinessLogic, DiscoverDataStore {
    
    var presenter: DiscoverPresentationLogic?
    var worker: DiscoverWorker?
    var movies: [Result] = []
    
    // MARK: Fetch
    func fetchMovies(request: Discover.FetchMovies.Request) async {
        let searchTitles = extractQuotedStrings(from: request.text)
        movies = await searchTitles.enumerated().asyncMap({ index, title in
            let worker = HomeWorker()
            let title = title.trimmingCharacters(in: .whitespacesAndNewlines).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            let url = APIEndpoint.Movie.searchMovie(query: title).toString
            let query: SearchResult? = try? await worker.downloadGenericAboutMovie(urlString: url)
            let movie = query?.results?.first(where: {$0.title == searchTitles[index]}) ?? MockData.Result
            return movie
        })
        print("çıktı")
        let response = Discover.FetchMovies.Response(movies: movies)
        presenter?.presentMovies(response: response)
    }
    
    // MARK: Helpers
    func extractQuotedStrings(from paragraph: String) -> [String] {
        let pattern = "\"(.*?)\""
        let regex = try! NSRegularExpression(pattern: pattern)
        let matches = regex.matches(in: paragraph, range: NSRange(paragraph.startIndex..., in: paragraph))
        return matches.map {
            let range = Range($0.range, in: paragraph)!
            return String(paragraph[range]).replacingOccurrences(of: "\"", with: "")
        }
    }
}


extension Sequence {
    func asyncMap<T>( _ transform: (Element) async throws -> T ) async rethrows -> [T] {
        var values = [T]()
        for element in self {
            try await values.append(transform(element))
        }
        return values
    }
}
