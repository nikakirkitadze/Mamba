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

class SplashViewController: UIViewController, SplashStoryboardLodable {
    
    @IBOutlet private weak var imageViewLogo: UIImageView!
    @IBOutlet private weak var imageViewGlitchTransition: UIImageView!
    
    weak var coordinator: MainCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        glitch()
        logoAnimation()
    }
    
    private func logoAnimation() {
        let y = self.view.frame.height / 3.3
        
        UIView.animate(withDuration: 1.5, delay: 0, options: [.curveEaseInOut]) { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.imageViewLogo.transform = CGAffineTransform(translationX: 0, y: y).scaledBy(x: 1.3, y: 1.3)
        } completion: { (finished) in
            self.coordinator?.main()
        }
    }
    
    private func glitch() {
        imageViewGlitchTransition.isHidden = true
        imageViewGlitchTransition.alpha = 0.4
        imageViewGlitchTransition.loadGif(name: "gif-glitch-transition")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.imageViewGlitchTransition.isHidden = false
            self.imageViewLogo.isHidden = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.imageViewGlitchTransition.isHidden = true
                self.imageViewLogo.isHidden = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.imageViewGlitchTransition.isHidden = false
                    self.imageViewLogo.isHidden = true
                }
            }
        }
    }
}
