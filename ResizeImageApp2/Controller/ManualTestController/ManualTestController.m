//
//  ManualTestingController.m
//  ResizeImageApp2
//
//  Created by Uber on 29/07/2019.
//  Copyright © 2019 RXMobile. All rights reserved.
//

#import "ManualTestController.h"
// Calculate optimal image size
#import "СalculateImageSize.h"

// Get Info about device
#import "GBDeviceInfo.h"

#import "TestingHelper.h"



@interface ManualTestController ()
@property (weak, nonatomic) IBOutlet UIImageView *aspectFitImageView;
@property (weak, nonatomic) IBOutlet UIImageView *aspectFillImageView;

@end

@implementation ManualTestController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Images Names
    // vacation
    // Fronalpstock1
    // gta
    // desert
    // tropics
    
    UIImageView* fitImgView = self.aspectFitImageView;
    UIImageView* fillImgView = self.aspectFillImageView;

    NSString* imageName    = @"vacation";
    UIImage*  originalImage = [UIImage imageNamed:imageName];
    NSData*   imageData = UIImageJPEGRepresentation(originalImage, 0.8);
    
    NSByteCountFormatter* counter = [NSByteCountFormatter new];
    [counter setAllowedUnits:NSByteCountFormatterUseMB];
    
    
    DLog(@"Now the test will be run on device: %@\n ",[GBDeviceInfo deviceInfo].modelString);
    
    DLog(@"Image.name (%@) in memory = %@",imageName ,[counter stringFromByteCount:imageData.length]);
    DLog(@"Image.size      in pixels = %@",NSStringFromCGSize(originalImage.size));
    DLog(@"ImageViews.size in pixels = %@ | in points = %@",NSStringFromCGSize([СalculateImageSize transformStructureWithScaleFactor:self.aspectFitImageView.frame.size]),
                                                            NSStringFromCGSize(self.aspectFitImageView.frame.size));
        
    
    // Manual (AspectFit) test
    CGSize aspectFitImageSizeInPixels   = [СalculateImageSize calculateSizeInPixels:originalImage.size
                                                                     imageViewSize:fitImgView.frame.size
                                                                       contentMode:fitImgView.contentMode];
    DLog(@"aspectFitImageSize in pixels = %@\n ",NSStringFromCGSize(aspectFitImageSizeInPixels));
    
   /*
    //UIKit
    DLog(@"UIKitObjc  AspectFit = %.4f",
    [TestingHelper resizeImageData:imageData forImgView:fitImgView byTechnology:ResizeTechnology_UIKitObjc neededSize:aspectFitImageSizeInPixels]);
    DLog(@"UIKitSwift AspectFit = %.4f\n ",
    [TestingHelper resizeImageData:imageData forImgView:fitImgView byTechnology:ResizeTechnology_UIKitSwift neededSize:aspectFitImageSizeInPixels]);
    */

     // CoreGraphics
     DLog(@"CoreGraphicsObjc AspectFit  = %.4f",
     [TestingHelper resizeImageData:imageData forImgView:fitImgView byTechnology:ResizeTechnology_CoreGraphicsObjc neededSize:aspectFitImageSizeInPixels]);
     DLog(@"CoreGraphicsSwift AspectFit = %.4f\n ",
     [TestingHelper resizeImageData:imageData forImgView:fitImgView byTechnology:ResizeTechnology_CoreGraphicsSwift neededSize:aspectFitImageSizeInPixels]);
   
    
    // ImageIO
    DLog(@"ImageIO_Objc  AspectFit = %.4f",
    [TestingHelper resizeImageData:imageData forImgView:fitImgView byTechnology:ResizeTechnology_ImageIO_Objc neededSize:aspectFitImageSizeInPixels]);
    DLog(@"ImageIO_Swift AspectFit = %.4f\n ",
    [TestingHelper resizeImageData:imageData forImgView:fitImgView byTechnology:ResizeTechnology_ImageIO_Swift neededSize:aspectFitImageSizeInPixels]);
   
    
    /*
    // ImageIO(Subsampling) (iOS 9+)
     DLog(@"ImageIO_Subsampling_Objc  AspectFit = %.4f",
    [TestingHelper resizeImageData:imageData forImgView:fitImgView byTechnology:ResizeTechnology_ImageIO_Subsampling_Objc  neededSize:aspectFitImageSizeInPixels]);
    
    DLog(@"ImageIO_Subsampling_Swift AspectFit = %.4f\n ",
    [TestingHelper resizeImageData:imageData forImgView:fitImgView byTechnology:ResizeTechnology_ImageIO_Subsampling_Swift  neededSize:aspectFitImageSizeInPixels]);
    
    
    // CoreImage
    DLog(@"CoreImageObjc  AspectFit = %.4f",
    [TestingHelper resizeImageData:imageData forImgView:fitImgView byTechnology:ResizeTechnology_CoreImageObjc neededSize:aspectFitImageSizeInPixels]);
    DLog(@"CoreImageSwift AspectFit = %.4f\n ",
    [TestingHelper resizeImageData:imageData forImgView:fitImgView byTechnology:ResizeTechnology_CoreImageSwift neededSize:aspectFitImageSizeInPixels]);
   */
    /*
    // vImage
    DLog(@"vImageObjc  AspectFit = %.4f",
    [TestingHelper resizeImageData:imageData forImgView:fitImgView byTechnology:ResizeTechnology_vImageObjc neededSize:aspectFitImageSizeInPixels]);
    DLog(@"vImageSwift AspectFit = %.4f\n ",
    [TestingHelper resizeImageData:imageData forImgView:fitImgView byTechnology:ResizeTechnology_vImageSwift neededSize:aspectFitImageSizeInPixels]);
   */
  
    
    
    
    
    /*
     // Manual (AspectFill) test
     CGSize aspectFillImageSizeInPixels = [СalculateImageSize calculateSizeInPixels:originalImage.size
                                                                     imageViewSize:self.aspectFillImageView.frame.size
                                                                       contentMode:self.aspectFillImageView.contentMode];
     DLog(@"aspectFillImageSize in pixels = %@",NSStringFromCGSize(aspectFitImageSizeInPixels));

     // UIKit
     DLog(@"UIKitObjc  AspectFill = %.4f",
     [TestingHelper resizeImageData:imageData forImgView:fillImgView byTechnology:ResizeTechnology_UIKitObjc neededSize:aspectFillImageSizeInPixels]);
     DLog(@"UIKitSwift AspectFill = %.4f\n ",
     [TestingHelper resizeImageData:imageData forImgView:fillImgView byTechnology:ResizeTechnology_UIKitSwift neededSize:aspectFillImageSizeInPixels]);

     // CoreGraphics
     DLog(@"CoreGraphicsObjc  AspectFill = %.4f",
     [TestingHelper resizeImageData:imageData forImgView:fillImgView byTechnology:ResizeTechnology_CoreGraphicsObjc neededSize:aspectFillImageSizeInPixels]);
     DLog(@"CoreGraphicsSwift AspectFill = %.4f\n ",
     [TestingHelper resizeImageData:imageData forImgView:fillImgView byTechnology:ResizeTechnology_CoreGraphicsSwift neededSize:aspectFillImageSizeInPixels]);
     
     // ImageIO
     DLog(@"ImageIO_Objc  AspectFill  = %.4f",
     [TestingHelper resizeImageData:imageData forImgView:fillImgView byTechnology:ResizeTechnology_ImageIO_Objc neededSize:aspectFillImageSizeInPixels]);
     DLog(@"ImageIO_Swift AspectFill  = %.4f\n ",
     [TestingHelper resizeImageData:imageData forImgView:fillImgView byTechnology:ResizeTechnology_ImageIO_Swift neededSize:aspectFillImageSizeInPixels]);
   
     
     // ImageIO(Subsampling) (iOS 9+)
     DLog(@"ImageIO_Subsampling_Objc AspectFill = %.4f",
     [TestingHelper resizeImageData:imageData forImgView:fillImgView byTechnology:ResizeTechnology_ImageIO_Subsampling_Objc neededSize:aspectFillImageSizeInPixels]);
     DLog(@"ImageIO_Subsampling_Swift AspectFill = %.4f\n ",
     [TestingHelper resizeImageData:imageData forImgView:fillImgView byTechnology:ResizeTechnology_ImageIO_Subsampling_Swift neededSize:aspectFillImageSizeInPixels]);
    
     
     // CoreImage
     DLog(@"CoreImageObjc AspectFill = %.4f",
     [TestingHelper resizeImageData:imageData forImgView:fillImgView byTechnology:ResizeTechnology_CoreImageObjc neededSize:aspectFillImageSizeInPixels]);
     DLog(@"CoreImageSwift AspectFill = %.4f\n ",
     [TestingHelper resizeImageData:imageData forImgView:fillImgView byTechnology:ResizeTechnology_CoreImageSwift neededSize:aspectFillImageSizeInPixels]);
   
     // vImage
     DLog(@"vImageObjcTime AspectFill = %.4f",
     [TestingHelper resizeImageData:imageData forImgView:fillImgView byTechnology:ResizeTechnology_vImageObjc neededSize:aspectFillImageSizeInPixels]);
     DLog(@"vImageSwiftTime AspectFill = %.4f\n ",
     [TestingHelper resizeImageData:imageData forImgView:fillImgView byTechnology:ResizeTechnology_vImageSwift neededSize:aspectFillImageSizeInPixels]);
     */
}



@end
