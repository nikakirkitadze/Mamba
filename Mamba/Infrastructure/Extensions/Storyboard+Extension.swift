//
//  Storyboard+Extension.swift
//  Movie DB
//
//  Created by Nika Kirkitadze on 9/26/20.
//

import UIKit

extension UIStoryboard {
    
    /**
     Instantiate `UIViewController` and returns the `Element`
     
     - Parameters:
        - viewController: Generic type `UIViewController`
        - storyboard: optional storyboard. Default `element.storyboard`
        - animated: `default = true`
     */
    open func instantiate<Element: UIViewController>(viewController type: Element.Type) -> Element {
        guard let viewController = instantiateViewController(withIdentifier: type.identifier) as? Element else {
            fatalError("Cannot instantiate viewController of type: \(type.identifier)")
        }
        return viewController
    }
}
