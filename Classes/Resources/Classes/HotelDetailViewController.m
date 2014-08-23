

#import "HotelDetailViewController.h"
#import "Hotel.h"
#import "ComplainceView.h"
#import "ComplianceForm.h"
#import "ComplianceViewController.h"
#import "RootVC.h"
#import "TabAndSplitAppAppDelegate.h"
#import "DetailedVC.h"
#import "Dashboard.h"


typedef enum {
	kDirections,
	kPhone,
	kURL,
	kStreet,
    kCity,
    kState,
    kZip,
    kProjectId,
    kProjectName,
    kPManager,
	NUMBER_OF_SECTIONS
} TableSections;


@interface HotelDetailViewController ()
{
    TabAndSplitAppAppDelegate *appDelegate;
    RootVC *root;
    DetailedVC *dcv;
}

@property (nonatomic, readonly) NSArray *directions;
@end


@implementation HotelDetailViewController

@synthesize table, hotel;
@synthesize directions;
@synthesize detailedNavigationController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        return nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate=(TabAndSplitAppAppDelegate *)[[UIApplication sharedApplication] delegate];
	self.table.backgroundColor = [UIColor clearColor];
	UIImage *backgroundImage = [[UIImage imageNamed:@"CalloutTableBackground.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:6];
	UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
	backgroundImageView.frame = self.view.bounds;
	self.table.backgroundView = backgroundImageView;
}


-(BOOL)shouldAutorotate
{
    if (UIInterfaceOrientationIsLandscape( [[UIDevice currentDevice] orientation])) {
        return  YES;
    }
    else
        return NO;
}


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.table reloadData];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [super viewDidUnload];
	self.table = nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	//if (indexPath.section == kAddress) {
    //return 80.0f;
	//}
	return 44.0f;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *kDirectionCellIdentifier = @"DirectionCellIdentifier";
	static NSString *kOtherCellIdentifier = @"OtherCellIdentifier";
	
	NSString *workingCellIdentifier = (indexPath.section == kDirections) ? kDirectionCellIdentifier : kOtherCellIdentifier;
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:workingCellIdentifier];
	if (cell == nil) {
		if ([workingCellIdentifier isEqualToString:kDirectionCellIdentifier]) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:workingCellIdentifier];
		}
		else {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:workingCellIdentifier];
		}
	}
	
    switch (indexPath.section) {
            
            //start brin
            
		case kDirections:
			//cell.textLabel.textAlignment = UITextAlignmentLeft;
			cell.textLabel.text = [self.directions objectAtIndex:indexPath.row];
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            //return cell;
            
			//cell.textLabel.textColor = [UIColor colorWithRed:82.0f/255.0f green:102.0f/255.0f blue:145.0f/255.0f alpha:1.0f];
            cell.textLabel.textColor=[UIColor blackColor];
            cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
            
            
			break;
		case kPhone:
            
            //start brin
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.textLabel.textColor=[UIColor blackColor];
            cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
            
            
			cell.textLabel.text = @"phone";
            
            cell.detailTextLabel.numberOfLines = 1;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",
										 self.hotel.phone];
            cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0f];
            
            
			break;
            
		case kURL:
            
            cell.textLabel.textColor=[UIColor blackColor];
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
            
			cell.textLabel.text = @"P Manager:";
			cell.detailTextLabel.text = self.hotel.url;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0f];
            
			break;
            
		case kStreet:
            
            cell.textLabel.textColor=[UIColor blackColor];
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
            
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
			cell.textLabel.text = @"Street";
			
            //	cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
			cell.detailTextLabel.numberOfLines = 1;
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",
										 self.hotel.street];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0f];
            
            break;
            
        case kCity:
            
            cell.textLabel.textColor=[UIColor blackColor];
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
            
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
			cell.textLabel.text = @"City";
			
            //	cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
			cell.detailTextLabel.numberOfLines = 1;
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",
										 self.hotel.city];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0f];
            
            break;
            
            
        case kState:
            
            cell.textLabel.textColor=[UIColor blackColor];
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
            
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
			cell.textLabel.text = @"State";
			
            //	cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
			cell.detailTextLabel.numberOfLines = 1;
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",
                                         
										 self.hotel.state];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0f];
            
            break;
            
        case kZip:
            
            cell.textLabel.textColor=[UIColor blackColor];
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
            
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
			cell.textLabel.text = @"Zip";
			
            //	cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
			cell.detailTextLabel.numberOfLines = 1;
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",
										 self.hotel.zip];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0f];
            
			break;
            
            //end brin
            
            
            break;
		default:
			break;
	}
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	return cell;
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return NUMBER_OF_SECTIONS;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger rows = 0;
	switch (section) {
		case kDirections:
			rows = [self.directions count];
			break;
		case kPhone:
		case kURL:
		case kStreet:
        case kCity:
        case kState:
        case kZip:
			rows = 1;
			break;
		default:
			break;
	}
	return rows;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        
    }
    if (indexPath.section == 0 && indexPath.row == 1)
    {
        
    }
    if (indexPath.section == 0 && indexPath.row == 2)
    {
        //appDelegate.Tag=4;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showDashboard" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeDashboard" object:nil];
        //NSLog(@"HotelDetail in 0,2");
        [self.table setHidden:FALSE];
        
    }
    
    
    if (indexPath.section == 0 && indexPath.row == 3)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"popchangeView" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"popchangeTableView" object:nil];
    }
    if (indexPath.section == 0 && indexPath.row == 4)
    {
        
    }
    if (indexPath.section == 0 && indexPath.row == 6)
    {
        
    }
}




- (void)setHotel:(Hotel *)newHotel {
	if (hotel != newHotel) {
		hotel = newHotel;
	}
	[self.table reloadData];
}

- (NSArray *)directions {
	if (directions == nil) {
		directions = [[NSArray alloc] initWithObjects: @"Project ID", @"Project Name", @"Reports", @"Inspections",  nil];
	}
	return directions;
}

@end
