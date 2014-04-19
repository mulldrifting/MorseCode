//
//  InputController.m
//  MorseCode
//
//  Created by Lauren Lee on 4/17/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "InputController.h"

#define NUMBER_OF_FRAME_PER_S 30
#define BRIGHTNESS_THRESHOLD 70
#define MIN_BRIGHTNESS_THRESHOLD 10
#define BRIGHTNESS_DIFFERENCE 10

#define FLASH_EVENT YES
#define DARK_EVENT NO

@implementation InputController

#pragma mark - init

- (id)init
{
    if (self = [super init])
    {
        _isStarted = NO;
        _brightnessThreshold = BRIGHTNESS_THRESHOLD;
    }
    return self;
}

-(void)startCamera
{
    _videoCamera = [GPUImageVideoCamera new];
    _videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    _prev = 0;
    _prevDiff = 0;
    _wasDarkEvent = YES;
    _wasFlashEvent = NO;
    
    GPUImageLuminosity *luminosity = [GPUImageLuminosity new];
    [_videoCamera addTarget:luminosity];
    
    [(GPUImageLuminosity *)luminosity setLuminosityProcessingFinishedBlock:^(CGFloat lumin, CMTime frameTime) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            _luminLabel.text = [NSString stringWithFormat:@"%f", lumin];
//        });
        
//        NSLog(@"Lumin is %f ", lumin*100);
        
        _curr = lumin*100;
        _diff = _prev - _curr;
        
//        NSLog(@"%f, diff: %f",_curr, fabsf(_diff));
        
//        if (![self bothNegOrPos:_diff y:_prevDiff])
        
        if (_wasDarkEvent) {
            if (_diff < 0 && fabsf(_diff) > BRIGHTNESS_DIFFERENCE)
            {
                // Brighter
                _endDarkTime = [NSDate date];
                _darkTimeInterval = [_endDarkTime timeIntervalSinceDate:_startDarkTime];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self derivePip:DARK_EVENT withDelay:_darkTimeInterval];
                });
                
                NSLog(@"Dark Time: %f", _darkTimeInterval);
//                NSLog(@"Prev Diff: %f Difference: %f", _prevDiff, _diff);
                _startFlashTime = [NSDate date];
                _wasFlashEvent = YES;
                _wasDarkEvent = NO;
            }
        }
        
        else if (_wasFlashEvent)
        {
            if (_diff > 0 && fabsf(_diff) > BRIGHTNESS_DIFFERENCE)
            {
                // Darker
                _endFlashTime = [NSDate date];
                _flashTimeInterval = [_endFlashTime timeIntervalSinceDate:_startFlashTime];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self derivePip:FLASH_EVENT withDelay:_flashTimeInterval];
                });
                
                NSLog(@"Flash Time: %f", _flashTimeInterval);
//                NSLog(@"Prev Diff: %f Difference: %f", _prevDiff, _diff);
                _startDarkTime = [NSDate date];
                _wasFlashEvent = NO;
                _wasDarkEvent = YES;
            }
        }
        
        
        _prevDiff = _diff;
        _prev = _curr;
    }];
    
    [_videoCamera startCameraCapture];
}

-(void)derivePip:(BOOL)event withDelay:(double)delay
{


    if (event == FLASH_EVENT) {
        if (delay > .08 && delay < .2) {
            // is a dot
            [self.delegate translateLetter:@"."];
//            NSLog(@".");
        }
        else if (delay > .24 && delay < .4) {
            // is a dash
            [self.delegate translateLetter:@"-"];
//            NSLog(@"-");
        }
    }
    else
    {
        if (delay > .05 && delay < .13)
        {
//            NSLog(@"|");
            // is a |
        }
        else if (delay > .26 && delay < .3)
        {
            // is a _
            [self.delegate translateLetter:@" "];
//            NSLog(@"_");
        }
        else if (delay > .65 && delay < .8)
        {
            // is a *
            [self.delegate translateLetter:@"*"];
//            NSLog(@"*");
        }
        else
        {
            [_videoCamera stopCameraCapture];
        }
    }

}

-(void)setupSession
{
    
    NSError *error = nil;
    
    _device = [self searchForBackCameraIfAvailable];
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if ( ! _input)
    {
        NSLog(@"Could not get video input: %@", error);
        return;
    }
    
    _session = [[AVCaptureSession alloc] init];
    
    _session.sessionPreset = AVCaptureSessionPresetLow;
    
    [_session addInput:_input];
    
//    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
//    [self.delegate addPreviewLayer:previewLayer];
    
    _output = [[AVCaptureVideoDataOutput alloc] init];
    
    if ( [_device lockForConfiguration:NULL] == YES ) {
        [_device setExposureMode:AVCaptureExposureModeLocked];
        [_device setActiveVideoMinFrameDuration:CMTimeMake(1, NUMBER_OF_FRAME_PER_S)]; //configure device framerate
        [_device unlockForConfiguration];
    }

    
    dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
    [_output setSampleBufferDelegate:self queue:queue];
    
    [_session addOutput:_output];
    
    [self startCapture];

}

