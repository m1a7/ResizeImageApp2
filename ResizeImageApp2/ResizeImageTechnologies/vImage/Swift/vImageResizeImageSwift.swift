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
    
    
    @objc internal static func resizeImageFromData(_ data: NSData, forSize size: CGSize) -> UIImage? {
        precondition(size != .zero)
    
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
                                  vImagePixelCount(size.height),
                                  vImagePixelCount(size.width),
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