#import "FirstViewController.h"
#import "Hotel.h"
#import "HotelAnnotation.h"
#import "HotelDetailViewController.h"
#import "ComplianceViewController.h"
#import "TabAndSplitAppAppDelegate.h"
#import "Dashboard.h"
#import "SearchProject.h"
#import "PopUpViewController.h"
#import "TapHereSubViewController.h"
#import "GIKPinAnnotationView.h"
#import "Reachability.h"
#import "PRIMECMController.h"
#import "PRIMECMAPPUtils.h"
#import "RootVC.h"

#define METERS_PER_MILE 1609.344

@interface FirstViewController ()
{
    NSMutableArray *hotelAnnotations;
    UITableView *tblView;
    NSArray *tableData;
    UIViewController *popoverContent;
    TabAndSplitAppAppDelegate *appDelegate;
    NSString *addPinsTrue;
    CLGeocoder *_geocoder;
    UIImage *newImage;
    UIButton *btnCloseAddImage;
    BOOL foundImage;
    NSMutableArray *arrayImages;
    int foundIndex;
    UIBarButtonItem *Button;
    UIBarButtonItem *Done;
    NSUserDefaults *defaults;
    double latitude;
    double longitude;
    BOOL isDisplayBottomBar;
    UIView *bottomView;
    UIBarButtonItem *btnMapType;
    BOOL isMapTypes;
    NSArray *menuItems;
    UIPopoverController *popMap;
    UIPopoverController *popMenu;
    NSMutableArray *hotels;
    NSMutableData *_receivedData;
    NSURLResponse *_receivedResponse;
    NSError *_connectionError;
    NSArray *resPonse;
}


@property (nonatomic, strong) NSArray *hotels;
- (void)showAnnotations;
@end

@implementation FirstViewController
@synthesize hotels;
@synthesize mapId;
@synthesize detailedNavigationController;
@synthesize imageSubView;
@synthesize viewTapHere;
@synthesize hud;

- (id)init {
	if (!(self = [super initWithNibName:@"GIKMapView" bundle:nil])) {
		return nil;
	}
	return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    defaults=[NSUserDefaults standardUserDefaults];
    addPinsTrue = @"0";
    isDisplayBottomBar=NO;
    isMapTypes=NO;
    bottomView =[[UIView alloc] init];
    appDelegate=(TabAndSplitAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    tblView=[[UITableView alloc] initWithFrame:CGRectMake(265, 580, 0, 0) style:UITableViewStyleGrouped];
    hotels=[[NSMutableArray alloc]init];
    popoverContent=[[UIViewController alloc] init];
    
    //loadAnnotations
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMapData:) name:@"ViewControllerAReloadData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeToolBar) name:@"changeMapToolBar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addMapGesture) name:@"addMapGesture" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAnnotations) name:@"loadAnnotations" object:nil];
    
    Button = [[UIBarButtonItem alloc]
              initWithTitle:NSLocalizedString(@"Menu", @"")
              style:UIBarButtonItemStyleDone
              target:self
              action:@selector(selectItem:)];
    
    Done = [[UIBarButtonItem alloc]
            initWithTitle:NSLocalizedString(@"Done", @"")
            style:UIBarButtonItemStyleDone
            target:self
            action:@selector(addNewMapPoint:)];
    btnMapType = [[UIBarButtonItem alloc]
                  initWithTitle:NSLocalizedString(@"Maps", @"")
                  style:UIBarButtonItemStyleDone
                  target:self
                  action:@selector(selectMapType:)];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.rightBarButtonItem = Button;
    self.navigationItem.leftBarButtonItem = btnMapType;
    
    // Coordinates for part of downtown San Francisco - around Moscone West, no less.
    MKCoordinateRegion startupRegion;
	startupRegion.center = CLLocationCoordinate2DMake(41.650639, -72.665895);
	startupRegion.span = MKCoordinateSpanMake(0.003515, 0.007129);
	[self.mapView setRegion:startupRegion animated:YES];
	[self.mapView setShowsUserLocation:YES];
    
	self.detailDataSource = self;
	HotelDetailViewController *controller = [[HotelDetailViewController alloc] initWithNibName:@"HotelDetailTableView" bundle:nil];
	self.calloutDetailController = controller;
	
    [self showAnnotations];
    
    if([appDelegate.userType isEqualToString:@"R"] || [appDelegate.userTypeOffline isEqualToString:@"R"])
    {
        menuItems = [NSArray arrayWithObjects:@"Dashboard", @"Add Project", @"Sign Out", @"Help", @"Sync" , nil];
    }
    else
    {
        menuItems = [NSArray arrayWithObjects:@"Dashboard", @"Sign Out", @"Help", @"Sync" , nil];
    }
}

