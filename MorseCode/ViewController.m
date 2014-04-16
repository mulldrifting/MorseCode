//
//  ViewController.m
//  MorseCode
//
//  Created by Lauren Lee on 4/14/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "ViewController.h"
#import "NSString+Morse.h"

@interface ViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *morseLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property (strong, nonatomic) NSString *inputString;
@property (strong, nonatomic) NSArray *codeArray;
@property (strong, nonatomic) NSArray *pipArray;
@property (nonatomic) BOOL signalIsCancelled;

@property (strong, nonatomic) NSOperationQueue *flashQueue;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Set up input text field
    self.inputField.delegate = self;
    [self.inputField addTarget:self.inputField action:@selector(resignFirstResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    self.inputString = self.inputField.text;
    
    self.morseLabel.text = @"";
    
    self.signalIsCancelled = NO;
    
    self.flashQueue = [NSOperationQueue new];
    [self.flashQueue setMaxConcurrentOperationCount:1];
    
    
    
}

//    for (int i=0; i<self.inputString.length; i++) {
//        NSString *letter = [self.inputString substringWithRange:NSMakeRange(i, 1)];
//        NSLog(@"%@",letter);
//        [self performSelector:@selector(logoutLetter:) withObject:letter afterDelay:0.1*i];
//    }
    
//    for (int i=0; i<self.inputString.length; i++) {
//        NSLog(@"%@", [self.inputString enumerateSubstringsInRange:NSMakeRange(0, self.inputString.length) options:0 usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
//            NSLog(@"%@", substring);
//        }])
//    }
//}


//- (void)downloadAndDisplay
//{
//    NSDate *currentTimeStamp = [NSDate date];
//    NSURL *photoURL = [NSURL URLWithString:@""];
//    NSData *photoData = [NSData dataWithContentsOfURL:photoURL];
//    
//    NSDate *timestampAfterDownload = [NSDate date];
//    NSTimeInterval downloadTime = [timestampAfterDownload timeIntervalSinceDate:currentTimeStamp];
//    NSLog(@"%f", downloadTime);

//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        _imageView.image = [UIImage imageWithData:photoData];
//    }];
//}



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    NSOperationQueue *imageQueue = [NSOperationQueue new];
//    
//    NSBlockOperation *downloadOperation = [NSBlockOperation blockOperationWithBlock:^{
//        [self downloadAndDisplay];
//    }];
////    [imageQueue addOperationWithBlock:^{
////        [self downloadAndDisplay];
////    }];
//
//    [downloadOperation setCompletionBlock:^{
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//             _imageView.image = _photo;
//        }];
//    }];
//    
//    [imageQueue addOperation:downloadOperation];
}

- (void)turnOn
{
    AVCaptureDevice *myDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([myDevice hasTorch] || [myDevice hasFlash]) {
        [myDevice lockForConfiguration:nil];
        [myDevice setTorchMode:AVCaptureTorchModeOn];
        [myDevice setFlashMode:AVCaptureFlashModeOn];
        [myDevice unlockForConfiguration];
    }
}

- (void)turnOff
{
    AVCaptureDevice *myDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([myDevice hasTorch] || [myDevice hasFlash]) {
        [myDevice lockForConfiguration:nil]; //add error msg
        [myDevice setTorchMode:AVCaptureTorchModeOff];
        [myDevice setFlashMode:AVCaptureFlashModeOff];
        [myDevice unlockForConfiguration];
    }
}

- (IBAction)startSignal:(id)sender
{
    
    if ([self.flashQueue operationCount] == 0) {
        self.signalIsCancelled = NO;
        [self.startButton setTitle:@"Cancel Signal" forState:UIControlStateNormal];
        [self.startButton setEnabled:NO];
        

        for (NSString *code in self.codeArray) {
            
            if (!self.signalIsCancelled) {
                
                [self.flashQueue addOperationWithBlock:^{
                    
                    if ([code isEqualToString:@" "] || [code isEqualToString:@"*"]) {
                        usleep([code delay]);
                    }
                    else {
                        [self turnOn];
                        usleep([code delay]);
                        [self turnOff];
                        usleep(100000);
                    }
                }];
                
            } // if statement
        } // for each letter

    }
    else
    {
        [self cancelSignal];
    }
}


//    NSBlockOperation *signalOperation = [NSBlockOperation blockOperationWithBlock:^{
//        NSString *symbol;
//        for (NSString *code in self.codeArray) {
//            for (int i=0; i<code.length; i++) {
//                if (![signalOperation isCancelled])
//                {
//                    symbol = [code substringWithRange:NSMakeRange(i, 1)];
//                    [self turnOn];
//                    [self performSelector:@selector(turnOff) withObject:nil afterDelay:[symbol delay]];
//                }
//            }
//        }
//    }];
//    [self turnOn];
//}

- (void)cancelSignal
{
    self.signalIsCancelled = YES;
    [self.flashQueue performSelector:@selector(cancelAllOperations) withObject:nil afterDelay:0.0];
    [self performSelector:@selector(turnOff) withObject:nil afterDelay:0.0];
    [self.startButton setTitle:@"Start Sending Signal" forState:UIControlStateNormal];
    [self.startButton setEnabled:YES];
}

//-(void)logoutLetter:(NSString*)letter
//{
//    NSLog(@"%@", letter);
//}

#pragma mark - Text Field Methods

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.inputField endEditing:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.inputString = self.inputField.text;
    self.codeArray = [self.inputString convertStringToCodeArray];
    self.morseLabel.text = [self.inputString formatCodeArray:self.codeArray];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string length] == 0) {
        return YES;
    }
    
    /*  limit to only alphanumeric and whitespace characters  */
    NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz \n"];
    for (int i = 0; i < [string length]; i++) {
        unichar c = [string characterAtIndex:i];
        if ([myCharSet characterIsMember:c]) {
            return YES;
        }
    }
    return NO;
}



@end