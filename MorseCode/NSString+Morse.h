//
//  NSString+Morse.h
//  MorseCode
//
//  Created by Lauren Lee on 4/14/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (Morse)

+(NSString *)symbolForLetter:(NSString *)letter;


-(NSString *)validateString;
-(NSArray *)convertStringToCodeArray;
-(NSString *)formatCodeArray:(NSArray*)codeArray;
-(int)delay;

@end

