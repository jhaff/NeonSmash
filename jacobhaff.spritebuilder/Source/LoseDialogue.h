//
//  WinDialouge.h
//  jacobhaff
//
//  Created by Jacob Haff on 7/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface LoseDialogue : CCNode

@property (nonatomic,weak) Gameplay* instanceOfGameplay;

- (void)runAnimationIn;
- (void)stay;



@end
