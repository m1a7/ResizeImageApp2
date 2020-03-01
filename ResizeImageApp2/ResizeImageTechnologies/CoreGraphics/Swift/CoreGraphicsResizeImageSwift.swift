//
//  CoreGraphicsResizeImageSwift.swift
//  ResizeImageApp2
//
//  Created by Uber on 20/07/2019.
//  Copyright © 2019 RXMobile. All rights reserved.
//

import UIKit
import CoreGraphics


@available(iOS 9.0, *)
class CoreGraphicsResizeImageSwift: NSObject {
    
    
    /*--------------------------------------------------------------------------------------------------------------
     Render a image in full size
     --------------------------------------------------------------------------------------------------------------*/
    
    @objc internal static func imageFromData(_ data: Data) -> UIImage?
    {
        var scaledImg : UIImage? = nil

        // Restore image from 'NSData'
        let imgDataProvider = CGDataProvider(data: data as CFData)
        let imageRef        = CGImage(jpegDataProviderSource: imgDataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
        
        // Recievie original size of image
        let originalImageWidth  = imageRef!.width;
        let originalImageHeight = imageRef!.height;
        
        
        // Setup options (colorSpace/bitmapInfo/bitsPerComponent)
        if (imageRef != nil)
        {
        let bitsPerComponent = imageRef?.bitsPerComponent
        let colorSpace       = imageRef?.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB)!
        let bitmapInfo       = imageRef?.bitmapInfo.rawValue
        
        let rectForNewSize = CGRect.init(x: 0.0, y: 0.0, width:Double(originalImageWidth), height:Double(originalImageHeight))
        
        let context = CGContext(data:nil,
                                width:  Int(originalImageWidth),
                                height: Int(originalImageHeight),
                                bitsPerComponent: bitsPerComponent!,
                                bytesPerRow: 0,
                                space: colorSpace,
                                bitmapInfo: bitmapInfo!)
            
            context?.interpolationQuality = .high
            context?.draw(imageRef!, in: rectForNewSize)
           
            
            // Render image
            let scaledImageRef = context!.makeImage()
                scaledImg      = UIImage.init(cgImage: scaledImageRef!)
        }
        return scaledImg
    }
    
    
    
    /*--------------------------------------------------------------------------------------------------------------
     Render a image in borders. Inside converts point to pixels
     --------------------------------------------------------------------------------------------------------------*/

     @objc internal static func imageFromData(_ data: Data, inSizeInPoints points: CGSize) -> UIImage?
     {
        let pixels = CalculateImageSize.convertCGSize(toPixels: points)
        return imageFromData(data, inSizeInPixels:pixels)
     }
    
    /*--------------------------------------------------------------------------------------------------------------
     Render a image in borders
     --------------------------------------------------------------------------------------------------------------*/

