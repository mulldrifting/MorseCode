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

-(NSArray*)convertStringToCodeArray
{
    NSMutableArray *codeArray = [NSMutableArray new];
    
    for(int i = 0; i < [self length]; i++) {
        [codeArray addObject:[self codeForLetterAtIndex:i]];
    }
    
    return codeArray;
}

-(NSArray*)convertStringToPipArray
{
    NSMutableArray *pipArray = [NSMutableArray new];
    
    NSString *letter;
    NSString *prevLetter = @" ";
    
    for (int i = 0; i < [self length]; i++) {
        
        letter = [self substringWithRange:NSMakeRange(i, 1)];
        
        if (![prevLetter isEqualToString:@" "] && ![letter isEqualToString:@" "]) {
            [pipArray addObject:@" "];
        }

        [pipArray addObjectsFromArray:[self arrayForLetterAtIndex:i]];
        
        prevLetter = letter;
    }
    
    return pipArray;
}

-(NSString*)letterAtIndex:(int)index
{
    return [self substringWithRange:NSMakeRange(index, 1)];
}

-(NSString*)codeForLetterAtIndex:(int)index
{
    return [[Constants letterToMorseDictionary] objectForKey:[self letterAtIndex:index]];
}

-(NSArray *)arrayForLetterAtIndex:(int)index
{
    return [[Constants letterToArrayDictionary] objectForKey:[self letterAtIndex:index]];
}

-(NSString*)formatCodeArray:(NSArray *)codeArray
{
    NSString *codeString = @"";
    
    for (NSString *code in codeArray) {
        codeString = [codeString stringByAppendingString:code];
        if ([code isEqualToString:@" "])
        {
            codeString = [codeString stringByAppendingString:@"  "];
        }
        else {
            codeString = [codeString stringByAppendingString:@" "];
        }
    }

    return codeString;
}

-(BOOL)isSpace
{
    if ([self isEqualToString:@"|"] || [self isEqualToString:@" "] || [self isEqualToString:@"*"]) {
        return YES;
    }
    return NO;
}

-(int)delay
{
    if ([[Constants delayDictionary] objectForKey:self]) {
        return [[[Constants delayDictionary] objectForKey:self] intValue];
    }
    return 0;
}

@end


