//
//  Gameplay.h
//  jacobhaff
//
//  Created by Jacob Haff on 7/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCScene.h"
//#import "LoseDialogue.h"

@interface Gameplay : CCScene


//@class LoseDialogue;



-(void)retry;

-(void)pause;

-(void)play;

-(void)shopLoad;
-(void)creditsLoad;



-(void)mainMenuLoad;

-(void)resumeButton;
-(void)tapsRemoveAds;

-(void)musicOn;


@property (nonatomic,assign) BOOL chargeCannonActivated;
@property (nonatomic,assign) BOOL gameHasBeenOpened;
@property (nonatomic,assign) int spriteNum;



//@property (nonatomic,weak) LoseDialogue* instanceOfLoseDialogue;



@end
