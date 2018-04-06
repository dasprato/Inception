//
//  NotificationCollectionViewCell.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2018-01-29.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit

class NotificationCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        
        addSubview(dateView)
        [
            dateView.leftAnchor.constraint(equalTo: leftAnchor), dateView.topAnchor.constraint(equalTo: topAnchor), dateView.heightAnchor.constraint(equalTo: heightAnchor), dateView.widthAnchor.constraint(equalTo: heightAnchor)
            ].forEach { (constraint) in
                constraint.isActive = true
        }
        
        dateView.addSubview(monthView)
        [monthView.topAnchor.constraint(equalTo: dateView.topAnchor), monthView.leftAnchor.constraint(equalTo: dateView.leftAnchor), monthView.rightAnchor.constraint(equalTo: dateView.rightAnchor), monthView.heightAnchor.constraint(equalTo: dateView.heightAnchor, multiplier: 0.2)
            ].forEach { (constraint) in
                constraint.isActive = true
        }
        
        dateView.addSubview(dayNumberView)
        [
            dayNumberView.rightAnchor.constraint(equalTo: dateView.rightAnchor), dayNumberView.leftAnchor.constraint(equalTo: dateView.leftAnchor), dayNumberView.bottomAnchor.constraint(equalTo: dateView.bottomAnchor), dayNumberView.heightAnchor.constraint(equalTo: dateView.heightAnchor, multiplier: 0.8)
        ].forEach { (constraint) in
                constraint.isActive = true
        }
        
        addSubview(timeView)
        [
            timeView.leftAnchor.constraint(equalTo: dateView.rightAnchor, constant: 8), timeView.topAnchor.constraint(equalTo: topAnchor), timeView.widthAnchor.constraint(equalTo: dateView.heightAnchor), timeView.heightAnchor.constraint(equalToConstant: (frame.height - 8) / 2)
            ].forEach { (constraint) in
                constraint.isActive = true
        }
        
        addSubview(dayView)
        [
            dayView.leftAnchor.constraint(equalTo: dateView.rightAnchor, constant: 8), dayView.bottomAnchor.constraint(equalTo: bottomAnchor), dayView.widthAnchor.constraint(equalTo: dateView.heightAnchor), dayView.heightAnchor.constraint(equalToConstant: (frame.height - 8) / 2)
            ].forEach { (constraint) in
                constraint.isActive = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var dateView: UIView = {
        let dv = UIView()
        dv.translatesAutoresizingMaskIntoConstraints = false
        dv.layer.borderWidth = 1.0
        dv.layer.borderColor = UIColor.white.cgColor
        dv.layer.cornerRadius = 5.0
        dv.clipsToBounds = true
        return dv
    }()
    
    var monthView: UILabel = {
        let mv = UILabel()
        mv.translatesAutoresizingMaskIntoConstraints = false
        mv.text = "MAR"
        mv.backgroundColor = .white
        mv.textColor = .darkGray
        mv.textAlignment = .center
        mv.font = UIFont.boldSystemFont(ofSize: mv.font.pointSize - 5)
        return mv
    }()
    
    var dayNumberView: UILabel = {
        let mv = UILabel()
        mv.translatesAutoresizingMaskIntoConstraints = false
        mv.text = "30"
        mv.textColor = .white
        mv.textAlignment = .center
        mv.font = UIFont.boldSystemFont(ofSize: mv.font.pointSize + 5)
        return mv
    }()
    
    
    var timeView: UILabel = {
        let mv = UILabel()
        mv.translatesAutoresizingMaskIntoConstraints = false
        mv.text = "16:20"
        mv.layer.borderWidth = 1.0
        mv.textColor = .white
        mv.layer.borderColor = UIColor.white.cgColor
        mv.layer.cornerRadius = 5.0
        mv.textAlignment = .center
        mv.font = UIFont.boldSystemFont(ofSize: mv.font.pointSize + 5)
        return mv
    }()
    
    var dayView: UILabel = {
        let mv = UILabel()
        mv.translatesAutoresizingMaskIntoConstraints = false
        mv.text = "SUN"
        mv.layer.borderWidth = 1.0
        mv.textColor = .white
        mv.layer.borderColor = UIColor.white.cgColor
        mv.layer.cornerRadius = 5.0
        mv.textAlignment = .center
        mv.font = UIFont.boldSystemFont(ofSize: mv.font.pointSize + 5)
        return mv
    }()
    
    
}
