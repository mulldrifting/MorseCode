//
//  TorchController.m
//  MorseCode
//
//  Created by Lauren Lee on 4/16/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "TorchController.h"
#import "NSString+Morse.h"
#import "Constants.h"
#import "ViewController.h"

@implementation TorchController

- (void)turnTorchOn:(BOOL)on
{
    AVCaptureDevice *myDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    
    if ([myDevice hasTorch] || [myDevice hasFlash]) {
        
        if([myDevice lockForConfiguration:&error])
        {
            if (on) {
                [myDevice setTorchMode:AVCaptureTorchModeOn];
                [myDevice setFlashMode:AVCaptureFlashModeOn];
            }
            else
            {
                [myDevice setTorchMode:AVCaptureTorchModeOff];
                [myDevice setFlashMode:AVCaptureFlashModeOff];
            }
        
            [myDevice unlockForConfiguration];
        }
        
        else {
            NSLog(@"Could not lock device for config error: %@", error);
        }
    }
}


- (void)startSignalWithString:(NSString *)string
{
    self.queue = [NSOperationQueue new];
    [self.queue setMaxConcurrentOperationCount:1];
    
    NSArray *pipArray = [string convertStringToPipArray];
    
    __block int letterIndex = 0;
    __block BOOL isNewWord = NO;
    
    [self changeLetterTo:[string letterAtIndex:letterIndex]];
    
    for (NSString *pip in pipArray) {
        
        [self.queue addOperationWithBlock:^{
            
            if ([pip isSpace]) {
                
                if ([pip isEqualToString:@" "]) {
                    letterIndex++;
                    [self changeLetterTo:[string letterAtIndex:letterIndex]];
                }
                
                if ([pip isEqualToString:@"*"]) {
                    letterIndex++;
                    isNewWord = YES;
                }
                
                usleep([pip delay]);
                
            } else {
                
                if (isNewWord) {
                    letterIndex++;
                    [self changeLetterTo:[string letterAtIndex:letterIndex]];
                    isNewWord = NO;
                }
                
                [self turnTorchOn:YES];
                usleep([pip delay]);
                [self turnTorchOn:NO];
            }
        }];
        
    } // end of for loop
    
    [self.queue addOperationWithBlock:^{
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.delegate finishSending];
        }];
    }];
}

- (void)cancelSignal
{
    [self.queue cancelAllOperations];
}

- (void)changeLetterTo:(NSString*)letter
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.delegate displayLetter:letter];
    }];
}

@end

