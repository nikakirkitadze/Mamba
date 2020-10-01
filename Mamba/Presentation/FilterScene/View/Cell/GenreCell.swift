//
//  GenreCell.swift
//  Mamba
//
//  Created by Nika Kirkitadze on 10/1/20.
//

import UIKit

class GenreCell: UICollectionViewCell {

    @IBOutlet weak var labelGenreName: UILabel!
    @IBOutlet weak var labelGenreMaxHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelGenreNameMaxWidthConstraint: NSLayoutConstraint!

    private var horizontalPadding: CGFloat = 32

    func setMaximumCellWidth(_ width: CGFloat) {
        self.labelGenreNameMaxWidthConstraint.constant = width - horizontalPadding
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = frame.height/2
    }
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor(hex: "d7d7d7")
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.labelGenreName.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        self.labelGenreName.numberOfLines = 0
    }

    internal func configure(with viewModel: GenreViewModel) {
        labelGenreName.text = viewModel.name
        labelGenreName.textColor = viewModel.textColor
        backgroundColor = viewModel.backgroundColor
    }

}
