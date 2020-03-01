//
//  EstimateImageSize.h
//  ResizeImageApp2
//
//  Created by Uber on 24/07/2019.
//  Copyright © 2019 RXMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*--------------------------------------------------------------------------------------------------------------
 🔬🖼 'CalculateImageSize' - the class was created to calculate the optimal image size for different 'contentMode'.
 ---------------
 The main task is to calculate the correct image size for a specific 'contentMode' and convert the size
 if necessary, from points to pixels.
 ---------------
 Duties:
 - Calculate image sizes in Points.
 - Calculate image sizes in Pixels.
 - To support the algorithms, the calculations for two main 'contentMode' - (AspectFit и AspectFill)
 ---------------
 The class provides the following features:
 - You can calculate the optimal size of images when zooming in or out (while maintaining the aspect ratio)
 - You can convert the structures 'CGSize' and 'CGRect' Points to Pixels pixels.
 ---------------
 Additionally:
 (⚠️) Remember that, 'UIImage.size'            -   always returns a value in PIXELS !
                     'UIImageView.frame.size'  -   always returns a value in POINTS !
     -------------
    This may be important when drawing images in other modules. Because they expect the size of 'UIImageView'
    in PIXELS, if you pass the size in points there, the image will end up being a small size!
 --------------------------------------------------------------------------------------------------------------*/

@interface CalculateImageSize : NSObject


#pragma mark - Calculate optimal size for any contentMode In points and pixels

+ (CGSize) calculateSizeInPoints:(CGSize)imageSizeInPoints      // Calculates the optimal size for the future image. And return structure in POINTS!
           imageViewSizeInPoints:(CGSize)imageViewSizeInPoints
                     contentMode:(UIViewContentMode)contentMode;

+ (CGSize) calculateSizeInPixels:(CGSize)imageSizeInPoints      // Calculates the optimal size for the future image. And return structure in PIXELS!
           imageViewSizeInPoints:(CGSize)imageViewSizeInPoints
                     contentMode:(UIViewContentMode)contentMode;



#pragma mark - Calculate for AspectFit & AspectFill in Points
/*--------------------------------------------------------------------------------------------------------------
 It takes dimensions within which method need to draw a picture.
 Calculates the aspect ratio for the mode '.AspectFit'. Returns dimensions in "points".
 --------------------------------------------------------------------------------------------------------------*/
+ (CGSize) aspectFit:(CGSize)originalImageSize boundingSize:(CGSize)boundingSize;

/*--------------------------------------------------------------------------------------------------------------
 It takes dimensions within which method need to draw a picture.
 Calculates the aspect ratio for the mode '.AspectFill'. Returns dimensions in "points".
 --------------------------------------------------------------------------------------------------------------*/
+ (CGSize) aspectFill:(CGSize)originalImageSize minimumSize:(CGSize)minimumSize;


#pragma mark - Convert CGSize CGRect to pixels

+ (CGSize) convertCGSizeToPixels:(CGSize)size; //  Transforms 'CGSize' from points to pixels
+ (CGRect) convertCGRectToPixels:(CGRect)rect; //  Transforms 'CGRect' from points to pixels
    
@end

NS_ASSUME_NONNULL_END