- (void)showInfoAlert {
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.navigationController.view addSubview:hud];
    hud.labelText=@"";
    hud.dimBackground = YES;
    hud.delegate = self;
    hud.userInteractionEnabled = false;
    [hud show:true];
}

- (void)hudWasHidden {
    [self.hud hide:YES];
}


- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}


-(IBAction)selectMapType:(id)sender
{
    isMapTypes=YES;
    tableData = [NSArray arrayWithObjects:@"Standard", @"Satellite", @"Hybrid", @"Locate", nil];
    [tblView reloadData];
    UIView *popoverView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 300)];
    popoverView.backgroundColor=[UIColor whiteColor];
    popoverContent.view=popoverView;
    popoverContent.preferredContentSize=CGSizeMake(250, 250);
    popoverContent.view=tblView; //Adding tableView to popover
    tblView.delegate=self;
    tblView.dataSource=self;
    popMenu=[[UIPopoverController alloc]initWithContentViewController:popoverContent];
    [popMenu presentPopoverFromBarButtonItem:(UIBarButtonItem *)sender
                    permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [popMap dismissPopoverAnimated:YES];
}


-(void)addMapGesture
{
    addPinsTrue = @"1";
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    tgr.numberOfTapsRequired = 1;
    [mapView addGestureRecognizer:tgr];
    
}


-(IBAction)addNewMapPoint:(id)sender
{
    self.mapView.userInteractionEnabled = YES;
    Hotel *theHotel = [[Hotel alloc] init];
    theHotel.projID = [defaults objectForKey:@"Project Id"];
    theHotel.projName = [defaults objectForKey:@"Project Name"];
    theHotel.street = [defaults objectForKey:@"Street"];
    theHotel.city = [defaults objectForKey:@"City"];
    theHotel.state = [defaults objectForKey:@"State"];
    theHotel.zip = [defaults objectForKey:@"Zip"];
    theHotel.phone = [defaults objectForKey:@"Phone No"];
    theHotel.url = [defaults objectForKey:@"Url"];
    theHotel.latitude = latitude;
    theHotel.longitude = longitude;
    HotelAnnotation *annotation = [[HotelAnnotation alloc] initWithLatitude:theHotel.latitude longitude:theHotel.longitude];
    annotation.hotel = theHotel;
    [self.mapView addAnnotation:annotation];
    [self saveNewProject];
}


-(void)saveNewProject
{
    /*
    if([self connected]){
        NSString *strURL = [NSString stringWithFormat:@"%@/api/project/create/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%f/%f/%@/", [PRIMECMAPPUtils getAPIEndpoint],
                            appDelegate.username,[defaults objectForKey:@"Project Id"],[defaults objectForKey:@"Phone No"],[defaults objectForKey:@"Project Name"],[defaults objectForKey:@"Project Description"],[defaults objectForKey:@"Project Title"],[defaults objectForKey:@"Street"],[defaults objectForKey:@"City"],[defaults objectForKey:@"State"],[defaults objectForKey:@"Zip"],[defaults objectForKey:@"Phone No"],[defaults objectForKey:@"Date"],[defaults objectForKey:@"Client Name"],[defaults objectForKey:@"Project Manager"],latitude,longitude,[defaults objectForKey:@"Inspector"]];
        NSString *uencodedUrl = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"URL---- %@",strURL);
        
        NSURL *apiURL =
        [NSURL URLWithString:uencodedUrl];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:apiURL];
        [urlRequest setHTTPMethod:@"POST"];
        
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
        
        _receivedData = [[NSMutableData alloc] init];
        
        [connection start];
        [self showInfoAlert];
    }
    else if (![self connected]){
        [self saveOffProject];
    }
     */
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormat stringFromDate:today];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.navigationController.view addSubview:hud];
    hud.labelText=@"";
    hud.dimBackground = YES;
    hud.delegate = self;
    [hud show:YES];
   
    
    NSNumber *latitudeNumber = [NSNumber numberWithDouble:latitude];
    NSNumber *longitudeNumber = [NSNumber numberWithDouble:longitude];   
    
    BOOL saveStatus = [PRIMECMController
                       saveProject:appDelegate.username
                       projId:[defaults objectForKey:@"Project Id"]
                       phone:[defaults objectForKey:@"Phone No"]
                       projName:[defaults objectForKey:@"Project Name"]
                       projDesc:[defaults objectForKey:@"Project Description"]
                       title:[defaults objectForKey:@"Project Title"]
                       street:[defaults objectForKey:@"Street"]
                       city:[defaults objectForKey:@"City"]
                       state:[defaults objectForKey:@"State"]
                       zip:[defaults objectForKey:@"Zip"]
                       date:dateString
                       clientName:[defaults objectForKey:@"Client Name"]
                       projMgr:[defaults objectForKey:@"Project Manager"]
                       latitude:[latitudeNumber stringValue]
                       longitude:[longitudeNumber stringValue]
                       inspector:[defaults objectForKey:@"Inspector"]];
    
    [hud setHidden:YES];
    
    if (saveStatus){
        UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Successfully saved project." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [exportAlert show];
    }else{
        UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to save project." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [exportAlert show];
    }

    self.navigationItem.rightBarButtonItem = Button;
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    //[[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}


