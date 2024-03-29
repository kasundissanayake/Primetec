//
//  GIKPinAnnotationView.m
//  AnimatedCallout
//
//  Created by Gordon on 2/15/11.
//  Copyright 2011 GeeksInKilts. All rights reserved.
//

#import "GIKPinAnnotationView.h"


@implementation GIKPinAnnotationView
@synthesize selectionEnabled;


- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
	if (!(self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier])) {
		return nil;
	}
	
	[self setCanShowCallout:NO]; // We want to show our own callout.

	//[self setAnimatesDrop:NO];

	[self setSelectionEnabled:YES];
	
	return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	if (self.selectionEnabled) {
		[super setSelected:selected animated:animated];
        
        //newly added
        self.image = [UIImage imageNamed:@"map_pincopy.png"];
	}
}

- (BOOL)isSelectionEnabled {
	return selectionEnabled;
}

@end
