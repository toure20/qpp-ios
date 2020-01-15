//
//  ImageManager.swift
//  QPP
//
//  Created by Toremurat on 8/23/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import UIKit
import CoreImage
import Photos
import AVFoundation

typealias SuccessCallback = (_ success: Bool) -> ()
typealias ImageCallback = (_ image: UIImage?, _ success: Bool) -> ()

enum ImageFilterType: Int {
    case original
    case onss //1977
    case adden
    case brookin
    case gingharm
    case earlybird
    case hudson
    case inkwell
    case lofi
    case perputa
    case toster
    case xpro2
    
    var title: String {
        switch self {
        case .original:
            return "Original"
        case .onss:
            return "1977"
        case .adden:
            return "Adden"
        case .brookin:
            return "Brookin"
        case .gingharm:
            return "Gingharm"
        case .earlybird:
            return "Earlybird"
        case .hudson:
            return "Hudson"
        case .inkwell:
            return "Inkwell"
        case .lofi:
            return "Lofi"
        case .perputa:
            return "Perputa"
        case .toster:
            return "Toster"
        case .xpro2:
            return "Xpro2"
        }
    }
    
    static var filters: [ImageFilterType] {
        return [.original, .onss, .adden, .brookin, .gingharm, .earlybird,
                .hudson, .inkwell, .lofi, .perputa, .toster, .xpro2]
    }
}

enum DesignType: String {
    case standard
    case gallery
    case unique
}

protocol ImageManagerProtocol: class {
    func clear()
    func imageWithFilter(_ type: ImageFilterType, _ callback: @escaping ImageCallback)
    func resetFilters(_ callback: @escaping SuccessCallback)
    func configureImage(_ input: UIImage?, _ callback: @escaping ImageCallback)
    func getCategoryImage(_ urlString: String?, _ callback: @escaping ImageCallback)
    func mediaPermissionRequest( sourceType: UIImagePickerController.SourceType,  callback: @escaping SuccessCallback)
    
    var originalImage: UIImage? { get set }
    var designType: DesignType { get set }
}

final class ImageManager: ImageManagerProtocol {
    private var queue: OperationQueue!
    
    private var mediaQueue: OperationQueue!
    private var mediaSession: URLSession!
    
    var savedFilteredImages: [ImageFilterType: UIImage] = [:]
    var savedCategoryImages: [String: UIImage] = [:]
    var imageObservers: [String: [ImageCallback]] = [:]
    
    var designType: DesignType = .standard
    
    weak var originalImage: UIImage? {
        willSet {
            savedFilteredImages.removeAll()
        }
    }
    
    init() {
        self.queue = OperationQueue()
        
        let mediaConfiguration = URLSessionConfiguration.default
        mediaConfiguration.timeoutIntervalForRequest = 120
        mediaConfiguration.timeoutIntervalForResource = 120
        mediaConfiguration.httpMaximumConnectionsPerHost = 10;
        
        self.mediaQueue = OperationQueue();
        self.mediaQueue.maxConcurrentOperationCount = 3;
        self.mediaSession = URLSession(configuration: mediaConfiguration,
                                       delegate: nil,
                                       delegateQueue: self.mediaQueue)
    }
    
    func clear() {
        savedFilteredImages.removeAll()
        savedCategoryImages.removeAll()
        originalImage = nil
        designType = .standard
    }
    
    func imageWithFilter(_ type: ImageFilterType, _ callback: @escaping ImageCallback) {
        if let saved = savedFilteredImages[type] {
            callback(saved, true)
            return
        }
        
        autoreleasepool(invoking: {
            let context: CIContext = CIContext(options: [CIContextOption.workingColorSpace: NSNull()])
            let input = CIImage.imageWithUImage(self.originalImage)
            
            let output: CIImage = self.applyFilter(type, input)
            let image = context.createUIImage(output, UIScreen.SCALE)
            DispatchQueue.main.async {
                self.savedFilteredImages[type] = image
                callback(image, true)
            }
        })
    }
    
