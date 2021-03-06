//
//  PersonViewController.swift
//  Mamba
//
//  Created by Nika Kirkitadze on 9/29/20.
//

import UIKit


class PersonViewController: BaseViewController, PersonStoryboardLodable {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var labelPersonName: UILabel!
    @IBOutlet private weak var labelPersonBio: UILabel!
    @IBOutlet private weak var labelGender: UILabel!
    @IBOutlet private weak var labelBirthday: UILabel!
    @IBOutlet private weak var labelPlaceOfBirth: UILabel!
    @IBOutlet private weak var viewTopGradient: GradientView!
    @IBOutlet private weak var imageViewPerson: NEOImageView!
    
    // MARK: - Private properties
    private var viewModel = PersonPageViewModel()
    private var personName: String?
    private let topBarShowPoint: CGFloat = -40
    
    weak var coordinator: MainCoordinator?
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
        scrollView.delegate = self
    }
    
    private func configureeViewModel() {
        if let personId = personId {
            viewModel.ready(with: personId)
        }
        
        viewModel.didFetchPersonData = { [weak self] personViewModel in
            guard let strongSelf = self else {return}
            strongSelf.personName = personViewModel.name
            
            DispatchQueue.main.async {
                strongSelf.labelPersonName.text = personViewModel.name
                strongSelf.labelGender.text = personViewModel.gender.value
                strongSelf.labelBirthday.text = personViewModel.birthday
                strongSelf.labelPlaceOfBirth.text = personViewModel.placeOfBirth
                strongSelf.labelPersonBio.text = personViewModel.bio
                strongSelf.imageViewPerson.loadImage(urlString: personViewModel.personImageUrl, placeholder: #imageLiteral(resourceName: "ic-picture-placeholder"))
            }
        }
    }
}

// MARK: - UIScrollViewDelegate
extension PersonViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setPageTitle()
    }
    
    func setPageTitle() {
        navigationController?.navigationBar.isBackgroundHidden = scrollView.contentOffset.y <= topBarShowPoint
        navigationController?.navigationBar.tintColor = scrollView.contentOffset.y <= topBarShowPoint ? Colors.barTintColorHide : Colors.barTintColorShow
        guard let name = personName else{return}
        navigationItem.title = scrollView.contentOffset.y <= topBarShowPoint ? "" : name
    }
}
