
//  Gameplay.m
//  jacobhaff
//
//  Created by Jacob Haff on 7/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "CCPhysics+ObjectiveChipmunk.h"
#import "Level.h"
#import "Blocks.h"
#import "GameData.h"
#import "LoseDialogue.h"
#import "Cannonball.h"
#import "CCActionFollowAxisVertical.h"
#import "CCActionFollow+CurrentOffset.h"
#import "CircleEnemy.h"
#import "RightLevelNode.h"
#import "LeftLevelNode.h"
#import "Ring.h"
#import "CCColor+Hue.h"
#import "AppDelegate.h"
#import "iAdHelper.h"
#import <StoreKit/StoreKit.h>
#import "ViewController.h"
#import "Mixpanel.h"


#define kRemoveAdsProductIdentifier @"com.jacobhaff.NeonSmash.noAds"


static NSString *const GAME_STATE_HIGHSCORE_KEY = @"highScore";
static NSString *const GAME_STATE_BALL_KEY = @"selectedBall";
static NSString *const GAME_STATE_TIMES_PLAYED = @"timesPLayed";
static NSString *const GAME_STATE_ADS_REMOVED = @"areAdsRemoved";


@interface Gameplay() <SKProductsRequestDelegate, SKPaymentTransactionObserver,ADInterstitialAdDelegate,ADBannerViewDelegate>

@end

@implementation Gameplay

{
//    bool adsRemoved;
    
    NSInteger timesPlayed;
    
    int ballNum;
    
    CCLabelTTF *bombsCharging;
    
    CCButton *soundButton;
    CCButton *removeAdsButton;
    CCButton *pauseButton;


    CCButton *musicButton2;
    
    bool areAdsRemoved;
    bool barShrinking;
    bool playingGame;
    
    CCSprite *_tutorialNuke;
    CCNodeColor *_tutorialLife;
    
    Level* currentLevel;
    
    CCNodeColor *_tutorialWindow;
    CCNode *buyMenu;
    CCButton *defaultBallButton;
    
    CCLabelTTF *_tutorialText;
    CCLabelTTF *_tutorialText2;
    CCSprite *_tutorialBomb;
    CCSprite *_tutorialRing;
    
    bool particleLoaded;
    CCButton *musicButton;
    
    float chargeBarVal;
    bool startingGame;
    
    float hue;
    CCNode *_blockGrouper;
    CCNode *_blockRemover;
    float chargeValue;
    float swipeDuration;
    float timeSinceStart;
    float startTime;
    float cannonballStartTime;
    
    NSMutableArray *_blockArray;
    
    CCLabelTTF *_highScoreLabel;
    CCLabelTTF *_highScoreLabel2;
    
    
    bool earthquakeActive;
    
    bool frenzyActive;
    
    CCLabelTTF *_timeLabel2;
    
    Ring *_ring1;
    Ring *_ring2;
    Ring *_ring3;
    Ring *_ring4;
    Ring *_ring5;
    Ring *_ring6;
    
    CCSlider *_colorSlider;
    CCLabelTTF *_hint1;
    
    CCPhysicsNode *_physicsNode;
    CCNode *_gameplayNode;
    CCNode *_background;
    Level *level1;
    Level *level2;
    Level *level3;
    Level *level4;
    Level *level5;
    Level *level6;
    
    
    CGPoint startLocation;
    CGPoint endLocation;
    
    CCParticleSystem *fire;
    
    CCNode *_noTouchNode1;
    CCNode *_noTouchNode2;
    CCNode *_noTouchNode3;
    CCNode *_noTouchNode4;
    CCNode *_noTouchNode5;
    CCNode *_noTouchNode6;
    
    CCSprite *_heart1;
    CCSprite *_heart2;
    CCSprite *_heart3;
    
    int difficulty;
    
    BOOL ignoreTouch;
    BOOL touchingScreen;
    
    int _enemyCount;
    int highScore;
    
    
    CCLabelTTF *_coinsLabel;
    
    float _oldScale;
    CCNode *_scalingNode;
    
    
    CCLabelTTF *_powerLabel;
    CCNodeGradient *_powerBar;
    CCNodeGradient *_chargeBar;
    
    BOOL cannonActivated;
    BOOL laserActivated;
    CCButton *_laserButton;
    CCButton *_cannonButton;
    CCButton *_chargeCannonButton;
    CCButton *_quakeButton;
    CCButton *_goButton;
    CCSprite *pressMe;

    
    CCButton *ballButton1;
    CCButton *ballButton2;
    CCButton *ballButton3;
    CCButton *ballButton4;
    CCButton *ballButton5;
    CCButton *ballButton6;
    
    
    
    NSMutableArray *_enemyArray;
    NSArray *_ringArray;
    
    CCNode *_levelNode1;
    CCNode *_levelNode2;
    CCNode *_levelNode3;
    CCNode *_levelNode4;
    CCNode *_levelNode5;
    CCNode *_levelNode6;
    
    CCNode *_pauseNode;
    
    CCNode *pauseDialogue;
    
    
    //    Level *level;
    
    CGPoint _startPoint;
    CGPoint _endPoint;
    
    NSMutableArray *_ballArray;
    int indexOfArray;
    
    CCNode *_camera;
    
    int health;
    
    CCLabelTTF *_boomNumLabel;
    CCLabelTTF *_timeLabel;
    NSArray *_levelArray;
    NSArray *_noTouchArray;
    
    BOOL gameOver;
    
    float cameraSpeed;
    LoseDialogue *menu;
//    UIViewController *adViewController;
    
    int score;
    float power;
    float powerM;
    
    bool gameHasBeenOpened;
    
    OALSimpleAudio *explosion;
    OALSimpleAudio *ping;
    OALSimpleAudio *ow;
    OALSimpleAudio *audio;

    
    CCLabelBMFont *healthLabel;
    
    CCNode *_scoreLocation;
    
    CCNode *_ominousFinger;
    CCNode *_ominousFinger2;

    
    bool pauseMenuOpen;
    NSNumber *highScoreNumber;
    NSString *cannonballCcb;
    
    int cannonballNum;
    
    CCColor* redColor;
    
    ADInterstitialAd *interstitial;
    
    CCNodeColor *_chargeupBar;
    
    AppController *app;
    UIViewController *adViewController;
    
    Mixpanel *mixpanel;
#define SW [[CCDirector sharedDirector] viewSize].width
#define SH [[CCDirector sharedDirector] viewSize].height
    
    
    
}

- (void)cycleInterstitial
{
    // Clean up the old interstitial...
    interstitial.delegate = nil;
//    [interstitial release];
    // and create a new interstitial. We set the delegate so that we can be notified of when
    interstitial = [[ADInterstitialAd alloc] init];
    interstitial.delegate = self;
}
- (void)presentInterlude{
[mixpanel track:@"InterstitialPresented"];


    // If the interstitial managed to load, then we'll present it now.
    if (interstitial.loaded) {
        
        [[[CCDirector sharedDirector] presentedViewController] setInterstitialPresentationPolicy:ADInterstitialPresentationPolicyManual];

        
//        [[interstitial setInterstitialPresentationPolicy:ADInterstitialPresentationPolicyManual];
        [app.navController pushViewController:adViewController animated:YES];
        [interstitial presentInView:adViewController.view];
        
       
    }
}

