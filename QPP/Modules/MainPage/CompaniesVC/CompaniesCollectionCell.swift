//
//  CompaniesCollectionCell.swift
//  QPP
//
//  Created by Toremurat on 7/17/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import UIKit

class CompaniesCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 14
    }
    
}
