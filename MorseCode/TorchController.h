//
//  TorchController.h
//  MorseCode
//
//  Created by Lauren Lee on 4/16/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TorchControllerDelegate <NSObject>

@optional

-(void)displayLetter:(NSString *)letter;
-(void)finishSending;

@end

@interface TorchController : NSObject

@property (nonatomic, weak) id<TorchControllerDelegate> delegate;

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSString *letter;
@property (nonatomic) int letterIndex;

- (void)startSignalWithString:(NSString*)string;
- (void)cancelSignal;
- (void)changeLetterTo:(NSString*)letter;

@end
