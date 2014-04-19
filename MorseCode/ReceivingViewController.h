//
//  ReceivingViewController.h
//  MorseCode
//
//  Created by Lauren Lee on 4/17/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "InputController.h"

@interface ReceivingViewController : UIViewController <InputControllerDelegate>

//@property (weak, nonatomic) IBOutlet UIView *previewView;
//@property (strong, nonatomic) AVCaptureVideoPreviewLayer* previewLayer;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

//@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
//@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
//
//@property (nonatomic) NSUInteger *pageIndex;

@property (strong, nonatomic) InputController *inputController;

@property (strong, nonatomic) NSMutableArray *pipArray;
@property (strong, nonatomic) NSMutableArray *letterArray;
@property (strong, nonatomic) NSString *completeString;



@end
