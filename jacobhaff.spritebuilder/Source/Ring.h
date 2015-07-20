//
//  Ring.h
//  jacobhaff
//
//  Created by Jacob Haff on 8/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface Ring : CCSprite


@property (nonatomic,assign) BOOL red;
@property (nonatomic,assign) BOOL ringChecked;

- (void)runAnimation;
- (void)runAnimation2;


@end
