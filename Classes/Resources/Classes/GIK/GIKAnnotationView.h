

#import <MapKit/MapKit.h>


@interface GIKAnnotationView : MKAnnotationView {
	BOOL selectionEnabled; // State flag to allow/prevent the callout's parent annotation view from being deselected.
}

@property (nonatomic, assign, getter=isSelectionEnabled) BOOL selectionEnabled;

@end
