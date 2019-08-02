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
    
    
    @objc internal static func resizeImage(_ image: UIImage, forSize size: CGSize) -> UIImage? {
        
        precondition(size != .zero)
        var scaledImg : UIImage? = nil

        if let imageRef = image.cgImage{
           
            let context = CGContext(data:nil,
                                   width: Int(size.width),
                                  height: Int(size.height),
                        bitsPerComponent: imageRef.bitsPerComponent,
                             bytesPerRow: 0,
                                   space: imageRef.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB)!,
                              bitmapInfo: imageRef.bitmapInfo.rawValue)
            context?.interpolationQuality = .high
            context?.draw(imageRef, in: CGRect(origin: .zero, size: size))
            
            if let myContext = context {
               let scaledImgRef = myContext.makeImage()
               scaledImg = UIImage(cgImage: scaledImgRef!)
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
}
