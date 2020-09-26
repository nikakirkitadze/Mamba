//
//  DetailsViewController.swift
//  Movie DB
//
//  Created by Nika Kirkitadze on 9/25/20.
//

import UIKit

protocol DetailsViewControllerDelegate: class {
    
}

class DetailsViewController: BaseViewController {
    
    // MARK: IBOutlets
    @IBOutlet private weak var viewGradient: GradientView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageViewHeader: NEOImageView!
    @IBOutlet private weak var imageViewPoster: NEOImageView!
    @IBOutlet private weak var viewPosterOuterView: UIView!
    @IBOutlet private weak var labelRating: UILabel!
    @IBOutlet private weak var labelShowTitle: UILabel!
    @IBOutlet private weak var labelShowTitleBig: UILabel!
    @IBOutlet private weak var labelShowOverview: UILabel!
    
    @IBOutlet private weak var constraingHeaderHeight: NSLayoutConstraint!
    
    // MARK: Private properties
    private let headerHeight: CGFloat = 240
    
    var showViewModel: TVShowViewModel?
    
    weak var delegate: DetailsViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureScrollView()
        setShadowForPoster()
        presentShowInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isBackgroundHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isBackgroundHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let showViewModel = showViewModel else {return}
        
        if segue.identifier == Segues.SimilarShows {
            let destination = segue.destination as! SimilarShowsViewController
            destination.showId = showViewModel.id
        }
    }
    
    private func configureScrollView() {
        scrollView.delegate = self
        scrollView.contentInset.top = UIDevice.isIpad ? 2.5 * headerHeight : headerHeight
    }
    
    private func presentShowInfo() {
        guard let viewModel = showViewModel else {return}
        imageViewHeader.loadImage(urlString: viewModel.backdropUrlString)
        imageViewPoster.loadImage(urlString: viewModel.posterUrlString)
        labelShowTitle.text = viewModel.title
        labelRating.attributedText = viewModel.attributedVoteAvarage
        labelShowTitleBig.text = viewModel.titleBig
        labelShowOverview.text = viewModel.overview
    }
    
    private func setShadowForPoster() {
        viewPosterOuterView.layer.shadowColor = Colors.shadowColor.cgColor
        viewPosterOuterView.layer.shadowOpacity = 0.5
        viewPosterOuterView.layer.shadowOffset = CGSize.zero
        viewPosterOuterView.layer.shadowRadius = 10
        viewPosterOuterView.layer.shadowPath = UIBezierPath(roundedRect: imageViewPoster.bounds, cornerRadius: 10).cgPath
        
        imageViewPoster.layer.cornerRadius = 10
    }
}

extension DetailsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setPageTitle()
        updateHeaderFrame()
    }
    
    func updateHeaderFrame() {
        var headerRect = CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: headerHeight)
        if scrollView.contentOffset.y < 0 {
            headerRect.size.height = -scrollView.contentOffset.y + headerHeight
        }
//        imageViewHeader.frame = headerRect
        constraingHeaderHeight.constant = headerRect.height
    }
    
    func setPageTitle() {
        navigationController?.navigationBar.isBackgroundHidden = scrollView.contentOffset.y <= -35
        navigationController?.navigationBar.tintColor = scrollView.contentOffset.y <= -44 ? .white : UIColor(hex: "E84367")
        
        
        guard let viewModel = showViewModel else{return}
        navigationItem.title = scrollView.contentOffset.y <= -35 ? "" : viewModel.title
    }
}
