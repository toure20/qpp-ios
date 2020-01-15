//
//  PhotoSize.swift
//  QPP
//
//  Created by Toremurat on 4/29/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import Foundation
import UIKit

/// Basic photo sizes with dimenstions
enum PhotoSize: String {
    case eight = "8x8"
    case nine = "9x13"
    case ten = "10x15"
    
    case polaroidSix = "6x9"
    case polaroidNine = "9x10"
    
//    case thirteen   = "13⨯18"
//    case fifteen    = "15⨯20"
//    case twenty     = "20⨯30"
//    case twentyOne  = "21⨯30"
//    case thirty     = "30⨯40"
    
    static var standart: PhotoSize {
        return .eight
    }
    
    var frameOffset: CGFloat {
        switch self {
        case .eight, .nine, .ten:
            return 4
        default:
            return 20
        }
    }
    
    var id: Int {
        switch self {
        case .eight: return 1
        case .nine: return 2
        case .ten: return 3
        case .polaroidSix: return 4
        case .polaroidNine: return 5
        }
    }
    var title: String {
        switch self {
        case .polaroidSix, .polaroidNine :
            return "Polaroid"
        case .eight:
            return "Square"
        case .nine, .ten:
            return "Album"
        default:
            return self.rawValue
        }
    }
//
//    var pixels: (width: CGFloat, height: CGFloat) {
//        switch self {
//        case .eight: return (width: 303.50484000001, height: 303.50484000001)
//        case .nine: return (width: 341.44294500001, height: 493.19536500002)
//        case .ten: return (width: 379.38105000001, height: 569.07157500002)
//        }
//    }
}
