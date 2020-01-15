//
//  UIView+Extension.swift
//  QPP
//
//  Created by Toremurat on 7/17/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import UIKit

extension UIView {
    func addShadow(offset: CGSize = CGSize.zero, color: UIColor = UIColor.gray, radius: CGFloat = 4.0, opacity: Float = 0.1) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
    
    func border(width: CGFloat = 0, color: UIColor? = nil, radius: CGFloat = 0) {
        if let color = color {
            layer.borderColor = color.cgColor
        }
        layer.borderWidth = width
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }

    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
}

extension CIContext {
    
    func createUIImage(_ ciimage: CIImage, _ scale: CGFloat) -> UIImage {
        guard let imageRef: CGImage = self.createCGImage(ciimage, from: ciimage.extent) else {
            return UIImage()
        }
        let image: UIImage = UIImage(cgImage: imageRef, scale: scale, orientation: .up)
        return image
    }
}

extension UIScreen {
    
    static var defaultWidth: CGFloat {
        return 375.0
    }
    
    static var SCALE: CGFloat {
        return UIScreen.main.scale
    }
    
    static var screenRect: CGRect {
        return UIScreen.main.bounds
    }
    
    static var screenWidth: CGFloat {
        return screenRect.size.width
    }
    
    static var screenHeight: CGFloat! {
        return screenRect.size.height
    }
    
    static var DIFF: CGFloat {
        let diffSide = min(screenWidth, screenHeight) - min(screenWidth, screenHeight) * 0.1875
        return (UIDevice.IS_IPAD) ? diffSide / defaultWidth : min(screenWidth, screenHeight) / defaultWidth
    }
    
    static var INDENT: CGFloat {
        return (UIDevice.IS_IPAD) ? (min(screenWidth, screenHeight) * (2.0 / 3.0)) : screenWidth
    }
}
extension CIImage {
    
    static func imageWithUImage(_ image: UIImage?) -> CIImage {
        guard let image = image, let cgimage = image.cgImage else {
            return CIImage()
        }
        
        let options: [CIImageOption: Any] = [CIImageOption.properties: [kCGImagePropertyOrientation: image.imageOrientation]]
        
        let output: CIImage = CIImage(cgImage: cgimage, options: options)
        return output.imageAccordingToOrientation()
    }
    
    func imageOrientation() -> UIImage.Orientation {
        if let orientation: UIImage.Orientation = properties[kCGImagePropertyOrientation as String] as? UIImage.Orientation {
            return orientation
        }
        return .up
    }
    
    func imageAccordingToOrientation() -> CIImage {
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch imageOrientation() {
        case .up:
            break
        case .down:
            transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
        case .left:
            transform = CGAffineTransform(translationX: extent.size.height / 2, y: extent.size.width / 2)
            transform = transform.rotated(by: CGFloat(Double.pi / 2.0))
            transform = transform.translatedBy(x: -extent.size.width / 2, y: -extent.size.height / 2)
        case .right:
            transform = CGAffineTransform(translationX: extent.size.height / 2, y: extent.size.width / 2)
            transform = transform.rotated(by: -CGFloat(Double.pi / 2.0))
            transform = transform.translatedBy(x: -extent.size.width / 2, y: -extent.size.height / 2)
        case .upMirrored:
            break;
        case .downMirrored:
            break;
        case .leftMirrored:
            transform = CGAffineTransform(translationX: extent.size.height / 2, y: extent.size.width / 2)
            transform = transform.rotated(by: CGFloat(Double.pi / 2.0))
            transform = transform.translatedBy(x: -extent.size.width / 2, y: -extent.size.height / 2)
        case .rightMirrored:
            transform = CGAffineTransform(translationX: extent.size.height / 2, y: extent.size.width / 2)
            transform = transform.rotated(by: -CGFloat(Double.pi / 2.0))
            transform = transform.translatedBy(x: -extent.size.width / 2, y: -extent.size.height / 2)
        }
        
        let newExtent: CGRect = extent.applying(transform)
        transform.concatenating(CGAffineTransform(translationX: newExtent.origin.x, y: newExtent.origin.y))
        
        return transformed(by: transform)
    }
    
}


public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            if let value = element.value as? Int8, value != 0 {
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
            return identifier
        }
        
        switch identifier {
        case "iPod5,1":
            return "iPod Touch 5"
        case "iPod7,1":
            return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":
            return "iPhone 4"
        case "iPhone4,1":
            return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":
            return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":
            return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":
            return "iPhone 5s"
        case "iPhone7,2":
            return "iPhone 6"
        case "iPhone7,1":
            return "iPhone 6 Plus"
        case "iPhone8,1":
            return "iPhone 6s"
        case "iPhone8,2":
            return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":
            return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":
            return "iPhone 7 Plus"
        case "iPhone8,4":
            return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":
            return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":
            return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":
            return "iPhone X"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":
            return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":
            return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":
            return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":
            return "iPad Air"
        case "iPad5,3", "iPad5,4":
            return "iPad Air 2"
        case "iPad6,11", "iPad6,12":
            return "iPad 5"
        case "iPad2,5", "iPad2,6", "iPad2,7":
            return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":
            return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":
            return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":
            return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":
            return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":
            return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":
            return "iPad Pro 12.9 Inch 2. Generation"
        case "iPad7,3", "iPad7,4":
            return "iPad Pro 10.5 Inch"
        case "AppleTV5,3":
            return "Apple TV"
        case "AppleTV6,2":
            return "Apple TV 4K"
        case "AudioAccessory1,1":
            return "HomePod"
        case "i386", "x86_64":
            return "Simulator"
        default:
            return identifier
        }
    }
    
    static var IS_IPAD: Bool {
        return UIDevice.current.model == "iPad"
    }
}
