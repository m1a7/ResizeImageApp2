//
//  vImageResizeImageObjc.h
//  ResizeImageApp2
//
//  Created by Uber on 23/07/2019.
//  Copyright © 2019 RXMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface vImageResizeImageObjc : NSObject

+ (nullable UIImage*) resizeImageFromData:(NSData*)data forSize:(CGSize)newSize;


@end

NS_ASSUME_NONNULL_END
