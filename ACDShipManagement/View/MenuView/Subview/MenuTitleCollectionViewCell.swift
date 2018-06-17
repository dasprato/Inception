//
//  MenuTitleCollectionViewCell.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2018-02-02.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit

class MenuTitleCollectionViewCell: UICollectionViewCell {
    
    var titleForCellText: Menu? {
        didSet {
            titleForCell.text = titleForCellText?.titleForCell
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        contentView.addSubview(titleForCell)
        NSLayoutConstraint.activate([titleForCell.leftAnchor.constraint(equalTo: leftAnchor, constant: 16), titleForCell.centerYAnchor.constraint(equalTo: centerYAnchor)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var titleForCell: UILabel = {
        let tfc = UILabel()
        tfc.translatesAutoresizingMaskIntoConstraints = false
        tfc.textColor = .white
        tfc.font = UIFont.boldSystemFont(ofSize: tfc.font.pointSize * 2)
        tfc.adjustsFontSizeToFitWidth = true
        tfc.textAlignment = .left
        return tfc
    }()
}
