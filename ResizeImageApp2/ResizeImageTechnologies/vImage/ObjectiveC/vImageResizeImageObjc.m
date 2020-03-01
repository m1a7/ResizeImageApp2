//
//  vImageResizeImageObjc.m
//  ResizeImageApp2
//
//  Created by Uber on 23/07/2019.
//  Copyright © 2019 RXMobile. All rights reserved.
//

#import "vImageResizeImageObjc.h"
#import <Accelerate/Accelerate.h>
#import "CalculateImageSize.h"

@implementation vImageResizeImageObjc

/*--------------------------------------------------------------------------------------------------------------
  Render a image in full size
 --------------------------------------------------------------------------------------------------------------*/
+ (nullable UIImage*) imageFromData:(NSData*)data
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
        
        // Recievie original size of image
        size_t originalImageWidth  = CGImageGetWidth(image);
        size_t originalImageHeight = CGImageGetHeight(image);
        
        vImage_Buffer destinationBuffer;
        error = vImageBuffer_Init(&destinationBuffer, (vImagePixelCount)originalImageHeight, (vImagePixelCount)originalImageWidth, format.bitsPerPixel, kvImageNoFlags);
        
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
        //NSLog(@"vImageResizeImageObjc resizedImage exception: %@",exception);
    } @finally {
        free(sourceBuffer.data);
    }
    return nil;
}

/*--------------------------------------------------------------------------------------------------------------
 Render a image in borders. Inside converts point to pixels
 --------------------------------------------------------------------------------------------------------------*/

+ (nullable UIImage*) imageFromData:(NSData*)data inSizeInPoints:(CGSize)points
{
    CGSize pixels = [CalculateImageSize convertCGSizeToPixels:points];
    return [vImageResizeImageObjc imageFromData:data inSizeInPixels:pixels];
}


/*--------------------------------------------------------------------------------------------------------------
 Render a image in borders
 --------------------------------------------------------------------------------------------------------------*/

+ (nullable UIImage*) imageFromData:(NSData*)data inSizeInPixels:(CGSize)pixels
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
        error = vImageBuffer_Init(&destinationBuffer, (vImagePixelCount)pixels.height, (vImagePixelCount)pixels.width, format.bitsPerPixel, kvImageNoFlags);
        
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
        //NSLog(@"vImageResizeImageObjc resizedImage exception: %@",exception);
    } @finally {
        free(sourceBuffer.data);
    }
    return nil;
}



/*--------------------------------------------------------------------------------------------------------------
 Render a image for the size of 'UIImageView', with regard to preserving the aspect ratio ('contetMode')
 --------------------------------------------------------------------------------------------------------------*/

+ (nullable UIImage*) imageFromData:(NSData*)data resizedForImageViewBounds:(CGSize)sizeInPoints forContentMode:(UIViewContentMode)contentMode
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
        //---------------------------
        // Calculate optimal size
        
        // Recievie original size of image
        size_t originalImageWidth  = CGImageGetWidth(image);
        size_t originalImageHeight = CGImageGetHeight(image);
        CGSize originalImageSize   = CGSizeMake(originalImageWidth, originalImageHeight);
        
        // Calculate optimal size
        CGSize optimalSizeInPixels = [CalculateImageSize calculateSizeInPixels:originalImageSize imageViewSizeInPoints:sizeInPoints contentMode:contentMode];
        //---------------------------
        vImage_Buffer destinationBuffer;
        error = vImageBuffer_Init(&destinationBuffer, (vImagePixelCount)optimalSizeInPixels.height, (vImagePixelCount)optimalSizeInPixels.width, format.bitsPerPixel, kvImageNoFlags);
        
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
        //NSLog(@"vImageResizeImageObjc resizedImage exception: %@",exception);
    } @finally {
        free(sourceBuffer.data);
    }
    return nil;
}


@end
