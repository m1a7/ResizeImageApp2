//
//  UIKitResizeImageObjc.m
//  ResizeImageApp2
//
//  Created by Uber on 20/07/2019.
//  Copyright © 2019 RXMobile. All rights reserved.
//

#import "UIKitResizeImageObjc.h"

@implementation UIKitResizeImageObjc

+ (nullable UIImage*) resizeImage:(UIImage*)image forSize:(CGSize)newSize
{
    UIImage* scaledImg = nil;
    CGRect rectForNewSize = CGRectMake(0.0, 0.0, newSize.width, newSize.height);

    if (@available(iOS 10, *)) {
        UIGraphicsImageRenderer * renderer = [[UIGraphicsImageRenderer alloc] initWithSize:newSize];
        scaledImg =
        [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
            [image drawInRect:rectForNewSize];
        }];
    } else {
        UIGraphicsBeginImageContextWithOptions(newSize, NO, [UIScreen mainScreen].scale);
        [image drawInRect:rectForNewSize];
        scaledImg  = UIGraphicsGetImageFromCurrentImageContext();   
        UIGraphicsEndImageContext();
    }
    return scaledImg;
}

@end
