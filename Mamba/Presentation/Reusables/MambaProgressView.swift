//
//  MambaProgressView.swift
//  Mamba
//
//  Created by Nika Kirkitadze on 9/30/20.
//

import UIKit

class MambaProgressView: UIView {
    
    private var animationView: UIView?
    private var imageViewGlitch: UIImageView?
    private var viewBackground: UIView?
    
    static let shared: MambaProgressView = {
        let instance = MambaProgressView()
        return instance
    }()
    
    convenience private init() {
        self.init(frame: UIScreen.main.bounds)
        setupLayout()
    }
    
    override private init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required internal init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    internal func setupLayout(interaction: Bool = true) {
        setupBackground(interaction)
        setupAnimation()
    }
    
    private func setupBackground(_ interaction: Bool) {
        if viewBackground == nil {
            let mainWindow = UIApplication.shared.windows.first ?? UIWindow()
            viewBackground = UIView(frame: self.bounds)
            mainWindow.addSubview(viewBackground!)
        }
        
        viewBackground?.backgroundColor = interaction ? .clear : .clear
        viewBackground?.isUserInteractionEnabled = (interaction == false)
    }
    
    private func setupAnimation() {
        if imageViewGlitch == nil {
            // Create Animation object
            imageViewGlitch = UIImageView()
            imageViewGlitch?.translatesAutoresizingMaskIntoConstraints = false
            imageViewGlitch?.alpha = 0.3
            imageViewGlitch?.contentMode = .scaleAspectFill
            imageViewGlitch?.loadGif(name: "gif-glitch-transition")
            viewBackground?.addSubview(imageViewGlitch!)
            imageViewGlitch?.fillSuperview()
        }
    }
    
    private func hide() {
        // Stop the animation
        imageViewGlitch?.isHidden = true
        animationView?.removeFromSuperview()
    }
    
    private func show() {
        imageViewGlitch?.isHidden = false
    }
}

extension MambaProgressView {
    class func dismiss(delay: TimeInterval = 1) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            shared.hide()
        }
    }
    
    class func show(_ status: String? = nil, interaction: Bool = true) {
        DispatchQueue.main.async {
            shared.show()
        }
    }
}

