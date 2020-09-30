//
//  Coordinator.swift
//  Movie DB
//
//  Created by Nika Kirkitadze on 9/26/20.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
