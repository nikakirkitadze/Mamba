//
//  TVShowServiceManager.swift
//  Movie DB
//
//  Created by Nika Kirkitadze on 9/25/20.
//

import Foundation

class TVShowServiceManager {
    static func fetchShows(page: Int = 1, completion: @escaping ([TVShow]) -> ()) {
        let params: [String:String] = [
            "api_key":ApiConfiguration.apiKey,
            "page": "\(page)"
        ]
        WebServiceManager.shared.get(endpoint: "tv/popular", params: params) { (result: Result<TVShowsResponse?, NeoError>) in
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
    
    static func fetchSimilarShows(id: Int, completion: @escaping ([TVShow]) -> ()) {
        let params: [String:String] = [
            "api_key":ApiConfiguration.apiKey
        ]
        WebServiceManager.shared.get(endpoint: "tv/\(id)/similar", params: params) { (result: Result<TVShowsResponse?, NeoError>) in
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
