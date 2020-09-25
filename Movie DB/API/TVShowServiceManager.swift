//
//  TVShowServiceManager.swift
//  Movie DB
//
//  Created by Nika Kirkitadze on 9/25/20.
//

import Foundation

class TVShowServiceManager {
    static func load(completion: @escaping ([TVShow]) -> ()) {
        WebServiceManager.shared.get(endpoint: "tv/popular", params: ["api_key":ApiConfiguration.apiKey]) { (result: Result<TVShowsResponse?, NeoError>) in
            switch result {
            case .success(let response):
                guard let response = response else {return}
                completion(response.results)
            case .failure(let err):
                Log.error(err)
            }
        }
    }
}