// is called when CCB file has completed loading
-(void)didLoadFromCCB {
    
#define MIXPANEL_TOKEN @"b84def948ec874d408bfeabca5498c30"
    [Mixpanel sharedInstanceWithToken: MIXPANEL_TOKEN];
    mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Test-Event"];
    
    
    
    
    bombsCharging.visible = false;
    pressMe.visible = false;
    _goButton.visible = false;
    _goButton.userInteractionEnabled = false;
//    playingGame = false;
//    interstitial = [[ADInterstitialAd alloc] init];
//    interstitial.delegate = self;
//    
//     _adLoaded = NO;
//    interstitial = [[ADInterstitialAd alloc] init]; interstitial.delegate = self; [[[CCDirector sharedDirector] presentedViewController] setInterstitialPresentationPolicy:ADInterstitialPresentationPolicyManual];
//    
    
//    UIView *adView = [[UIView alloc] init];

//    [adViewController showFullScreenAd];
//    
//    if (interstitial.loaded)
//    {
//    
//    
//    [interstitial presentFromViewController: adViewController];
//    adViewController = [[UIViewController alloc] init];
//    
//    app = (AppController*) [[UIApplication sharedApplication] delegate];
    adViewController = [[UIViewController alloc] init];
    
    app = (AppController*) [[UIApplication sharedApplication] delegate];
    
    
    [self cycleInterstitial];
//    }
//    if (interstitial.loaded)
//    {
//        [app.navController pushViewController:adViewController animated:YES];
//        [interstitial presentInView:adViewController.view];
//
//    }
//    git
//    [app.navController.view addSubview:adView];
//    
//    [[[CCDirector sharedDirector]view]addSubview:adViewController];
//    
//    }
    


   timesPlayed = [[NSUserDefaults standardUserDefaults] integerForKey: @"timesPlayed"];

    areAdsRemoved = [[NSUserDefaults standardUserDefaults] boolForKey:@"areAdsRemoved"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [iAdHelper sharedHelper];
    
    if (areAdsRemoved) {
        
    
    [[[iAdHelper sharedHelper] bannerView] setHidden:YES];
    }
    else {
        [[[iAdHelper sharedHelper] bannerView] setHidden:NO];

    }

    musicButton2.visible= false;
    musicButton2.userInteractionEnabled = false;
    
    cannonballNum = [[NSUserDefaults standardUserDefaults]integerForKey:@"selectedBall"];
    
    
    redColor = [CCColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0f];
    
    
    playingGame = false;
    buyMenu.userInteractionEnabled = false;
    buyMenu.visible = false;
    
    
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    //    [[NSUserDefaults standardUserDefaults]setInteger:highScore forKey:@"highScore"];
    highScore = [[NSUserDefaults standardUserDefaults]integerForKey:@"highScore"];
    
    
    _highScoreLabel.string = [NSString stringWithFormat:@"%i", highScore];
    _highScoreLabel2.string = [NSString stringWithFormat:@"%i", highScore];
    
    
    
    //    highScoreNumber = [NSNumber numberWithInt:highScore];
    
    particleLoaded = false;
    startingGame = false;
    
    //    gameHasBeenOpened = false;
    
    AppController *instanceOfGPlay;
    instanceOfGPlay.instanceOfGPlay = self;
    
    hue = 0;
    [GameData sharedInstance].coins += 1000;
    
    pauseDialogue = (LoseDialogue*)[CCBReader load:(@"pauseDialogue")];
    
    gameHasBeenOpened = [GameData sharedInstance].gameHasBeenOpened;
    
    if (gameHasBeenOpened == true)
    {
        playingGame = false;
        [[GameData sharedInstance] setItFalse];
        
        startingGame = true;
        
        menu = (LoseDialogue*)[CCBReader load:(@"MainScene")];
        [_gameplayNode addChild:(menu)];
        menu.instanceOfGameplay = self;
        healthLabel =[CCLabelBMFont labelWithString:@"H" fntFile:@"neon.fnt"];
        
        self.tutorialVanish;
        playingGame = false;
        
        
        healthLabel.scale = .5;
        _scoreLocation = [CCNode alloc];
        
        [_scoreLocation addChild:healthLabel];
        [menu runAnimationIn];
        
        
    }
    
    //lol
    else if ( gameHasBeenOpened == false)
        
    {
        _ominousFinger.visible = true;
        _ominousFinger2.visible = true;

        _tutorialNuke.visible = true;
        _tutorialRing.visible = true;
        
        _tutorialLife.visible = true;
        
        _tutorialBomb.visible = true;
        
        _tutorialText.visible = true;
        _tutorialText2.visible = true;
        
        _tutorialWindow.visible = true;
        gameOver = false;
        self.paused = false;
        playingGame = true;
//        playingGame = true;
        
    }
    
    //    gameHasBeenOpened = false;
    
    
    
    
    
    
    
    power = 100;
    powerM = 100;
    
    // access audio object
    audio = [OALSimpleAudio sharedInstance];
    //     play background sound
//    [audio playBg:@"NeonSmash.mp3" loop:TRUE];
    
    explosion = [OALSimpleAudio sharedInstance];
    [ping preloadEffect:@"Explosion.mp3"];
    
    ping = [OALSimpleAudio sharedInstance];
    
    ow = [OALSimpleAudio sharedInstance];
    
    [ow preloadEffect:@"OW.mp3"];
    
    
    
    [ping preloadEffect:@"ping.mp3"];
    
    _blockRemover.physicsBody.sensor = true;
    
    cameraSpeed = 1.5;
    
    health = 3 ;
//        power = 60;
//        powerM = power;
    _cannonButton.togglesSelectedState= true;
    
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    
    //set the Camera to follow the _camera as it moves
    CCActionFollowAxisVertical *follow = [CCActionFollowAxisVertical actionWithTarget:_camera];
    [_physicsNode runAction:follow];
    _physicsNode.position =[follow currentOffset];
    
    _levelArray = @[_levelNode1,_levelNode2,_levelNode3,_levelNode4,_levelNode5,_levelNode6, ];
    //    _noTouchArray = [NSMutableArray arrayWithObjects: _noTouchNode1,_noTouchNode2,_noTouchNode3,_noTouchNode4,_noTouchNode5,_noTouchNode6,nil];
    _noTouchArray = @[_noTouchNode1,_noTouchNode2,_noTouchNode3,_noTouchNode4,_noTouchNode5,_noTouchNode6];
    _ringArray = @[_ring1,_ring2,_ring3,_ring4,_ring5,_ring6];
    
    
    // initialize all the levels
    level1 = (Level*)[CCBReader load:@"Levels/1/1" owner:self];
    [_levelNode1 addChild:level1];
    level1.leftNode = false;
    
    level2 = (Level*)[CCBReader load:@"Levels/1/2" owner:self];
    [_levelNode2 addChild:level2];
    
    level2.leftNode = false;
    
    level3 = (Level*)[CCBReader load:@"Levels/1/3" owner:self];
    [_levelNode3 addChild:level3];
    level3.leftNode = false;
    
    level4 = (Level*)[CCBReader load:@"Levels/1/4" owner:self];
    [_levelNode4 addChild:level4];
    level4.leftNode = TRUE;
    
    level5 = (Level*)[CCBReader load:@"Levels/1/5" owner:self];
    [_levelNode5 addChild:level5];
    level5.leftNode = TRUE;
    
    level6 = (Level*)[CCBReader load:@"Levels/1/6" owner:self];
    [_levelNode6 addChild:level6];
    level6.leftNode = TRUE;
    
    earthquakeActive = false;
    
    
    
    //    gameOver = false;
    
    _blockRemover.physicsBody.collisionType = @"blockRemover";
    
    
    
    
    //set up the physics node
    _physicsNode.debugDraw = false;
    _physicsNode.collisionDelegate = self;
    
    //set weapons to deactivated
    cannonActivated = true;
    _cannonButton.selected = true;
    self.chargeCannonActivated = false;
    
    
    //initialize the arrays
    _ballArray = [NSMutableArray array];
    _enemyArray = [NSMutableArray array];
    _blockArray = [NSMutableArray array];
    
    
    
    
    // initialize the blocks and enemies of each level. This is for block tracking so chargeCannon works, and so the enemies can be tracked.
    for (CCNode *child in level1.children) {
        if ([child isKindOfClass:[Blocks class]]) {
            ((Blocks*)child).gameplayLayer= self;
            [_blockArray addObject:(child)];
        }
        
        else if ([child isKindOfClass:[CircleEnemy class]])
        {
            [_enemyArray addObject:(child)];
            
        }
        
    }
    
    for (CCNode *child in level2.children) {
        if ([child isKindOfClass:[Blocks class]]) {
            ((Blocks*)child).gameplayLayer= self;
            [_blockArray addObject:(child)];
            
        }
        
        else if ([child isKindOfClass:[CircleEnemy class]])
        {
            [_enemyArray addObject:(child)];
            
        }
        
    }
    
    
    for (CCNode *child in level3.children) {
        if ([child isKindOfClass:[Blocks class]]) {
            ((Blocks*)child).gameplayLayer= self;
            [_blockArray addObject:(child)];
            
        }
        
        else if ([child isKindOfClass:[CircleEnemy class]])
        {
            [_enemyArray addObject:(child)];
            
        }
        
    }
    
    
    
    
    //    set timeSinceStart to zero
    timeSinceStart = 0;
    //    [menu performSelector:@selector(stay)withObject:menu afterDelay:1];
    
}

//- (void)stay2
//{
//    [[self animationManager] runAnimationsForSequenceNamed:@"gameOverStay"];
//
//}





-(void)tapsRemoveAds{
    NSLog(@"User requests to remove ads");
    
    if([SKPaymentQueue canMakePayments]){
        NSLog(@"User can make payments");
        
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kRemoveAdsProductIdentifier]];
        productsRequest.delegate = self;
        [productsRequest start];
        
    }
    else{
        NSLog(@"User cannot make payments due to parental controls");
        //this is called the user cannot make payments, most likely due to parental controls
    }
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    SKProduct *validProduct = nil;
    int count = [response.products count];
    if(count > 0){
        validProduct = [response.products objectAtIndex:0];
        NSLog(@"Products Available!");
        [self purchase:validProduct];
    }
    else if(!validProduct){
        NSLog(@"No products available");
        //this is called if your product id is not valid, this shouldn't be called unless that happens.
    }
}