    private func applyFilter(_ type: ImageFilterType, _ input: CIImage) -> CIImage {
        var input = input
        switch type {
        case .onss:
            //            pixels = this.fm.colorFilter(pixels, [255, 25, 0, 0.15]); //DON'T REMOVE THIS CODE
            //            pixels = this.fm.brightness(pixels, 0.1);
            input = applyColorGenerator(255, 25, 0, 0.3, input)
            if let brightness = CIFilter(name: "CIColorControls") {
                brightness.setValue(0.1, forKey: kCIInputBrightnessKey)
                brightness.setValue(input, forKey: kCIInputImageKey)
                input = brightness.outputImage ?? input
            }
            return input
        case .adden:
            //            pixels = this.fm.colorFilter(pixels, [228, 130, 225, 0.13]); //DON'T REMOVE THIS CODE
            //            pixels = this.fm.saturation(pixels, -0.2);
            input = applyColorGenerator(228, 130, 225, 0.3, input)
            if let saturation = CIFilter(name: "CIColorControls") {
                saturation.setValue(0.8, forKey: kCIInputSaturationKey)
                saturation.setValue(input, forKey: kCIInputImageKey)
                input = saturation.outputImage ?? input
            }
            return input
        case .brookin:
            //            pixels = this.fm.colorFilter(pixels, [25, 240, 252, 0.05]); //DON'T REMOVE THIS CODE
            //            pixels = this.fm.sepia(pixels, 0.3);
            input = applyColorGenerator(25, 240, 252, 0.2, input)
            if let sepia = CIFilter(name: "CISepiaTone") {
                sepia.setValue(0.3, forKey: kCIInputIntensityKey)
                sepia.setValue(input, forKey: kCIInputImageKey)
                input = sepia.outputImage ?? input
            }
            return input
        case .gingharm:
            //            pixels = this.fm.sepia(pixels, 0.04); //DON'T REMOVE THIS CODE
            //            pixels = this.fm.contrast(pixels, -0.15);
            if let sepia = CIFilter(name: "CISepiaTone") {
                sepia.setValue(0.04, forKey: kCIInputIntensityKey)
                sepia.setValue(input, forKey: kCIInputImageKey)
                input = sepia.outputImage ?? input
            }
            if let contrast = CIFilter(name: "CIColorControls") {
                contrast.setValue(0.85, forKey: kCIInputContrastKey)
                contrast.setValue(input, forKey: kCIInputImageKey)
                input = contrast.outputImage ?? input
            }
            return input
        case .earlybird:
            //pixels = this.fm.colorFilter(pixels, [255, 165, 40, 0.2]); //DON'T REMOVE THIS CODE
            input = applyColorGenerator(255, 165, 40, 0.4, input)
            return input
        case .hudson:
            //            pixels = this.fm.rgbAdjust(pixels, [1, 1, 1.25]); //DON'T REMOVE THIS CODE
            //            pixels = this.fm.contrast(pixels, 0.1);
            //            pixels = this.fm.brightness(pixels, 0.15);
            input = applyColorGenerator(0, 0, 255, 0.15, input)
            if let contrast = CIFilter(name: "CIColorControls") {
                contrast.setValue(1.1, forKey: kCIInputContrastKey)
                contrast.setValue(0.15, forKey: kCIInputBrightnessKey)
                contrast.setValue(input, forKey: kCIInputImageKey)
                input = contrast.outputImage ?? input
            }
            return input
        case .inkwell:
            //pixels = this.fm.grayscale(pixels); //DON'T REMOVE THIS CODE
            if let mono = CIFilter(name: "CIPhotoEffectMono") {
                mono.setValue(input, forKey: kCIInputImageKey)
                input = mono.outputImage ?? input
            }
            return input
        case .lofi:
            //            pixels = this.fm.contrast(pixels, 0.15); //DON'T REMOVE THIS CODE
            //            pixels = this.fm.saturation(pixels, 0.2);
            if let contrast = CIFilter(name: "CIColorControls") {
                contrast.setValue(1.15, forKey: kCIInputContrastKey)
                contrast.setValue(1.2, forKey: kCIInputSaturationKey)
                contrast.setValue(input, forKey: kCIInputImageKey)
                input = contrast.outputImage ?? input
            }
            return input
        case .perputa:
            //pixels = this.fm.rgbAdjust(pixels, [1.05, 1.1, 1]); //DON'T REMOVE THIS CODE
            input = applyColorGenerator(255, 255, 0, 0.08, input)
            return input
        case .toster:
            //            pixels = this.fm.sepia(pixels, 0.1);
            //            pixels = this.fm.colorFilter(pixels, [255, 145, 0, 0.2]); //DON'T REMOVE THIS CODE
            if let sepia = CIFilter(name: "CISepiaTone") {
                sepia.setValue(0.1, forKey: kCIInputIntensityKey)
                sepia.setValue(input, forKey: kCIInputImageKey)
                input = sepia.outputImage ?? input
            }
            input = applyColorGenerator(255, 145, 0, 0.2, input)
            return input
        case .xpro2:
            //            pixels = this.fm.colorFilter(pixels, [255, 255, 0, 0.07]); //DON'T REMOVE THIS CODE
            //            pixels = this.fm.saturation(pixels, 0.2);
            //            pixels = this.fm.contrast(pixels, 0.15);
            input = applyColorGenerator(255, 255, 0, 0.15, input)
            if let saturation = CIFilter(name: "CIColorControls") {
                saturation.setValue(1.2, forKey: kCIInputSaturationKey)
                saturation.setValue(1.15, forKey: kCIInputContrastKey)
                saturation.setValue(input, forKey: kCIInputImageKey)
                input = saturation.outputImage ?? input
            }
            return input
        default:
            return input
        }
    }
    
