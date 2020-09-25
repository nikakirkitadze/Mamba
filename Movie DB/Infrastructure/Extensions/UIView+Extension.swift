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
}
