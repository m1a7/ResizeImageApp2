//
//  TestingHelper.m
//  ResizeImageApp2
//
//  Created by Uber on 29/07/2019.
//  Copyright © 2019 RXMobile. All rights reserved.
//

#import "TestingHelper.h"

// Support All Swift Files
#import "ResizeImageApp2-Swift.h"

#import "UIKitResizeImageObjc.h"         // UIKit
#import "CoreGraphicsResizeImageObjc.h"  // CoreGraphics
#import "ImageIOResizeImageObjc.h"       // ImageIO
#import "CoreImageResizeImageObjc.h"     // CoreImage
#import "vImageResizeImageObjc.h"        // vImage

#import "CalculateImageSize.h"

@implementation TestingHelper

/*--------------------------------------------------------------------------------------------------------------
 Gets the desired block with the technology of changing the image and passes it to the method for execution
 --------------------------------------------------------------------------------------------------------------*/

+ (double) resizeImageData:(NSData*)imageData
                forImgView:(UIImageView*)imageView
              byTechnology:(ResizeTechnology)technology
                neededSize:(CGSize)neededSize
{
    dispatch_block_t block = [TestingHelper getResizeBlock_imageData:imageData forImgView:imageView byTechnology:technology neededSize:neededSize];
    if (!block) return -1;
    
    if (technology == ResizeTechnology_UIKitObjc )        { return [TestingHelper performTechnologyName:@"UIKit Objective-C" block:block]; }
    if (technology == ResizeTechnology_UIKitSwift)        { return [TestingHelper performTechnologyName:@"UIKit Swift      " block:block]; }
    
    if (technology == ResizeTechnology_CoreGraphicsObjc)  { return [TestingHelper performTechnologyName:@"CoreGraphics Objective-C" block:block]; }
    if (technology == ResizeTechnology_CoreGraphicsSwift) { return [TestingHelper performTechnologyName:@"CoreGraphics Swift (iOS 9+)" block:block]; }
    
    if (technology == ResizeTechnology_ImageIO_Objc)      { return [TestingHelper performTechnologyName:@"ImageIO Objective-C" block:block]; }
    if (technology == ResizeTechnology_ImageIO_Swift)     { return [TestingHelper performTechnologyName:@"ImageIO Swift      " block:block]; }
    
    if (technology == ResizeTechnology_ImageIO_Subsampling_Objc)  { return [TestingHelper performTechnologyName:@"ImageIO(Subsampling) Objective-C  (iOS 9+)" block:block]; }
    if (technology == ResizeTechnology_ImageIO_Subsampling_Swift) { return  [TestingHelper performTechnologyName:@"ImageIO(Subsampling) Swift        (iOS 9+)" block:block]; }
    
    if (technology == ResizeTechnology_CoreImageObjc)     { return [TestingHelper performTechnologyName:@"CoreImage Objective-C" block:block]; }
    if (technology == ResizeTechnology_CoreImageSwift)    { return [TestingHelper performTechnologyName:@"CoreImage Swift      " block:block]; }
    
    if (technology == ResizeTechnology_vImageObjc)        { return [TestingHelper performTechnologyName:@"vImage Objective-C" block:block]; }
    if (technology == ResizeTechnology_vImageSwift)       { return [TestingHelper performTechnologyName:@"vImage Swift      " block:block]; }
    
    return -1;
}

/*--------------------------------------------------------------------------------------------------------------
 Returns the block with the desired technology that changes the size of the image
 --------------------------------------------------------------------------------------------------------------*/

