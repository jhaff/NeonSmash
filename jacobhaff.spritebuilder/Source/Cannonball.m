//
//  Cannonball.m
//  jacobhaff
//
//  Created by Jacob Haff on 7/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Cannonball.h"
#import "Gameplay.h"

@implementation Cannonball

//- (void)setIsAlive:(BOOL)newState {
//    //when you create an @property as we did in the .h, an instance variable with a leading underscore is automatically created for you
//    _isAlive = newState;
//    
//    // 'visible' is a property of any class that inherits from CCNode. CCSprite is a subclass of CCNode, and Creature is a subclass of CCSprite, so Creatures have a visible property
//    self.visible = _isAlive;
//}
-(void) didLoadFromCCB{
    self.sprite=
    self.bounceCount = 0;
    
//    if (    [Gameplay sharedInstance].sprite =  true;
//)
//    
//    {
//        self.spriteFrame = [CCSpriteFrame frameWithImageNamed: @"oie_29205930iZbTR0zD.png"];
//    }
}

@end
