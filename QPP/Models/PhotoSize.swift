//
//  PhotoSize.swift
//  QPP
//
//  Created by Toremurat on 4/29/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import Foundation

/// Basic photo sizes with dimenstions
enum PhotoSize: String {
    case nine = "9x13"
    case ten = "10x15"
    case thirteen = "13x18"
    case fifteen = "15x20"
    case twenty = "20x30"
    case twentyOne = "21x30"
    case thirty = "30x40"
    
    
    static var standart: PhotoSize {
        return .ten
    }
}
