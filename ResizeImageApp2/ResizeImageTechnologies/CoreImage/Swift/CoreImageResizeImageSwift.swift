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

    
    /*--------------------------------------------------------------------------------------------------------------
     Render a image in full size
     --------------------------------------------------------------------------------------------------------------*/
    
    @objc internal static func imageFromData(_ data: Data) -> UIImage?
    {
        let ciImage = CIImage.init(data: data)
        let originalImage = UIImage.init(ciImage: ciImage!)
        return originalImage
    }
    
    
    /*--------------------------------------------------------------------------------------------------------------
     Render a image in borders. Inside converts point to pixels
     --------------------------------------------------------------------------------------------------------------*/
    
    @objc internal static func imageFromData(_ data: Data, inSizeInPoints points: CGSize) -> UIImage?
    {
        let pixels = CalculateImageSize.convertCGSize(toPixels: points)
        return CoreImageResizeImageSwift.imageFromData(data, inSizeInPixels: pixels)
    }
    
    
    /*--------------------------------------------------------------------------------------------------------------
     Render a image in borders
     --------------------------------------------------------------------------------------------------------------*/
    
    @objc internal static func imageFromData(_ data: Data, inSizeInPixels pixels: CGSize) -> UIImage?
    {
        let src   = CGImageSourceCreateWithData(data as CFData, nil)
        let properties = CGImageSourceCopyPropertiesAtIndex(src!, 0, nil) as Dictionary?

        let imageWidthNumber = properties![kCGImagePropertyPixelWidth] as! NSNumber
        let imageHeightNumber = properties![kCGImagePropertyPixelHeight] as! NSNumber
        
        let imageWidth  = CGFloat(imageWidthNumber.floatValue);
        let imageHeight = CGFloat(imageHeightNumber.floatValue)
        
        let scale = max(pixels.width, pixels.height)/max(imageWidth, imageHeight)
        if (scale <= 0){  return nil; }

        let aspectRatio = imageWidth/imageHeight;
        if (aspectRatio <= 0){  return nil; }

        let scaledImage = CoreImageResizeImageSwift.resizeImageFromData(data, scale: scale, aspectRatio: aspectRatio)
        return scaledImage
    }
    
    /*--------------------------------------------------------------------------------------------------------------
     Render a image for the size of 'UIImageView', with regard to preserving the aspect ratio ('contetMode')
     --------------------------------------------------------------------------------------------------------------*/
    @objc internal static func imageFromData(_ data: Data, resizedForImageViewBounds sizeInPoints: CGSize, forContentMode mode:UIView.ContentMode) -> UIImage?
    {
        let src   = CGImageSourceCreateWithData(data as CFData, nil)
        let properties = CGImageSourceCopyPropertiesAtIndex(src!, 0, nil) as Dictionary?
        
        let imageWidthNumber = properties![kCGImagePropertyPixelWidth] as! NSNumber
        let imageHeightNumber = properties![kCGImagePropertyPixelHeight] as! NSNumber
        
        let imageWidth  = CGFloat(imageWidthNumber.floatValue);
        let imageHeight = CGFloat(imageHeightNumber.floatValue)
        
        let originalImageSize = CGSize.init(width: imageWidth, height: imageHeight)
        
        let optimalSizeInPixels = CalculateImageSize.calculate(inPixels: originalImageSize, imageViewSizeInPoints: sizeInPoints, contentMode: mode)
        
        let scale = max(sizeInPoints.width, sizeInPoints.height)/max(optimalSizeInPixels.width, optimalSizeInPixels.height)
        if (scale <= 0){  return nil; }
        
        let aspectRatio = imageWidth/imageHeight;
        if (aspectRatio <= 0){  return nil; }
        
        let scaledImage = CoreImageResizeImageSwift.resizeImageFromData(data, scale: scale, aspectRatio: aspectRatio)
        return scaledImage
    }
    
    
    /*--------------------------------------------------------------------------------------------------------------
     
     --------------------------------------------------------------------------------------------------------------*/
    @objc internal static func resizeImageFromData(_ data: Data, scale: CGFloat, aspectRatio: CGFloat) -> UIImage? {
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
