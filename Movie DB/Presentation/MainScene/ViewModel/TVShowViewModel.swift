//
//  TVShowViewModel.swift
//  Movie DB
//
//  Created by Nika Kirkitadze on 9/25/20.
//

import UIKit

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
    
    var attributedVoteAvarage: NSMutableAttributedString {
        let shadow = NSShadow()
        shadow.shadowOffset = .zero
        shadow.shadowColor = Colors.shadowColor
        shadow.shadowBlurRadius = 5
        
        var attributes = [
            NSAttributedString.Key.font:UIFont.named(.firaGoBook, size: 44),
            NSAttributedString.Key.foregroundColor:Colors.textMain,
            NSAttributedString.Key.shadow: shadow
        ]
        
        let body = NSMutableAttributedString()
        // first part
        let attributedStringFirst = NSAttributedString(string: "\(avgRaiting)", attributes: attributes)
        // decrease font size
        attributes[NSAttributedString.Key.font] = UIFont.named(.firaGoBook, size: 30)
        let attributedStringSecond = NSAttributedString(string: "/10", attributes: attributes)
        
        // whole string
        body.append(attributedStringFirst)
        body.append(attributedStringSecond)
        
        return body
    }
    
    init(show: TVShow) {
        id                 = show.id ?? 0
        title              = show.originalName ?? ""
        avgRaiting         = show.voteAverage ?? 0.0
        posterPath         = show.posterPath ?? ""
        backdropPath       = show.backdropPath ?? ""
    }
}