- (void)purchase:(SKProduct *)product{
    [mixpanel track:@"AdsRemoved"];

    SKPayment *payment = [SKPayment paymentWithProduct:product];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
    areAdsRemoved = true;
    [[NSUserDefaults standardUserDefaults] setBool:(areAdsRemoved) forKey:(@"areAdsRemoved")];

}

- (void) restore{
    //this is called when the user restores purchases, you should hook this up to a button
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"received restored transactions: %i", queue.transactions.count);
    for(SKPaymentTransaction *transaction in queue.transactions){
        if(transaction.transactionState == SKPaymentTransactionStateRestored){
            //called when the user successfully restores a purchase
            NSLog(@"Transaction state -> Restored");
            
            [self doRemoveAds];
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            break;
        }
    }
}


- (void)doRemoveAds{
    ADBannerView *banner;
    [banner setAlpha:0];
    areAdsRemoved = YES;
    removeAdsButton.visible = false;
    removeAdsButton.enabled = NO;
    [[NSUserDefaults standardUserDefaults] setBool:areAdsRemoved forKey:@"areAdsRemoved"];
    //use NSUserDefaults so that you can load whether or not they bought it
    //it would be better to use KeyChain access, or something more secure
    //to store the user data, because NSUserDefaults can be changed.
    //You're average downloader won't be able to change it very easily, but
    //it's still best to use something more secure than NSUserDefaults.
    //For the purpose of this tutorial, though, we're going to use NSUserDefaults
    [[NSUserDefaults standardUserDefaults] synchronize];
}



- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    for(SKPaymentTransaction *transaction in transactions){
        switch(transaction.transactionState){
            case SKPaymentTransactionStatePurchasing: NSLog(@"Transaction state -> Purchasing");
                //called when the user is in the process of purchasing, do not add any of your own code here.
                break;
            case SKPaymentTransactionStatePurchased:
                //this is called when the user has successfully purchased the package (Cha-Ching!)
                [self doRemoveAds]; //you can add your code for what you want to happen when the user buys the purchase here, for this tutorial we use removing ads
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSLog(@"Transaction state -> Purchased");
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Transaction state -> Restored");
                //add the same code as you did from SKPaymentTransactionStatePurchased here
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                //called when the transaction does not finish
                if(transaction.error.code == SKErrorPaymentCancelled){
                    NSLog(@"Transaction state -> Cancelled");
                    //the user cancelled the payment ;(
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
        }
    }
}



// broadcast change
//[[NSNotificationCenter defaultCenter]postNotificationName:GAME_STATE_SCORE_NOTIFICATION object:coinNumber];

// store change




-(void)tutorialVanish {
    _ominousFinger.visible = false;
    _ominousFinger2.visible = false;

    _tutorialNuke.visible = false;
    _tutorialRing.visible = false;
    _tutorialLife.visible = false;
    _tutorialBomb.visible = false;
    _tutorialText.visible = false;
    _tutorialText2.visible = false;
    
    
    _tutorialWindow.visible = false;
//    playingGame = true;
}








//spawn a random structure in the current level node
-(id)spawnStructurewithLevel:(CCNode*)_currentLevelNode
{
    //select a random number
    int levelNumber = arc4random()%1 + 1;
    //use that number to select a random structure or "level" to load
    NSString *currentLevel =[NSString stringWithFormat:@"Levels/Level%i",levelNumber];
    // set the CCNODE level equal to loading the current level
    Level *level = (Level*)[CCBReader load:currentLevel owner:self];
    //finally, add the level as a child to the _currentLevelNode to spawn it in
    return level;
}

#pragma mark Touch Handling for Cannon


- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    
    
    {
        startingGame = true;
        
        touchingScreen = true;
        
        //        //TODO: Make cleaner areas where user cannot touch
        //        if (CGRectContainsPoint(_noTouchNode.boundingBox, [touch locationInNode:_levelNode]))  {
        //            ignoreTouch = YES;
        //        } else {
        //            ignoreTouch = NO;
        startLocation = [touch locationInWorld];
        
        
        startLocation = [_physicsNode convertToNodeSpace:startLocation];
        startTime = timeSinceStart;
        //
        //
        //    }
        
        
        
        
        
    }
}

//-(void) checkTouches {
//    CGPoint touchToCheck;
//    if (self.chargeCannonActivated) {
//        touchToCheck = endLocation;
//    } else {
//        touchToCheck = startLocation;
//    }
//    for (CCNode *noTouchNode in _noTouchArray) {
//        //        touchToCheck = [_physicsNode convertToWorldSpace: touchToCheck ];
//        //        touchToCheck = [noTouchNode convertToNodeSpace:touchToCheck];
//        CGPoint noTouchNodePosition = [noTouchNode.parent convertToWorldSpace:noTouchNode.position];
//
//        noTouchNodePosition = [_physicsNode convertToNodeSpace: noTouchNodePosition];
//        //        CGPoint noTouchNodePosition = noTouchNode.position;
//
//        if ([noTouchNode.parent class] == [RightLevelNode class]) {
//
//
//            float zSquared = ( powf((touchToCheck.x - noTouchNodePosition.x),2) + powf((touchToCheck.y - noTouchNodePosition.y - 0.5*(_levelNode1.contentSize.width - noTouchNode.contentSize.width) ),2));
//            float z = sqrtf(zSquared);
//
//            float radius = 126;
//            if (z < radius) {
//
//                if (self.chargeCannonActivated) {
//                    endLocation = ccp(endLocation.x-radius,endLocation.y);
//                } else {
//                    startLocation = ccp(startLocation.x - radius , startLocation.y);
//                }
//                NSLog(@"RightWorking");
//
//
//            }
//        }
//        else if ([noTouchNode.parent class] == [LeftLevelNode class])
//        {
//            float zSquared = ( powf((touchToCheck.x - noTouchNodePosition.x),2) + powf((touchToCheck.y - noTouchNodePosition.y + 0.5*(_levelNode1.contentSize.width - noTouchNode.contentSize.width) ),2));
//            float z = sqrtf(zSquared);
//
//            float radius = 126;
//            if (z < radius) {
//
//                if (self.chargeCannonActivated) {
//                    endLocation = ccp(endLocation.x-radius,endLocation.y);
//                } else {
//                    startLocation = ccp(startLocation.x + radius , startLocation.y);
//                }
//                NSLog(@"LeftWorking");
//            }
//            //        NSLog(@"z is: %f", z);
//            //        NSLog(@"touch x is: %f y is: %f", touchToCheck.x, touchToCheck.y);
//
//        }
//
//        else{
//            NSLog(@"Node is of NEITHER class.");
//        }
//    }
//}

-(void)allBallButtonsDeselect
{
    cannonballNum = 0;
    
    ballNum = 0;
    
    [[NSUserDefaults standardUserDefaults] setInteger: ballNum forKey: @"selectedBall"];
    defaultBallButton.selected = true;
    ballButton1.selected = false;
    ballButton2.selected = false;
    ballButton3.selected = false;
    ballButton4.selected = false;
    ballButton5.selected = false;
    ballButton6.selected = false;
}

