//
//  AppStoryboard.swift
//  Movie DB
//
//  Created by Nika Kirkitadze on 9/26/20.
//

import UIKit

enum AppStoryboard: String {
    
    case main               = "Main"
    case details            = "Details"
    
    var name: String {
        switch self {
        case .main: return "Main"
        case .details: return "Details"
        }
    }
    
    var instance: UIStoryboard {
        UIStoryboard(name: rawValue, bundle: nil)
    }
    
    func viewControllerFromId<T: UIViewController>() -> T? {
        return self.instance.instantiateViewController(withIdentifier: String(describing: T.self)) as? T
    }
}
