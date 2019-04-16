//
//  CAGradientLayer+Extension.swift
//  QPP
//
//  Created by Toremurat on 4/16/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import UIKit

enum PanDirection {
    case right
    case bottom
    case left
    case up
    
    var startPoint: CGPoint {
        switch self {
        case .right:
            return CGPoint(x: 0.0, y: 0.5)
        case .bottom:
            return CGPoint(x: 0.5, y: 0.0)
        case .left:
            return CGPoint(x: 1.0, y: 0.5)
        case .up:
            return CGPoint(x: 0.5, y: 1.0)
        }
    }
    
    var endPoint: CGPoint {
        switch self {
        case .right:
            return CGPoint(x: 1.0, y: 0.5)
        case .bottom:
            return CGPoint(x: 0.5, y: 1.0)
        case .left:
            return CGPoint(x: 0.0, y: 0.5)
        case .up:
            return CGPoint(x: 0.5, y: 0.0)
        }
    }
}

extension CAGradientLayer {
    
    convenience init(frame: CGRect, colors: [UIColor], direction: PanDirection = .right) {
        self.init()
        self.frame = frame
        self.colors = colors.map { $0.cgColor }
        startPoint = direction.startPoint
        endPoint = direction.endPoint
    }
    
    func createGradientImage() -> UIImage? {
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        render(in: context)
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    static func renderGradientImage(_ colors: [UIColor], _ frame: CGRect) -> UIImage? {
        let gradient: CAGradientLayer = CAGradientLayer(frame: frame, colors: colors, direction: .right)
        return gradient.createGradientImage()
    }
}