+ (dispatch_block_t) getResizeBlock_imageData:(NSData*)imageData
                                   forImgView:(UIImageView*)imageView
                                 byTechnology:(ResizeTechnology)technology
                                   neededSize:(CGSize)neededSize
{
    // UIKit
    if (technology == ResizeTechnology_UIKitObjc){
        return
        ^{  imageView.image = [UIKitResizeImageObjc imageFromData:imageData inSizeInPixels:neededSize]; };
    }
    
    if (technology == ResizeTechnology_UIKitSwift){
        return
        ^{ imageView.image =  [UIKitResizeImageSwift imageFromData:imageData inSizeInPixels:neededSize]; };
    }
    //===============================================================================================================//
    
    // CoreGraphics
    if (technology == ResizeTechnology_CoreGraphicsObjc){
        return
        ^{ imageView.image = [CoreGraphicsResizeImageObjc imageFromData:imageData inSizeInPixels:neededSize]; };
    }
    if (technology == ResizeTechnology_CoreGraphicsSwift){
        if (@available(iOS 9, *)) {
            return
            ^{  imageView.image = [CoreGraphicsResizeImageSwift imageFromData:imageData inSizeInPixels:neededSize]; };
        }
    }
    //===============================================================================================================//
    
    // ImageIO
    if (technology == ResizeTechnology_ImageIO_Objc){
        return
        ^{  imageView.image = [ImageIOResizeImageObjc imageFromData:imageData inSizeInPixels:neededSize]; };
    }
    if (technology == ResizeTechnology_ImageIO_Swift){
        return
        ^{ imageView.image = [ImageIOResizeImageSwift imageFromData:imageData inSizeInPixels:neededSize]; };
    }
    //===============================================================================================================//
    
    // ImageIO(Subsampling)
    if (technology == ResizeTechnology_ImageIO_Subsampling_Objc){
        if (@available(iOS 9, *)) {
            return
            ^{  imageView.image = [ImageIOResizeImageObjc imageWithSubsamplingFromData:imageData imgExtension:@"jpg" inSizeInPixels:[CalculateImageSize convertCGSizeToPixels:neededSize]]; };
        }
    }
    if (technology == ResizeTechnology_ImageIO_Subsampling_Swift){
        if (@available(iOS 9, *)) {
            return
            ^{ imageView.image =  [ImageIOResizeImageSwift resizeImageFromDataWithSubsampling:imageData imgExtension:@"jpg" forSize:neededSize]; };
        }
    }
    
    //===============================================================================================================//
    
    // CoreImage
    if (technology == ResizeTechnology_CoreImageObjc){
        return
        ^{  imageView.image = [CoreImageResizeImageObjc imageFromData:imageData inSizeInPixels:neededSize]; };
    }
    if (technology == ResizeTechnology_CoreImageSwift){
        return
        ^{ imageView.image =  [CoreImageResizeImageSwift imageFromData:imageData inSizeInPixels:neededSize]; };
    }
    //===============================================================================================================//
    
    
    // vImage
    if (technology == ResizeTechnology_vImageObjc){
        return
        ^{ imageView.image = [vImageResizeImageObjc imageFromData:imageData inSizeInPixels:neededSize]; };
    }
    if (technology == ResizeTechnology_vImageSwift){
        return
        ^{ imageView.image = [vImageResizeImageSwift imageFromData:imageData inSizeInPixels:neededSize]; };
    }
    //===============================================================================================================//
   
    return nil;
}

/*--------------------------------------------------------------------------------------------------------------
 Executes the block and displays the execution time in the console
 --------------------------------------------------------------------------------------------------------------*/

+ (double) performTechnologyName:(NSString*)technologyName block:(dispatch_block_t)block
{
    CFTimeInterval startTime = CFAbsoluteTimeGetCurrent();
    block();
    CFTimeInterval endTime = CFAbsoluteTimeGetCurrent();
    //DLog(@"%@:\t %.3g",technologyName, (endTime - startTime));
    
    double time = (double)(endTime - startTime);
    return time;
}



/*--------------------------------------------------------------------------------------------------------------
 Convert enum value to string
 --------------------------------------------------------------------------------------------------------------*/

+ (NSString*) convertEnumResizeTechnologyToString:(ResizeTechnology)enumValue
{
    NSString* convert = @"Switch not found mathes!";
    switch (enumValue) {
        case ResizeTechnology_UIKitObjc:          convert = @"UIKitObjc               ";  break;
        case ResizeTechnology_UIKitSwift:         convert = @"UIKitSwift              ";  break;
            
        case ResizeTechnology_CoreGraphicsObjc:   convert = @"CoreGraphicsObjc        "; break;
        case ResizeTechnology_CoreGraphicsSwift:  convert = @"CoreGraphicsSwift       "; break;
            
        case ResizeTechnology_ImageIO_Objc:       convert = @"ImageIO_Objc            "; break;
        case ResizeTechnology_ImageIO_Swift:      convert = @"ImageIO_Swift           "; break;
            
        case ResizeTechnology_ImageIO_Subsampling_Objc:   convert = @"ImageIO_Subsampling_Objc";     break;
        case ResizeTechnology_ImageIO_Subsampling_Swift:  convert = @"ImageIO_Subsampling_Swift";    break;
            
        case ResizeTechnology_CoreImageObjc:      convert = @"CoreImageObjc           "; break;
        case ResizeTechnology_CoreImageSwift:     convert = @"CoreImageSwift          "; break;
            
        case ResizeTechnology_vImageObjc:         convert = @"vImageObjc              "; break;
        case ResizeTechnology_vImageSwift:        convert = @"vImageSwift             "; break;
            
        default: DLog(@"+convertEnumResizeTechnologyToString| Switch not found mathes!"); break;
            
    }
    return convert;
}

@end
