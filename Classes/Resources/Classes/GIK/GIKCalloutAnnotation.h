

#import <MapKit/MapKit.h>

@interface GIKCalloutAnnotation : NSObject <MKAnnotation> {
	CLLocationCoordinate2D coordinate;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithLocation:(CLLocationCoordinate2D)theCoordinate;

@end
