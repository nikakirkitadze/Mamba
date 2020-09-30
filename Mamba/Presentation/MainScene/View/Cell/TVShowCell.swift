//
//  TVShowCell.swift
//  Movie DB
//
//  Created by Nika Kirkitadze on 9/25/20.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
}

class TVShowCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageViewPoster: NEOImageView!
    @IBOutlet private weak var labelShowTitle: UILabel!
    @IBOutlet private weak var labelDate: UILabel!
    @IBOutlet private weak var viewRatingContainer: RatingView!
    @IBOutlet private weak var viewHighlight: UIView!
    @IBOutlet private weak var constraintMaxWidth: NSLayoutConstraint!
    @IBOutlet private weak var constraintMaxHeight: NSLayoutConstraint!
    
    private var effectView: UIVisualEffectView?
    
    private var maxWidth: CGFloat? = nil {
        didSet {
            guard let maxWidth = maxWidth else {
                return
            }
            constraintMaxWidth.isActive = true
            constraintMaxWidth.constant = maxWidth
        }
    }
    
    private var maxHeight: CGFloat? = nil {
        didSet {
            guard let maxHeight = maxHeight else {
                return
            }
            constraintMaxHeight.isActive = true
            constraintMaxHeight.constant = maxHeight
        }
    }
    
    var size: CGSize = .zero {
        didSet {
            maxHeight = size.height
            maxWidth = size.width
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 5
        imageViewPoster.layer.cornerRadius = 5
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                viewHighlight?.isHidden = false
                viewHighlight?.alpha = 1.0
            } else {
                UIView.animate(withDuration: 0.1,
                               delay: 0.0, options: [.curveEaseOut, .allowUserInteraction],
                               animations: { [unowned self] in
                                self.viewHighlight?.alpha = 0.0
                    }) { _ in
                        self.viewHighlight?.isHidden = true
                }
            }
        }
    }
    
    private func setBottomShadow() {
        let shadowSize: CGFloat = 10
        let shadowDistance: CGFloat = -5
        let contactRect = CGRect(x: shadowSize, y: frame.height - (shadowSize * 0.4) + shadowDistance, width: frame.width - shadowSize * 2, height: shadowSize)
        layer.shadowColor = Colors.shadowColor.cgColor
        layer.shadowPath = UIBezierPath(ovalIn: contactRect).cgPath
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.4
    }

    internal func configure(with viewModel: TVShowViewModel) {
        imageViewPoster.loadImage(urlString: viewModel.posterUrlString)
        labelShowTitle.text = viewModel.title
        labelDate.text = viewModel.date
        viewRatingContainer.avgRaiting = viewModel.avgRaiting
    }
}
