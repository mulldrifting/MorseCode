//
//  Constants.m
//  MorseCode
//
//  Created by Lauren Lee on 4/14/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import "Constants.h"

@implementation Constants

+(NSDictionary*)letterToMorseDictionary
{
    static NSDictionary *inst = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inst = @{
                 @"A": @".-", @"B": @"-...", @"C": @"-.-.",
                 @"D": @"-..",  @"E": @".",  @"F": @"..-.",
                 @"G": @"--.",  @"H": @"....", @"I": @"..",
                 @"J": @".---", @"K": @"-.-",  @"L": @".-..",
                 @"M": @"--",   @"N": @"-.",   @"O": @"---",
                 @"P": @".--.", @"Q": @"--.-", @"R": @".-.",
                 @"S": @"...",  @"T": @"-",  @"U": @"..-",
                 @"V": @"...-", @"W": @".--",  @"X": @"-..-",
                 @"Y": @"-.--", @"Z": @"--..",
                 
                 @"0": @"-----",  @"1": @".----",  @"2": @"..---",
                 @"3": @"...--",  @"4": @"....-",  @"5": @".....",
                 @"6": @"-....",  @"7": @"--...",  @"8": @"---..",
                 @"9": @"----.",
                 
                 @" ": @" "
                 };
    });
    return inst;
}

+(NSDictionary*)letterToArrayDictionary
{
    static NSDictionary *inst = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inst = @{
                 @"A": @[@".", @"|", @"-"],
                 @"B": @[@"-", @".", @".", @"."],
                 @"C": @[@"-", @".", @"-", @"."],
                 @"D": @[@"-", @".", @"."],
                 @"E": @[@"."],
                 @"F": @[@".", @".", @"-", @"."],
                 @"G": @[@"-", @"-", @"."],
                 @"H": @[@".", @".", @". ", @"."],
                 @"I": @[@".", @"."],
                 @"J": @[@".", @"-", @"-", @"-"],
                 @"K": @[@"-", @".", @"-"],
                 @"L": @[@".", @"-", @".", @"."],
                 @"M": @[@"-", @"-"],
                 @"N": @[@"-", @"."],
                 @"O": @[@"-", @"-", @"-"],
                 @"P": @[@".", @"-", @"-", @"."],
                 @"Q": @[@"-", @"-", @".", @"-"],
                 @"R": @[@".", @"-", @"."],
                 @"S": @[@".", @".", @"."],
                 @"T": @[@"-"],
                 @"U": @[@".", @".", @"-"],
                 @"V": @[@".", @".", @".", @"-"],
                 @"W": @[@".", @"-", @"-"],
                 @"X": @[@"-", @".", @".", @"-"],
                 @"Y": @[@"-", @".", @"-", @"-"],
                 @"Z": @[@"-", @"-", @".", @"."],
                 
                 @"0": @[@"-", @"-", @"-", @"-", @"-"],
                 @"1": @[@".", @"-", @"-", @"-", @"-"],
                 @"2": @[@".", @".", @"-", @"-", @"-"],
                 @"3": @[@".", @".", @".", @"-", @"-"],
                 @"4": @[@".", @".", @".", @".", @"-"],
                 @"5": @[@".", @".", @".", @".", @"."],
                 @"6": @[@"-", @".", @".", @".", @"."],
                 @"7": @[@"-", @"-", @".", @".", @"."],
                 @"8": @[@"-", @"-", @"-", @".", @"."],
                 @"9": @[@"-", @"-", @"-", @"-", @"."],
                 
                 @" ": @[@"*" ]
                 };
    });
    return inst;
}

+(NSDictionary*)delayDictionary
{
    static NSDictionary *inst = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inst = @{@"-": [NSNumber numberWithInt:300000], //dash
                 @".": [NSNumber numberWithInt:100000], //dot
                 @"|": [NSNumber numberWithInt:100000], //space between pip
                 @" ": [NSNumber numberWithInt:300000], //space between letter
                 @"*": [NSNumber numberWithInt:500000]}; //space between word
        
    });
    return inst;
}

@end