//MARK: BuyButtonsHere
-(void)oneBall{
    [mixpanel track:@"oneBall"];

    if (highScore > 20 || areAdsRemoved){
        
        cannonballNum = 1;
        ballNum = 1;
        [[NSUserDefaults standardUserDefaults] setInteger: ballNum forKey: @"selectedBall"];
        defaultBallButton.selected = false;
        ballButton1.selected = true;
        ballButton2.selected = false;
        ballButton3.selected = false;
        ballButton4.selected = false;
        ballButton5.selected = false;
        ballButton6.selected = false;
        self.spriteNum = 0;
        [self presentInterlude];
        
    }
    
    else {
        [self allBallButtonsDeselect];
//        [[self animationManager] runAnimationsForSequenceNamed:@"noBuy"];
        
        
    }
}

-(void)twoBall{
    [mixpanel track:@"twoBall"];

    if (highScore >= 40 || areAdsRemoved){
        cannonballNum = 2;
        
        defaultBallButton.selected = false;
        ballNum = 2;
        [[NSUserDefaults standardUserDefaults] setInteger: ballNum forKey: @"selectedBall"];
        ballButton1.selected = false;
        ballButton2.selected = true;
        ballButton3.selected = false;
        ballButton4.selected = false;
        ballButton5.selected = false;
        ballButton6.selected = false;
    }
    else{
        [self allBallButtonsDeselect];
        [[self animationManager] runAnimationsForSequenceNamed:@"noBuy"];
        
    }
    
}
-(void)threeBall{
    [mixpanel track:@"threeBall"];

    if (highScore >= 60 || areAdsRemoved){
        cannonballNum = 3;
        
        defaultBallButton.selected = false;
        ballNum = 3;
        [[NSUserDefaults standardUserDefaults] setInteger: ballNum forKey: @"selectedBall"];
        ballButton1.selected = false;
        ballButton2.selected = false;
        ballButton3.selected = true;
        ballButton4.selected = false;
        ballButton5.selected = false;
        ballButton6.selected = false;
    }
    else{
        [self allBallButtonsDeselect];
        [[self animationManager] runAnimationsForSequenceNamed:@"noBuy"];
        
    }
    
    
}
-(void)fourBall{
    [mixpanel track:@"fourBall"];

    if (highScore >= 80 || areAdsRemoved){
        cannonballNum = 4;
        
        ballNum = 4;
        [[NSUserDefaults standardUserDefaults] setInteger: ballNum forKey: @"selectedBall"];
        defaultBallButton.selected = false;
        
        ballButton1.selected = false;
        ballButton2.selected = false;
        ballButton3.selected = false;
        ballButton4.selected = true;
        ballButton5.selected = false;
        ballButton6.selected = false;
    }
    else{
        [self allBallButtonsDeselect];
        [[self animationManager] runAnimationsForSequenceNamed:@"noBuy"];
        
    }
    
    
    
}
-(void)fiveBall{
    [mixpanel track:@"fiveBall"];

    if (highScore >= 100 || areAdsRemoved) {
        cannonballNum = 5;
        
        ballNum = 5;
        [[NSUserDefaults standardUserDefaults] setInteger: ballNum forKey: @"selectedBall"];
        defaultBallButton.selected = false;
        
        ballButton1.selected = false;
        ballButton2.selected = false;
        ballButton3.selected = false;
        ballButton4.selected = false;
        ballButton5.selected = true;
        ballButton6.selected = false;
    }
    
    else{
        [self allBallButtonsDeselect];
        [[self animationManager] runAnimationsForSequenceNamed:@"noBuy"];
        
    }
    
    
}


-(void)sixBall{
    [mixpanel track:@"sixBall"];

    if (highScore >= 120 || areAdsRemoved) {
        cannonballNum = 6;
        
        ballNum = 6;
        [[NSUserDefaults standardUserDefaults] setInteger: ballNum forKey: @"selectedBall"];
        defaultBallButton.selected = false;
        
        ballButton1.selected = false;
        ballButton2.selected = false;
        ballButton3.selected = false;
        ballButton4.selected = false;
        ballButton5.selected = false;
        ballButton6.selected = true;
    }
    else{
        [self allBallButtonsDeselect];
        [[self animationManager] runAnimationsForSequenceNamed:@"noBuy"];
        
    }
    
}




- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event

{
    touchingScreen = false;
    //TODO: Make sure works with multitouch
    if (!ignoreTouch) {
        // Calculate offset
        
        CGPoint touchPointPos = [touch locationInWorld];
        
        CGPoint pt = [_physicsNode convertToNodeSpace:[touch locationInWorld]];
        float dx = pt.x - startLocation.x;
        float dy = pt.y - startLocation.y;
        float dx2;
        float dy2;
        if (dy != 0 && dx != 0) {
            CGPoint normalizedDir = ccpNormalize(ccp(dx, dy));
            dx2 = normalizedDir.x;
            dy2 = normalizedDir.y;
        } else {
            dy2 = dy;
            dx2 = dx;
        }
        
        
        endLocation = [touch locationInWorld];
        endLocation  = [ _physicsNode convertToNodeSpace:endLocation];
        
        swipeDuration = timeSinceStart - startTime;
        //        [self checkTouches];
        
        if (cannonActivated == true) {
            [self fireprojectiletowards: dx and: dy withPower: swipeDuration];
        }
        else if (self.chargeCannonActivated == true) {
            [self fireprojectiletowards: dx and: dy withPower: swipeDuration];
        }
        else if (earthquakeActive){
            
            [level1 earthquake:&(touchPointPos)];
            [level2 earthquake:&(touchPointPos)];
            
            [level3 earthquake:&(touchPointPos)];
            
            [level4 earthquake:&(touchPointPos)];
            
            [level5 earthquake:&(touchPointPos)];
            
            [level6 earthquake:&(touchPointPos)];
        }
    }
    
    
    // Set new location
}



-(void) chargeFireProjectileTowards: (float) dx and: (float) dy or: (float) dx2 and: (float) dy2 withPower: (float) swipeDurationTime {
    CGPoint impulse2 = ccpMult(ccp(dx2, dy2),  (clampf(swipeDurationTime, 1 ,3) * 200) );
    float charge = chargeValue * 60;
    
    
    //load the cannonball from the ccb and class
    Cannonball* _cannonball = (Cannonball*) [CCBReader load:@"BoomBall"];
    _cannonball.visible = true;
    _cannonball.physicsBody.collisionType = @"BoomBall";
    //set its position to the start location of the user's touch
    //create cannonball
    [_physicsNode addChild:_cannonball];
    _cannonball.position = endLocation;
    
    
    //apply an impulse proportional to the distance of the points
    [_cannonball.physicsBody applyImpulse: impulse2];
    
    [_ballArray addObject:(_cannonball)];
    //        _cannonball.physicsBody.
}







//                    //load the cannonball from the ccb and class
//                    Cannonball* _cannonball = (Cannonball*) [CCBReader load:@"Cannonball"];
//                    //set its position to the start location of the user's touch
//                    _cannonball.position = endLocation;
//                    //create cannonball
//                    [_physicsNode addChild:_cannonball];
////                    float swipePower = 5 -swipeDuration;
////                    if (swipePower < 0) {
////                        swipePower = 0;
//                    //}
//
//                    //apply an impulse proportional to the distance of the points
//                    [_cannonball.physicsBody applyImpulse: impulse2];
//
//                    power -= (impulse2.x * .006);
//                    [_ballArray addObject:(_cannonball)];
//                    //        _cannonball.physicsBody.







