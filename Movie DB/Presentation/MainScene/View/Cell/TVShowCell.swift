//
//  TVShowCell.swift
//  Movie DB
//
//  Created by Nika Kirkitadze on 9/25/20.
//

import UIKit

class TVShowCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageViewPoster: UIImageView!
    @IBOutlet private weak var constraintMaxWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backgroundColor = .red
    }
    
    private func setBottomShadow() {
        let shadowSize: CGFloat = 10
        let shadowDistance: CGFloat = -12
        let contactRect = CGRect(x: shadowSize, y: frame.height - (shadowSize * 0.4) + shadowDistance, width: frame.width - shadowSize * 2, height: shadowSize)
        layer.shadowColor = UIColor(hex: "E84367").cgColor
        layer.shadowPath = UIBezierPath(ovalIn: contactRect).cgPath
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.4
    }

    internal func configure(with viewModel: TVShowViewModel) {
        
    }
}
