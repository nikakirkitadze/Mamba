//
//  VideoResponse.swift
//  Mamba
//
//  Created by Nika Kirkitadze on 9/30/20.
//

import Foundation

struct VideoResponse: Codable {
    var id: Int?
    var videos: [Video]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case videos = "results"
    }
}
