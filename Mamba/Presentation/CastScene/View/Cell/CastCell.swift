//
//  CastCell.swift
//  Mamba
//
//  Created by Nika Kirkitadze on 9/28/20.
//

import UIKit

class CastCell: UICollectionViewCell {

    @IBOutlet private weak var imageViewPerson: NEOImageView!
    @IBOutlet private weak var labelActorName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageViewPerson.layer.cornerRadius = imageViewPerson.frame.width/2
    }

    internal func configure(with viewModel: CastViewModel) {
        imageViewPerson.loadImage(urlString: viewModel.profilePath, placeholder: #imageLiteral(resourceName: "ic-picture-placeholder"))
        labelActorName.text = viewModel.actorName
    }
}
