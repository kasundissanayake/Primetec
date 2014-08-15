

#import "GIKCalloutAnnotation.h"

@implementation GIKCalloutAnnotation

@synthesize coordinate;

- (id)initWithLocation:(CLLocationCoordinate2D)theCoordinate {
	if (!(self = [super init])) {
		return nil;
	}
	
	coordinate = theCoordinate;
	return self;
}
@end
