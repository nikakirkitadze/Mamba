//
//  CastViewModel.swift
//  Mamba
//
//  Created by Nika Kirkitadze on 9/28/20.
//

import Foundation

struct CastViewModel {
    
    var id: Int
    var actorName: String
    
    // MARK: - Private properties
    private var profileUrl: String
    
    var profilePath: String {
        return "https://image.tmdb.org/t/p/w300/\(profileUrl)"
    }
    
    init(cast: Cast) {
        id = cast.id ?? 0
        actorName = cast.name ?? ""
        profileUrl = cast.profilePath ?? ""
    }
}
