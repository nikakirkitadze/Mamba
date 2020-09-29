//
//  Constants.swift
//  Movie DB
//
//  Created by Nika Kirkitadze on 8/17/20.
//

import UIKit

struct StoryboardId {
    static let Main                             = "Main"
    static let Details                          = "Details"
}

struct Segues {
    static let CastSegue                        = "cast_segue"
    static let SimilarShows                     = "smilar_shows"
}

struct Margins {
    static let leading: CGFloat                 = 24
    static let trailing: CGFloat                = 24
}

struct Colors {
    static let mainBG                           = UIColor(named: "background")
    static let textMain                         = UIColor(named: "textColor")
    static let textSecondary                    = UIColor(named: "textColorSecondary")
    static let barTintColorShow                 = UIColor(named: "barTintColorShow")
    static let barTintColorHide                 = UIColor(named: "barTintColorHide")
    static let shadowColor                      = UIColor(hex: "FFBB3B")
    static let ratingColor                      = UIColor(hex: "f4f6ff")
}
