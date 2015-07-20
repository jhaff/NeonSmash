//
//  Ring.m
//  jacobhaff
//
//  Created by Jacob Haff on 8/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Ring.h"

@implementation Ring
-(void) didLoadFromCCB {
    self.red = TRUE;
    self.physicsBody.sensor = TRUE;
    self.ringChecked = false;
    
    CCBAnimationManager* animationManager = self.userObject;
    // timelines can be referenced and run by name
    [animationManager runAnimationsForSequenceNamed:@"Red"];
}

- (void)runAnimation
{
    
        
    
    // the animation manager of each node is stored in the 'userObject' property
    CCBAnimationManager* animationManager = self.userObject;
    // timelines can be referenced and run by name
    [animationManager runAnimationsForSequenceNamed:@"Green"];
    self.ringChecked = true;
}

- (void)runAnimation2
{
    
    if (self.ringChecked == false){
    
    // the animation manager of each node is stored in the 'userObject' property
    CCBAnimationManager* animationManager = self.userObject;
    // timelines can be referenced and run by name
    [animationManager runAnimationsForSequenceNamed:@"Red"];
    }
}



@end
