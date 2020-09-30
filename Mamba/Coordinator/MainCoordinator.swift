//
//  MainCoordinatorr.swift
//  Mamba
//
//  Created by Nika Kirkitadze on 9/30/20.
//

import UIKit

class MainCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var window: UIWindow?
    
    init(window: UIWindow? = nil, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = SplashViewController.instantiate()
        vc.coordinator = self
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func main() {
        let vc = MainViewController.instantiate()
        vc.coordinator = self
        navigationController.navigationBar.isHidden = false
        navigationController.setViewControllers([vc], animated: false)
    }
    
    func details(with viewModel: TVShowViewModel) {
        let vc = DetailsViewController.instantiate()
        vc.showViewModel = viewModel
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func person(with personId: Int) {
        let vc = PersonViewController.instantiate()
        vc.personId = personId
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}