- (void) fireprojectiletowards:  (float) dx and: (float) dy withPower: (float) swipeDuration
{
    if (!gameOver) {
        if (power >= powerM) {
            
        
    
        _ominousFinger.visible = false;
        _ominousFinger2.visible = false;

        _tutorialNuke.visible = false;
        _tutorialRing.visible = false;
        
        _tutorialLife.visible = false;
        
        
        _tutorialBomb.visible = false;
        
        _tutorialText.visible = false;
        _tutorialText2.visible = false;
        
        _tutorialWindow.visible = false;
        
            power = 0;

        if (cannonActivated) {
            
            
            //load the cannonball from the ccb and class
            
            NSLog(@"Cannonball%i",self.spriteNum);
            
            
            
            if (cannonballNum == 1) {
                cannonballCcb = (@"Cannonball1");
                
            }
            if (cannonballNum == 2) {
                cannonballCcb = (@"Cannonball2");
                
            }
            if (cannonballNum == 3) {
                cannonballCcb = (@"Cannonball3");
                
            }
            if (cannonballNum == 4) {
                cannonballCcb = (@"Cannonball4");
                
            }
            if (cannonballNum == 5) {
                cannonballCcb = (@"Cannonball5");
                
            }
            if (cannonballNum == 6) {
                cannonballCcb = (@"Cannonball6");
                
            }
            else if (cannonballNum == 0) {
                cannonballCcb = (@"Cannonball0");
                
            }
            
            
            
            Cannonball *_cannonball = (Cannonball*) [CCBReader load:(cannonballCcb)];
            
            
            //                NSLog(@"bounce %i", nodeA.bounceCount);
            
            //set its position to the start location of the user's touch
            _cannonball.position = startLocation;
            //create cannonball
            [_physicsNode addChild:_cannonball];
            //apply an impulse proportional to the distance of the points**
            CGPoint impulse = ccpMult(ccp(dx, dy), 50/(.5 *(clampf(swipeDuration,.4, .55)) ));
            
            //            [_cannonball.physicsBody applyImpulse:ccp(clampf(impulse.x, -2000, 220000), clampf(impulse.y, -2000, 20000))];
            [_cannonball.physicsBody applyImpulse:impulse];
            
            [_ballArray addObject:(_cannonball)];
            
            power -=1;
            
            
        }
        
    
        else if (self.chargeCannonActivated){
            //load the cannonball from the ccb and class
            
            Cannonball *_cannonball = (Cannonball*) [CCBReader load:@"BoomBall"];
            
            //set its position to the start location of the user's touch
            _cannonball.position = startLocation;
            //create cannonball
            [_physicsNode addChild:_cannonball];
            //apply an impulse proportional to the distance of the points**
            CGPoint impulse = ccpMult(ccp(dx, dy), 20/((clampf(swipeDuration,0.1, 8)) ));
            
            //            [_cannonball.physicsBody applyImpulse:ccp(clampf(impulse.x, -2000, 220000), clampf(impulse.y, -2000, 20000))];
            [_cannonball.physicsBody applyImpulse:impulse];
            
            [_ballArray addObject:(_cannonball)];
            
        }
    }
    }
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair Block:(CCNode *)nodeA blockRemover:(CCNode *)nodeB {
    
    [self blockRemoved:(nodeA)];
    //    NSLog(@"BlockColission");
    return NO;
    
}

-(void)blockRemoved:(CCNode*) Block{
    [Block removeFromParent];
}

//
//- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair Powerup:(CCNode *)nodeA  wildcard:(CCNode *)nodeB {
//
//
//    if ([pair totalKineticEnergy]> 11000){
//        NSLog(@"ENERGY %f", [pair totalKineticEnergy]);
//        NSLog(@"IMPULSE %f", ccpLength([pair totalImpulse]));
//
//    }
//
//}



//Enemy Handline
- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair Powerup:(CCNode *)nodeA wildcard:(CCNode *)nodeB {
    
    float energy = [pair totalKineticEnergy];
    
    // if energy is large enough, remove the Enemy
    if (energy > 100000.f) {
        
        [self bombExplode:(nodeA)];
        
    }
}

- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair cBall:(Cannonball *)nodeA Powerup:(CCNode *)nodeB {
    [self bombExplode:(nodeB)];
    
}


//-(BOOL)noTouchCollision{
//
//}

-(void)upwardWind{
    _physicsNode.gravity = ccp(0, 10000);
    
}


- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair cBall:(Cannonball *)nodeA wildcard:(CCNode *)nodeB {
    
    
    
    
    // load particle effect and cast CCNode to CCParticleSystem
    CCParticleSystem *splash = (CCParticleSystem *)[CCBReader load:@"Explosion1"];
    // make the particle effect clean itself up, once it is completed
    splash.autoRemoveOnFinish = TRUE;
    
    //    CGPoint partPos = [ _gameplayNode convertToNodeSpace:(nodeA.position) ];
    // place the particle effect on the seals position
    splash.position = nodeA.position;
    // add the particle effect to the scene
    [nodeA.parent addChild:splash];
    
    [[_physicsNode space] addPostStepBlock:^{
        nodeA.bounceCount += 1;
        //        NSLog(@"bounce %i", nodeA.bounceCount);
        
        if (nodeA.bounceCount > 7) {
            
            
            [self cannonballRemoved: nodeA];
        }
    } key:nodeA];
    
}




- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair BoomBall:(CCNode *)nodeA wildcard:(CCNode *)nodeB {
    
    
    [self bombExplode:(nodeA)];
    //    [self colorSelect];
}

-(void)musicOff{
    musicButton.visible = false;
    musicButton.userInteractionEnabled = false;
    musicButton2.visible = true;
    musicButton2.userInteractionEnabled = true;
    [audio stopBg];
//    [audio paused];
}

-(void)musicOn{
    [audio playBg:@"NeonSmash.mp3" loop:TRUE];
    musicButton.visible = true;
    musicButton.userInteractionEnabled = true;
    musicButton2.visible = false;
    musicButton2.userInteractionEnabled = false;
}







-(void)bombExplode: (CCNode*) target{
    
    // load particle effect and cast CCNode to CCParticleSystem
    fire = (CCParticleSystem *)[CCBReader load:@"Explosion2"];
    
    //    fire.autoRemoveOnFinish = TRUE;
    
    if (soundButton.selected == false) {
        [explosion playEffect:@"Explosion.mp3" loop:false];
        
    }
    
    // make the particle effect clean itself up, once it is completed
    //    fire.autoRemoveOnFinish = TRUE;
    
    //    CGPoint partPos = [ _gameplayNode convertToNodeSpace:(nodeA.position) ];
    // place the particle effect on the seals position
    fire.position = target.position;
    // add the particle effect to the scene
    [target.parent addChild:fire];
    
    [[_physicsNode space] addPostStepBlock:^{
        
        
        
        [level1 gravPush: target];
        [level2 gravPush: target];
        
        [level3 gravPush: target];
        
        [level4 gravPush: target];
        
        [level5 gravPush: target];
        
        [level6 gravPush: target];
        
        [target removeFromParent];
        
        
    } key:target];
    
}


//Remove the enemy from the game
- (void)EnemyRemoved:(CCNode *)CircleEnemy {
    [CircleEnemy removeFromParent];
    
}

-(void)go
{
    if (    frenzyActive == true) {
        
        cannonActivated = false;
        _chargeCannonActivated = true;
        barShrinking = true;
        _goButton.selected=true;
        [self scheduleBlock:^(CCTimer *timer) {
            _chargeCannonActivated = false;
            cannonActivated = true;
            chargeBarVal = 0;
            _goButton.visible = true;
            barShrinking = false;
            _goButton.selected = false;
            
            
        } delay:5];
    }
    
    
}



- (void)update:(CCTime)delta{
    if (playingGame && !gameOver) {
        
    if (startingGame == true) {
        
        if (power <= powerM) {
            if (score < 10) {
                power += 1.6;
            }
            else if (score < 20) {
                power += 2.1;
            }
            else if (score < 32){
            power += 2.6;
            }
            else if (score < 43){
                power += 3.1;
            }
            else if (score < 52 ) {
                power += 3.5;
            }
            else if (score < 61){
                power += 3.7;
            }
            else {
                power+= 4.0;
            }
        }
        
        
            
        _powerBar.scaleX = power / (powerM);
        
        
        if (barShrinking == false) {
            
            
            if (chargeBarVal <= 20) {
                chargeBarVal += .02;
                _goButton.userInteractionEnabled = false;
                _goButton.visible = false;
                pressMe.visible = false;
                bombsCharging.visible = true;


                
            }
            
            else{
                bombsCharging.visible = false;

                _goButton.userInteractionEnabled = true;
                _goButton.visible = true;
                frenzyActive = true;
                pressMe.visible = true;

                
            }
        }
        else if (barShrinking == true){
            if (chargeBarVal > 0) {
                
                
                chargeBarVal -= .06;
            }
            
        }
        
        
        _chargeupBar.scaleX = chargeBarVal / 20;
    }
    else if (barShrinking == true){
        _chargeupBar.scaleX = !chargeBarVal / 20;
        
    }
    }
    
//    hue += .25;
//    hue = fmodf(hue, 360.f);
//    [self colorChange];
    fire.position = ccp(fire.position.x, fire.position.y +2);
    
    if (score < 13) {
        difficulty = 1;
    }
    
    else if (score < 23) {
        difficulty = 2;
        [mixpanel track:@"Level2"];

    }
    else if (score < 33) {
        difficulty = 3;
        [mixpanel track:@"Level3"];

    }
    else if (score < 40) {
        difficulty = 4;
        [mixpanel track:@"Level4"];

    }

    
    
    
    
    
    if (gameOver == false)
    {
        
        
        
        
        
        for (int i = 0; i < [_levelArray count]; i++) {
            int numberOutside = 0;
            
            CCNode *currentLevelNode = _levelArray[i];
            CCNode *currentNoTouch = _noTouchArray[i];
            Ring *currentRing = _ringArray [i];
            if (currentLevelNode.children.count > 1) {
                
                
                
                currentLevel = [currentLevelNode.children objectAtIndex:1];
                //            NSLog(@"currentLevel: %@", currentLevel);
                
                
                
                
                
                for (CCNode *child in [currentLevel getBlockGrouper].children){
                    
                    
                    
                    CGPoint currentNoTouchPosition = [currentNoTouch.parent convertToWorldSpace: currentNoTouch.position];
                    
                    currentNoTouchPosition = [_physicsNode convertToNodeSpace: currentNoTouchPosition];
                    
                    
                    
                    CGPoint childPosInNode = [child.parent convertToWorldSpace:(child.position)];
                    
                    childPosInNode = [_physicsNode convertToNodeSpace:childPosInNode];
                    
                    if ([currentLevelNode class] == [RightLevelNode class]) {
                        
                        
                        
                        float blockSquared = ( powf((childPosInNode.x - currentNoTouchPosition.x),2) + powf((childPosInNode.y - currentNoTouchPosition.y - 0.5*(currentLevelNode.contentSize.width-currentNoTouch.contentSize.width) ),2));
                        float blockz = sqrtf(blockSquared);
                        float radius = 126;
                        if (blockz > radius) {
                            numberOutside++;
                        }
                        
                    }
                    
                    else if ([currentLevelNode class] == [LeftLevelNode class]) {
                        
                        float blockSquared = ( powf((childPosInNode.x - currentNoTouchPosition.x),2) + powf((childPosInNode.y - currentNoTouchPosition.y + 0.5*(currentLevelNode.contentSize.width+currentNoTouch.contentSize.width) ),2));
                        float blockz = sqrtf(blockSquared);
                        float radius = 126;
                        if (blockz * .32 > radius) {
                            numberOutside++;
                        }
                        
                    }
                    
                }
                if (currentRing.ringChecked == false) {
                    
                    if (numberOutside > currentLevel.children.count *.86  ) {
                        //safe!
                        
                        currentRing.red = false;
                        
                        [currentRing runAnimation];
                        if (playingGame) {
                            
                            score ++;

                            [[[iAdHelper sharedHelper] bannerView] setHidden:YES];
                            [self cycleInterstitial];

                        }
                        if (soundButton.selected == false) {
                            [ping playEffect:@"ping.mp3" loop:false];
                        }
                        
                        _timeLabel.string = [NSString stringWithFormat:@"%i", score];
                        _timeLabel2.string = [NSString stringWithFormat:@"%i", score];
                        
                        CCParticleSystem *yay = (CCParticleSystem *)[CCBReader load:@"GreenParticleSystem"];
                        
                        yay.autoRemoveOnFinish = true;
                        
                        
                        [currentLevel addChild:yay];
                        //                        particleLoaded = true;
                        
                        yay.position = ccp( 0.05 * currentLevelNode.contentSize.width+currentNoTouch.contentSize.width , 0 );
                        yay.scale = 2.3;
                        
                        if (score > highScore) {
                            [[NSUserDefaults standardUserDefaults] setInteger: score forKey: @"highScore"];
                            
                            highScore = score;
                            
                            
                            
                            
                        }
                        
                        _highScoreLabel.string = [NSString stringWithFormat:@"%i", highScore];
                        _highScoreLabel2.string = [NSString stringWithFormat:@"%i", highScore];
                        
                        
                        
                        
                        //                    [GameData sharedInstance].coins +=10;
                        
                        
                        currentRing.ringChecked = true;
                    }
                    
                    
                }
            }
        }
        
        
        
        //Increase timer
        timeSinceStart += .06;
        if(_ominousFinger.visible == false){
            if (playingGame) {

            if (cameraSpeed <= 3.2) {
                
                
                
            
            cameraSpeed += .00061;

            }
            else if (cameraSpeed <= 4.5) {
                cameraSpeed += .00041;

            }
            else{
                cameraSpeed += .00021;

            }
            }
        }
        //Regenerate power with a cap
        
        
        if (playingGame) {
            
        
//        
//        if (power < 2) {
//            power += .05;
//        }
        
        
        
        
        
        
        //constantly update time and power labels
        
        //           _coinsLabel.string = [NSString stringWithFormat:@"Coins: %ld", (long)[GameData sharedInstance].coins];
        
        
        
        //        _coinsLabel.string = [NSString stringWithFormat:@"Health: %i", health];
        //        NSLog(@"health %i", health);
        
        //        _coinsLabel.visible = true;
        
        //        _boomNumLabel.visible = true;
        
        //        _boomNumLabel.string = [NSString stringWithFormat:@"%i", [GameData sharedInstance].boomNum ];
        
        
        _powerLabel.string = [NSString stringWithFormat:@"%ld", (long)power];
        _powerLabel.visible = true;
        }
        
        if (self.chargeCannonActivated) {
            if (touchingScreen) {
                swipeDuration = timeSinceStart - startTime;
                
                chargeValue = (swipeDuration * .2);
                _chargeBar.scaleX = (chargeValue);
                
            }
            else {
                _chargeBar.scaleX = 0;
                
            }
            
            
            
            
        }
        
        
        
        
        //move the _camera forwards at a constant speed.
        if (startingGame == true) {
            
            
            _camera.position = ccp (_camera.position.x,_camera.position.y + cameraSpeed);
        }
        
        _blockRemover.position = ccp(_blockRemover.position.x, (_blockRemover.position.y) - cameraSpeed);
        
        //Constantly be checking if levels need to be moved, and to move them if so.
        [self repositionLevel];
        
        for (int i = 0; i < _ringArray.count; i ++) {
            //make an enemy from the CircleEnemy class
            Ring *ring;
            //identify the enemy with where it is stored in the array to keep track of each distinct enemy
            ring = _ringArray [i];
            //set the variable enemyPosition of each enemy equal to THAT ENEMY's WORLD position
            CGPoint ringPositionInWorld = [ring convertToWorldSpace: ccp(0, 0)];
            // if the enemy is off the screen, delete it, decrease the health variable by 1, and log the health, and remove the enemy from the enemyArray.
            
            
            //            if (ringPositionInWorld.y < !SH)
            //            {
            //                if (ring.ringChecked == false)
            //
            //                {
            //                    if (ring.red ){
            //
            //                            health --;
            //
            //                        ring.ringChecked = true;
            //                        NSLog(@"ring checkd");
            //                    }
            //
            //
            //
            //                }
            
            //            }
        }
        
        
        
        
        
        
        
        //if cannonballs are on the screen,...
        if (_ballArray.count >= 1) {
            //loop through each individual ball, see if it's moving slowly, and remove it if so.
            for (int i = 0; i < _ballArray.count; i++) {
                
                Cannonball *_cannonball;
                _cannonball = _ballArray [i];
                CGPoint _cannonballPositionInWorld = [_cannonball convertToWorldSpace: ccp(0, 0)];
                CGPoint _gameplayPositionInWorld = [_gameplayNode convertToWorldSpace: ccp(0, 0)];
                
                //                    NSLog(@"cannon pos: %f", _cannonballPositionInWorld.x);
                if (_cannonballPositionInWorld.y < _gameplayPositionInWorld.y || _cannonballPositionInWorld.y > (_gameplayPositionInWorld.y + SH)) {
                    NSLog(@"Cball Removed: %f", _cannonballPositionInWorld.x);
                    
                    
                    [[_physicsNode space] addPostStepBlock:^{
                        //        NSLog(@"bounce %i", nodeA.bounceCount);
                        
                        
                        [self cannonballRemoved:_cannonball];
                        
                        
                    } key:_cannonball];
                    
                }
            }
        }
    }
}






//simply remove the cannonball both from the array tracking it and the physics node.
-(void)cannonballRemoved:(Cannonball*) _cannonball
{
    [_cannonball.parent removeChild:(_cannonball)];
    [_ballArray removeObject:(_cannonball)];
}

#pragma mark button handling
- (void)activateCannon {
    laserActivated = FALSE;
    cannonActivated = true;
    _laserButton.selected = FALSE;
    self.chargeCannonActivated = false;
    _chargeCannonButton.selected = FALSE;
    _cannonButton.selected = true ;
    earthquakeActive = false;
    _quakeButton.selected = false;
    
    
    
}
-(void)pause{
    [mixpanel track:@"PauseButton"];

    if (!gameOver) {
        
    
    if (playingGame) {
        [self tutorialVanish];
    
    
    [[self animationManager] runAnimationsForSequenceNamed:@"pause"];
    gameOver = true;
    _physicsNode.paused = true;
    //    playingGame = !playingGame;
    //        pauseMenuOpen = true;
    //        self.paused = true;
    
    
    
    
    //        self.paused = false;
    //
    //        pauseMenuOpen = false;
    //
    //        [_gameplayNode removeChild:(pauseDialogue)];
    //
    }
    }
}

-(void)resumeButton{
    [mixpanel track:@"resume"];

    //    self.paused = !self.paused;
    //    [_gameplayNode removeChild:(pauseDialogue)];
    _physicsNode.paused = false;
    
    
    
    
    [[self animationManager] runAnimationsForSequenceNamed:@"unPause"];
    
    
    [self performSelector:@selector(unPause)withObject:self afterDelay:.4];
    
    gameOver = false;
    
    
    
}

-(void)unPause{
    [[self animationManager] runAnimationsForSequenceNamed:@"Default Timeline"];
    //    playingGame = !playingGame;
}

-(void)play{
    [mixpanel track:@"PlayButton"];

    playingGame = true;
    [self retry];
}

-(void)disableAllBallButtons{
    ballButton1.enabled = false;
    ballButton2.enabled = false;
    ballButton3.enabled = false;
    ballButton4.enabled = false;
    ballButton5.enabled = false;
    ballButton6.enabled = false;
}

-(void)creditsLoad{
    
    [[self animationManager] runAnimationsForSequenceNamed:@"credits"];
    buyMenu.visible=true;
    buyMenu.userInteractionEnabled = true;
    self.tutorialVanish;
    [_gameplayNode removeChild:(menu)];
    playingGame = false;
}
-(void)shopLoad{
    [mixpanel track:@"ShopButton"];

    
    [self disableAllBallButtons];
    
    //    ballButton1.backgroundColorForState = true
    playingGame = false;
    if (areAdsRemoved) {
        ballButton1.enabled = true;
        ballButton2.enabled = true;
        ballButton3.enabled = true;
        ballButton4.enabled = true;
        ballButton5.enabled = true;
        ballButton6.enabled = true;
    }
     else if (highScore >= 120){
        ballButton1.enabled = true;
        ballButton2.enabled = true;
        ballButton3.enabled = true;
        ballButton4.enabled = true;
        ballButton5.enabled = true;
        ballButton6.enabled = true;

        
    }
     else if (highScore >= 100){
         ballButton1.enabled = true;
         ballButton2.enabled = true;
         ballButton3.enabled = true;
         ballButton4.enabled = true;
         ballButton5.enabled = true;
         
     }
     else if (highScore >= 80){
         ballButton1.enabled = true;
         ballButton2.enabled = true;
         ballButton3.enabled = true;
         ballButton4.enabled = true;
         
     }
     else if (highScore >= 60){
         ballButton1.enabled = true;
         ballButton2.enabled = true;
         ballButton3.enabled = true;
         
     }
    
     else if (highScore >= 40){
         ballButton1.enabled = true;
         ballButton2.enabled = true;
         
     }
    
    else if (highScore >= 20) {
        ballButton1.enabled = true;
    }
    else {
        [self disableAllBallButtons];
    }


    
  
    
    
    [[self animationManager] runAnimationsForSequenceNamed:@"buy"];
    buyMenu.visible=true;
    buyMenu.userInteractionEnabled = true;
    self.tutorialVanish;
    [_gameplayNode removeChild:(menu)];
    playingGame = false;
    
    if (areAdsRemoved){
        removeAdsButton.visible = false;
        removeAdsButton.userInteractionEnabled = false;
    }
    
}

-(void)quake {
    _quakeButton.selected = true;
    earthquakeActive = true;
    laserActivated = FALSE;
    cannonActivated = false;
    _chargeCannonButton.selected = FALSE;
    _cannonButton.selected = false ;
    
    
    
    
    
}

-(void) loseHealth
{
    if (gameHasBeenOpened == false) {
        [[self animationManager] runAnimationsForSequenceNamed:@"pain"];
        if (soundButton.selected == false) {
            [ow playEffect:@"OW.mp3" loop:false];
        }
        
        
        health --;
        if (health == 2) {
            _heart1.visible = false;
        }
        else if (health == 1){
            _heart2.visible = false;
        }
        else if (health == 0)
        {
            _heart3.visible = false;
        }
        
        
        if (health <= 0) {
            timesPlayed ++;
            if (timesPlayed == 10) {
                [mixpanel track:@"10Times"];
                
            }
            else if (timesPlayed == 20){
                [mixpanel track:@"20Times"];
                
            }
            else if (timesPlayed == 30){
                [mixpanel track:@"30Times"];
            }
            else if (timesPlayed == 40){
                [mixpanel track:@"40Times"];
            }
            else if (timesPlayed == 50){
                [mixpanel track:@"50Times"];
            }
            else if (timesPlayed == 75){
                [mixpanel track:@"75Times"];
            }
            else if (timesPlayed == 100){
                [mixpanel track:@"100!"];
            }
            [[self animationManager] runAnimationsForSequenceNamed:@"gameOver"];
            [[NSUserDefaults standardUserDefaults] setInteger: timesPlayed forKey: @"timesPlayed"];
            [self checkToPresentAd];

            
            //            [self performSelector:@selector(stay2)withObject:self afterDelay:1];
            
            
            gameOver = true;
            
           
            if (areAdsRemoved) {
                
                
                [[[iAdHelper sharedHelper] bannerView] setHidden:YES];
            }
            else {
                [[[iAdHelper sharedHelper] bannerView] setHidden:NO];
                
            }

            playingGame = false;
        }
        
    }
}


-(void) colorChange {
    //    float hue = _colorSlider.sliderValue*360.f;
    CCColor *hueColor = [CCColor alloc];
    hueColor = [hueColor initWithHue:hue saturation:.25 brightness:0.25 alpha:1.f];
    _background.color = hueColor;
    
}

-(void) colorSelect {
    //    float hue = _colorSlider.sliderValue*360.f;
    //    CCColor *hueColor = [CCColor alloc];
    //    hueColor = [hueColor initWithHue:hue saturation:1.f brightness:1.f alpha:1.f];
    //    _background.color = hueColor;
    
}

//called when retry button is hit
- (void)retry {
    // reload this level
    self.userInteractionEnabled = NO;
    CCScene *newGameplay = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:newGameplay];
//    self->playingGame = true;
//    pauseButton.enabled = true;
        
    //    [menu removeFromParent];
}

