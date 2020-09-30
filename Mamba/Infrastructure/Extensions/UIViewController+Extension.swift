//
//  UIViewController+Extension.swift
//  Movie DB
//
//  Created by Nika Kirkitadze on 9/26/20.
//

import UIKit

extension UIViewController {
    
    var isDarkMode: Bool {
        if #available(iOS 13.0, *) {
            return self.traitCollection.userInterfaceStyle == .dark
        }
        else {
            return false
        }
    }
    
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
    
    public func removeSelfIfNeeded(with range: Range<Int> = Range(3...4)) {
        guard let nc = self.navigationController else {return}
        guard nc.viewControllers.count > 4 else {return}
        for vc in nc.viewControllers[range] { vc.removeFromParent() }
    }
}
