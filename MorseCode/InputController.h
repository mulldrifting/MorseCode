//
//  InputController.h
//  MorseCode
//
//  Created by Lauren Lee on 4/17/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import <GPUImage/GPUImage.h>
#import <Foundation/Foundation.h>

@protocol InputControllerDelegate <NSObject>

@optional

//-(void)addPreviewLayer:(AVCaptureVideoPreviewLayer*)previewLayer;
-(void)translateLetter:(NSString *)pip;

@end

@interface InputController : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, weak) id<InputControllerDelegate> delegate;

@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureDevice *device;
@property (strong, nonatomic) AVCaptureDeviceInput *input;
@property (strong, nonatomic) AVCaptureVideoDataOutput *output;

@property (strong, nonatomic) GPUImageVideoCamera *videoCamera;

@property (nonatomic) int  lastTotalBrightnessValue;
@property (nonatomic) int brightnessThreshold;
@property (nonatomic) BOOL isStarted;

@property (nonatomic) BOOL wasFlashEvent;
@property (nonatomic) BOOL wasDarkEvent;

@property (nonatomic) CGFloat curr;
@property (nonatomic) CGFloat prev;
@property (nonatomic) CGFloat diff;
@property (nonatomic) CGFloat prevDiff;

@property (strong, nonatomic) NSDate *startFlashTime;
@property (strong, nonatomic) NSDate *endFlashTime;
@property (strong, nonatomic) NSDate *startDarkTime;
@property (strong, nonatomic) NSDate *endDarkTime;
@property (nonatomic) double flashTimeInterval;
@property (nonatomic) double darkTimeInterval;

- (id)init;
- (void)startCamera;
- (void)setupSession;
-(BOOL)bothNegOrPos:(CGFloat)x y:(CGFloat)y;

@end