//called when chargeCannon button is hit
-(void)chargeCannon {
    [mixpanel track:@"ChargeCannon"];

    //set cannon to off
    cannonActivated = false;
    //make the chargeCannon activated. it needs the self because chargeCannon acivated is a property
    self.chargeCannonActivated = true;
    laserActivated = FALSE;
    _cannonButton.selected = FALSE;
    _laserButton.selected = FALSE;
    earthquakeActive = false;
    _quakeButton.selected = false;
    
    
    
}

-(void)MainMenuLoad{
    [mixpanel track:@"mainmenu"];

    
    
    
    
    [GameData sharedInstance].gameHasBeenOpened =  true;
    
    //    [AppController instanceOfGPlay].gameHasBeenOpened = true;
    //
    //    return [CCBReader loadAsScene:@"Gameplay"];
    //
    
    
    [GameData sharedInstance].gameHasBeenOpened =  true;
    CCScene *restartGameplay = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:restartGameplay];
    
}

//-(void)shopLoad{
//    LoseDialogue *shop = (LoseDialogue*)[CCBReader load:(@"Shop")];
//    [_gameplayNode addChild:(shop)];
//}

-(void)checkToPresentAd{
    NSLog(@"times %d",timesPlayed);

    if (!areAdsRemoved) {
        
    
    if ((timesPlayed %  3 == 0)){
        NSLog(@"times %d",timesPlayed);
        [self presentInterlude];
    }
    }
}

