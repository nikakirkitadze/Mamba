//
//  DetailsHeaderView.swift
//  Mamba
//
//  Created by Nika Kirkitadze on 9/28/20.
//

import UIKit

class DetailsHeaderView: UIView {
    
    // MARK: - IBInspectable properties
    @IBInspectable var imageHeader: UIImage! {
        didSet {
            imageViewHeader?.image = imageHeader
        }
    }
    
    // MARK: - Private properties
    private var imageViewHeader: NEOImageView?
    private var viewGradient: GradientView?
    
    // MARK: - Internal properties
    internal var imageUrl: String? {
        didSet {
            if let url = imageUrl {
                imageViewHeader?.loadImage(urlString: url)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    private func setupLayout() {
        createImageViewHeader()
        createNoiseImage()
        createViewGradient()
    }
    
    private func createImageViewHeader() {
        imageViewHeader = NEOImageView()
        imageViewHeader?.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageViewHeader!)
        imageViewHeader?.fillSuperview()
    }
    
    private func createViewGradient() {
        viewGradient = GradientView()
        viewGradient?.translatesAutoresizingMaskIntoConstraints = false
        viewGradient?.topColor = UIColor.black.withAlphaComponent(0.1)
        viewGradient?.bottomColor = UIColor.black.withAlphaComponent(0.8)
        viewGradient?.isVertical = true
        addSubview(viewGradient!)
        viewGradient?.fillSuperview()
    }
    
    private func createNoiseImage() {
        let iv = UIImageView(image: UIImage(named: "img-noise"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iv)
        iv.fillSuperview()
    }
}
