

#import <MapKit/MapKit.h>

@class GIKCalloutAnnotation;

@interface GIKAnnotation : NSObject <MKAnnotation> {
	CLLocationDegrees latitude;
	CLLocationDegrees longitude;
	
	GIKCalloutAnnotation *callout;
}

@property (nonatomic, strong) GIKCalloutAnnotation *callout;

- (id)initWithLatitude:(CLLocationDegrees)theLatitude longitude:(CLLocationDegrees)theLongitude;
- (void)setCoordinate:(CLLocationCoordinate2D)theCoordinate;

@end
