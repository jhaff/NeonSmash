//
//  ViewController.m
//  jacobhaff
//
//  Created by Jacob Haff on 7/8/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "ViewController.h"
#import <iAd/ADInterstitialAd.h>
#import <iAd/UIViewControlleriAdAdditions.h>


@implementation ViewController

    -(void)viewDidLoad {
    requestingAd = NO;
        
        if (interstitial.loaded)
        {
            [interstitial presentFromViewController:self];
        }
    }

    //Interstitial iAd
    -(void) showFullScreenAd {
        //Check if already requesting ad
        if (requestingAd == NO) {
    //        [ADInterstitialAd release];
            interstitial = [[ADInterstitialAd alloc] init];
            interstitial.delegate = self;
            self.interstitialPresentationPolicy = ADInterstitialPresentationPolicyManual;
            [self requestInterstitialAdPresentation];
            NSLog(@"interstitialAdREQUEST");
            requestingAd = YES;
        }//end if
    }

    -(void)interstitialAd:(ADInterstitialAd *)interstitialAd didFailWithError:(NSError *)error {
        interstitial = nil;
    //    [interstitialAd release];
    //    [ADInterstitialAd release];
        requestingAd = NO;
        NSLog(@"interstitialAd didFailWithERROR");
        NSLog(@"%@", error);
    }

    -(void)interstitialAdDidLoad:(ADInterstitialAd *)interstitialAd {
        NSLog(@"interstitialAdDidLOAD");
        if (interstitialAd != nil && interstitial != nil && requestingAd == YES) {
    [interstitial presentInView:self.view];
            NSLog(@"interstitialAdDidPRESENT");
        }//end if
    }

    -(void)interstitialAdDidUnload:(ADInterstitialAd *)interstitialAd {
        interstitial = nil;
    //    [interstitialAd release];
    //    [ADInterstitialAd release];
        requestingAd = NO;
        NSLog(@"interstitialAdDidUNLOAD");
    }

    -(void)interstitialAdActionDidFinish:(ADInterstitialAd *)interstitialAd {
        interstitial = nil;
//        [interstitialAd release];
//        [ADInterstitialAd release];
        requestingAd = NO;
        NSLog(@"interstitialAdDidFINISH");
    
}

@end
