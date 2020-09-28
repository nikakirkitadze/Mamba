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
    @IBOutlet private weak var viewHeader: DetailsHeaderView!
    @IBOutlet private weak var imageViewPoster: NEOImageView!
    @IBOutlet private weak var viewPosterOuterView: UIView!
    @IBOutlet private weak var viewContent: UIView!
    @IBOutlet private weak var labelRating: UILabel!
    @IBOutlet private weak var labelShowTitle: UILabel!
    @IBOutlet private weak var labelShowTitleBig: UILabel!
    @IBOutlet private weak var labelShowOverview: UILabel!
    @IBOutlet private weak var constraingHeaderHeight: NSLayoutConstraint!
    
    // MARK: Private properties
    private var headerHeight: CGFloat {
        return UIDevice.isIpad ? 450 : 240
    }
    private let topBarShowPoint: CGFloat = 110
    
    var showViewModel: TVShowViewModel?
    
    weak var delegate: DetailsViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureScrollView()
        setShadowForPoster()
        presentShowInfo()
        
        guard let viewModel = showViewModel else {
            return
        }
        TVShowServiceManager.fetchCasts(showId: viewModel.id) { (data) in
            print(data)
        }
        
//        let shapeLayer = CAShapeLayer()
//        let path = UIBezierPath()
//        path.move(to: CGPoint(x: 0, y: 25)) // start
//        path.addLine(to: CGPoint(x: view.frame.maxX, y: 0))
//        path.addLine(to: CGPoint(x: view.frame.maxX, y: view.frame.maxY))
//        path.addLine(to: CGPoint(x: 0, y: view.frame.maxY))
//        path.addLine(to: CGPoint(x: 0, y: 25)) // end
//        path.close()
//        shapeLayer.path = path.cgPath
//
//        viewContent.layer.addSublayer(shapeLayer)
//        shapeLayer.frame = viewContent.bounds
//        shapeLayer.fillColor = Colors.mainBG!.cgColor
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
        
        if segue.identifier == Segues.CastSegue {
            let destination = segue.destination as! CastViewController
            destination.showId = showViewModel.id
        }
    }
    
    private func configureScrollView() {
        scrollView.delegate = self
//        scrollView.contentInset.top = UIDevice.isIpad ? 2.5 * headerHeight : headerHeight
    }
    
    private func presentShowInfo() {
        guard let viewModel = showViewModel else {return}
        viewHeader.imageUrl = viewModel.backdropUrlString
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
        Log.debug(scrollView.contentOffset.y)
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
        navigationController?.navigationBar.isBackgroundHidden = scrollView.contentOffset.y <= topBarShowPoint
//        navigationController?.navigationBar.tintColor = scrollView.contentOffset.y <= topBarShowPoint ? .white : Colors.textSecondary
        
        guard let viewModel = showViewModel else{return}
        navigationItem.title = scrollView.contentOffset.y <= topBarShowPoint ? "" : viewModel.title
    }
}
