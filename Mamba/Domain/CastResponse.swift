//
//  CastResponse.swift
//  Mamba
//
//  Created by Nika Kirkitadze on 9/28/20.
//

import Foundation

// MARK: - CastResponse
struct CastResponse: Codable {
    let cast: [Cast]?
    let crew: [Crew]?
    let id: Int?
}

// MARK: - Cast
struct Cast: Codable {
    let character, creditID: String?
    let id: Int?
    let name: String?
    let gender: Int?
    let profilePath: String?
    let order: Int?

    enum CodingKeys: String, CodingKey {
        case character
        case creditID = "credit_id"
        case id, name, gender
        case profilePath = "profile_path"
        case order
    }
}

// MARK: - Crew
struct Crew: Codable {
    let creditID, department: String?
    let id: Int?
    let name: String?
    let gender: Int?
    let job: String?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case creditID = "credit_id"
        case department, id, name, gender, job
        case profilePath = "profile_path"
    }
}
