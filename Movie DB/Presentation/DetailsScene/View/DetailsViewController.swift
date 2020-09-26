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
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageViewHeader: UIImageView!
    @IBOutlet private weak var viewGradient: GradientView!
    
    private let headerHeight: CGFloat = 240
    
    weak var delegate: DetailsViewControllerDelegate?
    
    var showId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.contentInset.top = headerHeight
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

extension DetailsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        navigationController?.navigationBar.isBackgroundHidden = scrollView.contentOffset.y <= 190
        navigationController?.navigationBar.tintColor = scrollView.contentOffset.y <= -44 ? .white : UIColor(hex: "E84367")
        setPageTitle()
        updateHeaderFrame()
    }
    
    func updateHeaderFrame() {
        var headerRect = CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: headerHeight)
        if scrollView.contentOffset.y < 0 {
            headerRect.size.height = -scrollView.contentOffset.y + headerHeight
        }
        imageViewHeader.frame = headerRect
    }
    
    func setPageTitle() {
//        if let movie = currentItem, let movieTitle = movie.title {
//            navigationItem.title = scrollView.contentOffset.y <= 190 ? "" : movieTitle
//        }
//
//        if let movie = favouriteMovieItem, let movieTitle = movie.title {
//            navigationItem.title = scrollView.contentOffset.y <= 190 ? "" : movieTitle
//        }
    }
}
