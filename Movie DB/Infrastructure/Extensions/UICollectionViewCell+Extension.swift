//
//  UICollectionViewCell+Extension.swift
//  Eco Connect
//
//  Created by Nika Kirkitadze on 7/7/20.
//  Copyright © 2020 Capital Group. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle.main)
    }
}
