//
//  PhotoCart.swift
//  QPP
//
//  Created by Toremurat on 4/29/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import Foundation
import UIKit

class PhotoCart {
    var quantity: Int = 1
    var size: PhotoSize
    var image: UIImage?
    
    init(quantity: Int = 1, size: PhotoSize = PhotoSize.standart, image: UIImage?) {
        self.quantity = quantity
        self.size = size
        self.image = image
    }
}
