//
//  vImageResizeImageSwift.swift
//  ResizeImageApp2
//
//  Created by Uber on 23/07/2019.
//  Copyright © 2019 RXMobile. All rights reserved.
//

import UIKit
import Accelerate.vImage


class vImageResizeImageSwift: NSObject {
    
    
    /*--------------------------------------------------------------------------------------------------------------
     Render a image in full size
     --------------------------------------------------------------------------------------------------------------*/
    
    @objc internal static func imageFromData(_ data: Data) -> UIImage?
    {
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil),
            let image       = CGImageSourceCreateImageAtIndex(imageSource, 0, nil),
            let properties  = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [CFString: Any],
            let imageWidth  = properties[kCGImagePropertyPixelWidth]  as? vImagePixelCount,
            let imageHeight = properties[kCGImagePropertyPixelHeight] as? vImagePixelCount
            else {
                return nil
        }
        
        // Define the image format
        var format = vImage_CGImageFormat(bitsPerComponent: 8,
                                          bitsPerPixel: 32,
                                          colorSpace: nil,
                                          bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue),
                                          version: 0,
                                          decode: nil,
                                          renderingIntent: .defaultIntent)
        var error: vImage_Error
        
        // Create and initialize the source buffer
        var sourceBuffer = vImage_Buffer()
        defer { sourceBuffer.data.deallocate() }
        error = vImageBuffer_InitWithCGImage(&sourceBuffer,
                                             &format,
                                             nil,
                                             image,
                                             vImage_Flags(kvImageNoFlags))
        guard error == kvImageNoError else { return nil }
        
        // Create and initialize the destination buffer
        var destinationBuffer = vImage_Buffer()
        error = vImageBuffer_Init(&destinationBuffer,
                                  vImagePixelCount(imageHeight),
                                  vImagePixelCount(imageWidth),
                                  format.bitsPerPixel,
                                  vImage_Flags(kvImageNoFlags))
        guard error == kvImageNoError else { return nil }
        
        // Scale the image
        error = vImageScale_ARGB8888(&sourceBuffer,
                                     &destinationBuffer,
                                     nil,
                                     vImage_Flags(kvImageNoFlags))
        guard error == kvImageNoError else { return nil }
        
        // Create a CGImage from the destination buffer
        guard let resizedImage =
            vImageCreateCGImageFromBuffer(&destinationBuffer,
                                          &format,
                                          nil,
                                          nil,
                                          vImage_Flags(kvImageNoAllocate),
                                          &error)?.takeRetainedValue(),
            error == kvImageNoError
            else {
                return nil
        }
        
        return UIImage(cgImage: resizedImage)
    }
    
    
    /*--------------------------------------------------------------------------------------------------------------
     Render a image in borders. Inside converts point to pixels
     --------------------------------------------------------------------------------------------------------------*/
    
    @objc internal static func imageFromData(_ data: Data, inSizeInPoints points: CGSize) -> UIImage?
    {
        let pixels = CalculateImageSize.convertCGSize(toPixels: points)
        return vImageResizeImageSwift.imageFromData(data, inSizeInPixels: pixels)
    }
    
    
    /*--------------------------------------------------------------------------------------------------------------
     Render a image in borders
     --------------------------------------------------------------------------------------------------------------*/
    
    @objc internal static func imageFromData(_ data: Data, inSizeInPixels pixels: CGSize) -> UIImage?
    {
        precondition(pixels != .zero)
        
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil),
            let image       = CGImageSourceCreateImageAtIndex(imageSource, 0, nil),
            let properties  = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [CFString: Any],
            let imageWidth  = properties[kCGImagePropertyPixelWidth]  as? vImagePixelCount,
            let imageHeight = properties[kCGImagePropertyPixelHeight] as? vImagePixelCount
            else {
                return nil
        }
        
        // Define the image format
        var format = vImage_CGImageFormat(bitsPerComponent: 8,
                                          bitsPerPixel: 32,
                                          colorSpace: nil,
                                          bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue),
                                          version: 0,
                                          decode: nil,
                                          renderingIntent: .defaultIntent)
        
        var error: vImage_Error
        
        // Create and initialize the source buffer
        var sourceBuffer = vImage_Buffer()
        defer { sourceBuffer.data.deallocate() }
        error = vImageBuffer_InitWithCGImage(&sourceBuffer,
                                             &format,
                                             nil,
                                             image,
                                             vImage_Flags(kvImageNoFlags))
        guard error == kvImageNoError else { return nil }
        
        // Create and initialize the destination buffer
        var destinationBuffer = vImage_Buffer()
        error = vImageBuffer_Init(&destinationBuffer,
                                  vImagePixelCount(pixels.height),
                                  vImagePixelCount(pixels.width),
                                  format.bitsPerPixel,
                                  vImage_Flags(kvImageNoFlags))
        guard error == kvImageNoError else { return nil }
        
        // Scale the image
        error = vImageScale_ARGB8888(&sourceBuffer,
                                     &destinationBuffer,
                                     nil,
                                     vImage_Flags(kvImageNoFlags))
        guard error == kvImageNoError else { return nil }
        
        // Create a CGImage from the destination buffer
        guard let resizedImage =
            vImageCreateCGImageFromBuffer(&destinationBuffer,
                                          &format,
                                          nil,
                                          nil,
                                          vImage_Flags(kvImageNoAllocate),
                                          &error)?.takeRetainedValue(),
            error == kvImageNoError
            else {
                return nil
        }
        
        return UIImage(cgImage: resizedImage)
    }
    
    /*--------------------------------------------------------------------------------------------------------------
     Render a image for the size of 'UIImageView', with regard to preserving the aspect ratio ('contetMode')
     --------------------------------------------------------------------------------------------------------------*/
    @objc internal static func imageFromData(_ data: Data, resizedForImageViewBounds sizeInPoints: CGSize, forContentMode mode:UIView.ContentMode) -> UIImage?
    {
        precondition(sizeInPoints != .zero)
        
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil),
            let image       = CGImageSourceCreateImageAtIndex(imageSource, 0, nil),
            let properties  = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [CFString: Any],
            let imageWidth  = properties[kCGImagePropertyPixelWidth]  as? vImagePixelCount,
            let imageHeight = properties[kCGImagePropertyPixelHeight] as? vImagePixelCount
            else {
                return nil
        }
        
        // Define the image format
        var format = vImage_CGImageFormat(bitsPerComponent: 8,
                                          bitsPerPixel: 32,
                                          colorSpace: nil,
                                          bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue),
                                          version: 0,
                                          decode: nil,
                                          renderingIntent: .defaultIntent)
        
        var error: vImage_Error
        
        // Create and initialize the source buffer
        var sourceBuffer = vImage_Buffer()
        defer { sourceBuffer.data.deallocate() }
        error = vImageBuffer_InitWithCGImage(&sourceBuffer,
                                             &format,
                                             nil,
                                             image,
                                             vImage_Flags(kvImageNoFlags))
        guard error == kvImageNoError else { return nil }
        
        //---------------------------
        let originalImageWidth = image.width
        let originalImageHeight = image.height
        let originalImageSize = CGSize.init(width: originalImageWidth, height: originalImageHeight)
       
        let optimalSizeInPixels = CalculateImageSize.calculate(inPixels: originalImageSize, imageViewSizeInPoints: sizeInPoints, contentMode: mode)
        //---------------------------

        // Create and initialize the destination buffer
        var destinationBuffer = vImage_Buffer()
        error = vImageBuffer_Init(&destinationBuffer,
                                  vImagePixelCount(optimalSizeInPixels.height),
                                  vImagePixelCount(optimalSizeInPixels.width),
                                  format.bitsPerPixel,
                                  vImage_Flags(kvImageNoFlags))
        guard error == kvImageNoError else { return nil }
        
        // Scale the image
        error = vImageScale_ARGB8888(&sourceBuffer,
                                     &destinationBuffer,
                                     nil,
                                     vImage_Flags(kvImageNoFlags))
        guard error == kvImageNoError else { return nil }
        
        // Create a CGImage from the destination buffer
        guard let resizedImage =
            vImageCreateCGImageFromBuffer(&destinationBuffer,
                                          &format,
                                          nil,
                                          nil,
                                          vImage_Flags(kvImageNoAllocate),
                                          &error)?.takeRetainedValue(),
            error == kvImageNoError
            else {
                return nil
        }
        
        return UIImage(cgImage: resizedImage)
    }
    
}
