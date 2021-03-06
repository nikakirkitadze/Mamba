//
//  TVShowViewModel.swift
//  Mamba
//
//  Created by Nika Kirkitadze on 9/25/20.
//

import UIKit

struct TVShowViewModel {
    
    internal var id: Int
    internal var title: String
    internal var titleBig: String
    internal var overview: String
    internal var avgRaiting: Double
    internal var date: String
    
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
        shadow.shadowColor = Colors.ratingColor
        shadow.shadowBlurRadius = 5
        
        var attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font:UIFont.named(.firaGoBook, size: 44),
            NSAttributedString.Key.foregroundColor:Colors.ratingColor,
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
        id                  = show.id ?? 0
        title               = show.originalName ?? ""
        titleBig            = "\(title) | \(show.firstAirDate ?? "")"
        overview            = show.overview ?? ""
        avgRaiting          = show.voteAverage ?? 0.0
        posterPath          = show.posterPath ?? ""
        backdropPath        = show.backdropPath ?? ""
        date                = show.firstAirDate ?? ""
    }
}
