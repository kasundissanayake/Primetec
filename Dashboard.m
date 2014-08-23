#import "Dashboard.h"
#import "TabAndSplitAppAppDelegate.h"
#import "ComplianceReport.h"
#import "NonComplianceReport.h"
#import "DailyInspectionReport.h"
#import "ExpenseReport.h"
#import "SummaryReport.h"
#import "RootVC.h"

@interface Dashboard ()
{
    TabAndSplitAppAppDelegate *appDelegate;
}
@property (weak, nonatomic, readonly) NSArray *directions;
@end

@implementation Dashboard
@synthesize detailedNavigationController;
@synthesize directions, table;
@synthesize rootvc;

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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showToolbar" object:nil];
    appDelegate=(TabAndSplitAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    //appDelegate.tag=1;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    //appDelegate.Tag=1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (indexPath.section == 0) {
        
        NSArray *titles = @[@"Compliance Report", @"Non-Compliance Report", @"Daily Inspection Report", @"Expense Report", @"Summary Sheet", @"", @""];
        cell.textLabel.text = titles[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showToolbar" object:nil];
	return cell;
}


- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary* dict = [NSDictionary dictionaryWithObject:
                          [NSNumber numberWithInt:indexPath.row]
                                                     forKey:@"index"];
    UIViewController *currentVC = self.navigationController.visibleViewController;
    for (NSInteger j = 0; j < [tableView numberOfSections]; ++j)
    {
        for (NSInteger i = 0; i < [tableView numberOfRowsInSection:j]; ++i)
        {
            [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]].backgroundColor=[UIColor clearColor];
            UITableViewCell *cell=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
            cell.textLabel.textColor=[UIColor blackColor];
        }
    }
    UITableViewCell *selectedCell=[tableView cellForRowAtIndexPath:indexPath];
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:selectedCell.frame];
    bgView.backgroundColor = [UIColor orangeColor];
    
    selectedCell.selectedBackgroundView  = bgView;
    [selectedCell setSelected:YES animated:NO];
    selectedCell.textLabel.textColor=[UIColor whiteColor];
    
    if (![NSStringFromClass([currentVC class]) isEqualToString:@"reportDashboard"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeDashboard" object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showToolbar" object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadProjectList" object:self userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showToolbar" object:nil];
    }
}

@end
