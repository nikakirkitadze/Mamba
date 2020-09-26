//
//  UIFont+Extension.swift
//  Movie DB
//
//  Created by Nika Kirkitadze on 9/26/20.
//

import UIKit

public enum FontName: String {
    case firaGoBook = "FiraGO-Book"
    case firaGoMedium = "FiraGO-Medium"
    
    var value: String {
        return self.rawValue
    }
}

extension UIFont {
    static func named(_ fontName: FontName, size: CGFloat = 0) -> UIFont {
        return UIFont(name: fontName.value, size: size) ?? UIFont.systemFont(ofSize: 20)
    }
    
    static let firaGoBook = named(.firaGoBook)
}