-(void)updateBrightnessThreshold:(int)pValue
{
    _brightnessThreshold = pValue;
}

-(BOOL)startCapture
{
    if(!self.isStarted){
        _lastTotalBrightnessValue = 0;
        [self.session startRunning];
        self.isStarted = YES;
    }
    return self.isStarted;
}

-(BOOL)stopCapture
{
    if(self.isStarted){
        [self.session stopRunning];
        self.isStarted = NO;
    }
    return self.isStarted;
}

#pragma mark - Delegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    if (CVPixelBufferLockBaseAddress(imageBuffer, 0) == kCVReturnSuccess)
    {
        UInt8 *base = (UInt8 *)CVPixelBufferGetBaseAddress(imageBuffer);
        
        //  calculate average brightness in a simple way
        
        size_t bytesPerRow      = CVPixelBufferGetBytesPerRow(imageBuffer);
        size_t width            = CVPixelBufferGetWidth(imageBuffer);
        size_t height           = CVPixelBufferGetHeight(imageBuffer);
        UInt32 totalBrightness  = 0;
        
        for (UInt8 *rowStart = base; height; rowStart += bytesPerRow, height --)
        {
            size_t columnCount = width;
            for (UInt8 *p = rowStart; columnCount; p += 4, columnCount --)
            {
                UInt32 value = (p[0] + p[1] + p[2]);
                totalBrightness += value;
            }
        }
        CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
        
        if(_lastTotalBrightnessValue==0) _lastTotalBrightnessValue = totalBrightness;
        
        _curr = [self calculateLevelOfBrightness:totalBrightness];
        
//        NSLog(@"last:%d curr:%d", _prev, _curr);
        
        _diff = abs(_prev - _curr);
        
        if (_curr >= 100 && _prev < 100 && _diff > 2) {
            _endDarkTime = [NSDate date];
            _darkTimeInterval = [_endDarkTime timeIntervalSinceDate:_startDarkTime];
            NSLog(@"Dark Time: %f", _darkTimeInterval);
            _startFlashTime = [NSDate date];
        }
        else if (_prev >= 100 && _curr < 100 && _diff > 2)
        {
            _endFlashTime = [NSDate date];
            _flashTimeInterval = [_endFlashTime timeIntervalSinceDate:_startFlashTime];
            NSLog(@"Flash Time: %f", _flashTimeInterval);
            _startDarkTime = [NSDate date];
        }
        
        
        
        
        if([self calculateLevelOfBrightness:totalBrightness]<_brightnessThreshold)
        {
//
//            
////            if([self calculateLevelOfBrightness:totalBrightness]>MIN_BRIGHTNESS_THRESHOLD)
////            {
//////                [[NSNotificationCenter defaultCenter] postNotificationName:@"onMagicEventDetected" object:nil];
////                NSLog(@"%d",[self calculateLevelOfBrightness:totalBrightness]);
////            }
////            else //Mobile phone is probably on a table (too dark - camera obturated)
////            {
//////                [[NSNotificationCenter defaultCenter] postNotificationName:@"onMagicEventNotDetected" object:nil];
//////                NSLog(@"onMagicEventNotDetected");
////                NSLog(@"%d",[self calculateLevelOfBrightness:totalBrightness]);
////            }
//            
////            NSLog(@"%d",[self calculateLevelOfBrightness:totalBrightness]);
//            
        }
        else{
            _lastTotalBrightnessValue = totalBrightness;
        
//
////            [[NSNotificationCenter defaultCenter] postNotificationName:@"onMagicEventNotDetected" object:nil];
////            NSLog(@"onMagicEventNotDetected");
////            NSLog(@"%d",[self calculateLevelOfBrightness:totalBrightness]);
        }
        
        _prev = _curr;
        
    }
    
}

-(int) calculateLevelOfBrightness:(int) pCurrentBrightness
{
    return (pCurrentBrightness*100) /_lastTotalBrightnessValue;
}

#pragma mark - Tools
- (AVCaptureDevice *)searchForBackCameraIfAvailable
{
    //  look at all the video devices and get the first one that's on the front
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    _device = nil;
    for (AVCaptureDevice *device in videoDevices)
    {
        if (device.position == AVCaptureDevicePositionBack)
        {
            _device = device;
            break;
        }
    }
    
    //  couldn't find one on the front, so just get the default video device.
    if ( ! _device)
    {
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    return _device;
}

-(BOOL)bothNegOrPos:(CGFloat)x y:(CGFloat)y
{
    return ((x>=0 && y>=0) || (x<=0 && y<=0));
}

@end
