//
//  LeftLevelNode.m
//  jacobhaff
//
//  Created by Jacob Haff on 7/30/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "LeftLevelNode.h"

@implementation LeftLevelNode

-(void) didLoadFromCCB {
    CGPoint gravity = ccp(-1000,0);
    self.physicsBody.force = gravity;
}

@end
