//
//  UIApplication.swift
//  Mamba
//
//  Created by Nika Kirkitadze on 10/1/20.
//

import UIKit

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
    
    static func topVC() -> UIViewController? {
        return shared.topMostViewController()
    }
}
