//
//  HotelAnnotation.m
//  AnimatedCallout
//
//  Created by Gordon on 2/14/11.
//  Copyright 2011 GeeksInKilts. All rights reserved.
//

#import "HotelAnnotation.h"
#import "Hotel.h"

@interface HotelAnnotation ()

@end


@implementation HotelAnnotation
@synthesize hotel;


-(BOOL)shouldAutorotate
{
    if (UIInterfaceOrientationIsLandscape( [[UIDevice currentDevice] orientation])) {
        return  YES;
    }
    else
        return NO;
}
- (id)initWithLatitude:(CLLocationDegrees)theLatitude longitude:(CLLocationDegrees)theLongitude {
	if (!(self = [super initWithLatitude:theLatitude longitude:theLongitude])) {
		return nil;
	}
	
	return self;
}

- (NSString *)title {
	return [self.hotel name];
}

@end
