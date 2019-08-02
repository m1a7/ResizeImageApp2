//
//  ImageIOResizeImageObjc.h
//  ResizeImageApp2
//
//  Created by Uber on 20/07/2019.
//  Copyright © 2019 RXMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageIOResizeImageObjc : NSObject

+ (nullable UIImage*) resizeImageFromData:(NSData*)data forSize:(CGSize)newSize;
+ (nullable UIImage*) resizeImageFromDataWithSubsampling:(NSData*)data imgExtension:(NSString*)extension forSize:(CGSize)newSize NS_AVAILABLE_IOS(9_0);

@end

NS_ASSUME_NONNULL_END
