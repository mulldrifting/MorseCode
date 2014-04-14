//
//  Constants.m
//  MorseCode
//
//  Created by Lauren Lee on 4/14/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import "Constants.h"

@implementation Constants

+(NSDictionary*)morseDictionary
{
    NSDictionary *morseDictionary = @{
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
                                      @"9": @"----."
                                      };
    return morseDictionary;
}

@end
