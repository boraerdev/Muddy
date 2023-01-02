//
//  HomeWorker.swift
//  Muddy
//
//  Created by Bora Erdem on 20.12.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class HomeWorker {
    static let shared = HomeWorker()
    
    func downloadGenericAboutMovie<T: Codable>(urlString: String) async throws -> T? {
        guard let url = URL(string: urlString) else {return nil}
        do {
            let (data,_) = try await URLSession.shared.data(from: url)
            let json = try JSONDecoder().decode(T.self, from: data)
            print("WorkerURL: \(url.absoluteString)")
            return json
        } catch { return nil }
    }
    
    
}
