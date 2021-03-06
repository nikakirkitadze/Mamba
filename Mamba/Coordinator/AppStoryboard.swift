//
//  AppStoryboard.swift
//  Movie DB
//
//  Created by Nika Kirkitadze on 9/26/20.
//

import UIKit

enum AppStoryboard: String {
    
    case splash             = "Splash"
    case main               = "Main"
    case details            = "Details"
    case person             = "Person"
    
    var name: String {
        switch self {
        case .splash: return "Splash"
        case .main: return "Main"
        case .details: return "Details"
        case .person: return "Person"
        }
    }
    
    var instance: UIStoryboard {
        UIStoryboard(name: rawValue, bundle: nil)
    }
    
    func viewControllerFromId<T: UIViewController>() -> T? {
        return self.instance.instantiateViewController(withIdentifier: String(describing: T.self)) as? T
    }
}
