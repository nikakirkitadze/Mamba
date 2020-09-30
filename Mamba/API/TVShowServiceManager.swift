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
    
    static func search(with query: String, and page: Int = 1, completion: @escaping ([TVShow]) -> ()) {
        let params: [String:String] = [
            "api_key":ApiConfiguration.apiKey,
            "query": query,
            "page": "\(page)"
        ]
        WebServiceManager.shared.get(endpoint: "search/tv", params: params) { (result: Result<TVShowsResponse?, NeoError>) in
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
    
    static func fetchCasts(showId: Int, completion: @escaping ([Cast]) -> ()) {
        let params: [String:String] = [
            "api_key":ApiConfiguration.apiKey,
            "tv_id": "\(showId)"
        ]
        WebServiceManager.shared.get(endpoint: "/tv/\(showId)/credits", params: params) { (result: Result<CastResponse?, NeoError>) in
            switch result {
            case .success(let response):
                guard let response = response else {return}
                guard let results = response.cast else {return}
                completion(results)
            case .failure(let err):
                Log.error(err)
            }
        }
    }
    
    static func fetchTrailers(showId: Int, completion: @escaping ([Video]) -> ()) {
//        https://www.youtube.com/watch?v=
        WebServiceManager.shared.get(endpoint: "/tv/\(showId)/videos") { (result: Result<VideoResponse?, NeoError>) in
            switch result {
            case .success(let response):
                guard let response = response else {return}
                completion(response.videos ?? [])
            case .failure(let err):
                Log.error(err)
            }
        }
    }
}
