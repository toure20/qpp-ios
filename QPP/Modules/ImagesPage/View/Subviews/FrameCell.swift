//
//  FrameCell.swift
//  QPP
//
//  Created by Toremurat on 9/4/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import UIKit

class FrameCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            containerView.backgroundColor = isSelected ? .white : .black
            titleLabel.textColor = isSelected ? .black : .white
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.border(width: 2.0, color: UIColor.white, radius: 5.0)
    }
}
