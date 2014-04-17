//
//  TorchControllerDelegate.h
//  MorseCode
//
//  Created by Lauren Lee on 4/16/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TorchControllerDelegate <NSObject>


@optional


@end

@interface TorchControllerDelegate : NSObject

@property (nonatomic, weak) id<TorchControllerDelegate> delegate;

@end