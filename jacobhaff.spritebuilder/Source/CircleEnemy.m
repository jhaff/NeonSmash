//
//  CircleEnemy.m
//  jacobhaff
//
//  Created by Jacob Haff on 7/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CircleEnemy.h"

@implementation CircleEnemy

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"CircleEnemy";
}

@end
