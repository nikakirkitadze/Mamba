//
//  GenresResponse.swift
//  Mamba
//
//  Created by Nika Kirkitadze on 10/1/20.
//

import Foundation

struct GenresResponse: Codable {
    var genres: [Genre]?
}

struct Genre: Codable {
    var id: Int
    var name: String
}
