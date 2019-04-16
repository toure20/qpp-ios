//
//  UIColor+Extension.swift
//  QPP
//
//  Created by Toremurat on 4/16/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static func RGB(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
        return RGBA(r, g, b, 1.0)
    }
    
    static func RGBA(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor {
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
}

extension UIColor {
    
    convenience init(hex: String) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if cString.count != 6 {
            self.init(white: 1.0, alpha: 1.0)
        } else {
            var rgbValue: UInt32 = 0
            Scanner(string: cString).scanHexInt32(&rgbValue)
            
            self.init(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
        }
    }
}

extension UIColor {
    static func gradient(_ colors: [UIColor]) -> UIColor {
        guard let image = CAGradientLayer.renderGradientImage(colors, CGRect(x: 0, y: 0, width: 1, height: 1)) else {
            return UIColor.black
        }
        return UIColor(patternImage: image)
    }
}
