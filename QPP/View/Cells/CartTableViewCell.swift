//
//  CartTableViewCell.swift
//  QPP
//
//  Created by Абай Жунус on 4/8/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import UIKit

protocol CartTableCellOutput: class {
    func updateItem(count: Int, at index: Int)
}

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var bgImage: UIImageView!
    
    weak var output: CartTableCellOutput?
    
    var index: Int = 0
    var quantity = 1 {
        didSet {
            output?.updateItem(count: quantity, at: index)
            if quantity > 0 {
                quantityLabel.text = "\(quantity)"
            } else {
                quantity = 1
            }
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgImage.layer.cornerRadius = 8
        
        [plusButton, minusButton, quantityLabel].forEach {
            $0?.layer.borderWidth = 1.0
            $0?.layer.borderColor = UIColor.black.cgColor
        }
        
        minusButton.addTarget(self, action: #selector(minusButtonPressed), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(plusButtonPressed), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc private func minusButtonPressed() {
        quantity -= 1
    }
    
    @objc private func plusButtonPressed() {
        quantity += 1
    }

}
