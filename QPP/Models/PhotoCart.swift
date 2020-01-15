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
    var frame: FrameType = .white
    
    init(quantity: Int = 1, size: PhotoSize = PhotoSize.standart, image: UIImage?, frame: FrameType = .white) {
        self.quantity = quantity
        self.size = size
        self.image = image
        self.frame = frame
    }
    
    func update(_ quantity: Int) {
        self.quantity = quantity
    }
    
}