-(void)changeToolBar
{
    self.navigationItem.rightBarButtonItem = Done;
    TapHereSubViewController *controllerTap = [[TapHereSubViewController alloc] initWithNibName:@"TapHereSubViewController" bundle:nil];
    [self presentViewController:controllerTap animated:YES completion:nil];
}


-(void)displayPopupView
{
    PopUpViewController *controller = [[PopUpViewController alloc] initWithNibName:@"PopUpViewController" bundle:nil];
    [controller setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentViewController:controller animated:YES completion:nil];
}


//setting up the pin and getting the location accuracy
-(void)locationDetails:(NSString*)latitudecode longitudeVal:(NSString*)longitudecode
{
    CLLocationCoordinate2D cordinates;
    cordinates.latitude = [latitudecode floatValue];
    cordinates.longitude = [longitudecode floatValue];
    CLLocation *location = [[CLLocation alloc] initWithCoordinate:cordinates altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
    _geocoder = [[CLGeocoder alloc] init];
    [_geocoder reverseGeocodeLocation: location completionHandler:
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
         }
     }];
}


-(void)displayBottomBar
{
    if(!isDisplayBottomBar)
    {
        bottomView.backgroundColor=[UIColor whiteColor];
        // first reduce the view to 1/100th of its original dimension
        CGAffineTransform trans = CGAffineTransformScale(bottomView.transform, 0.01, 0.01);
        bottomView.transform = trans;	// do it instantly, no animation
        
        [mapView addSubview:bottomView];
        isDisplayBottomBar=YES;
        bottomView.frame = CGRectMake(600, 580, 50, 50);//place where to start animating
        
        
        [UIView animateWithDuration:0.1
                         animations:^{
                             bottomView.frame = CGRectMake(20.0, 582.0,600.0, 50.0);//place where to end animating
                         }];
        UIButton *buttonMaps = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonMaps addTarget:self
                       action:@selector(displayMap)
             forControlEvents:UIControlEventTouchUpInside];
        
        [buttonMaps setTitle:@"Maps" forState:UIControlStateNormal];
        buttonMaps.frame = CGRectMake(10.0, 10.0, 20.0, 30.0);
        [bottomView addSubview:buttonMaps];
    }
    else
    {
        [bottomView removeFromSuperview];
        // bottomView.hidden=YES;
        isDisplayBottomBar=NO;
        bottomView.frame = CGRectMake(20.0, 582.0,600.0, 50.0);//place where to start animating
        [UIView animateWithDuration:0.1
                         animations:^{
                             bottomView.frame = CGRectMake(600, 580, 50, 50);//place where to end animating
                         }];
    }
}


-(IBAction)showDashboard:(id)sender
{
    Dashboard *das=[[Dashboard alloc] init];
    das.title=@"Dashboard";
    NSLog(@"In FirstViewCon, showDashboard");
    [self.navigationController pushViewController:das animated:YES];
}



// once the mapview appears, below method used for close the map

-(void)selectionDone
{
    // [popoverController dismissPopoverAnimated:YES];
    [popMenu dismissPopoverAnimated:YES];
    [popMap dismissPopoverAnimated:YES];
}


- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer
{
    if ([addPinsTrue isEqualToString:@"1"]) {
        if (gestureRecognizer.state != UIGestureRecognizerStateEnded)
            return;
        CLLocationCoordinate2D coordinate;
        
        CGPoint touchPoint = [gestureRecognizer locationInView:mapView];
        coordinate = [mapView convertPoint:touchPoint toCoordinateFromView:mapView];
        NSLog(@"latitude  %f longitude %f",coordinate.latitude,coordinate.longitude);
        CGPoint point = [gestureRecognizer locationInView:self.mapView];
        CLLocationCoordinate2D locCoord = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
        
        latitude=locCoord.latitude;
        longitude=locCoord.longitude;
        // MKPointAnnotation *newAnnotation = [[MKPointAnnotation alloc] init];
        
        //brin
        GIKAnnotation *newAnnotation = [[GIKAnnotation alloc] init];
        [newAnnotation setCoordinate:locCoord];
        [self.mapView addAnnotation:newAnnotation];
        addPinsTrue = @"0";
        self.mapView.userInteractionEnabled = NO;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(isMapTypes)
    {
        return 2;
    }
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isMapTypes)
    {
        if(section==0)
        {
            return 3;
        }
        else
        {
            return 1;
        }
        
    }
    
    return [menuItems count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if(isMapTypes)
    {
        if(indexPath.section==0)
        {
            cell.textLabel.text =[tableData objectAtIndex:indexPath.row];
        }
        else
        {
            cell.textLabel.text =[tableData objectAtIndex:tableData.count-1];
        }
    }
    else
    {
        cell.textLabel.text =[menuItems objectAtIndex:indexPath.row];
    }
    return cell;
    
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (isMapTypes) {
        if (indexPath.section == 0 && indexPath.row == 0)
        {
            self.mapView.mapType=MKMapTypeStandard;
        }
        else if (indexPath.section == 0 && indexPath.row == 1)
        {
            self.mapView.mapType=MKMapTypeSatellite;
        }
        else if (indexPath.section == 0 && indexPath.row == 2)
        {
            self.mapView.mapType=MKMapTypeHybrid;
        }
        else if (indexPath.section == 1 && indexPath.row == 0)
        {
            [self.mapView showsUserLocation];
        }
    }
    else
    {
        if (indexPath.section == 0 && indexPath.row == 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeDashboard" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showSProject" object:nil];
        }
        
        
        if(indexPath.section==0 && indexPath.row==1 && ([appDelegate.userType isEqualToString:@"R"] || [appDelegate.userTypeOffline isEqualToString:@"R"]))
        {
            [self displayPopupView];
            appDelegate.Tag=5;
        }
        if(indexPath.section==0 && indexPath.row==1 && ([appDelegate.userType isEqualToString:@"I"] || [appDelegate.userTypeOffline isEqualToString:@"I"]))
            
        {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showFirst" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"logoutView" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"logouttableView" object:nil];
            
            UIBarButtonItem *btn = [[UIBarButtonItem alloc]
                                    initWithTitle:NSLocalizedString(@"", @"")
                                    style:UIBarButtonItemStyleDone
                                    target:self
                                    action:@selector(YourActionMethod:)];
            
            self.navigationItem.rightBarButtonItem = btn;
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
        
        
        if (indexPath.section == 0 && indexPath.row == 2 && ([appDelegate.userType isEqualToString:@"R"] || [appDelegate.userTypeOffline isEqualToString:@"R"]))
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showFirst" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"logoutView" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"logouttableView" object:nil];
            UIBarButtonItem *btn = [[UIBarButtonItem alloc]
                                    initWithTitle:NSLocalizedString(@"", @"")
                                    style:UIBarButtonItemStyleDone
                                    target:self
                                    action:@selector(YourActionMethod:)];
            
            self.navigationItem.rightBarButtonItem = btn;
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
        
        if (indexPath.section == 0 && indexPath.row == 2 && ([appDelegate.userType isEqualToString:@"I"] || [appDelegate.userTypeOffline isEqualToString:@"I"]))
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.primetgrp.com/technical-support/"]];
        }
        
        
        if (indexPath.section == 0 && indexPath.row == 3 && ([appDelegate.userType isEqualToString:@"R"] || [appDelegate.userTypeOffline isEqualToString:@"R"]))
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.primetgrp.com/technical-support/"]];
        }
        
        if (indexPath.section == 0 && indexPath.row == 3 && ([appDelegate.userType isEqualToString:@"I"] || [appDelegate.userTypeOffline isEqualToString:@"I"]))
        {
            [self syncAll];
        }
        
        
        if (indexPath.section == 0 && indexPath.row == 4 && ([appDelegate.userType isEqualToString:@"R"] || [appDelegate.userTypeOffline isEqualToString:@"R"]))
        {
            [self syncAll];
        }
    }
    //[popoverController dismissPopoverAnimated:YES];
    [popMenu dismissPopoverAnimated:YES];
    [popMap dismissPopoverAnimated:YES];
}

