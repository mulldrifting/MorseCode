//
//  ViewController.m
//  MorseCode
//
//  Created by Lauren Lee on 4/14/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import "ViewController.h"
#import "NSString+Morse.h"

@interface ViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *morseLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputField;

@property (strong, nonatomic) NSString *inputString;

@property (strong, nonatomic) NSArray *codeArray;

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
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Text Field Methods

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.inputField endEditing:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.inputString = self.inputField.text;
    self.morseLabel.text = [self.inputString convertStringToCode];
}



@end