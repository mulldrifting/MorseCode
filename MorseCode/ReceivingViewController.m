//
//  ReceivingViewController.m
//  MorseCode
//
//  Created by Lauren Lee on 4/17/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import <ProgressHUD/ProgressHUD.h>
#import "ReceivingViewController.h"
#import "Constants.h"

#define FLASH_EVENT YES
#define DARK_EVENT NO

@implementation ReceivingViewController 

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.inputController = [[InputController alloc] init];
    self.inputController.delegate = self;
    
    self.pipArray = [NSMutableArray new];
    self.letterArray = [NSMutableArray new];
    
    self.completeString = @"";
    
    self.messageLabel.text = self.completeString;
}

-(IBAction)startReceiving:(id)sender
{
    [self.inputController startCamera];
}

//-(void)addPreviewLayer:(AVCaptureVideoPreviewLayer*)previewLayer
//{
//    self.previewLayer = previewLayer;
//    CGRect bounds= self.previewView.layer.bounds;
//    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    self.previewLayer.bounds=bounds;
//    self.previewLayer.position=CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
//    
////    previewLayer.frame = self.previewView.bounds; // Assume you want the preview layer to fill the view.
//    [self.previewView.layer addSublayer:self.previewLayer];
//}

-(void)translateLetter:(NSString *)pip
{
    if ([pip isEqualToString:@"*"])
    {
//        NSLog(@"%@", pip);
        [self translatePipArray];
        [self.completeString stringByAppendingString:@" "];
        self.messageLabel.text = self.completeString;
    }
    else if ([pip isEqualToString:@"-"] || [pip isEqualToString:@"."])
    {
//        NSLog(@"%@", pip);
        [self.pipArray addObject:pip];
        
    }
    else if ([pip isEqualToString:@" "])
    {
//        NSLog(@"%@", pip);
        [self translatePipArray];
    }
    
}

-(void)translatePipArray
{
    NSString *code = @"";
    for (NSString *pip in self.pipArray) {
        code  = [code stringByAppendingString:pip];
    }
    
    NSString *letter = [[Constants morseToLetterDictionary] objectForKey:code];
    
    self.completeString = [self.completeString stringByAppendingString:letter];
    
    NSLog(@"%@", letter);
    
    [self.pipArray removeAllObjects];
}

@end