-(void) syncAll
{
    NSLog(@"syncing all!");
    
    [self showInfoAlert];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        int syncStatus = [PRIMECMController synchronizeWithServer];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            
            [self reloadInputViews];
            [self hudWasHidden];
            
            if(syncStatus == 0)
            {
                UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Successfully synchronized with the server." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [exportAlert show];
            }
            else
            {
                NSString *errMsg;
                if (syncStatus == 1){
                    errMsg=@"No Internet connection";
                }
                else if (syncStatus == 2){
                    errMsg=@"Server is not responding.";
                }
                else if (syncStatus == 3){
                    errMsg=@"Invalid response received from server.";
                }
                else if (syncStatus == 4){
                    errMsg=@"Failed to push offline data to the server.";
                }
                
                errMsg=[NSString stringWithFormat:@"Failed to synchronize. Please try again. Failed reason: %@", errMsg];
                UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:errMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [exportAlert show];
            }
        });
        
    });
}

-(IBAction)selectItem:(id)sender
{
    isMapTypes=NO;
    [tblView reloadData];
    UIView *popoverView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 300)];
    popoverView.backgroundColor=[UIColor whiteColor];
    popoverContent.view=popoverView;
    popoverContent.preferredContentSize=CGSizeMake(250, 250);
    popoverContent.view=tblView; //Adding tableView to popover
    tblView.delegate=self;
    tblView.dataSource=self;
    popMap=[[UIPopoverController alloc]initWithContentViewController:popoverContent];
    [popMap presentPopoverFromBarButtonItem:(UIBarButtonItem *)sender
                   permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [popMenu dismissPopoverAnimated:YES];
}


-(void)doneAction
{
    
}


-(void)createAddImageCloseBtn
{
    UIImage* imageNormal = [UIImage imageNamed:@"closeBtn.png"];
    UIImage* imageHighLighted = [UIImage imageNamed:@"closeBtn.png"];
    CGRect frame;
    frame = CGRectMake(648,136, 40,40);
    btnCloseAddImage = [[UIButton alloc]initWithFrame:frame];
    [btnCloseAddImage setBackgroundImage:imageNormal forState:UIControlStateNormal];
    [btnCloseAddImage setBackgroundImage:imageHighLighted forState:UIControlStateHighlighted];
    [btnCloseAddImage setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnCloseAddImage setTitle:@"" forState:UIControlStateNormal];
    [btnCloseAddImage setShowsTouchWhenHighlighted:YES];
    [btnCloseAddImage addTarget:self action:@selector(removeAddImageView) forControlEvents:UIControlEventTouchUpInside];
}


-(IBAction)showAddImageView:(id)sender
{
    imageSubView.layer.cornerRadius=5;
    imageSubView.layer.masksToBounds=YES;
    imageSubView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    imageSubView.layer.borderWidth = 3.0f;
}


- (void)showAnnotations {
    hotels = [appDelegate.projectsArray mutableCopy];
	hotelAnnotations = [[NSMutableArray alloc]init];
	for (NSDictionary *hotel in self.hotels) {
		Hotel *theHotel = [[Hotel alloc] init];
        theHotel.name =[hotel valueForKey:@"p_name"];
		theHotel.street = [hotel valueForKey:@"street"];
		theHotel.city = [hotel valueForKey:@"city"];
		theHotel.state = [hotel valueForKey:@"state"];
		theHotel.zip = [hotel valueForKey:@"zip"];
		theHotel.phone = [hotel valueForKey:@"phone"];
		//theHotel.url = [hotel objectForKey:@"url"];
		theHotel.latitude = [[hotel valueForKey:@"p_latitude"] doubleValue];
		theHotel.longitude = [[hotel valueForKey:@"p_longitude"] doubleValue];
		HotelAnnotation *annotation = [[HotelAnnotation alloc] initWithLatitude:theHotel.latitude longitude:theHotel.longitude];
		annotation.hotel = theHotel;
		[hotelAnnotations addObject:annotation];
	}
	[self.mapView addAnnotations:hotelAnnotations];
}


- (void)detailController:(UIViewController *)detailController detailForAnnotation:(id)annotation {
	[(HotelDetailViewController *)detailController setHotel:[(HotelAnnotation *)annotation hotel]];
}


- (void)viewDidUnload {
	[super viewDidUnload];
}


-(void)reloadMapData:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    mapId=[dict valueForKey:@"mapId"];
    HotelAnnotation *annotation=[hotelAnnotations objectAtIndex:[mapId intValue]];
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude =annotation.coordinate.latitude;
    zoomLocation.longitude= annotation.coordinate.longitude;
    
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.0*METERS_PER_MILE, 0.0*METERS_PER_MILE);
    // 3
    [mapView setRegion:viewRegion animated:YES];
    
    [mapView selectAnnotation:annotation animated:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


- (NSArray *)hotels {
    hotels = [appDelegate.projectsArray mutableCopy];
    //NSLog(@"Hotels----%@",hotels);
	return hotels;
}

@end
