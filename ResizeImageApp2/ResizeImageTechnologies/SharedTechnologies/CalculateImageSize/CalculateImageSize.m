//
//  EstimateImageSize.m
//  ResizeImageApp2
//
//  Created by Uber on 24/07/2019.
//  Copyright © 2019 RXMobile. All rights reserved.
//

#import "CalculateImageSize.h"

@implementation CalculateImageSize

#pragma mark - Calculate optimal size for any contentMode In points and pixels

/*--------------------------------------------------------------------------------------------------------------
 Calculates the optimal size for the future image. And return structure in POINTS!
 --------------------------------------------------------------------------------------------------------------*/

+ (CGSize) calculateSizeInPoints:(CGSize)imageSizeInPoints imageViewSizeInPoints:(CGSize)imageViewSizeInPoints contentMode:(UIViewContentMode)contentMode
{
    CGSize resultSize;
    
    if (contentMode == UIViewContentModeScaleAspectFit){
        resultSize = [CalculateImageSize aspectFit:imageSizeInPoints boundingSize:imageViewSizeInPoints];
    } else {
        resultSize = [CalculateImageSize aspectFill:imageSizeInPoints minimumSize:imageViewSizeInPoints];
    }
    return resultSize;
}

/*--------------------------------------------------------------------------------------------------------------
  Calculates the optimal size for the future image. And return structure in PIXELS!
 --------------------------------------------------------------------------------------------------------------*/

+ (CGSize) calculateSizeInPixels:(CGSize)imageSizeInPoints imageViewSizeInPoints:(CGSize)imageViewSizeInPoints contentMode:(UIViewContentMode)contentMode
{
    CGSize sizeInPoints = [CalculateImageSize calculateSizeInPoints:imageSizeInPoints imageViewSizeInPoints:imageViewSizeInPoints contentMode:contentMode];
    CGSize sizeInPixels = [CalculateImageSize convertCGSizeToPixels:sizeInPoints];
    return sizeInPixels;
}


#pragma mark - Calculate for AspectFit & AspectFill in Points

/*--------------------------------------------------------------------------------------------------------------
 It takes dimensions within which method need to draw a picture.
 Calculates the aspect ratio for the mode '.AspectFit'. Returns dimensions in "points".
 --------------------------------------------------------------------------------------------------------------*/

+ (CGSize) aspectFit:(CGSize)originalImageSize boundingSize:(CGSize)boundingSize
{
    CGFloat mW = boundingSize.width  / originalImageSize.width;
    CGFloat mH = boundingSize.height / originalImageSize.height;
    
    if( mH < mW ) {
        boundingSize.width = floorf(boundingSize.height / originalImageSize.height * originalImageSize.width);
    }
    else if( mW < mH ) {
        boundingSize.height = floorf(boundingSize.width / originalImageSize.width * originalImageSize.height);
    }
    return boundingSize;
}

/*--------------------------------------------------------------------------------------------------------------
 It takes dimensions within which method need to draw a picture.
 Calculates the aspect ratio for the mode '.AspectFill'. Returns dimensions in "points".
 --------------------------------------------------------------------------------------------------------------*/

+ (CGSize) aspectFill:(CGSize)originalImageSize minimumSize:(CGSize)minimumSize
{
    CGFloat mW = minimumSize.width / originalImageSize.width;
    CGFloat mH = minimumSize.height / originalImageSize.height;
    
    if( mH > mW ) {
        minimumSize.width = floorf(minimumSize.height / originalImageSize.height * originalImageSize.width);
    }
    else if( mW > mH ) {
        minimumSize.height = floorf(minimumSize.width / originalImageSize.width * originalImageSize.height);
    }
    return minimumSize;
}


#pragma mark - Convert CGSize CGRect to pixels

/*--------------------------------------------------------------------------------------------------------------
 Transforms 'CGSize' from points to pixels
 --------------------------------------------------------------------------------------------------------------*/

+ (CGSize) convertCGSizeToPixels:(CGSize)size
{
    CGFloat scaleFactor     = [UIScreen mainScreen].scale;
    CGAffineTransform scale = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
    CGSize sizeWithScaleFactor = CGSizeApplyAffineTransform(size, scale);
    CGSize roundedSize         = CGSizeMake(floorf(sizeWithScaleFactor.width), floorf(sizeWithScaleFactor.height));
    return roundedSize;
}

/*--------------------------------------------------------------------------------------------------------------
 Transforms 'CGRect' from points to pixels
 --------------------------------------------------------------------------------------------------------------*/
+ (CGRect) convertCGRectToPixels:(CGRect)rect
{
    CGFloat      scaleFactor = [UIScreen mainScreen].scale;
    CGAffineTransform affine = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
    CGRect        scaledRect = CGRectApplyAffineTransform(rect, affine);
    return scaledRect;
}




@end
