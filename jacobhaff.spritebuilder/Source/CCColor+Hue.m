//
//  CCColor+Hue.m
//  jacobhaff
//
//  Created by Jacob Haff on 8/13/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCColor+Hue.h"

@implementation CCColor (Hue)


- (CCColor*) initWithHue:(float)hue saturation:(float)saturation brightness:(float)brightness alpha:(float)alpha
{
	self = [super init];
	if (!self) return nil;
	
	float chroma = saturation * brightness;
	float hueSection = hue / 60.0f;
	float X = chroma *  (1.0f - ABS(fmod(hueSection, 2.0f) - 1.0f));
	ccColor4F rgb;
	if(hueSection < 1.0) {
		rgb.r = chroma;
		rgb.g = X;
	} else if(hueSection < 2.0) {
		rgb.r = X;
		rgb.g = chroma;
	} else if(hueSection < 3.0) {
		rgb.g = chroma;
		rgb.b = X;
	} else if(hueSection < 4.0) {
		rgb.g= X;
		rgb.b = chroma;
	} else if(hueSection < 5.0) {
		rgb.r = X;
		rgb.b = chroma;
	} else if(hueSection <= 6.0){
		rgb.r = chroma;
		rgb.b = X;
	}
    
	float Min = brightness - chroma;
    
	rgb.r += Min;
	rgb.g += Min;
	rgb.b += Min;
	rgb.a = alpha;
    
	return [CCColor colorWithCcColor4f:rgb];
}


@end
