//
//  DetailsViewController.swift
//  Mamba
//
//  Created by Nika Kirkitadze on 9/25/20.
//

import UIKit

class DetailsViewController: BaseViewController, DetailsStoryboardLodable {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var viewHeader: DetailsHeaderView!
    @IBOutlet private weak var imageViewGlitchTransition: UIImageView!
    @IBOutlet private weak var imageViewPoster: NEOImageView!
    @IBOutlet private weak var viewPosterOuterView: UIView!
    @IBOutlet private weak var imageViewPlay: UIImageView!
    @IBOutlet private weak var viewContent: UIView!
    @IBOutlet private weak var labelRating: UILabel!
    @IBOutlet private weak var labelShowTitle: UILabel!
    @IBOutlet private weak var labelShowTitleBig: UILabel!
    @IBOutlet private weak var labelShowOverview: UILabel!
    @IBOutlet private weak var constraingHeaderHeight: NSLayoutConstraint!
    
    // MARK: Private properties
    private let topBarShowPoint: CGFloat = 110
    private var videos = [Video]()
    
    var showViewModel: TVShowViewModel?
    weak var coordinator: MainCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchTrailers()
        configureScrollView()
        setShadowForPoster()
        presentShowInfo()
        setupPosterGesture()
        removeSelfIfNeeded()
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
            destination.delegate = self
            destination.showId = showViewModel.id
        }
        
        if segue.identifier == Segues.CastSegue {
            let destination = segue.destination as! CastViewController
            destination.delegate = self
            destination.showId = showViewModel.id
        }
    }
    
    private func configureScrollView() {
        scrollView.delegate = self
    }
    
    private func presentShowInfo() {
        guard let viewModel = showViewModel else {return}
        viewHeader.imageUrl = viewModel.backdropUrlString
        imageViewPoster.loadImage(urlString: viewModel.posterUrlString, placeholder: #imageLiteral(resourceName: "ic-picture-placeholder"))
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
    
    private func fetchTrailers() {
        if let vm = showViewModel {
            TVShowServiceManager.fetchTrailers(showId: vm.id) { (videos) in
                self.videos.append(contentsOf: videos)
                Log.debug(videos)
            }
        }
    }
    
    private func setupPosterGesture() {
        imageViewPoster.isUserInteractionEnabled = true
        imageViewPoster.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePosterGesture)))
        
        UIView.animate(withDuration: 0.4, delay: 1) {
            self.imageViewPlay.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        } completion: { (finished) in
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 20, initialSpringVelocity: 8, options: .curveEaseIn) {
                self.imageViewPlay.transform = .identity
            } completion: { (finished) in
                
            }
        }
    }
    
    @objc func handlePosterGesture(_ gesture: UITapGestureRecognizer) {
        guard let first = videos.first, let key = first.key else {return}
        guard let url = URL(string: "youtube://\(key)") else {return}
        
        UIApplication.shared.open(url, options: [:]) { (finished) in
            Log.info("Finished")
        }
    }
}

// MARK: - UIScrollViewDelegate
extension DetailsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setPageTitle()
        updateHeaderFrame()
    }
    
    func updateHeaderFrame() {
        var headerRect = CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: Margins.headerHeight)
        if scrollView.contentOffset.y < 0 {
            headerRect.size.height = -scrollView.contentOffset.y + Margins.headerHeight
        }
        constraingHeaderHeight.constant = headerRect.height
    }
    
    func setPageTitle() {
        navigationController?.navigationBar.isBackgroundHidden = scrollView.contentOffset.y <= topBarShowPoint
        navigationController?.navigationBar.tintColor = scrollView.contentOffset.y <= topBarShowPoint ? Colors.barTintColorHide : Colors.barTintColorShow
        
        guard let viewModel = showViewModel else{return}
        navigationItem.title = scrollView.contentOffset.y <= topBarShowPoint ? "" : viewModel.title
    }
}

// MARK: - CastViewControllerDelegate
extension DetailsViewController: CastViewControllerDelegate {
    func openPersonPage(viewModel: CastViewModel) {
        coordinator?.person(with: viewModel.id)
    }
}

extension DetailsViewController: SimilarShowsViewControllerDelegate {
    func openDetail(with viewModel: TVShowViewModel) {
        coordinator?.details(with: viewModel)
    }
}
