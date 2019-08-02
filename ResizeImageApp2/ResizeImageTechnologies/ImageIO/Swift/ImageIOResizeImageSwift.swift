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
    
    

@objc internal static func resizeImageFromData(_ data: NSData, forSize size: CGSize) -> UIImage? {
    
        precondition(size != .zero)
        
        let options: [CFString: Any] = [
            kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height),
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true
        ]
        var scaledImage : UIImage?

        if let source = CGImageSourceCreateWithData(data as CFData, nil){
            if let thumbnail  = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary){
                  scaledImage =  UIImage(cgImage: thumbnail)
            }
        }
        return scaledImage
    }
    
    

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
