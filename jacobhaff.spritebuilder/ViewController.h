//
//  ViewController.h
//  jacobhaff
//
//  Created by Jacob Haff on 7/8/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/ADInterstitialAd.h>


@interface ViewController : UIViewController <ADInterstitialAdDelegate> {
    
    

    
    ADInterstitialAd *interstitial;
    BOOL requestingAd;
    


}

-(void)showFullScreenAd;


@end

