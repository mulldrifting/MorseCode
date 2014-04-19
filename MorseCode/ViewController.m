//
//  ViewController.m
//  MorseCode
//
//  Created by Lauren Lee on 4/14/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <ProgressHUD/ProgressHUD.h>
#import "ViewController.h"
#import "ReceivingViewController.h"
#import "TorchController.h"
#import "NSString+Morse.h"
#import "Constants.h"


@interface ViewController () <UITextFieldDelegate, TorchControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *morseLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
//@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
//@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) NSString *inputString;
@property (nonatomic) BOOL signalIsOver;

@property (strong, nonatomic) TorchController *torchController;
@property (strong, nonatomic) ReceivingViewController *receivingController;
@property (strong, nonatomic) UIPageViewController *pageViewController;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up receiving view controller
    self.receivingController = [ReceivingViewController new];

    // Set up Torch Controller
    self.torchController = [TorchController new];
    self.torchController.delegate = self;
    
    // Set up input text field
    self.inputField.delegate = self;
    self.inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.inputField addTarget:self.inputField
                        action:@selector(resignFirstResponder)
              forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.inputField addTarget:self
                        action:@selector(textFieldDidChange)
              forControlEvents:UIControlEventEditingChanged];
    
    // Set up start button
    [self.startButton setTitle:@"Start Sending Signal" forState:UIControlStateNormal];
    [self.startButton setEnabled:NO];
    
    // Set up page control
//    self.scrollView.delegate = self;
//    [self.pageControl addTarget:self
//                           action:@selector(changePage)
//                 forControlEvents:UIControlEventValueChanged];
//    self.pageControl.currentPage =
    
    // Dismiss keyboard when tapping outside
    UITapGestureRecognizer *tapOutside = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapOutside];

    // Initialize variables
    self.inputString = self.inputField.text;
    
    self.morseLabel.text = @"";
    
    self.signalIsOver = YES;
}

-(void)dismissKeyboard
{
    [self.inputField resignFirstResponder];
}

- (IBAction)startButtonPressed:(id)sender
{
    if (self.signalIsOver == YES) {
        
        self.signalIsOver = NO;
        [self.startButton setTitle:@"Cancel Signal" forState:UIControlStateNormal];

        [self.torchController startSignalWithString:self.inputString];
        
    }
    else
    {
        [self finishSending];
    }
}

#pragma mark - Text Field Methods

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.inputField endEditing:YES];
}

- (void)textFieldDidChange
{
    self.inputString = [self.inputField.text uppercaseString];
    self.morseLabel.text = [self.inputString formatCodeArray:[self.inputString convertStringToCodeArray]];
    if ([self.inputField.text length] > 0) {
        [self.startButton setEnabled:YES];
    } else {
        [self.startButton setEnabled:NO];
    }
}

// Limit what characters can be entered into text field
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // Makes backspace work
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

#pragma mark - ProgressHUD methods

-(void)displayLetter:(NSString *)letter
{
    [ProgressHUD show:[NSString stringWithFormat:@"%@: %@", letter, [[Constants letterToMorseDictionary] objectForKey:letter]]];
}

-(void)finishSending
{
    [ProgressHUD dismiss];
    [self.startButton setTitle:@"Start Sending Signal" forState:UIControlStateNormal];
    self.signalIsOver = YES;
    [self.torchController cancelSignal];
}

#pragma mark - Page View Controller Data Source
//
//- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
//{
//    NSUInteger index = ((ReceivingViewController*) viewController).pageIndex;
//    
//    if ((index == 0) || (index == NSNotFound)) {
//        return nil;
//    }
//    
//    index--;
//    return [self viewControllerAtIndex:index];
//}
//
//- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
//{
//    NSUInteger index = ((ReceivingViewController*) viewController).pageIndex;
//    
//    if (index == NSNotFound) {
//        return nil;
//    }
//    
//    index++;
//    if (index == [self.pageTitles count]) {
//        return nil;
//    }
//    return [self viewControllerAtIndex:index];
//}


@end



