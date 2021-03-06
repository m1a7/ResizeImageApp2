//
//  CoreGraphicsResizeImageObjc.m
//  ResizeImageApp2
//
//  Created by Uber on 20/07/2019.
//  Copyright © 2019 RXMobile. All rights reserved.
//

#import "CoreGraphicsResizeImageObjc.h"
#import <CoreGraphics/CoreGraphics.h>
#import "CalculateImageSize.h"

@implementation CoreGraphicsResizeImageObjc

/*--------------------------------------------------------------------------------------------------------------
  Render a image in full size
 --------------------------------------------------------------------------------------------------------------*/
+ (nullable UIImage*) imageFromData:(NSData*)data
{
    // Restore image from 'NSData'
    CGDataProviderRef imgDataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef) data);
    CGImageRef imageRef = CGImageCreateWithJPEGDataProvider(imgDataProvider, NULL, true, kCGRenderingIntentDefault);
    
    // Recievie original size of image
    size_t originalImageWidth  = CGImageGetWidth(imageRef);
    size_t originalImageHeight = CGImageGetHeight(imageRef);
    
    // Setup options (colorSpace/bitmapInfo/bitsPerComponent)
    size_t    bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    CGBitmapInfo    bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    // Set 'optimal' size
    CGRect rectForNewSize = CGRectMake(0.0f, 0.0f, originalImageWidth, originalImageHeight);
    CGContextRef context = CGBitmapContextCreate(NULL, originalImageWidth, originalImageHeight, bitsPerComponent, 0, colorSpace, bitmapInfo);
    CGContextDrawImage(context, rectForNewSize, imageRef);
    
    // Render image
    CGImageRef scaledImageRef = CGBitmapContextCreateImage(context);
    UIImage*   scaledImg      = [UIImage imageWithCGImage:scaledImageRef];
    
    // Release low-level variable
    CGImageRelease(scaledImageRef);
    CGContextRelease(context);
    CGImageRelease(imageRef);
    CGDataProviderRelease(imgDataProvider);
    
    return scaledImg;
}


/*--------------------------------------------------------------------------------------------------------------
  Render a image in borders. Inside converts point to pixels
 --------------------------------------------------------------------------------------------------------------*/

+ (nullable UIImage*) imageFromData:(NSData*)data inSizeInPoints:(CGSize)points
{
    CGSize pixels = [CalculateImageSize convertCGSizeToPixels:points];
    return [CoreGraphicsResizeImageObjc imageFromData:data inSizeInPixels:pixels];
}

/*--------------------------------------------------------------------------------------------------------------
  Render a image in borders
 --------------------------------------------------------------------------------------------------------------*/

+ (nullable UIImage*) imageFromData:(NSData*)data inSizeInPixels:(CGSize)pixels
{
    CGDataProviderRef imgDataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef) data);
    CGImageRef imageRef = CGImageCreateWithJPEGDataProvider(imgDataProvider, NULL, true, kCGRenderingIntentDefault);

    //-----
    const size_t width  = pixels.width;
    const size_t height = pixels.height;
    //-----
    
    size_t    bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    CGBitmapInfo    bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    CGRect rectForNewSize = CGRectMake(0.0f, 0.0f, width, height);
    
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, bitsPerComponent, 0, colorSpace, bitmapInfo);
    CGContextDrawImage(context, rectForNewSize, imageRef);

    
    CGImageRef scaledImageRef = CGBitmapContextCreateImage(context);
    UIImage*   scaledImg      = [UIImage imageWithCGImage:scaledImageRef];

    CGImageRelease(scaledImageRef);
    CGContextRelease(context);
   
    CGImageRelease(imageRef);
    CGDataProviderRelease(imgDataProvider);

    return scaledImg;
}

/*--------------------------------------------------------------------------------------------------------------
 Render a image for the size of 'UIImageView', with regard to preserving the aspect ratio ('contetMode')
 --------------------------------------------------------------------------------------------------------------*/
+ (nullable UIImage*) imageFromData:(NSData*)data resizedForImageViewBounds:(CGSize)sizeInPoints forContentMode:(UIViewContentMode)contentMode
{
    // Restore image from 'NSData'
    CGDataProviderRef imgDataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef) data);
    CGImageRef imageRef = CGImageCreateWithJPEGDataProvider(imgDataProvider, NULL, true, kCGRenderingIntentDefault);
    
    // Recievie original size of image
    size_t originalImageWidth  = CGImageGetWidth(imageRef);
    size_t originalImageHeight = CGImageGetHeight(imageRef);
    CGSize originalImageSize   = CGSizeMake(originalImageWidth, originalImageHeight);
    
    // Calculate optimal size
    CGSize optimalSizeInPixels = [CalculateImageSize calculateSizeInPixels:originalImageSize imageViewSizeInPoints:sizeInPoints contentMode:contentMode];
    
    // Setup options (colorSpace/bitmapInfo/bitsPerComponent)
    size_t    bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    CGBitmapInfo    bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    // Set 'optimal' size
    CGRect rectForNewSize = CGRectMake(0.0f, 0.0f, optimalSizeInPixels.width, optimalSizeInPixels.height);
    CGContextRef context = CGBitmapContextCreate(NULL, optimalSizeInPixels.width, optimalSizeInPixels.height, bitsPerComponent, 0, colorSpace, bitmapInfo);
    CGContextDrawImage(context, rectForNewSize, imageRef);
    
    // Render image
    CGImageRef scaledImageRef = CGBitmapContextCreateImage(context);
    UIImage*   scaledImg      = [UIImage imageWithCGImage:scaledImageRef];
    
    // Release low-level variable
    CGImageRelease(scaledImageRef);
    CGContextRelease(context);
    CGImageRelease(imageRef);
    CGDataProviderRelease(imgDataProvider);
    
    return scaledImg;
}

/*--------------------------------------------------------------------------------------------------------------
 Resize image
 --------------------------------------------------------------------------------------------------------------*/
+ (nullable UIImage*) resizeImage:(UIImage*)image toSizeInPixels:(CGSize)pixels
{
    CGImageRef imageRef = [image CGImage];
    const size_t width  = pixels.width;
    const size_t height = pixels.height;
    size_t    bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    CGBitmapInfo    bitmapInfo    = CGImageGetBitmapInfo(imageRef);
    
    CGRect rectForNewSize = CGRectMake(0.0f, 0.0f, width, height);
    
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, bitsPerComponent, 0, colorSpace, bitmapInfo);
    CGContextDrawImage(context, rectForNewSize, imageRef);
    
    
    CGImageRef scaledImageRef = CGBitmapContextCreateImage(context);
    UIImage*   scaledImg      = [UIImage imageWithCGImage:scaledImageRef];
    
    CGImageRelease(scaledImageRef);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    return scaledImg;
}

@end
