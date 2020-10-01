//
//  GenreViewModel.swift
//  Mamba
//
//  Created by Nika Kirkitadze on 10/1/20.
//

import UIKit

struct GenreViewModel {
    
    var id: Int
    var name: String
    var selected: Bool = false
    
    var textColor: UIColor? {
        return selected ? .black : .black
    }
    
    var backgroundColor: UIColor? {
        return selected ? .green : UIColor(hex: "d7d7d7")
    }
    
    init(genre: Genre) {
        id = genre.id
        name = genre.name
    }
}
