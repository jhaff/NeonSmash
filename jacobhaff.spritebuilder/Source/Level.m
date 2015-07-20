//
//  Level.m
//  jacobhaff
//
//  Created by Jacob Haff on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Level.h"


#define SH [[CCDirector sharedDirector] viewSize].height


@implementation Level {
    CCNode *_blockGrouper;
   
}


-(void) update:(CCTime)delta {
    CGPoint gravity;
    if (self.leftNode) {
        gravity = ccp(-8000,0);
    } else {
        gravity = ccp(8000,0);
    }
    //    self.children
    //    physicsBody.force = gravity;
    
//    NSLog(@"%@",_blockGrouper.children);
    for (CCNode *child in _blockGrouper.children){
        CGPoint pos = [child convertToWorldSpace:(ccp(0, 0))];
        if (pos.y < SH) {
            child.physicsBody.collisionType = @"Block";
//            NSLog(@"block marked");
        }
        
                
            [child.physicsBody applyForce:(gravity)];
        
        
    }
    
}
-(void) gravPush: (CCNode*) boomBall {

for (CCNode *child in _blockGrouper.children){
    
    
    CGPoint blockPos = [child convertToWorldSpace:(ccp(0, 0))];
    
    CGPoint ballPos = [boomBall convertToWorldSpace:(ccp(0, 0))];
    
    CGPoint blockBallDiff = ccpSub(blockPos , ballPos);
    
    float dist = ccpLength(blockBallDiff);
    
    
    
    
    CGPoint blockBallDiffNorm = ccpNormalize(blockBallDiff);
    CGPoint forceApplied = ccpMult(blockBallDiffNorm, 700000000/ ( dist * dist));
    if ( blockPos.y < SH * .9){
    [child.physicsBody applyImpulse:(forceApplied)];
        [child.physicsBody applyAngularImpulse:(forceApplied.y)];

    }
    
    
    

    
    }
    


}


-(void) earthquake: (CGPoint*) touchPoint {
    
    for (CCNode *child in _blockGrouper.children){
            CGPoint blockPos = [child convertToWorldSpace:(ccp(0, 0))];
            CGPoint blockBallDiff = ccpSub(child.position , *touchPoint);
            blockBallDiff = ccpNormalize(blockBallDiff);
            CGPoint forceApplied = ccpMult(blockBallDiff, 100000);
            [child.physicsBody applyImpulse:(forceApplied)];
            }
    
    }


-(CCNode*) getBlockGrouper{
    return _blockGrouper;
}


@end