-(void)repositionLevel





{
    
    //    }
    //    else if (score > 200){
    //        difficulty = 2;
    //    }
    //    else if (score > 300) {
    //        difficulty = 2;
    //    }
    int levelNumber = arc4random_uniform(5) +1;
    
    
    
    for (int i = 0; i<6; i++) {
        CCNode *levelHolder = _levelArray[i];
        Ring *ring = _ringArray[i];
        
        //        float levelHolderYPosition = [_camera convertToNodeSpace:[_physicsNode convertToWorldSpace:(levelHolder.position)]].y;
        //        if (levelHolderYPosition < - (levelHolder.contentSize.width * 1.18)+SH/2)
        //        if ([_physicsNode convertToWorldSpace:(levelHolder.position)].y < _camera.position.y - (levelHolder.contentSize.width * 1.18)+SH)
        float levelYPos = [levelHolder convertToWorldSpace:ccp(0,0)].y;
        if (i<3) {
            levelYPos+=300;
            
        }
        if (levelYPos < _gameplayNode.position.y - (levelHolder.contentSize.width * 1)+SH)
        {
            levelHolder.position = ccp( levelHolder.position.x , levelHolder.position.y + levelHolder.contentSize.width*3 );
            //            levelHolder.position=ccp(levelHolder.position.x,levelHolder.position.y+1);
//            NSLog(@"leevle remv");
            if (i == 2) {
                [levelHolder removeChild:level3];
                level3 = (Level*)[CCBReader load:[NSString stringWithFormat:@"Levels/%i/%i", difficulty, levelNumber]];
                level3.leftNode = false;
                
                if (ring.red) {
                    [self loseHealth];

                }
                ring.red = true;
                ring.ringChecked = false;

                [ring runAnimation2];

                
                
                
                
                [levelHolder addChild:level3];
                
                
                for (CCNode *child in level3.children) {
                    if ([child isKindOfClass:[Blocks class]]) {
                        ((Blocks*)child).gameplayLayer= self;
                    }
                    
                    
                    
                }
            }
            
            
            
            else if (i==1) {
                [levelHolder removeChild:level2];
                level2 = (Level*)[CCBReader load:[NSString stringWithFormat:@"Levels/%i/%i", difficulty, levelNumber]];
                
                
                
                
                if (ring.red) {
                    [self loseHealth];
                }

                ring.red = true;
                ring.ringChecked = false;
                [ring runAnimation2];

                
                [levelHolder addChild:level2];
                level2.leftNode = false;
                
                
                for (CCNode *child in level2.children) {
                    if ([child isKindOfClass:[Blocks class]]) {
                        ((Blocks*)child).gameplayLayer= self;
                    }
                    
                    
                }
                
                
            }
            
            else if (i == 0){
                [levelHolder removeChild:level1];
                level1 = (Level*)[CCBReader load:[NSString stringWithFormat:@"Levels/%i/%i", difficulty, levelNumber]];
                
                level1.leftNode = false;
                
                
                
                if (ring.red) {
                    [self loseHealth];
                }
                
                
                ring.red = true;
                ring.ringChecked = false;
                [ring runAnimation2];

                
                [levelHolder addChild:level1];
                
                for (CCNode *child in level1.children) {
                    if ([child isKindOfClass:[Blocks class]]) {
                        ((Blocks*)child).gameplayLayer= self;
                    }
                    
                    
                }
            }
            else if (i == 3){
                [levelHolder removeChild:level4];
                level4 = (Level*)[CCBReader load:[NSString stringWithFormat:@"Levels/%i/%i", difficulty, levelNumber]];
                
                level4.leftNode = true;
                
                if (ring.red) {
                    [self loseHealth];
                }
                
                ring.red = true;
                ring.ringChecked = false;
                [ring runAnimation2];

                [levelHolder addChild:level4];
                
                for (CCNode *child in level4.children) {
                    if ([child isKindOfClass:[Blocks class]]) {
                        ((Blocks*)child).gameplayLayer= self;
                    }
                    
                    
                }
            }
            else if (i == 4){
                [levelHolder removeChild:level5];
                level5 = (Level*)[CCBReader load:[NSString stringWithFormat:@"Levels/%i/%i", difficulty, levelNumber]];
                if (ring.red) {
                    [self loseHealth];
                }

                
                ring.red = true;
                ring.ringChecked = false;
                [ring runAnimation2];

                [levelHolder addChild:level5];
                level5.leftNode = true;
                
                
                
                
                for (CCNode *child in level5.children) {
                    if ([child isKindOfClass:[Blocks class]]) {
                        ((Blocks*)child).gameplayLayer= self;
                    }
                    
                    
                }
            }
            else if (i == 5){
                [levelHolder removeChild:level6];
                level6 = (Level*)[CCBReader load:[NSString stringWithFormat:@"Levels/%i/%i", difficulty, levelNumber]];
                level6.leftNode = true;
                if (ring.red) {
                    [self loseHealth];
                }

                ring.red = true;
                ring.ringChecked = false;
                [ring runAnimation2];

                
                [levelHolder addChild:level6];
                
                
                
                
                for (CCNode *child in level6.children) {
                    if ([child isKindOfClass:[Blocks class]]) {
                        ((Blocks*)child).gameplayLayer= self;
                    }
                    
                    
                }
            }
            
            else {
                NSLog(@"DEATH");
            }
        }
        
    }
    
    //MARK:IADS
    
    
    
    
    
    
    
    
}
-(void)interstitialAd:(ADInterstitialAd *)interstitialAd didFailWithError:(NSError *)error {
    interstitial = nil;
    //    [interstitialAd release];
    //    [ADInterstitialAd release];
//    requestingAd = NO;
    NSLog(@"interstitialAd didFailWithERROR");
    NSLog(@"%@", error);
}

