//
//  CALayer+Gradient.swift
//  QPP
//
//  Created by Toremurat on 4/16/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationBar {
    
    func setupGradientBackground(_ colors: [UIColor]) {
        let rect: CGRect = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 1))
        let gradient = CAGradientLayer(frame: rect, colors: colors, direction: .right)
        setBackgroundImage(gradient.createGradientImage(), for: .default)
    }
    
    func setupWithShadow(barTintColor: UIColor = .white, tintColor: UIColor = .gray, titleColor: UIColor = .black) {
        self.isTranslucent = false
        self.tintColor = tintColor
        self.barTintColor = barTintColor
        self.titleTextAttributes = [NSAttributedString.Key.foregroundColor: titleColor]
        
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
    }
    
    func removeShadow() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
        self.barTintColor = .clear
        self.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.backgroundColor = .clear
        self.tintColor = .white
    }
}
