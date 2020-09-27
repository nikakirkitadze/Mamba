//
//  UIView+Extension.swift
//  Movie DB
//
//  Created by Nika Kirkitadze on 9/25/20.
//

import UIKit

extension UIView {
    var recursiveSubviews: [UIView] {
        var subviews = self.subviews.compactMap({$0})
        subviews.forEach { subviews.append(contentsOf: $0.recursiveSubviews) }
        return subviews
    }
    
    func addShadow(color: UIColor, offset: CGSize, opacity: Float, radius: CGFloat = 5.0) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset // CGSize(width: 0, height: 1.0)
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
}
