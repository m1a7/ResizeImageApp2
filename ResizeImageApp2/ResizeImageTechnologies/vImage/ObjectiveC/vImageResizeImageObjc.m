//
//  vImageResizeImageObjc.m
//  ResizeImageApp2
//
//  Created by Uber on 23/07/2019.
//  Copyright © 2019 RXMobile. All rights reserved.
//

#import "vImageResizeImageObjc.h"
#import <Accelerate/Accelerate.h>

@implementation vImageResizeImageObjc


+ (nullable UIImage*) resizeImageFromData:(nonnull NSData*)data forSize:(CGSize)newSize
{
    vImage_Buffer sourceBuffer;
    
    @try {
        CGImageSourceRef imageSource = CGImageSourceCreateWithData((CFDataRef)data, NULL);
        CGImageRef image = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
        
        vImage_CGImageFormat format = {
            .bitsPerComponent = 8,
            .bitsPerPixel = 32,
            .colorSpace = NULL,
            .bitmapInfo = (CGBitmapInfo)kCGImageAlphaFirst,
            .version = 0,
            .decode = NULL,
            .renderingIntent = kCGRenderingIntentDefault,
        };
        
        vImage_Error error = vImageBuffer_InitWithCGImage(&sourceBuffer, &format, NULL, image, kvImageNoFlags);
        
        if (error != kvImageNoError){ return nil; }
        
        vImage_Buffer destinationBuffer;
        error = vImageBuffer_Init(&destinationBuffer, (vImagePixelCount)newSize.height, (vImagePixelCount)newSize.width, format.bitsPerPixel, kvImageNoFlags);
        
        if (error != kvImageNoError){ return nil; }
        
        error = vImageScale_ARGB8888(&sourceBuffer, &destinationBuffer, NULL, kvImageNoFlags);
        
        if (error != kvImageNoError){ return nil; }
        
        CGImageRef resizedImage = vImageCreateCGImageFromBuffer(&destinationBuffer,&format,NULL,NULL,kvImageNoAllocate,&error);
        UIImage* scaledImage = [UIImage imageWithCGImage:resizedImage];
        
        CFRelease(imageSource);
        CGImageRelease(image);
        CGImageRelease(resizedImage);   

        return scaledImage;
        
    } @catch (NSException *exception) {
        NSLog(@"vImageResizeImageObjc resizedImage exception: %@",exception);
    } @finally {
        free(sourceBuffer.data);
    }
    return nil;
}
 

@end
