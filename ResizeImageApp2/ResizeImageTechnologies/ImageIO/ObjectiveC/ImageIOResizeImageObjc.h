//
//  ImageIOResizeImageObjc.h
//  RXWebCacheNSOperation
//
//  Created by Uber on 15/09/2019.
//  Copyright © 2019 RXMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*--------------------------------------------------------------------------------------------------------------
 🗜🌁 'ImageIOResizeImageObjc' - the class render images from 'NSData' using the 'ImageIO' technology.
 ---------------
 The main task is to draw an image with the resolution specified in 'CGSize' from binary code
 ---------------
 Duties:
 - Draw an image using 'ImageIO'.
 ---------------
 The class provides the following features:
 - You can draw a picture in original size
 - You can pass the desired size (in points) and the method automatically converts them, and returns the image to pixels
 - You can immediately pass the desired size in (in pixels)
 - You can transfer the size of the UIImageView and the picture will automatically be reduced to the optimal size (considering contenMode)
 --------------------------------------------------------------------------------------------------------------*/

@interface ImageIOResizeImageObjc : NSObject

+ (nullable UIImage*) imageFromData:(NSData*)data;                               // render a image in full size
+ (nullable UIImage*) imageFromData:(NSData*)data inSizeInPoints:(CGSize)points; // render a image in borders. Inside converts point to pixels
+ (nullable UIImage*) imageFromData:(NSData*)data inSizeInPixels:(CGSize)pixels; // render a image in borders.

/*--------------------------------------------------------------------------------------------------------------
  Render a image for the size of 'UIImageView', with regard to preserving the aspect ratio ('contetMode')
 --------------------------------------------------------------------------------------------------------------*/
+ (nullable UIImage*) imageFromData:(NSData*)data resizedForImageViewBounds:(CGSize)sizeInPoints forContentMode:(UIViewContentMode)contentMode;

/*--------------------------------------------------------------------------------------------------------------
 Uses the 'Subsampling' technology. Supports formats ('jpeg'/ 'tiff', 'png').
 --------------------------------------------------------------------------------------------------------------*/
+ (nullable UIImage*) imageWithSubsamplingFromData:(NSData*)data imgExtension:(NSString*)extension inSizeInPixels:(CGSize)pixels NS_AVAILABLE_IOS(9_0);

@end

NS_ASSUME_NONNULL_END
