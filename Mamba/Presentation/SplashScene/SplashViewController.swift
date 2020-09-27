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

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
