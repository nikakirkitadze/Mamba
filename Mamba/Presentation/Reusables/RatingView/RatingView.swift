//
//  RatingView.swift
//  Mamba
//
//  Created by Nika Kirkitadze on 9/27/20.
//

import UIKit

class RatingView: UIView {
    
    // MARK: Private properties
    private var labelRating: UILabel!
    private var effectView: UIVisualEffectView!
    private let trackLayer = CAShapeLayer()
    private let shapeLayer = CAShapeLayer()
    
    private var attributedVoteAvarageSmall: NSMutableAttributedString {
        var attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font:UIFont.named(.firaGoBook, size: 12),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        let body = NSMutableAttributedString()
        // first part
        let attributedStringFirst = NSAttributedString(string: "\(avgRaiting ?? 0)", attributes: attributes)
        // decrease font size
        attributes[NSAttributedString.Key.font] = UIFont.named(.firaGoBook, size: 8)
        let attributedStringSecond = NSAttributedString(string: "/10", attributes: attributes)
        
        // whole string
        body.append(attributedStringFirst)
        body.append(attributedStringSecond)
        
        return body
    }
    
    private var didAnimated = false
    
    internal var avgRaiting: Double? {
        didSet {
            if let rating = avgRaiting {
                labelRating.attributedText = attributedVoteAvarageSmall
                makeColor(by: rating)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        trackLayer.frame = bounds
        shapeLayer.frame = bounds
    }
    
    private func setupLayout() {
        layer.cornerRadius = bounds.width/2
        backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        createBlurEffectView()
        createLabel()
        setupAnimationLayer()
    }
    
    private func createBlurEffectView() {
        let blur = UIBlurEffect(style: .dark)
        effectView = UIVisualEffectView(effect: blur)
        effectView.layer.cornerRadius = bounds.width/2
        effectView.clipsToBounds = true
        addSubview(effectView)
    }
    
    private func createLabel() {
        labelRating = UILabel()
        labelRating.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelRating)
        
        NSLayoutConstraint.activate([
            labelRating.centerYAnchor.constraint(equalTo: centerYAnchor),
            labelRating.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func setupAnimationLayer() {
        // create my track layer
        let arcCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        let circularPath = UIBezierPath(arcCenter: arcCenter, radius: bounds.width/2, startAngle: -.pi / 2, endAngle: 3 * .pi / 2, clockwise: true)
        trackLayer.path = circularPath.cgPath
        
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 2
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = .round
        layer.addSublayer(trackLayer)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.strokeEnd = 0
        layer.addSublayer(shapeLayer)
    }
    
    private func startAnimation(toValue: Double) {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.fromValue = 0
        basicAnimation.toValue = toValue / 100
        basicAnimation.duration = 2
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "basic_animation")
    }
    
    private func makeColor(by rating: Double) {
        // 0%  - 40% red
        // 40% - 50% yellow
        // 50% - 100% green
        let percent = (rating / 10) * 100
        var color: UIColor = .clear
        
        if (0...40).contains(percent) {
            color = .red
        } else if (40...50).contains(percent) {
            color = .yellow
        } else if (50...100).contains(percent) {
            color = .green
        }
        
        shapeLayer.strokeColor = color.cgColor
        startAnimation(toValue: percent)
    }
}
