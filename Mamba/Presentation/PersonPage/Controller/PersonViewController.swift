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
    @IBOutlet private weak var labelPersonName: UILabel!
    @IBOutlet private weak var labelPersonBio: UILabel!
    @IBOutlet private weak var viewTopGradient: GradientView!
    @IBOutlet private weak var imageViewPerson: NEOImageView!
    
    // MARK: - Private properties
    private var viewModel = PersonPageViewModel()
    
    weak var delegate: PersonViewControllerDelegate?
    var personId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        configureeViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isBackgroundHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isBackgroundHidden = false
    }
    
    private func setupLayout() {
        imageViewPerson.layer.cornerRadius = 10
    }
    
    private func configureeViewModel() {
        if let personId = personId {
            viewModel.ready(with: personId)
        }
        
        viewModel.didFetchPersonData = { [weak self] personViewModel in
            guard let strongSelf = self else {return}
            
            DispatchQueue.main.async {
                strongSelf.labelPersonName.text = personViewModel.name
                strongSelf.labelPersonBio.text = personViewModel.bio
                strongSelf.imageViewPerson.loadImage(urlString: personViewModel.personImageUrl)
            }
        }
    }
}
