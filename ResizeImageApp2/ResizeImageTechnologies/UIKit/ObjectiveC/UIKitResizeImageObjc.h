//
//  UIKitResizeImageObjc.h
//  ResizeImageApp2
//
//  Created by Uber on 20/07/2019.
//  Copyright © 2019 RXMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


/*--------------------------------------------------------------------------------------------------------------
 🗜🌁 'UIKitResizeImageObjc' - the class render images from 'NSData' using the 'UIKit' technology.
 ---------------
 The main task is to draw an image with the resolution specified in 'CGSize' from binary code
 ---------------
 Duties:
 - Draw an image using 'UIKit'.
 ---------------
 The class provides the following features:
 - You can draw a picture in original size
 - You can pass the desired size (in points) and the method automatically converts them, and returns the image to pixels
 - You can immediately pass the desired size in (in pixels)
 - You can transfer the size of the UIImageView and the picture will automatically be reduced to the optimal size (considering contenMode)
 --------------------------------------------------------------------------------------------------------------*/

@interface UIKitResizeImageObjc : NSObject

+ (nullable UIImage*) imageFromData:(NSData*)data;                                // render a image in full size
+ (nullable UIImage*) imageFromData:(NSData*)data inSizeInPoints:(CGSize)points;  // render a image in borders. Inside converts point to pixels
+ (nullable UIImage*) imageFromData:(NSData*)data inSizeInPixels:(CGSize)pixels;  // render a image in borders.


/*--------------------------------------------------------------------------------------------------------------
 Render a image for the size of 'UIImageView', with regard to preserving the aspect ratio ('contetMode')
 --------------------------------------------------------------------------------------------------------------*/
+ (nullable UIImage*) imageFromData:(NSData*)data resizedForImageViewBounds:(CGSize)sizeInPoints forContentMode:(UIViewContentMode)contentMode;


/*--------------------------------------------------------------------------------------------------------------
  Resize image
 --------------------------------------------------------------------------------------------------------------*/
+ (nullable UIImage*) resizeImage:(UIImage*)image toSizeInPixels:(CGSize)pixels;

@end

NS_ASSUME_NONNULL_END
