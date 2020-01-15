//
//  FilterCell.swift
//  QPP
//
//  Created by Toremurat on 8/23/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import UIKit

final class FilterCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var imageManager: ImageManagerProtocol!
    
    var filterType: ImageFilterType?
    var isCurrent: Bool = false {
        willSet {
            containerView.backgroundColor = newValue ? UIColor.RGBA(29, 190, 128, 0.32) : UIColor.clear
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.border(width: 0.0, color: nil, radius: 7.0)
        thumbImageView.border(width: 0.0, color: nil, radius: 4.0)
    }
    
    func setupFilterType(_ type: ImageFilterType) {
        filterType = type
        nameLabel.text = type.title
        imageManager.imageWithFilter(type, { [weak self] image, success in
            if let `self` = self, self.filterType == type { self.thumbImageView.image = image }
        })
    }
    
}
