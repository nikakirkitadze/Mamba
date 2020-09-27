//
//  SplashViewController.swift
//  Mamba
//
//  Created by Nika Kirkitadze on 9/27/20.
//

import UIKit

protocol SplashViewControllerDelegate: class {
    func openMain()
}

class SplashViewController: UIViewController {
    
    @IBOutlet private weak var imageViewLogo: UIImageView!
    
    weak var delegate: SplashViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        logoAnimation()
    }
    
    private func logoAnimation() {
        let y = self.view.frame.height / 3.3
        
        UIView.animate(withDuration: 1.5, delay: 0, options: [.curveEaseInOut]) { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.imageViewLogo.transform = CGAffineTransform(translationX: 0, y: y).scaledBy(x: 1.3, y: 1.3)
        } completion: { (finished) in
            self.delegate?.openMain()
        }
    }
}
