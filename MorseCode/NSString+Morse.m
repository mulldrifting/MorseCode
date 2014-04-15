//
//  NSString+Morse.m
//  MorseCode
//
//  Created by Lauren Lee on 4/14/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import "NSString+Morse.h"
#import "Constants.h"

typedef NS_ENUM(NSInteger, codeType) {
    kDash,
    kDot,
    kSpace
};

@implementation NSString (Morse)

-(NSString*)validateString
{
    NSString *string = [self uppercaseString];

//    NSError *error;
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^A-Z0-9]" options:NSRegularExpressionCaseInsensitive error:&error];
//    string = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@""];
//    if (!error)
//    {
//        NSLog(@"%@",string);
//        return string;
//    }
//    return @"";
    return string;
}

-(NSArray*)convertStringToCodeArray
{
    NSString *string = [self validateString];
    NSMutableArray *codeArray = [NSMutableArray new];
    
    NSString *letter;
    NSString *code;
    NSString *symbol;
    
    for(int i = 0; i < [string length]; i++) {
        letter = [string substringWithRange:NSMakeRange(i, 1)];
        code = [NSString symbolForLetter:letter];
        for (int j = 0; j < [code length]; j++) {
            symbol = [code substringWithRange:NSMakeRange(j, 1)];
            [codeArray addObject:symbol];
        }
        [codeArray addObject:@" "];
    }
    
    return codeArray;
}



+(NSString*)symbolForLetter:(NSString *)letter
{
    return [[Constants morseDictionary] objectForKey:letter];
}

-(NSString*)formatCodeArray:(NSArray *)codeArray
{
    NSString *codeString = @"";
    
    for (NSString *code in codeArray) {
        if (![code isEqualToString:@"*"])
        {
            codeString = [codeString stringByAppendingString:code];
        }
        else {
            codeString = [codeString stringByAppendingString:@"   "];
        }
    }

    return codeString;
}



-(int)delay
{
    if ([[Constants delayDictionary] objectForKey:self]) {
        return [[[Constants delayDictionary] objectForKey:self] integerValue];
    }
    return 0;
}

@end


