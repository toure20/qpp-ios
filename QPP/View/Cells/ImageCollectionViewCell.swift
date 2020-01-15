//
//  ImageCollectionViewCell.swift
//  QPP
//
//  Created by Toremurat on 4/2/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    override var isSelected: Bool {
        didSet {
            let black = UIColor.black.withAlphaComponent(0.5)
            footerIcon.isHidden = !isSelected
            footerView.backgroundColor = isSelected ? black : .clear
        }
    }
    
    var bgImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 1.0
        return imageView
    }()
    
    var footerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    var footerIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "avengers-flat")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor =  UIColor.white
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImage)
        bgImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        addSubview(footerView)
        footerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        footerView.addSubview(footerIcon)
        footerIcon.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(30)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
