//
//  Blocks.m
//  jacobhaff
//
//  Created by Jacob Haff on 7/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Blocks.h"
#import "Gameplay.h"

@implementation Blocks
// Add inside the @implementation
@synthesize entryPoint = _entryPoint;
@synthesize exitPoint = _exitPoint;
@synthesize sliceEntered = _sliceEntered;
@synthesize sliceExited = _sliceExited;
@synthesize sliceEntryTime = _sliceEntryTime;


// Add inside the initWithTexture method, inside the if statement


-(void)didLoadFromCCB {
    _sliceExited = NO;
    _sliceEntered = NO;
    _entryPoint = cpvzero;
    _exitPoint = cpvzero;
    _sliceExited = 0;
    self.userInteractionEnabled = true;

    }
    
//-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
//        if (self.gameplayLayer.vaporizerActivated) {
//            [self removeFromParent];
//            
//        }
//}


@end
