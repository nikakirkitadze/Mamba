//
//  TVShowViewModel.swift
//  Movie DB
//
//  Created by Nika Kirkitadze on 9/25/20.
//

import Foundation

struct TVShowViewModel {
    
    var id: Int
    var title: String
    var avgRaiting: Double
    
    // MARK: Private properties
    private var posterPath: String
    private var backdropPath: String
    
    var posterUrlString: String {
        return "https://image.tmdb.org/t/p/w300\(posterPath)"
    }
    
    var backdropUrlString: String {
        return "https://image.tmdb.org/t/p/w780\(backdropPath)"
    }
    
    init(show: TVShow) {
        id                 = show.id ?? 0
        title              = show.originalName ?? ""
        avgRaiting         = show.voteAverage ?? 0.0
        posterPath         = show.posterPath ?? ""
        backdropPath       = show.backdropPath ?? ""
    }
}