    @objc internal static func imageFromData(_ data: Data, inSizeInPixels pixels: CGSize) -> UIImage?
    {
        var scaledImg : UIImage? = nil

        // Restore image from 'NSData'
        let imgDataProvider = CGDataProvider(data: data as CFData)
        let imageRef        = CGImage(jpegDataProviderSource: imgDataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
        
        
        let rectForNewSize = CGRect.init(x: 0.0, y: 0.0, width:pixels.width, height:pixels.height)

        if (imageRef != nil){
            
            let context = CGContext(data:nil,
                                    width: Int(pixels.width),
                                    height: Int(pixels.height),
                                    bitsPerComponent: imageRef!.bitsPerComponent,
                                    bytesPerRow: 0,
                                    space: imageRef!.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB)!,
                                    bitmapInfo: imageRef!.bitmapInfo.rawValue)
            context?.interpolationQuality = .high
            context?.draw(imageRef!, in:rectForNewSize)
            
            if let myContext = context {
                let scaledImgRef = myContext.makeImage()
                scaledImg = UIImage(cgImage: scaledImgRef!)
            }
        }
        return scaledImg
    }
    
    
    /*--------------------------------------------------------------------------------------------------------------
     Render a image for the size of 'UIImageView', with regard to preserving the aspect ratio ('contetMode')
     --------------------------------------------------------------------------------------------------------------*/
    @objc internal static func imageFromData(_ data: Data, resizedForImageViewBounds sizeInPoints: CGSize, forContentMode mode:UIView.ContentMode) -> UIImage?
    {
        var scaledImg : UIImage? = nil
        
        // Restore image from 'NSData'
        let imgDataProvider = CGDataProvider(data: data as CFData)
        let imageRef        = CGImage(jpegDataProviderSource: imgDataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
        
        // Recievie original size of image
        let originalImageWidth  = imageRef?.width
        let originalImageHeight = imageRef?.height
        let originalImageSize   = CGSize.init(width: originalImageWidth!, height: originalImageHeight!)
        
        // Calculate optimal size
        let optimalSizeInPixels = CalculateImageSize.calculate(inPixels:originalImageSize, imageViewSizeInPoints:sizeInPoints, contentMode:mode)
        
        
        let rectForNewSize = CGRect.init(x: 0.0, y: 0.0, width:optimalSizeInPixels.width, height:optimalSizeInPixels.height)
    
        if (imageRef != nil){
            
            let context = CGContext(data:nil,
                                    width: Int(optimalSizeInPixels.width),
                                    height: Int(optimalSizeInPixels.height),
                                    bitsPerComponent: imageRef!.bitsPerComponent,
                                    bytesPerRow: 0,
                                    space: imageRef!.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB)!,
                                    bitmapInfo: imageRef!.bitmapInfo.rawValue)
            context?.interpolationQuality = .high
            context?.draw(imageRef!, in:rectForNewSize)
            
            if let myContext = context {
                let scaledImgRef = myContext.makeImage()
                scaledImg = UIImage(cgImage: scaledImgRef!)
            }
            
            // Render image
            if let myContext = context {
                let scaledImgRef = myContext.makeImage()
                      scaledImg  = UIImage(cgImage: scaledImgRef!)
            }
        }
        return scaledImg
    }
    
    
    
    // Mark: Helper method
    private static func colorSpaceNameMethod(colorSpaceString: String) -> CFString {
        
        switch colorSpaceString {
        case "srgb":
            return CGColorSpace.sRGB
        case "display-P3":
            if #available(iOS 9.3, *) {
                return CGColorSpace.displayP3
            } else {
                return CGColorSpace.sRGB
            }
        case "gray-gamma-22":
            return CGColorSpace.genericGrayGamma2_2
        case "extended-gray":
            if #available(iOS 10.0, *) {
                return CGColorSpace.extendedGray
            } else {
                return CGColorSpace.genericGrayGamma2_2
            }
        case "extended-srgb":
            if #available(iOS 10.0, *) {
                return CGColorSpace.extendedSRGB
            } else {
                return CGColorSpace.sRGB
            }
        case "extended-linear-srgb":
            if #available(iOS 10.0, *) {
                return CGColorSpace.extendedLinearSRGB
            } else {
                return CGColorSpace.genericRGBLinear
            }
        default:
            return CGColorSpace.sRGB
        }
    }
    
    /*--------------------------------------------------------------------------------------------------------------
     Resize image
     --------------------------------------------------------------------------------------------------------------*/
 
    @objc internal static func resizeImage(_ image: UIImage, toSizeInPixels pixels: CGSize) -> UIImage? {
        
        precondition(pixels != .zero)
        var scaledImg : UIImage? = nil
        
        if let imageRef = image.cgImage{
            
            let context = CGContext(data:nil,
                                    width: Int(pixels.width),
                                    height: Int(pixels.height),
                                    bitsPerComponent: imageRef.bitsPerComponent,
                                    bytesPerRow: 0,
                                    space: imageRef.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB)!,
                                    bitmapInfo: imageRef.bitmapInfo.rawValue)
            context?.interpolationQuality = .high
            context?.draw(imageRef, in: CGRect(origin: .zero, size: pixels))
            
            if let myContext = context {
                let scaledImgRef = myContext.makeImage()
                scaledImg = UIImage(cgImage: scaledImgRef!)
            }
        }
        return scaledImg
    }
}
