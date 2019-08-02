//
//  CoreGraphicsResizeImageObjc.h
//  ResizeImageApp2
//
//  Created by Uber on 20/07/2019.
//  Copyright © 2019 RXMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CoreGraphicsResizeImageObjc : NSObject

+ (nullable UIImage*) resizeImage:(UIImage*)image forSize:(CGSize)newSize;

@end

NS_ASSUME_NONNULL_END
