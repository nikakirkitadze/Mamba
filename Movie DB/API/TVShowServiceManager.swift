//
//  TVShowServiceManager.swift
//  Movie DB
//
//  Created by Nika Kirkitadze on 9/25/20.
//

import Foundation

class TVShowServiceManager {
    static func load(completion: @escaping ([TVShow]) -> ()) {
        WebServiceManager.shared.get(endpoint: "tv/popular") { (result: Result<TVShowsResponse?, NeoError>) in
            switch result {
            case .success(let response):
                guard let response = response else {return}
                guard let results = response.results else {return}
                completion(results)
            case .failure(let err):
                Log.error(err)
            }
        }
    }
}
