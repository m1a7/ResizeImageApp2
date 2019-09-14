//
//  CoreGraphicsResizeImageObjc.m
//  ResizeImageApp2
//
//  Created by Uber on 20/07/2019.
//  Copyright © 2019 RXMobile. All rights reserved.
//

#import "CoreGraphicsResizeImageObjc.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation CoreGraphicsResizeImageObjc


+ (nullable UIImage*) resizeImage:(UIImage*)image forSize:(CGSize)newSize
{
    CGImageRef imageRef = [image CGImage];
    const size_t width  = newSize.width;
    const size_t height = newSize.height;
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
   
    return scaledImg;
}

@end
