//
//  MyOrdersTableViewCell.swift
//  QPP
//
//  Created by Toremurat on 5/13/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import UIKit

class MyOrdersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(order: UserOrder) {
        titleLabel.text = "Заказ №\(order.id)"
        statusLabel.text = order.status
        dateLabel.text = order.date
        countLabel.text = "Количество: \(order.photos.count)"
    }
}
