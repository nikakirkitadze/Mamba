//
//  BottomSheetContainerViewController.swift
//  Mamba
//
//  Created by Nika Kirkitadze on 10/1/20.
//

import UIKit

class BottomSheetContainerViewController<Content: UIViewController, BottomSheet: UIViewController> : UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Public properties
    public var isHide: Bool = true
    
    // MARK: - Initialization
    public init(contentViewController: Content,
                bottomSheetViewController: BottomSheet,
                bottomSheetConfiguration: BottomSheetConfiguration) {
        
        self.contentViewController = contentViewController
        self.bottomSheetViewController = bottomSheetViewController
        self.configuration = bottomSheetConfiguration
        
        super.init(nibName: nil, bundle: nil)
        
        self.setupUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    // MARK: - Bottom Sheet Actions
    public func showBottomSheet(animated: Bool = true) {
        self.topConstraint.constant = -configuration.height
        
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.state = .full
            })
        } else {
            self.view.layoutIfNeeded()
            self.state = .full
        }
        
        isHide = false
    }
    
    public func hideBottomSheet(animated: Bool = true) {
        self.topConstraint.constant = -configuration.initialOffset
        
        if animated {
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0.5,
                           options: [.curveEaseOut],
                           animations: {
                            self.view.layoutIfNeeded()
                           }, completion: { _ in
                            self.state = .initial
                           })
        } else {
            self.view.layoutIfNeeded()
            self.state = .initial
        }
        
        isHide = true
    }
    
    // MARK: - Pan Action
    @objc func handlePan(_ sender: DirectedPanGestureRecognizer) {
        let translation = sender.translation(in: bottomSheetViewController.view)
        let velocity = sender.velocity(in: bottomSheetViewController.view)
        guard let direction = sender.direction else {return}
        if direction == .left || direction == .up { return }
        
        let yTranslationMagnitude = translation.y.magnitude
        
        switch sender.state {
        case .began, .changed:
            
            if self.state == .full {
                guard translation.y > 0 else { return }
                topConstraint.constant = -(configuration.height - yTranslationMagnitude)
                self.view.layoutIfNeeded()
            } else {
                let newConstant = -(configuration.initialOffset + yTranslationMagnitude)
                
                guard translation.y < 0 else { return }
                guard newConstant.magnitude < configuration.height else {
                    self.showBottomSheet()
                    return
                }
                
                topConstraint.constant = newConstant
                self.view.layoutIfNeeded()
            }
        case .ended:
            if self.state == .full {
                if yTranslationMagnitude >= configuration.height / 2 || velocity.y > 1000 {
                    self.hideBottomSheet()
                } else {
                    self.showBottomSheet()
                }
            } else {
                if yTranslationMagnitude >= configuration.height / 2 || velocity.y < -1000 {
                    self.showBottomSheet()
                } else {
                    self.hideBottomSheet()
                }
            }
        case .failed:
            if self.state == .full {
                self.showBottomSheet()
            } else {
                self.hideBottomSheet()
            }
        default: break
        }
    }
    
    // MARK: - Configuration
    public struct BottomSheetConfiguration {
        let height: CGFloat
        let initialOffset: CGFloat
    }
    
    private var configuration: BottomSheetConfiguration
    
    // MARK: - State
    public enum BottomSheetState {
        case initial
        case full
    }
    
    var state: BottomSheetState = .initial
    
    // MARK: - Children
    let contentViewController: Content
    let bottomSheetViewController: BottomSheet
    
    // MARK: - Top Constraint
    private var topConstraint = NSLayoutConstraint()
    private var heightConstraint = NSLayoutConstraint()
    
    // MARK: - Pan Gesture
    lazy var panGesture: DirectedPanGestureRecognizer = {
        let pan = DirectedPanGestureRecognizer()
        pan.delegate = self
        pan.addTarget(self, action: #selector(handlePan))
        return pan
    }()
    
    // MARK: - UI Setup
    private func setupUI() {
        self.addChild(contentViewController)
        self.addChild(bottomSheetViewController)
        
        self.view.addSubview(contentViewController.view)
        self.view.addSubview(bottomSheetViewController.view)
        bottomSheetViewController.view.addGestureRecognizer(panGesture)
        
        contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        bottomSheetViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentViewController.view.leftAnchor
                .constraint(equalTo: self.view.leftAnchor),
            contentViewController.view.rightAnchor
                .constraint(equalTo: self.view.rightAnchor),
            contentViewController.view.topAnchor
                .constraint(equalTo: self.view.topAnchor),
            contentViewController.view.bottomAnchor
                .constraint(equalTo: self.view.bottomAnchor)
        ])
        
        contentViewController.didMove(toParent: self)
        
        topConstraint = bottomSheetViewController.view.topAnchor
            .constraint(equalTo: self.view.bottomAnchor,
                        constant: -configuration.initialOffset)
        
        NSLayoutConstraint.activate([
            bottomSheetViewController.view.heightAnchor
                .constraint(equalToConstant: configuration.height),
            bottomSheetViewController.view.leftAnchor
                .constraint(equalTo: self.view.leftAnchor),
            bottomSheetViewController.view.rightAnchor
                .constraint(equalTo: self.view.rightAnchor),
            topConstraint
        ])
        
        // heigt of sheet
        heightConstraint = bottomSheetViewController.view.heightAnchor.constraint(equalToConstant: configuration.height)
        
        bottomSheetViewController.didMove(toParent: self)
    }
    
    private func relayout() {
        NSLayoutConstraint.activate([
            bottomSheetViewController.view.heightAnchor
                .constraint(equalToConstant: configuration.height),
            bottomSheetViewController.view.leftAnchor
                .constraint(equalTo: self.view.leftAnchor),
            bottomSheetViewController.view.rightAnchor
                .constraint(equalTo: self.view.rightAnchor),
            topConstraint
        ])
    }
    
    // MARK: - UIGestureRecognizer Delegate
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: - viewWillTransition
    // TODO: - will fix
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            let height = UIScreen.main.bounds.height * 0.35
            heightConstraint.constant = height
            self.bottomSheetViewController.view.setNeedsLayout()
        } else {
            let height = UIScreen.main.bounds.height * 0.55
            heightConstraint.constant = height
            self.bottomSheetViewController.view.setNeedsLayout()
        }
    }
}
