//
//  UICollectionView+Extension.swift
//  Eco Connect
//
//  Created by Nika Kirkitadze on 7/31/20.
//  Copyright © 2020 Capital Group. All rights reserved.
//

import UIKit

extension UICollectionView {
    func registerClass<T: UICollectionViewCell>(class: T.Type) {
        self.register(T.nib(), forCellWithReuseIdentifier: T.identifier)
    }
    
    func deque<T: UICollectionViewCell>(_ classType: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
}
