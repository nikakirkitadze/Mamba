//
//  PersonViewModel.swift
//  Mamba
//
//  Created by Nika Kirkitadze on 9/29/20.
//

import Foundation

enum Gender: Int {
    case female = 0
    case male
    
    var value: String {
        return self == .female ? "Female" : "Male"
    }
}

struct PersonViewModel {
    
    var name: String
    var birthday: String
    var bio: String
    var gender: Gender
    
    // MARK: - Private properties
    private var imageUrl: String
    
    var personImageUrl: String {
        return "https://image.tmdb.org/t/p/w300/\(imageUrl)"
    }
    
    init(person: Person) {
        name = person.name ?? ""
        birthday = person.birthday ?? ""
        bio = person.biography ?? ""
        gender = Gender(rawValue: person.gender ?? 0) ?? .male
        imageUrl = person.profilePath ?? ""
    }
}
