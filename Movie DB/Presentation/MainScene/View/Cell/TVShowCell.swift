//
//  TVShowCell.swift
//  Movie DB
//
//  Created by Nika Kirkitadze on 9/25/20.
//

import UIKit

class TVShowCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageViewPoster: NEOImageView!
    @IBOutlet private weak var constraintMaxWidth: NSLayoutConstraint!
    @IBOutlet private weak var constraintMaxHeight: NSLayoutConstraint!
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 5
        imageViewPoster.layer.cornerRadius = 5
        setBottomShadow()
    }
    
    private func setBottomShadow() {
        let shadowSize: CGFloat = 10
        let shadowDistance: CGFloat = -5
        let contactRect = CGRect(x: shadowSize, y: frame.height - (shadowSize * 0.4) + shadowDistance, width: frame.width - shadowSize * 2, height: shadowSize)
        layer.shadowColor = Colors.cellShadowColor.cgColor
        layer.shadowPath = UIBezierPath(ovalIn: contactRect).cgPath
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.4
    }

    internal func configure(with viewModel: TVShowViewModel) {
        imageViewPoster.loadImage(urlString: viewModel.posterUrlString)
    }
}
