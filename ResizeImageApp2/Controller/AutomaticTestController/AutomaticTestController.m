//
//  ViewController.m
//  ResizeImageApp2
//
//  Created by Uber on 20/07/2019.
//  Copyright © 2019 RXMobile. All rights reserved.
//

#import "AutomaticTestController.h"

// Calculate optimal image size
#import "CalculateImageSize.h"

// Get Info about device
#import "GBDeviceInfo.h"

#import "TestingHelper.h"


@interface AutomaticTestController ()

@property (weak, nonatomic) IBOutlet UIImageView *aspectFitImageView;
@property (weak, nonatomic) IBOutlet UIImageView *aspectFillImageView;

@end

@implementation AutomaticTestController

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // If you want to test specific technologies, comment out the elements of the array that you do not need.
    NSArray<NSNumber*>* technologies = @[// UIKit
                                         [NSNumber numberWithInteger:ResizeTechnology_UIKitObjc],
                                         [NSNumber numberWithInteger:ResizeTechnology_UIKitSwift],

                                         // CoreGraphics
                                         [NSNumber numberWithInteger:ResizeTechnology_CoreGraphicsObjc],
                                         [NSNumber numberWithInteger:ResizeTechnology_CoreGraphicsSwift],

                                         // ImageIO
                                         [NSNumber numberWithInteger:ResizeTechnology_ImageIO_Objc],
                                         [NSNumber numberWithInteger:ResizeTechnology_ImageIO_Swift],

                                         // ImageIO Subsampling
                                         [NSNumber numberWithInteger:ResizeTechnology_ImageIO_Subsampling_Objc],
                                         [NSNumber numberWithInteger:ResizeTechnology_ImageIO_Subsampling_Swift],

                                         // CoreImage
                                         [NSNumber numberWithInteger:ResizeTechnology_CoreImageObjc],
                                         [NSNumber numberWithInteger:ResizeTechnology_CoreImageSwift],

                                         // vImage
                                         [NSNumber numberWithInteger:ResizeTechnology_vImageObjc],
                                         [NSNumber numberWithInteger:ResizeTechnology_vImageSwift]
                                         ];
    
    
    // This is a set of standard pictures attached to Assets.xcassets
    // You may want to edit this array to transmit one or more one picture
    NSArray* imagesForTest = @[@"vacation",@"Bridge0.4MB",@"Bridge2MB",@"Desert3.97MB",@"desert",@"Fronalpstock1",@"gta",@"tropics"];

    
    [self performBenchmarkOnTechnologies:technologies imagesName:imagesForTest forImageView:self.aspectFitImageView];
    [self performBenchmarkOnTechnologies:technologies imagesName:imagesForTest forImageView:self.aspectFillImageView];
}


/*--------------------------------------------------------------------------------------------------------------
    Method which perform benchmark resize on another technologies for another images
 --------------------------------------------------------------------------------------------------------------*/

- (void) performBenchmarkOnTechnologies:(NSArray<NSNumber*>*)technologies imagesName:(NSArray*)images forImageView:(UIImageView*)imageView
{
    NSByteCountFormatter* counter = [NSByteCountFormatter new];
    [counter setAllowedUnits:NSByteCountFormatterUseMB];
    DLog(@"\nNow the test will be run on device: %@\n ",[GBDeviceInfo deviceInfo].modelString);
    
    
    NSMutableDictionary<NSString*,NSNumber*>* averageResults = [NSMutableDictionary new];
    
    for (NSString* imageName in images)
    {
        @autoreleasepool {

        UIImage* originalImage = [UIImage imageNamed:imageName];
        // You can convert binary data to PNG, but will be better if you will convert to JPG
        // Because JPG has less weight after converting
        //NSData* imageJpgData = UIImagePNGRepresentation(originalImage);
        NSData* imageJpgData = UIImageJPEGRepresentation(originalImage, 0.8);
        
        CGSize aspectFitImageSizeInPixels   = [CalculateImageSize calculateSizeInPixels:originalImage.size
                                                                  imageViewSizeInPoints:imageView.frame.size
                                                                            contentMode:imageView.contentMode];
        
        
        DLog(@"Name(%@) | Size: %@ | SourceImage: %@ | Will converted to: %@",imageName, [counter stringFromByteCount:imageJpgData.length],
                                                                              NSStringFromCGSize(originalImage.size), NSStringFromCGSize(aspectFitImageSizeInPixels));
        
        for (NSNumber* technology in technologies)
        {
              @autoreleasepool {
                ResizeTechnology technologyEnumValue = [technology integerValue];
                NSString*      technologyStringValue = [TestingHelper convertEnumResizeTechnologyToString:technologyEnumValue];
                
                NSMutableArray<NSNumber*>* technologyTimeArray = [NSMutableArray new];
                int attemptsNumber = 5;
                for (int i=0; i<=attemptsNumber; i++)
                {
                    double time = [TestingHelper resizeImageData:imageJpgData forImgView:imageView byTechnology:technologyEnumValue neededSize:aspectFitImageSizeInPixels];
                    NSNumber* timeNumber = [NSNumber numberWithDouble:time];
                    [technologyTimeArray addObject:timeNumber];
                    
                    if (i==attemptsNumber)
                    {
                        NSNumber *average = [technologyTimeArray valueForKeyPath:@"@avg.self"];
                        [averageResults setValue:average forKey:technologyStringValue];
                        double rounded = [average doubleValue];
                        DLog(@"%@\t| AverageTime For : %.4f",technologyStringValue,rounded);
                    }
                }
              }
        }
        // Print Best result
        NSString* keyToBestResult;
        double bestResultNumber = 0;
        
        for (NSString* technologyName in averageResults.allKeys)
        {
            double result = [averageResults[technologyName] doubleValue];
            
            if ((result > 0) && ((result < bestResultNumber) || (bestResultNumber == 0))){
                bestResultNumber = result;
                keyToBestResult  = technologyName;
            }
        }
        DLog(@"----------------------------------------------------------------------");
        DLog(@"| The Best Technology: %@ | Time: %.4f",keyToBestResult,bestResultNumber);
        DLog(@"----------------------------------------------------------------------");
        
        DLog(@"=====================================================================\n");
        }
    }
}





@end

