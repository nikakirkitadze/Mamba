//
//  AppCoordinator.swift
//  Movie DB
//
//  Created by Nika Kirkitadze on 9/26/20.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    private let navController: UINavigationController
    private let window: UIWindow
    
    // MARK: - Initializer
    init(navController: UINavigationController, window: UIWindow) {
        self.navController = navController
        self.window = window
    }
    
    func start() {
        window.rootViewController = navController
        window.makeKeyAndVisible()
        showSplash()
    }
    
    // MARK: - Navigation
    private func showSplash() {
        let sb = AppStoryboard.splash.instance
        let splashVC = sb.instantiate(viewController: SplashViewController.self)
        splashVC.delegate = self
        navController.navigationBar.isHidden = true
        navController.setViewControllers([splashVC], animated: false)
    }
    
    private func showMain() {
        let sb = AppStoryboard.main.instance
        let mainVC = sb.instantiate(viewController: MainViewController.self)
        mainVC.delegate = self
        navController.navigationBar.isHidden = false
        navController.setViewControllers([mainVC], animated: false)
    }
    
    private func pushDetails(viewModel: TVShowViewModel) {
        let sb = AppStoryboard.details.instance
        let detailsVC = sb.instantiate(viewController: DetailsViewController.self)
        detailsVC.delegate = self
        detailsVC.showViewModel = viewModel
        navController.pushViewController(detailsVC, animated: true)
    }
    
    private func pushPerson(with viewModel: CastViewModel) {
        let sb = AppStoryboard.person.instance
        let personVC = sb.instantiate(viewController: PersonViewController.self)
        personVC.delegate = self
        navController.pushViewController(personVC, animated: true)
    }
}

// MARK: - SplashViewControllerDelegate
extension AppCoordinator: SplashViewControllerDelegate {
    func openMain() {
        showMain()
    }
}

// MARK: - MainViewControllerDelegate
extension AppCoordinator: MainViewControllerDelegate {
    func openDetails(pass viewModel: TVShowViewModel) {
        pushDetails(viewModel: viewModel)
    }
}

// MARK: - DetailsViewControllerDelegate?'
extension AppCoordinator: DetailsViewControllerDelegate {
    func openPersonPage(with viewModel: CastViewModel) {
        pushPerson(with: viewModel)
    }
}

// MARK: - PersonViewControllerDelegate
extension AppCoordinator: PersonViewControllerDelegate {
    
}
