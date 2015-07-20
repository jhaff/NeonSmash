//
//  CCActionFollowVertical.m
//  CCActionFollowAxis
//
//  Created by Benjamin Reynolds on 7/15/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCActionFollowAxisVertical.h"

@implementation CCActionFollowAxisVertical

-(void) step:(CCTime) dt
{
    if(_boundarySet)
    {
        CGPoint tempPos = ccpSub(ccp(0, _halfScreenSize.y), _followedNode.position);
        [(CCNode *)_target setPosition:ccp(clampf(tempPos.x, _leftBoundary, _rightBoundary), tempPos.y)];
    }
    else
        [(CCNode *)_target setPosition:ccpSub( ccp(0, _halfScreenSize.y), _followedNode.position )];
}

- (CGPoint)currentOffset {
    if(_boundarySet)
    {
        // whole map fits inside a single screen, no need to modify the position - unless map boundaries are increased
        if(_boundaryFullyCovered)
            return [(CCNode *)_target position];
        
        CGPoint tempPos = ccpSub( ccp(0, _halfScreenSize.y), _followedNode.position);
        return ccp(clampf(tempPos.x, _leftBoundary, _rightBoundary), clampf(tempPos.y, _bottomBoundary, _topBoundary));
    }
    else
        return ccpSub( ccp(0, _halfScreenSize.y), _followedNode.position );
}

@end
