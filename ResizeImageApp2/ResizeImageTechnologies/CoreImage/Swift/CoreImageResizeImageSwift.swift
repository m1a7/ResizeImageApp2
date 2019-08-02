//
//  CoreImageResizeImageSwift.swift
//  ResizeImageApp2
//
//  Created by Uber on 23/07/2019.
//  Copyright © 2019 RXMobile. All rights reserved.
//
import UIKit
import CoreImage


class CoreImageResizeImageSwift: NSObject {

    
  @objc internal static func resizeImageFromData(_ data: NSData, forSize size: CGSize) -> UIImage? {
        precondition(size != .zero)
        
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil),
              let properties  = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [CFString: Any],
              let imageWidth  = properties[kCGImagePropertyPixelWidth]  as? CGFloat,
              let imageHeight = properties[kCGImagePropertyPixelHeight] as? CGFloat
             else {
                return nil
        }
    
        let scale = max(size.width, size.height) / max(imageWidth, imageHeight)
        guard scale >= 0, !scale.isInfinite, !scale.isNaN else { return nil }
        
        let aspectRatio = imageWidth / imageHeight
        guard aspectRatio >= 0, !aspectRatio.isInfinite, !aspectRatio.isNaN else { return nil }
        
        return resizeImageFromData(data, scale: scale, aspectRatio: aspectRatio)
    }
    

   @objc internal static func resizeImageFromData(_ data: NSData, scale: CGFloat, aspectRatio: CGFloat) -> UIImage? {
        precondition(aspectRatio > 0.0)
        precondition(scale > 0.0)
        
        
        guard let image = CIImage(data: data as Data) else {
            return nil
        }
        
        let filter = CIFilter(name: "CILanczosScaleTransform")
            filter?.setValue(image, forKey: kCIInputImageKey)
            filter?.setValue(scale, forKey: kCIInputScaleKey)
            filter?.setValue(aspectRatio, forKey: kCIInputAspectRatioKey)

        let sharedContext   = CoreImageResizeImageObjc.context(options: [.useSoftwareRenderer : false]);
        
        guard let outputCIImage = filter?.outputImage,
              let outputCGImage = sharedContext.createCGImage(outputCIImage, from: outputCIImage.extent)
            else {
                return nil
        }
        return UIImage(cgImage: outputCGImage)
    }
}
