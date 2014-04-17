//
//  NSString+Morse.h
//  MorseCode
//
//  Created by Lauren Lee on 4/14/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (Morse)

-(NSArray *)convertStringToCodeArray;
-(NSArray *)convertStringToPipArray;

-(NSString *)letterAtIndex:(int)index;
-(NSString *)codeForLetterAtIndex:(int)index;
-(NSArray *)arrayForLetterAtIndex:(int)index;

-(NSString *)formatCodeArray:(NSArray*)codeArray;

-(BOOL)isSpace;
-(int)delay;

@end

