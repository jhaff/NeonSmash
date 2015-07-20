//
//  Blocks.h
//  jacobhaff
//
//  Created by Jacob Haff on 7/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "CCPhysics+ObjectiveChipmunk.h"



BOOL _sliceEntered;
BOOL _sliceExited;
cpVect _entryPoint;
cpVect _exitPoint;
double _sliceEntryTime;

@class Gameplay;



@interface Blocks : CCSprite

// Add after the @interface
@property(nonatomic,readwrite)BOOL sliceEntered;
@property(nonatomic,readwrite)BOOL sliceExited;
@property(nonatomic,readwrite)cpVect entryPoint;
@property(nonatomic,readwrite)cpVect exitPoint;
@property(nonatomic,readwrite)double sliceEntryTime;
@property(nonatomic, weak) Gameplay *gameplayLayer;


@end
