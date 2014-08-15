//
//  SDMapViewController.m
//  SimpleDrawing
//
//  Created by Nathanial Woolls on 10/22/12.
//

// This code is distributed under the terms and conditions of the MIT license.

// Copyright (c) 2012 Nathanial Woolls
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "SDMapViewController.h"

#import "SDMapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "SDMapAnnotation.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>

@interface SDMapViewController () <UISearchBarDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) CLGeocoder *geocoder;
#pragma mark - IBOutlets

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomToolbar;
@property(weak,nonatomic)IBOutlet UIButton *btnSearch;


@end

@implementation SDMapViewController
@synthesize locationManager;

- (UIImage*)imageOfMap {
    
    UIGraphicsBeginImageContextWithOptions(((UIView*)self.mapView).frame.size, NO, 0.0);
    [self.mapView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
    
}

- (void)dismissKeyboard {
    
    for(UIView *subView in self.searchBar.subviews) {
        if ([subView isKindOfClass:[UITextField class]]) {
            UITextField *searchField = (UITextField *)subView;
            [searchField resignFirstResponder];
        }
    }
    
}

- (void)showErrorHUD:(NSString*)message {
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_error.png"]];
    
    // Set custom view mode
    hud.mode = MBProgressHUDModeCustomView;
    
    hud.labelText = message;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud show:YES];
    [hud hide:YES afterDelay:2.0];
    
}

- (void)showCoordinateOnMapView:(CLLocationCoordinate2D)coordinate withAddress:(NSString*)address {
    
    SDMapAnnotation *annotation = [[SDMapAnnotation alloc] initWithCoordinate:coordinate andTitle:address];
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.2;
    span.longitudeDelta = 0.2;
    
    region.span = span;
    region.center = coordinate;
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self.mapView addAnnotation:annotation];
    [self.mapView setRegion:region animated:TRUE];
    [self.mapView regionThatFits:region];
    
}

#pragma mark - IBActions

- (IBAction)cancelTapped:(id)sender {
    
    [self.delegate viewController:self wasDismissed:NO];
    
    [self dismissModalViewControllerAnimated:YES];
    
}

- (IBAction)doneTapped:(id)sender {
    
    [self.delegate viewController:self wasDismissed:YES];
    
    [self dismissModalViewControllerAnimated:YES];
    
}
-(IBAction)showCurrentLocation:(id)sender
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];

}
-(void)locationDetails:(NSString*)latitudecode longitudeVal:(NSString*)longitudecode{
    CLLocationCoordinate2D cordinates;
    cordinates.latitude = [latitudecode floatValue];
    cordinates.longitude = [longitudecode floatValue];
    
    CLLocation *location = [[CLLocation alloc] initWithCoordinate:cordinates altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
    
    _geocoder = [[CLGeocoder alloc] init];
    
    [self.geocoder reverseGeocodeLocation: location completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         
         if (error) {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                             message:@"Cannot determined the address"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
             
             [alert show];
             
         }
         else
         {
             
             //Get address
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             
             NSLog(@"Placemark array: %@",placemark.addressDictionary );
             
             //String to address
             NSString *locatedaddress = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             
             //Print the location in the console
             NSLog(@"Currently address is: %@",locatedaddress);
             //lblLocationDetails.text = locatedaddress;
             [self showCoordinateOnMapView:cordinates withAddress:locatedaddress];
         }
         
         
     }];
    
}
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    NSLog(@"StartingStartingStartingStartingStarting");
    CLLocationCoordinate2D coordinate = [newLocation coordinate];
    [self.locationManager stopUpdatingLocation];
   NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
   NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    
    
    [self locationDetails:latitude longitudeVal:longitude];
    //[self gotoNextView];
    //goto step3
    
}

- (void)locationManager: (CLLocationManager *)manager
       didFailWithError: (NSError *)error
{
    [manager stopUpdatingLocation];
   
    NSLog(@"error%@",error);
    switch([error code])
    {
        case kCLErrorNetwork: // general, network-related error
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"please check your network connection or that you are not in airplane mode" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
        }
            break;
        case kCLErrorDenied:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"user has denied to use current Location.Please turn on location services. " delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
        }
            break;
        default:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"unknown network error" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
        }
            break;
    }
}




- (IBAction)mapStyleSegmentChanged:(id)sender {
    
    UISegmentedControl *segmentedControl = (UISegmentedControl*)sender;
    
    if (segmentedControl.selectedSegmentIndex == 0) {
        self.mapView.mapType = MKMapTypeStandard;
    } else if (segmentedControl.selectedSegmentIndex == 1) {
        self.mapView.mapType = MKMapTypeSatellite;
    } else if (segmentedControl.selectedSegmentIndex == 2) {
        self.mapView.mapType = MKMapTypeHybrid;
    }
    
}

#pragma mark - Keyboard handling

//allow the kb to be dismissed even though this is a modal form
- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

#pragma mark - UISearchBar delegate

-(IBAction)searchAddr:(id)sender
{
    [self searchBarSearchButtonClicked:self.searchBar];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSString *address = searchBar.text;
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {

        if (error) {            
            [self showErrorHUD:@"Not Found"];            
            return;
        }
        
        CLPlacemark *placemark = placemarks[0];                
        [self showCoordinateOnMapView:placemark.region.center withAddress:address];
        
        [self dismissKeyboard];
        
    }];
    
}

#pragma mark - Memory management

- (void)viewDidUnload {
    
    [self setMapView:nil];
    [self setSearchBar:nil];
    [self setBottomToolbar:nil];
    
    [super viewDidUnload];
    
}
-(void)viewDidLoad
{
    UIImage *buttonImageSave= [[UIImage imageNamed:@"whiteButton.png"]
                               resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlightSave = [[UIImage imageNamed:@"whiteButtonHighlight.png"]
                                         resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    [self.btnSearch setBackgroundImage:buttonImageSave forState:UIControlStateNormal]
    ;
    [self.btnSearch setBackgroundImage:buttonImageHighlightSave forState:UIControlStateHighlighted];
    [super viewDidLoad];
}

@end
