//
//  EstimateImageSize.h
//  ResizeImageApp2
//
//  Created by Uber on 24/07/2019.
//  Copyright © 2019 RXMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface СalculateImageSize : NSObject

+ (CGSize) calculateSizeInPixels:(CGSize)originalImageSize imageViewSize:(CGSize)imageViewSize contentMode:(UIViewContentMode)contentMode;
+ (CGSize) calculateSizeInPoints:(CGSize)originalImageSize imageViewSize:(CGSize)imageViewSize contentMode:(UIViewContentMode)contentMode;
+ (CGSize) transformStructureWithScaleFactor:(CGSize) originalSize;

@end

NS_ASSUME_NONNULL_END
