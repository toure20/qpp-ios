//
//  UIImage+Extension.swift
//  QPP
//
//  Created by Toremurat on 10/1/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import UIKit

public extension UIImage {
    
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    func fixImageOrientation() -> UIImage {
        
        
        // No-op if the orientation is already correct
        if (self.imageOrientation == UIImage.Orientation.up) {
            return self;
        }
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform:CGAffineTransform = CGAffineTransform.identity
        
        if (self.imageOrientation == UIImage.Orientation.down
            || self.imageOrientation == UIImage.Orientation.downMirrored) {
            
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        }
        
        if (self.imageOrientation == UIImage.Orientation.left
            || self.imageOrientation == UIImage.Orientation.leftMirrored) {
            
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
        }
        
        if (self.imageOrientation == UIImage.Orientation.right
            || self.imageOrientation == UIImage.Orientation.rightMirrored) {
            
            transform = transform.translatedBy(x: 0, y: self.size.height);
            transform = transform.rotated(by: CGFloat(-Double.pi / 2));
        }
        
        if (self.imageOrientation == UIImage.Orientation.upMirrored
            || self.imageOrientation == UIImage.Orientation.downMirrored) {
            
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        }
        
        if (self.imageOrientation == UIImage.Orientation.leftMirrored
            || self.imageOrientation == UIImage.Orientation.rightMirrored) {
            
            transform = transform.translatedBy(x: self.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
        }
        
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx:CGContext = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height),
                                      bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0,
                                      space: self.cgImage!.colorSpace!,
                                      bitmapInfo: self.cgImage!.bitmapInfo.rawValue)!
        
        ctx.concatenate(transform)
        
        
        if (self.imageOrientation == UIImage.Orientation.left
            || self.imageOrientation == UIImage.Orientation.leftMirrored
            || self.imageOrientation == UIImage.Orientation.right
            || self.imageOrientation == UIImage.Orientation.rightMirrored
            ) {
            
            
            ctx.draw(self.cgImage!, in: CGRect(x:0,y:0,width:self.size.height,height:self.size.width))
            
        } else {
            ctx.draw(self.cgImage!, in: CGRect(x:0,y:0,width:self.size.width,height:self.size.height))
        }
        
        
        // And now we just create a new UIImage from the drawing context
        let cgimg:CGImage = ctx.makeImage()!
        let imgEnd:UIImage = UIImage(cgImage: cgimg)
        
        return imgEnd
    }
}
