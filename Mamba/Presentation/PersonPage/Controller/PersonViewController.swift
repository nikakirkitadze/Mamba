//
//  PersonViewController.swift
//  Mamba
//
//  Created by Nika Kirkitadze on 9/29/20.
//

import UIKit

protocol PersonViewControllerDelegate: class {
    
}

class PersonViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var viewTopGradient: GradientView!
    @IBOutlet private weak var imageViewPerson: NEOImageView!
    
    weak var delegate: PersonViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isBackgroundHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isBackgroundHidden = false
    }
}
