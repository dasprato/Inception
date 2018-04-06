
//
//  QuickActionCollectionViewCell.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2018-02-02.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit

class QuickActionCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        
        addSubview(cellButton)
        NSLayoutConstraint.activate([cellButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 8), cellButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -8), cellButton.topAnchor.constraint(equalTo: topAnchor, constant: 8), cellButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var cellButton: UIButton = {
        let eb = UIButton(type: .system)
        eb.translatesAutoresizingMaskIntoConstraints = false
        eb.contentMode = .scaleAspectFit
        return eb
    }()
    
    
}
