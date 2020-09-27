//
//  UIViewController+Extension.swift
//  Movie DB
//
//  Created by Nika Kirkitadze on 9/26/20.
//

import UIKit

extension UIViewController {
    
    /// ViewController identifier
    public static var identifier: String {
        return String(describing: self)
    }
    
    /**
     Presents viewController using default paramters.
     
     - Parameters:
        - element: Generic type `UIViewController`
        - storyboard: optional storyboard. Default `element.storyboard`
        - animated: `default = true`
     */
    open func present<T: UIViewController>(element: T.Type, storyboard: UIStoryboard? = nil, animated: Bool = true) {
        if let storyboard = storyboard {
            let viewController = storyboard.instantiate(viewController: element.self)
            present(viewController, animated: animated, completion: nil)
        } else if let storyboard = self.storyboard {
            let viewController = storyboard.instantiate(viewController: element.self)
            present(viewController, animated: animated, completion: nil)
        }
    }
}