    private func applyColorGenerator(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ alpha: CGFloat, _ input: CIImage) -> CIImage {
        guard let generator = CIFilter(name: "CIColorCrossPolynomial") else {
            return input
        }
        
        let r: [CGFloat] = [r / 255.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        let g: [CGFloat] = [0.0, g / 255.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        let b: [CGFloat] = [0.0, 0.0, b / 255.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        
        generator.setValue(CIVector(values: r, count: 10), forKey: "inputRedCoefficients")
        generator.setValue(CIVector(values: g, count: 10), forKey: "inputGreenCoefficients")
        generator.setValue(CIVector(values: b, count: 10), forKey: "inputBlueCoefficients")
        generator.setValue(input, forKey: kCIInputImageKey)
        
        let image = CIImage(image: CIContext().createUIImage(generator.outputImage ?? input, UIScreen.SCALE))
        if let maskFilter = CIFilter(name: "CIBlendWithAlphaMask") {
            let mask = CIImage(color: CIColor(red: 1, green: 1, blue: 1, alpha: alpha))
            maskFilter.setValue(image, forKey: kCIInputImageKey)
            maskFilter.setValue(input, forKey: kCIInputBackgroundImageKey)
            maskFilter.setValue(mask, forKey: kCIInputMaskImageKey)
            return maskFilter.outputImage ?? input
        }
        return generator.outputImage ?? input
    }
    
    func resetFilters(_ callback: @escaping SuccessCallback) {
        let group = DispatchGroup()
        
        let filters = ImageFilterType.filters
        filters.forEach({
            group.enter()
            imageWithFilter($0, {image, success in
                group.leave()
            })
        })
        
        group.notify(queue: DispatchQueue.main) {
            callback(true)
        }
    }
    
    func configureImage(_ input: UIImage?, _ callback: @escaping ImageCallback) {
        guard let input = input else {
            callback(UIImage(), true)
            return
        }
        
        autoreleasepool(invoking: {
            var output: CIImage = CIImage.imageWithUImage(input)
            let context: CIContext = CIContext(options: [:])
            let s1 = UIScreen.screenWidth * UIScreen.SCALE / output.extent.size.width;
            let s2 = UIScreen.screenHeight * UIScreen.SCALE / output.extent.size.height;
            let s3 = min(s1, s2)
            output = output.transformed(by: CGAffineTransform(scaleX: s3, y: s3))
            let image = context.createUIImage(output, UIScreen.SCALE)
            callback(image, true)
        })
    }
    
    func getCategoryImage(_ urlString: String?, _ callback: @escaping ImageCallback) {
        guard let urlString = urlString, !urlString.isEmpty else {
            callback(nil, false)
            return
        }
        
        if let saved = savedCategoryImages[urlString] {
            callback(saved, true)
            return
        }
        
        var observers = imageObservers[urlString]
        if observers != nil {
            observers?.append(callback)
            imageObservers[urlString] = observers
            return
        }
        observers = []
        observers?.append(callback)
        imageObservers[urlString] = observers
        
        let request = URLRequest(url: URL(string: urlString)!)
        
        let task = mediaSession.dataTask(with: request, completionHandler: { [weak self] (data, response, error) -> Void in
            guard let `self` = self else { return }
            let failureBlock: ImageCallback = {image, success in
                DispatchQueue.main.async {
                    if let observers = self.imageObservers[urlString] {
                        for block in observers {
                            block(image, success)
                        }
                    }
                    self.imageObservers.removeValue(forKey: urlString)
                }
            }
            
            guard let data = data, let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200, error == nil, let image = UIImage(data: data, scale: UIScreen.SCALE) else {
                    failureBlock(nil, false)
                    return
            }
            
            self.savedCategoryImages[urlString] = image
            failureBlock(image, true)
        })
        task.resume()
    }
    
    func mediaPermissionRequest( sourceType: UIImagePickerController.SourceType,  callback: @escaping SuccessCallback) {
        if sourceType == .camera {
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
                DispatchQueue.main.async {
                    callback(granted)
                }
            }
        } else if sourceType == .photoLibrary {
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    callback(status == .authorized)
                }
            }
        }
    }
    
}
