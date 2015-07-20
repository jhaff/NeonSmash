//
//  GameData.h
//  jacobhaff
//
//  Created by Jacob Haff on 7/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameData : NSObject

-(void)setItFalse;


+ (instancetype)sharedInstance;
@property (nonatomic, assign) NSInteger coins;
@property (nonatomic, assign) NSInteger boomNum;
@property (nonatomic, assign) NSInteger highScore;

@property (nonatomic, assign) bool gameHasBeenOpened;



@end
