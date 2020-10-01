//
//  GenresServiceManager.swift
//  Mamba
//
//  Created by Nika Kirkitadze on 10/1/20.
//

import Foundation

class GenresServiceManager {
    static func tvGenresList(completion: @escaping ([Genre]) -> ()) {
        WebServiceManager.shared.get(endpoint: "genre/tv/list") { (result: Result<GenresResponse?, NeoError>) in
            switch result {
            case .success(let response):
                guard let res = response, let genres = res.genres else {return}
                completion(genres)
            case .failure(let err):
                Log.error(err)
            }
        }
    }
}
