//
//  Extensions.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2018-01-30.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    @objc func addShadow() {
        
        let changeColor = CATransition()
        changeColor.type = kCATransitionFade
        changeColor.duration = 0.2
        
        
        CATransaction.begin()
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        self.navigationController?.navigationBar.layer.add(changeColor, forKey: nil)
        CATransaction.setCompletionBlock {
        }
        CATransaction.commit()
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowOpacity = 1.0
        self.navigationController?.navigationBar.layer.masksToBounds = false
    }
    
    @objc func removeShadow() {
        let changeColor = CATransition()
        changeColor.type = kCATransitionFade
        changeColor.duration = 0.2
        CATransaction.begin()
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.clear.cgColor
        self.navigationController?.navigationBar.layer.add(changeColor, forKey: nil)
        CATransaction.setCompletionBlock {
        }
        CATransaction.commit()
        
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.0
        self.navigationController?.navigationBar.layer.masksToBounds = false
        
    }
    

}

class CustomUIButton: UIButton {
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .darkGray
        self.setTitleColor(.white, for: .normal)
        
    }

    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")

    }
    
    override var buttonType: UIButtonType {
        return UIButtonType.system
    }
}


class CustomUILabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textColor = UIColor.gray
        self.textAlignment = .center
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = UIFont.boldSystemFont(ofSize: self.font.pointSize * 2)
        self.adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class FlexibleTextView: UITextView {
    // limit the height of expansion per intrinsicContentSize
    var maxHeight: CGFloat = 0.0
    private let placeholderTextView: UITextView = {
        let tv = UITextView()
        
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        tv.isScrollEnabled = false
        tv.textColor = UIColor.lightGray
        tv.isUserInteractionEnabled = false
        return tv
    }()
    var placeholder: String? {
        get {
            return placeholderTextView.text
        }
        set {
            placeholderTextView.text = newValue
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        isScrollEnabled = false
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        NotificationCenter.default.addObserver(self, selector: #selector(UITextInputDelegate.textDidChange(_:)), name: Notification.Name.UITextViewTextDidChange, object: self)
        placeholderTextView.font = font
        addSubview(placeholderTextView)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.layer.cornerRadius = 10.0
        self.font = UIFont(name: "Arial", size: 20)
        
        NSLayoutConstraint.activate([
            placeholderTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
            placeholderTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
            placeholderTextView.topAnchor.constraint(equalTo: topAnchor),
            placeholderTextView.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var text: String! {
        didSet {
            invalidateIntrinsicContentSize()
            placeholderTextView.isHidden = !text.isEmpty
        }
    }
    
    override var font: UIFont? {
        didSet {
            placeholderTextView.font = font
            invalidateIntrinsicContentSize()
        }
    }
    
    override var contentInset: UIEdgeInsets {
        didSet {
            placeholderTextView.contentInset = contentInset
        }
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        
        if size.height == UIViewNoIntrinsicMetric {
            // force layout
            layoutManager.glyphRange(for: textContainer)
            size.height = layoutManager.usedRect(for: textContainer).height + textContainerInset.top + textContainerInset.bottom
        }
        
        if maxHeight > 0.0 && size.height > maxHeight {
            size.height = maxHeight
            
            if !isScrollEnabled {
                isScrollEnabled = true
            }
        } else if isScrollEnabled {
            isScrollEnabled = false
        }
        
        return size
    }
    
    @objc private func textDidChange(_ note: Notification) {
        // needed incase isScrollEnabled is set to true which stops automatically calling invalidateIntrinsicContentSize()
        invalidateIntrinsicContentSize()
        placeholderTextView.isHidden = !text.isEmpty
    }
}


extension UIViewController {
    @objc func closeView(_ viewController: UIViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func openShareController(_ viewController: UIViewController) {
        print("Showing")
        let activityItem: [AnyObject] = [QRCodeViewController.qrCodeImageView.image as! AnyObject]
        let avc = UIActivityViewController(activityItems: activityItem as [AnyObject], applicationActivities: nil)
        avc.modalTransitionStyle = .crossDissolve
        present(avc, animated: true, completion: nil)
    }
    
    func setupBarWithBaiscStyling(_ viewController: UIViewController) {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = .gray
        navigationController?.navigationBar.addShadow()
        view.backgroundColor = .darkGray
        
        let barButtonClose = UIBarButtonItem(image: UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(closeView(_:)))
        barButtonClose.tintColor = .white
        navigationItem.setLeftBarButton(barButtonClose, animated: true)
    }
}

extension UIView {
    func addShadow() {
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
    }
}


class CustomUITextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.cornerRadius = 10.0
        self.font = UIFont(name: "Arial", size: 20)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textAlignment = .center
        self.keyboardAppearance = .dark
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



