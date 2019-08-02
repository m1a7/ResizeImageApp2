//
//  CoreImageResizeImageObjc.h
//  ResizeImageApp2
//
//  Created by Uber on 23/07/2019.
//  Copyright © 2019 RXMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@class CIContext;
typedef NSString * CIContextOption NS_TYPED_ENUM;

@interface CoreImageResizeImageObjc : NSObject

+ (nullable UIImage*) resizeImageFromData:(NSData*)data forSize:(CGSize)newSize;
+ (nullable UIImage*) resizeImageFromData:(NSData*)data scale:(CGFloat)scale aspectRatio:(CGFloat)aspectRatio;

#pragma mark - CIContext

+ (CIContext*) contextWithOutOptions;
+ (CIContext*) contextWithUsingSoftwareRender;
+ (CIContext*) contextWithOptions:(nullable NSDictionary<CIContextOption, id> *)options;

@end

NS_ASSUME_NONNULL_END
