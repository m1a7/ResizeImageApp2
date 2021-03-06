//
//  ImageIOResizeImageSwift.swift
//  ResizeImageApp2
//
//  Created by Uber on 20/07/2019.
//  Copyright © 2019 RXMobile. All rights reserved.
//

import UIKit
import ImageIO
import MobileCoreServices

class ImageIOResizeImageSwift: NSObject {
    
    
    /*--------------------------------------------------------------------------------------------------------------
     Render a image in full size
     --------------------------------------------------------------------------------------------------------------*/
    
    @objc internal static func imageFromData(_ data: Data) -> UIImage?
    {
        let src   = CGImageSourceCreateWithData(data as CFData, nil)
        let cgImg = CGImageSourceCreateImageAtIndex(src!, 0, nil)
        let image = UIImage.init(cgImage: cgImg!)
        return image
    }
    
    
    /*--------------------------------------------------------------------------------------------------------------
     Render a image in borders. Inside converts point to pixels
     --------------------------------------------------------------------------------------------------------------*/
    
    @objc internal static func imageFromData(_ data: Data, inSizeInPoints points: CGSize) -> UIImage?
    {
        precondition(points != .zero)
        let pixels = CalculateImageSize.convertCGSize(toPixels: points)
        return imageFromData(data, inSizeInPixels:pixels)
     }
    
    
    /*--------------------------------------------------------------------------------------------------------------
     Render a image in borders
     --------------------------------------------------------------------------------------------------------------*/
    
    @objc internal static func imageFromData(_ data: Data, inSizeInPixels pixels: CGSize) -> UIImage?
    {
        let src   = CGImageSourceCreateWithData(data as CFData, nil)
        let options: [CFString: Any] = [
            kCGImageSourceThumbnailMaxPixelSize: max(pixels.width, pixels.height),
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true
        ]
        var scaledImage : UIImage?
    
        if let thumbnail  = CGImageSourceCreateThumbnailAtIndex(src!, 0, options as CFDictionary){
            scaledImage =  UIImage(cgImage: thumbnail)
        }
        return scaledImage
    }

    
    
    /*--------------------------------------------------------------------------------------------------------------
     Render a image for the size of 'UIImageView', with regard to preserving the aspect ratio ('contetMode')
     --------------------------------------------------------------------------------------------------------------*/
    @objc internal static func imageFromData(_ data: Data, resizedForImageViewBounds sizeInPoints: CGSize, forContentMode mode:UIView.ContentMode) -> UIImage?
    {
        var scaledImage : UIImage?
        let src   = CGImageSourceCreateWithData(data as CFData, nil)
        let properties = CGImageSourceCopyPropertiesAtIndex(src!, 0, nil) as Dictionary?
        
        let imageWidthNumber = properties![kCGImagePropertyPixelWidth] as! NSNumber
        let imageHeightNumber = properties![kCGImagePropertyPixelHeight] as! NSNumber

        let imageWidth  = CGFloat(imageWidthNumber.floatValue);
        let imageHeight = CGFloat(imageHeightNumber.floatValue)
        
        let originalImageSize = CGSize.init(width: imageWidth, height: imageHeight)
        
         // Calculate optimal size
        let optimalSizeInPixels = CalculateImageSize.calculate(inPixels: originalImageSize, imageViewSizeInPoints: sizeInPoints, contentMode: mode)
        
         // Create parameters for rendering
        let options: [CFString: Any] = [
            kCGImageSourceThumbnailMaxPixelSize: max(optimalSizeInPixels.width, optimalSizeInPixels.height),
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform  : true
        ]
        
        if let thumbnail  = CGImageSourceCreateThumbnailAtIndex(src!, 0, options as CFDictionary){
            scaledImage =  UIImage(cgImage: thumbnail)
        }
        
        return scaledImage
    }
    
    
    /*--------------------------------------------------------------------------------------------------------------
     Uses the 'Subsampling' technology. Supports formats ('jpeg'/ 'tiff', 'png').
     --------------------------------------------------------------------------------------------------------------*/
    
  @available(iOS 9.0, *)
  @objc internal  static func resizeImageFromDataWithSubsampling(_ data: Data, imgExtension exten:String, forSize size: CGSize) -> UIImage? {

        precondition(size != .zero)
     
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil),
              let properties  = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [CFString: Any],
              let imageWidth  = properties[kCGImagePropertyPixelWidth]  as? CGFloat,
              let imageHeight = properties[kCGImagePropertyPixelHeight] as? CGFloat
            else {
                return nil
        }
        
        var options: [CFString: Any] = [
            kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height),
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform:   true
        ]
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, exten as CFString, kUTTypeImage)?.takeRetainedValue() {
            options[kCGImageSourceTypeIdentifierHint] = uti
            
            if uti == kUTTypeJPEG || uti == kUTTypeTIFF || uti == kUTTypePNG ||
                String(uti).hasPrefix("public.heif")
            {
                switch min(imageWidth / size.width, imageHeight / size.height) {
                case ...2.0:
                    options[kCGImageSourceSubsampleFactor] = 2.0
                case 2.0...4.0:
                    options[kCGImageSourceSubsampleFactor] = 4.0
                case 4.0...:
                    options[kCGImageSourceSubsampleFactor] = 8.0
                default:
                    break
                }
            }
        }
        
        guard let image = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary) else {
            return nil
        }
        return UIImage(cgImage: image)
    }
 
}
