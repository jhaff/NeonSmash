 //
//  WinDialouge.m
//  jacobhaff
//
//  Created by Jacob Haff on 7/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//
#import "Gameplay.h"
#import "LoseDialogue.h"
#import "GameData.h"

@implementation LoseDialogue

//-(void)retryButton{
//    [self.instanceOfGameplay retry];
////    [self.instanceOfGameplay removeChild:self cleanup:YES];
//    
//}

-(void)play{
    [self.instanceOfGameplay play];
    [self removeFromParent];
}
-(void)tapsRemoveAds{
    [self.instanceOfGameplay tapsRemoveAds];
}
-(void)mainMenu
{
    [self.instanceOfGameplay mainMenuLoad];
//    [self removeFromParent];
}
-(void)shop {
    [self.instanceOfGameplay shopLoad];
//    [self removeFromParent];

}
-(void)credits {
    [self.instanceOfGameplay creditsLoad];
    //    [self removeFromParent];
    
}
-(void)restart{
    [self.instanceOfGameplay play];
    [self removeFromParent];

}

-(void)resume{
    
    [self.instanceOfGameplay pause];
//    self.instanceOfGameplay.paused = false;
    [self removeFromParent];
    
//    [self removeFromParent];

}
-(void)buyPowerup {
    //check if player has enough coins
    //decrement coins
    //give user item
    //
    
    NSLog(@"coins: %i", [GameData sharedInstance].coins);
    if ([GameData sharedInstance].coins >200)
    {
        [GameData sharedInstance].coins -= 200;
        [GameData sharedInstance].boomNum ++;
        
    }
        
    
}

- (void)stay
{
    [[self animationManager] runAnimationsForSequenceNamed:@"noo"];

}

- (void)runAnimationIn
{
    
    [[self animationManager] runAnimationsForSequenceNamed:@"Untitled Timeline"];

    
    // the animation manager of each node is stored in the 'userObject' property
    // timelines can be referenced and run by name
    
}

@end