//-(void)interstitialAdDidLoad:(ADInterstitialAd *)interstitialAd {
//    NSLog(@"interstitialAdDidLOAD");
//    if (interstitialAd != nil && interstitial != nil && requestingAd == YES) {
//        [interstitial presentInView:self.view];
//        NSLog(@"interstitialAdDidPRESENT");
//    }//end if
//}

//-(void)interstitialAdDidUnload:(ADInterstitialAd *)interstitialAd {
//    interstitial = nil;
//    //    [interstitialAd release];
//    //    [ADInterstitialAd release];
////    requestingAd = NO;
//    NSLog(@"interstitialAdDidUNLOAD");
//    
//    
//}
- (void)interstitialAdDidUnload:(ADInterstitialAd *)interstitialAd
{
    [self cycleInterstitial];
 
}

-(void)interstitialAdActionDidFinish:(ADInterstitialAd *)interstitialAd {
//    [self bannerViewActionDidFinish:interstitialAd];
//}
    interstitial = nil;
    //        [interstitialAd release];
    //        [ADInterstitialAd release];
//    requestingAd = NO;
//    NSLog(@"interstitialAdDidFINISH");
//    [adViewController removeFromParentViewController];
//        [self retry];
//    [adViewController.view removeFromSuperview];
//    
//    CCScene *newGameplay = [CCBReader loadAsScene:@"Gameplay"];
//    [[CCDirector sharedDirector] replaceScene:newGameplay];
    [app.navController popToRootViewControllerAnimated:YES];


}




@end
