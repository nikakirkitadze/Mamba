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
    private var imageViewGlitch: UIImageView?
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
        createImageViewGlitch()
        createNoiseImage()
        createViewGradient()
    }
    
    private func createImageViewHeader() {
        imageViewHeader = NEOImageView()
        imageViewHeader?.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageViewHeader!)
        imageViewHeader?.fillSuperview()
    }
    
    private func createImageViewGlitch() {
        imageViewGlitch = UIImageView()
        imageViewGlitch?.isHidden = true
        imageViewGlitch?.alpha = 0.25
        imageViewGlitch?.loadGif(name: "gif-glitch-transition")
        imageViewGlitch?.translatesAutoresizingMaskIntoConstraints = false
        imageViewGlitch?.contentMode = .scaleToFill
        addSubview(imageViewGlitch!)
        imageViewGlitch?.fillSuperview()
        
        glitchInitialAnimation()
        glitchAnimation()
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
    
    private func glitchInitialAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.imageViewGlitch?.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.imageViewGlitch?.isHidden = true
            }
        }
    }
    
    private func glitchAnimation() {
        let randomSeconds = [2, 3, 4, 3.5]
        let randomAlphas: [CGFloat] = [0.3, 0.4, 0.5, 0.1]

        let randomSecond = randomSeconds[Int.random(in: 0..<randomSeconds.count)]
        let randomAlpha = randomAlphas[Int.random(in: 0..<randomAlphas.count)]
        
        imageViewGlitch?.alpha = randomAlpha
        
        DispatchQueue.main.asyncAfter(deadline: .now() + randomSecond) {
            self.imageViewGlitch?.isHidden = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.imageViewGlitch?.isHidden = true
                
                self.glitchAnimation()
            }
        }
    }
}
