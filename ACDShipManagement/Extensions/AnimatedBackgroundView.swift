//
//  AnimatedBackgroundView.swift
//  TablaTutorial
//
//  Created by Prato Das on 2018-06-16.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit

class AnimatedBackgroundView: UIView {
    var gradientLayer = CAGradientLayer()
    var colorTop = UIColor(red: (CGFloat(arc4random_uniform(255)))/255, green: (CGFloat(arc4random_uniform(255)))/255, blue: (CGFloat(arc4random_uniform(255)))/255, alpha: 1.0).cgColor
    var colorBottom = UIColor(red: (CGFloat(arc4random_uniform(255)))/255, green: (CGFloat(arc4random_uniform(255)))/255, blue: (CGFloat(arc4random_uniform(255)))/255, alpha: 1.0).cgColor
    
    
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0
    let gradientOne = UIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1).cgColor
    let gradientTwo = UIColor(red: 0/255, green: 191/255, blue: 255/255, alpha: 1).cgColor
    let gradientThree = UIColor(red: 25/255, green: 25/255, blue: 122/255, alpha: 1).cgColor
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        gradientSet.append([gradientOne, gradientTwo])
        gradientSet.append([gradientTwo, gradientThree])
        gradientSet.append([gradientThree, gradientOne])
        
        gradientLayer.colors = gradientSet[currentGradient]
        gradientLayer.startPoint = CGPoint(x:0, y:0)
        gradientLayer.endPoint = CGPoint(x:1, y:1)
        gradientLayer.drawsAsynchronously = true
        layer.insertSublayer(gradientLayer, at: 0)
        
        
        
        animateGradient()
        
    }
    
    func animateGradient() {
        if currentGradient < gradientSet.count - 1 {
            currentGradient += 1
        } else {
            currentGradient = 0
        }
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = 5.0
        gradientChangeAnimation.toValue = gradientSet[currentGradient]
        gradientChangeAnimation.fillMode = kCAFillModeForwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradientChangeAnimation.delegate = self
        gradientLayer.add(gradientChangeAnimation, forKey: "colorChange")
    }
    
    // change the frame when the view lays out
    override func layoutSubviews() {
        self.gradientLayer.frame = frame
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
}


extension AnimatedBackgroundView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("flag is true")
        if flag {
            gradientLayer.colors = gradientSet[currentGradient]
            animateGradient()
        }
    }
}
