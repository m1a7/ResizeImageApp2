//
//  EstimateImageSize.m
//  ResizeImageApp2
//
//  Created by Uber on 24/07/2019.
//  Copyright © 2019 RXMobile. All rights reserved.
//

#import "СalculateImageSize.h"

@implementation СalculateImageSize

/*--------------------------------------------------------------------------------------------------------------
 Calculates the optimal size for the future image in points
 --------------------------------------------------------------------------------------------------------------*/

+ (CGSize) calculateSizeInPoints:(CGSize)originalImageSize imageViewSize:(CGSize)imageViewSize contentMode:(UIViewContentMode)contentMode
{
    CGSize scaledImageSize;
    if (contentMode == UIViewContentModeScaleAspectFit){
        CGRect scaledImageRect = CGRectZero;
        
        CGFloat aspectWidth = imageViewSize.width / originalImageSize.width;
        CGFloat aspectHeight = imageViewSize.height / originalImageSize.height;
        CGFloat aspectRatio = MIN ( aspectWidth, aspectHeight );
        
        scaledImageRect.size.width = originalImageSize.width * aspectRatio;
        scaledImageRect.size.height = originalImageSize.height * aspectRatio;
        scaledImageRect.origin.x = (imageViewSize.width - scaledImageRect.size.width) / 2.0f;
        scaledImageRect.origin.y = (imageViewSize.height - scaledImageRect.size.height) / 2.0f;
        scaledImageSize = scaledImageRect.size;
    }else if (contentMode == UIViewContentModeScaleToFill){
        scaledImageSize = imageViewSize;
    }
    else {
        // UIViewContentModeScaleAspectFill and other...
        if (originalImageSize.width > originalImageSize.height) {
            scaledImageSize.width  = (originalImageSize.width/originalImageSize.height) * imageViewSize.height;
            scaledImageSize.height =  imageViewSize.height;
        } else {
            scaledImageSize.width  = imageViewSize.width;
            scaledImageSize.height = (originalImageSize.height/originalImageSize.width) * imageViewSize.width;
        }
    }
    CGSize roundedSize = CGSizeMake(floorf(scaledImageSize.width), floorf(scaledImageSize.height));
    return roundedSize;
}

/*--------------------------------------------------------------------------------------------------------------
  Calculates the optimal size for the future image in pixels
 --------------------------------------------------------------------------------------------------------------*/

+ (CGSize) calculateSizeInPixels:(CGSize)originalImageSize imageViewSize:(CGSize)imageViewSize contentMode:(UIViewContentMode)contentMode
{
    CGSize sizeWithoutScaleFactor = [СalculateImageSize calculateSizeInPoints:originalImageSize imageViewSize:imageViewSize contentMode:contentMode];
   
    CGFloat scaleFactor     = [UIScreen mainScreen].scale;
    CGAffineTransform scale = CGAffineTransformMakeScale(scaleFactor, scaleFactor);

    CGSize sizeWithScaleFactor = CGSizeApplyAffineTransform(sizeWithoutScaleFactor, scale);
    CGSize roundedSize = CGSizeMake(floorf(sizeWithScaleFactor.width), floorf(sizeWithScaleFactor.height));
    return roundedSize;
}

/*--------------------------------------------------------------------------------------------------------------
 Transforms the structure from points to pixels
 --------------------------------------------------------------------------------------------------------------*/

+ (CGSize) transformStructureWithScaleFactor:(CGSize) originalSize
{
    CGFloat scaleFactor     = [UIScreen mainScreen].scale;
    CGAffineTransform scale = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
    CGSize sizeWithScaleFactor = CGSizeApplyAffineTransform(originalSize, scale);
    return sizeWithScaleFactor;
}



@end
