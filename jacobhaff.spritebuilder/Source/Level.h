//
//  Level.h
//  jacobhaff
//
//  Created by Jacob Haff on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Level : CCNode

@property (nonatomic,assign) int enemyCount;
@property (nonatomic,assign) int coinsAwarded;
@property (nonatomic,assign) int power;
@property (nonatomic,copy)NSString *nextLevel;
@property (nonatomic,copy)NSString *currentLevel;
@property (nonatomic,assign) BOOL *leftNode;



@property (nonatomic,assign) CGPoint scaleCenter;

-(void) gravPush: (CCNode*) boomBall;

-(void) earthquake: (CGPoint*) touchPoint;


-(CCNode*) getBlockGrouper;
    



@end
