//
//  TestingHelper.h
//  ResizeImageApp2
//
//  Created by Uber on 29/07/2019.
//  Copyright © 2019 RXMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ResizeTechnology) {
    
    ResizeTechnology_UIKitObjc = 0,     // UIKit Objective-C
    ResizeTechnology_UIKitSwift,        // UIKit Swift
    
    ResizeTechnology_CoreGraphicsObjc,  // CoreGraphics Objective-C
    ResizeTechnology_CoreGraphicsSwift, // CoreGraphics Swift
    
    ResizeTechnology_ImageIO_Objc,      //  ImageIO Objective-C
    ResizeTechnology_ImageIO_Swift,     //  ImageIO Swift
    
    ResizeTechnology_ImageIO_Subsampling_Objc,  //  ImageIO Objective-C
    ResizeTechnology_ImageIO_Subsampling_Swift, //  ImageIO Swift
    
    ResizeTechnology_CoreImageObjc,     //  CoreImage Objective-C
    ResizeTechnology_CoreImageSwift,    //  CoreImage Swift
    
    ResizeTechnology_vImageObjc,        //  vImage Objective-C
    ResizeTechnology_vImageSwift,       //  vImage Swift
    
    ResizeTechnology_Count
};

#if __has_feature(objc_arc)
#define DLog(format, ...) CFShow((__bridge CFStringRef)[NSString stringWithFormat:format, ## __VA_ARGS__]);
#else
#define DLog(format, ...) CFShow([NSString stringWithFormat:format, ## __VA_ARGS__]);
#endif

@interface TestingHelper : NSObject

/*--------------------------------------------------------------------------------------------------------------
 Gets the desired block with the technology of changing the image and passes it to the method for execution
 --------------------------------------------------------------------------------------------------------------*/

+ (double) resizeImageData:(NSData*)imageData
                forImgView:(UIImageView*)imageView
              byTechnology:(ResizeTechnology)technology
                neededSize:(CGSize)neededSize;

/*--------------------------------------------------------------------------------------------------------------
 Returns the block with the desired technology that changes the size of the image
 --------------------------------------------------------------------------------------------------------------*/

+ (dispatch_block_t) getResizeBlock_imageData:(NSData*)imageData
                                   forImgView:(UIImageView*)imageView
                                 byTechnology:(ResizeTechnology)technology
                                   neededSize:(CGSize)neededSize;
/*--------------------------------------------------------------------------------------------------------------
 Executes the block and displays the execution time in the console
 --------------------------------------------------------------------------------------------------------------*/

+ (double) performTechnologyName:(NSString*)technologyName block:(dispatch_block_t)block;


/*--------------------------------------------------------------------------------------------------------------
  Convert enum value to string
 --------------------------------------------------------------------------------------------------------------*/
+ (NSString*) convertEnumResizeTechnologyToString:(ResizeTechnology)enumValue;

@end

NS_ASSUME_NONNULL_END
