//
//  SizeCell.swift
//  QPP
//
//  Created by Toremurat on 9/4/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import UIKit

class SizeCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var sizeLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            containerView.backgroundColor = isSelected ? .white : .black
            sizeLabel.textColor = isSelected ? .black : .white
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.border(width: 2.0, color: UIColor.white, radius: 5.0)
    }
    
}
