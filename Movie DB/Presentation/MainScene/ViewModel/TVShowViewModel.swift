//
//  TVShowViewModel.swift
//  Movie DB
//
//  Created by Nika Kirkitadze on 9/25/20.
//

import Foundation

struct TVShowViewModel {
    
    var title: String
    var avgRaiting: Double
    
    // MARK: Private properties
    private var posterPath: String
    
    var posterUrlString: String {
        return "https://image.tmdb.org/t/p/w300\(posterPath)"
    }
    
    init(show: TVShow) {
        self.title          = show.originalName ?? ""
        self.avgRaiting     = show.voteAverage ?? 0.0
        self.posterPath       = show.posterPath ?? ""
    }
}
