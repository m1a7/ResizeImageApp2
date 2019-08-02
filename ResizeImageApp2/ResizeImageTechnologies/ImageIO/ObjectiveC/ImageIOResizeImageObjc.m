//
//  ImageIOResizeImageObjc.m
//  ResizeImageApp2
//
//  Created by Uber on 20/07/2019.
//  Copyright © 2019 RXMobile. All rights reserved.
//

#import "ImageIOResizeImageObjc.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

@implementation ImageIOResizeImageObjc

+ (nullable UIImage*) resizeImageFromData:(NSData*)data forSize:(CGSize)newSize
{
    CGImageSourceRef src = CGImageSourceCreateWithData((CFDataRef)data, NULL);
    CFDictionaryRef options =
    (__bridge CFDictionaryRef)@{ (id)kCGImageSourceCreateThumbnailWithTransform   : (id)kCFBooleanTrue,
                                 (id)kCGImageSourceThumbnailMaxPixelSize          : (id)[NSNumber numberWithDouble:MAX(newSize.width, newSize.height)],
                                 (id)kCGImageSourceCreateThumbnailFromImageAlways : (id)kCFBooleanTrue
                                 };
    
    CGImageRef thumbnail = CGImageSourceCreateThumbnailAtIndex(src, 0, options);
    
    UIImage* scaledImage = [[UIImage alloc] initWithCGImage:thumbnail];

    CFRelease(src);
    CGImageRelease(thumbnail);
    return scaledImage;
}


+ (nullable UIImage*) resizeImageFromDataWithSubsampling:(NSData*)data imgExtension:(NSString*)extension forSize:(CGSize)newSize NS_AVAILABLE_IOS(9_0)
{
    CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)data, NULL);
    NSMutableDictionary* options =
    (__bridge NSMutableDictionary *)((__bridge CFMutableDictionaryRef)
    [@{(id)kCGImageSourceCreateThumbnailWithTransform   : (id)kCFBooleanTrue,
       (id)kCGImageSourceThumbnailMaxPixelSize          : (id)[NSNumber numberWithDouble:MAX(newSize.width, newSize.height)],
       (id)kCGImageSourceCreateThumbnailFromImageAlways : (id)kCFBooleanTrue
       } mutableCopy]);
    
    NSDictionary* properties = (NSDictionary*)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(source, 0, nil));

    NSNumber *imageWidthNumber  = properties[(NSString *)CFBridgingRelease(kCGImagePropertyPixelWidth)];
    NSNumber *imageHeightNumber = properties[(NSString *)CFBridgingRelease(kCGImagePropertyPixelHeight)];

    CGFloat   imageWidth  = (CGFloat)[imageWidthNumber  floatValue];
    CGFloat   imageHeight = (CGFloat)[imageHeightNumber floatValue];


    NSString* UTI = (__bridge NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                                       (__bridge CFStringRef)extension,
                                                                       kUTTypeImage);
    [options setValue:UTI forKey:(__bridge NSString*)kCGImageSourceTypeIdentifierHint];
    
    if ([UTI isEqualToString:(__bridge NSString*)kUTTypeJPEG] ||
        [UTI isEqualToString:(__bridge NSString*)kUTTypeTIFF] ||
        [UTI isEqualToString:(__bridge NSString*)kUTTypePNG]  ||
        [UTI hasPrefix:@"public.heif"])
    {
        CGFloat minValue = MIN(imageWidth/newSize.width, imageHeight/newSize.height);
        if (minValue < 2.0f){
            [options setValue:[NSNumber numberWithFloat:2.0] forKey:(__bridge NSString*)kCGImageSourceSubsampleFactor];
        }
        if ((minValue >= 2.0f) && (minValue <= 4.0)){
            [options setValue:[NSNumber numberWithFloat:4.0] forKey:(__bridge NSString*)kCGImageSourceSubsampleFactor];
        }
        if (minValue > 4.0) {
            [options setValue:[NSNumber numberWithFloat:8.0] forKey:(__bridge NSString*)kCGImageSourceSubsampleFactor];
        }
    }
    
    CGImageRef imageRef  = CGImageSourceCreateThumbnailAtIndex(source, 0, (__bridge CFDictionaryRef)options);
    UIImage* scaledImage = [UIImage imageWithCGImage:imageRef];
    
    CFRelease(source);
    CGImageRelease(imageRef);
    return scaledImage;
}


@end
