//
//  Storyboarded.swift
//  Mamba
//
//  Created by Nika Kirkitadze on 9/30/20.
//

import UIKit

protocol Storyboarded {
    static func instantiate() -> Self
    @nonobjc static var storyboardName: String { get }
}

extension Storyboarded {
    static func instantiate() -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
}

protocol SplashStoryboardLodable: Storyboarded {}
protocol MainStoryboardLodable: Storyboarded {}
protocol FilterStoryboardLodable: Storyboarded {}
protocol DetailsStoryboardLodable: Storyboarded {}
protocol PersonStoryboardLodable: Storyboarded {}

extension SplashStoryboardLodable where Self: UIViewController {
    @nonobjc static var storyboardName: String {
        return "Splash"
    }
}

extension MainStoryboardLodable where Self: UIViewController {
    @nonobjc static var storyboardName: String {
        return "Main"
    }
}

extension FilterStoryboardLodable where Self: UIViewController {
    @nonobjc static var storyboardName: String {
        return "Filter"
    }
}

extension DetailsStoryboardLodable where Self: UIViewController {
    @nonobjc static var storyboardName: String {
        return "Details"
    }
}

extension PersonStoryboardLodable where Self: UIViewController {
    @nonobjc static var storyboardName: String {
        return "Person"
    }
}

