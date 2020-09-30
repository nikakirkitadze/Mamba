//
//  MambaSearchField.swift
//  Mamba
//
//  Created by Nika Kirkitadze on 9/27/20.
//

import UIKit

class MambaSearchField: UITextField {
    
    @IBInspectable var leftIcon: UIImage! {
        didSet {
            setupLeftView(with: leftIcon)
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var titleText: String = "" {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    internal var mambaFieldEditingChanged: ((String)->())?
    
    private var titleLabel: UILabel!
    private var isError: Bool = false
    private var fontSize = 12
    
    private var isDarkMode: Bool {
        return traitCollection.userInterfaceStyle == .dark
    }
    
    /// A Boolean value that determines whether the textfield is being edited or is selected.
    open var editingOrSelected: Bool {
        return super.isEditing || isSelected
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupField()
    }
    
    override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        
        UIView.animate(withDuration: 0.3) {
            self.titleLabel.font = UIFont.named(.firaGoBook, size: 12)
            self.titleLabel.frame.origin.y = 5
        }
        
        return result
    }
    
    override func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        
        if let text = self.text, text.count == 0 {
            let titleLabelHeight = self.calculateLabelHeigt()
            let y = (bounds.height - titleLabelHeight) / 2
            
            UIView.animate(withDuration: 0.3) {
                self.titleLabel.font = UIFont.named(.firaGoBook, size: 15)
                self.titleLabel.frame.origin.y = y
            }
        }
        
        return result
    }
    
    private func setupField() {
        setupFieldShadow()
        createTitleLabel()
        setupLeftView()
        addEditingChangedObserver()
        
        delegate = self
        clearButtonMode = .always
        backgroundColor = Colors.mainBG
        
        let titleLabelHeight = calculateLabelHeigt()
        let y = (bounds.height - titleLabelHeight) / 2
        let x = leftView?.frame.width ?? 0.0
        titleLabel.frame = CGRect(x: x + 6, y: y, width: bounds.width, height: titleLabelHeight)
    }
    
    fileprivate func addEditingChangedObserver() {
        self.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    /**
     Invoked when the editing state of the textfield changes. Override to respond to this change.
     */
    @objc open func editingChanged() {
        mambaFieldEditingChanged?(text ?? "")
    }
    
    private func setupFieldShadow() {
        let color: UIColor = isDarkMode ? .white : .black
        let radius: CGFloat = isDarkMode ? 8 : 15
        addShadow(color: color, offset: .zero, opacity: 0.4, radius: radius)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        guard UIApplication.shared.applicationState == .inactive else {
            return
        }
        
        setupFieldShadow()
    }
    
    private func createTitleLabel() {
        let titleLabel = UILabel()
        titleLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        titleLabel.textColor = UIColor(hex: "616F8D")
        titleLabel.font = UIFont.named(.firaGoBook, size: 15)
        titleLabel.text = "Search"
        
        addSubview(titleLabel)
        self.titleLabel = titleLabel
    }
    
    private func setupLeftView(with icon: UIImage = UIImage(named: "ic-search")!) {
        leftViewMode = .always
        
        let lv = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: bounds.height))
        let iv = UIImageView(image: icon)
        lv.addSubview(iv)
        
        iv.center = lv.center
        leftView = lv
    }
    
    private func calculateLabelHeigt() -> CGFloat {
        if let titleLabel = titleLabel {
            return titleLabel.font.lineHeight
        }
        
        return 0
    }
}

extension MambaSearchField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return endEditing(true)
    }
}
