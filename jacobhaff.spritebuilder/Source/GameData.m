//
//  GameData.m
//  jacobhaff
//
//  Created by Jacob Haff on 7/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameData.h"

static NSString *const GAME_STATE_COIN_KEY = @"GameStateCoinKey";
static NSString *const GAME_STATE_BOOMNUM_KEY = @"GameStateBoomNumKey";
static NSString *const GAME_STATE_HIGHSCORE_KEY = @"GameStateHighScoreNumKey";




@implementation GameData
{
    bool gameHasBeenOpened;
}

+ (instancetype)sharedInstance {
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    
    // initialize sharedObject as nil (first call only)
    __strong static id _sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc]init];
    });
    
    // returns the same object each time
    return _sharedObject;
}


- (instancetype)init {
    self = [super init];
    
    if (self) {
        NSNumber *coins = [[NSUserDefaults standardUserDefaults]objectForKey:GAME_STATE_COIN_KEY];
        self.coins = [coins integerValue];
        NSNumber *BoomNum = [[NSUserDefaults standardUserDefaults]objectForKey:GAME_STATE_BOOMNUM_KEY];
        self.boomNum = [BoomNum integerValue];
        NSNumber *highScore = [[NSUserDefaults standardUserDefaults]objectForKey:GAME_STATE_HIGHSCORE_KEY];
        self.highScore = [highScore integerValue];

    }
    return self;
    
}

-(void)setItFalse
{
    self.gameHasBeenOpened = false;
}


- (void)setHighScore:(NSInteger)highScore {
    _highScore = highScore;
    
    
    
//    NSNumber *coinNumber = [NSNumber numberWithInt:coins];
    
    
    
    // store change
//    [[NSUserDefaults standardUserDefaults]setObject:coinNumber forKey:GAME_STATE_COIN_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


- (void)setScore:(NSInteger)highScore{
    _highScore = highScore;
    
    NSNumber *highScoreNumber = [NSNumber numberWithInt:highScore];
    
    // broadcast change
    //[[NSNotificationCenter defaultCenter]postNotificationName:GAME_STATE_SCORE_NOTIFICATION object:coinNumber];
    
    // store change
    [[NSUserDefaults standardUserDefaults]setObject:highScoreNumber forKey:GAME_STATE_HIGHSCORE_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


- (void)setCoins:(NSInteger)coins {
    _coins = coins;
    

    
    NSNumber *coinNumber = [NSNumber numberWithInt:coins];
    

    
    // store change
    [[NSUserDefaults standardUserDefaults]setObject:coinNumber forKey:GAME_STATE_COIN_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

@end
