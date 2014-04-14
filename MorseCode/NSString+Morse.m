//
//  NSString+Morse.m
//  MorseCode
//
//  Created by Lauren Lee on 4/14/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import "NSString+Morse.h"
#import "Constants.h"

@implementation NSString (Morse)

-(NSString*)validateString
{
    NSString *string = [self uppercaseString];
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^A-Z0-9]" options:NSRegularExpressionCaseInsensitive error:&error];
    string = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@""];
    if (!error)
    {
        return string;
    }
    return @"";
}

-(NSString*)convertStringToCode
{
    NSString *string = [self validateString];
    NSMutableArray *codeArray = [NSMutableArray new];
    
    NSString *letter;
    
    for(int i = 0; i < [string length]; i++) {
        letter = [string substringWithRange:NSMakeRange(i, 1)];
        [codeArray addObject:[string symbolForLetter:letter]];
         }
    
    return [self formatCode:codeArray];
}

-(NSString*)symbolForLetter:(NSString *)letter
{
    return [[Constants morseDictionary] objectForKey:letter];
}

-(NSString*)formatCode:(NSArray *)codeArray
{
    NSString *codeString = @"";
    
    for (NSString *code in codeArray) {
        codeString = [codeString stringByAppendingString:[NSString stringWithFormat:@"%@ ",code]];
    }

    return codeString;
}

@end


