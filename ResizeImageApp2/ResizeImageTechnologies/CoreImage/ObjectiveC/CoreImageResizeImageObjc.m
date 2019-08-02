//
//  CoreImageResizeImageObjc.m
//  ResizeImageApp2
//
//  Created by Uber on 23/07/2019.
//  Copyright © 2019 RXMobile. All rights reserved.
//

#import "CoreImageResizeImageObjc.h"
#import <CoreImage/CoreImage.h>


@implementation CoreImageResizeImageObjc


+ (nullable UIImage*) resizeImageFromData:(NSData*)data forSize:(CGSize)newSize
{
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((CFDataRef)data, NULL);
    NSDictionary*    properties  = (NSDictionary*)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil));
    
    NSNumber *imageWidthNumber  = properties[(NSString *)CFBridgingRelease(kCGImagePropertyPixelWidth)];
    NSNumber *imageHeightNumber = properties[(NSString *)CFBridgingRelease(kCGImagePropertyPixelHeight)];

    CGFloat imageWidth  = (CGFloat)[imageWidthNumber floatValue];
    CGFloat imageHeight = (CGFloat)[imageHeightNumber floatValue];
    
    CGFloat scale = MAX(newSize.width, newSize.height)/MAX(imageWidth, imageHeight);
    if (scale <= 0){ return nil; }
    
    CGFloat aspectRatio = imageWidth/imageHeight;
    if (aspectRatio <= 0){ return nil; }
        
    UIImage* scaledImage = [CoreImageResizeImageObjc resizeImageFromData:data scale:scale aspectRatio:aspectRatio];
    CFRelease(imageSource);
    return scaledImage;
}

+ (nullable UIImage*) resizeImageFromData:(NSData*)data scale:(CGFloat)scale aspectRatio:(CGFloat)aspectRatio
{
    CIImage* image = [CIImage imageWithData:data];
    if (!image) { return nil;}
    
    CIFilter* filter = [CIFilter filterWithName:@"CILanczosScaleTransform"];
    [filter setValue:image forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:scale]       forKey:kCIInputScaleKey];
    [filter setValue:[NSNumber numberWithFloat:aspectRatio] forKey:kCIInputAspectRatioKey];

    CIContext* context = [CoreImageResizeImageObjc contextWithUsingSoftwareRender];
    CIImage*   outputCIImage = [filter outputImage];
    CGImageRef outputCGImage = [context createCGImage:outputCIImage fromRect:outputCIImage.extent];
    
    if (!outputCIImage || !outputCGImage){ return nil; }
    
    UIImage* scaledImage = [UIImage imageWithCGImage:outputCGImage];
    CGImageRelease(outputCGImage);  
    return scaledImage;
}


#pragma mark - CIContext

+ (CIContext*) contextWithOutOptions {
    return [CIContext contextWithOptions:nil];
}

+ (CIContext*) contextWithUsingSoftwareRender
{
    NSDictionary* options = @{ kCIContextUseSoftwareRenderer : [NSNumber numberWithBool:NO]};
    return [CoreImageResizeImageObjc contextWithOptions:options];
}


+ (CIContext*) contextWithOptions:(nullable NSDictionary<CIContextOption, id> *)options
{
    return [CIContext contextWithOptions:options];
}
@end
