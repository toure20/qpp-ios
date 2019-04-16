//
//  UIStoryboard+Extension.swift
//  QPP
//
//  Created by Toremurat on 4/16/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    static func byName(_ a: String) -> UIStoryboard {
        return UIStoryboard(name: a, bundle: nil)
    }
    
}

extension UIViewController {
    
    static func instantiate<T>(_ type: T.Type) -> T {
        return instantiate("\(type)", type)
    }
    
    static func instantiate<T>(_ storyboard: String ,_ type: T.Type) -> T {
        return UIStoryboard.byName(storyboard).instantiateViewController(withIdentifier: "\(type)") as! T
    }
    
}
