//
//  UIKitResizeImageObjc.m
//  ResizeImageApp2
//
//  Created by Uber on 20/07/2019.
//  Copyright © 2019 RXMobile. All rights reserved.
//

#import "UIKitResizeImageObjc.h"
#import "CalculateImageSize.h"


@implementation UIKitResizeImageObjc


/*--------------------------------------------------------------------------------------------------------------
 Render a image in full size
 --------------------------------------------------------------------------------------------------------------*/
+ (nullable UIImage*) imageFromData:(NSData*)data
{
    return [UIImage imageWithData:data];
}


/*--------------------------------------------------------------------------------------------------------------
 Render a image in borders. Inside converts point to pixels
 --------------------------------------------------------------------------------------------------------------*/

+ (nullable UIImage*) imageFromData:(NSData*)data inSizeInPoints:(CGSize)points
{
    UIImage* image     = [UIImage imageWithData:data];
    UIImage* scaledImg = nil;
    
    CGRect rectForNewSize = CGRectMake(0.0, 0.0, points.width, points.height);

    if (@available(iOS 10, *)) {
        UIGraphicsImageRenderer * renderer = [[UIGraphicsImageRenderer alloc] initWithSize:points];
        scaledImg =
        [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
            [image drawInRect:rectForNewSize];
        }];
    } else {
        UIGraphicsBeginImageContextWithOptions(points, NO, [UIScreen mainScreen].scale);
        [image drawInRect:rectForNewSize];
        scaledImg  = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return scaledImg;
}

/*--------------------------------------------------------------------------------------------------------------
 Render a image in borders
 --------------------------------------------------------------------------------------------------------------*/

+ (nullable UIImage*) imageFromData:(NSData*)data inSizeInPixels:(CGSize)pixels
{
    CGDataProviderRef imgDataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef) data);
    CGImageRef               imageRef = CGImageCreateWithJPEGDataProvider(imgDataProvider, NULL, true, kCGRenderingIntentDefault);
    UIImage* image = [UIImage imageWithCGImage:imageRef];
    
    UIImage* scaledImg = nil;
    CGRect rectForNewSize = CGRectMake(0.0, 0.0, pixels.width, pixels.height);
    
    if (@available(iOS 10, *)) {
        UIGraphicsImageRendererFormat* fortmat = [UIGraphicsImageRendererFormat new];
        fortmat.scale = 1.f;
        
        UIGraphicsImageRenderer * renderer = [[UIGraphicsImageRenderer alloc] initWithSize:pixels format:fortmat];
        scaledImg =
        [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
            [image drawInRect:rectForNewSize];
        }];
    } else {
        UIGraphicsBeginImageContextWithOptions(pixels, NO, 1.f);
        [image drawInRect:rectForNewSize];
        scaledImg  = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    CGDataProviderRelease(imgDataProvider);
    CGImageRelease(imageRef);

    return scaledImg;
}

/*--------------------------------------------------------------------------------------------------------------
 Render a image for the size of 'UIImageView', with regard to preserving the aspect ratio ('contetMode')
 --------------------------------------------------------------------------------------------------------------*/
+ (nullable UIImage*) imageFromData:(NSData*)data resizedForImageViewBounds:(CGSize)sizeInPoints forContentMode:(UIViewContentMode)contentMode
{
    UIImage* scaledImg = nil;
    // Get render original image
    CGDataProviderRef imgDataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef) data);
    CGImageRef               imageRef = CGImageCreateWithJPEGDataProvider(imgDataProvider, NULL, true, kCGRenderingIntentDefault);
    UIImage*            originalImage = [UIImage imageWithCGImage:imageRef];
    
    // Calculate optimal size
    CGSize  optimalSizeInPixels = [CalculateImageSize calculateSizeInPixels:originalImage.size imageViewSizeInPoints:sizeInPoints contentMode:contentMode];
    
    // Prepare rect for futher image
    CGRect rectForNewSize = CGRectMake(0.0, 0.0, optimalSizeInPixels.width, optimalSizeInPixels.height);
    
    // Render image
    if (@available(iOS 10, *)) {
        UIGraphicsImageRendererFormat* fortmat = [UIGraphicsImageRendererFormat new];
        fortmat.scale = 1.f;
        
        UIGraphicsImageRenderer * renderer = [[UIGraphicsImageRenderer alloc] initWithSize:optimalSizeInPixels format:fortmat];
        scaledImg =
        [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
            [originalImage drawInRect:rectForNewSize];
        }];
    } else {
        UIGraphicsBeginImageContextWithOptions(optimalSizeInPixels, NO, 1.f);
        [originalImage drawInRect:rectForNewSize];
        scaledImg  = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return scaledImg;
}


/*--------------------------------------------------------------------------------------------------------------
  Resize image
 --------------------------------------------------------------------------------------------------------------*/

+ (nullable UIImage*) resizeImage:(UIImage*)image toSizeInPixels:(CGSize)pixels
{
    UIImage* scaledImg = nil;
    CGRect rectForNewSize = CGRectMake(0.0, 0.0, pixels.width, pixels.height);
    
    if (@available(iOS 10, *)) {
        UIGraphicsImageRenderer * renderer = [[UIGraphicsImageRenderer alloc] initWithSize:pixels];
        scaledImg =
        [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
            [image drawInRect:rectForNewSize];
        }];
    } else {
        UIGraphicsBeginImageContextWithOptions(pixels, NO, [UIScreen mainScreen].scale);
        [image drawInRect:rectForNewSize];
        scaledImg  = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return scaledImg;
}


@end
