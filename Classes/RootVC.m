#import "RootVC.h"
#import "DetailedVC.h"
#import "ComplianceViewController.h"
#import "nonComplianceViewController.h"
#import "DailyInspectionViewController.h"
#import "ExpenceViewController.h"
#import "SummaryReportViewController.h"
#import "FirstViewController.h"
#import "TabAndSplitAppAppDelegate.h"
#import "Dashboard.h"
#import "ComplianceReport.h"
#import "ComplianceReport.h"
#import "NonComplianceReport.h"
#import "DailyInspectionReport.h"
#import "ExpenseReport.h"
#import "SummaryReport.h"
#import "SearchProject.h"
#import "reportDashboard.h"
#import "ProjectDetailsCell.h"
#import "Reachability.h"
#import "PRIMECMAPPUtils.h"

typedef enum {
	kkDirections,
	kkPhone,
	kkURL,
	kkAddress,
	kNUMBER_OF_SECTIONS
} TableSections;

@interface RootVC ()
{
    TabAndSplitAppAppDelegate *appDelegate;
    NSMutableArray *projectDetails;
    NSMutableArray *projectDetailsSearch;
    NSMutableArray *projectDetailsFiltered;
    NSArray *filteredProjects;
    NSMutableData *_receivedData;
    NSURLResponse *_receivedResponse;
    NSError *_connectionError;
    NSArray *resPonse;
    
    //woornika
    MBProgressHUD *HUD;
    NSUserDefaults *defaults;
    int no;
}

@property (weak, nonatomic, readonly) NSArray *directions;
@property (strong) NSMutableArray *devices;
@end

@implementation RootVC
@synthesize detailedNavigationController;
@synthesize directions, table, Frontimage;
@synthesize proStatusSeg;
@synthesize searchBar;

-(IBAction)showFirst:(id)sender
{
    if(appDelegate.Tag==1)
    {
        appDelegate.Tag=4;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeView" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeTableView" object:nil];
    }
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		return nil;
	}
	return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate=(TabAndSplitAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    UIBarButtonItem *btnEdit = [[UIBarButtonItem alloc] initWithTitle:@"Edit"style:UIBarButtonItemStyleDone target:self action:@selector(btnEdit)];
    UIBarButtonItem *btnDelete = [[UIBarButtonItem alloc] initWithTitle:@"Delete"style:UIBarButtonItemStyleDone target:self action:@selector(btnDelete)];
    UIImage* toolbarBackground = [UIImage imageNamed:@"Bar1.png"];
    btnEdit.width = 400;
    CGRect rect2 = CGRectMake(0,660 , self.view.frame.size.width , 0);
    
    toolbar = [[UIToolbar alloc]initWithFrame:rect2];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    
    NSArray *toolbarItems = [NSArray arrayWithObjects:btnDelete, btnEdit, nil];
    
    [toolbar setItems:toolbarItems];
    
    
    [[UIToolbar appearance] setBackgroundImage:toolbarBackground
                            forToolbarPosition:UIToolbarPositionAny
                                    barMetrics:UIBarMetricsDefault];
    
    [toolbar sizeToFit];
    [self.view addSubview:toolbar];
    toolbar.hidden=TRUE;
    defaults=[NSUserDefaults standardUserDefaults];
    // start brin
    table.hidden = TRUE;
    // [self.proStatusSeg setHidden:FALSE];
    //end brin
    appDelegate.Tag=4;
    self.table.backgroundColor = [UIColor clearColor];
    self.table.opaque = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showToolbar) name:@"showToolbar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDashboard:) name:@"changeDashboard" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSProject) name:@"showSProject" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showDashboard) name:@"showDashboard" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeView) name:@"changeView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTableView) name:@"changeTableView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popchangeView) name:@"popchangeView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popchangeTableView) name:@"popchangeTableView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutView) name:@"logoutView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logouttableView) name:@"logouttableView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCompliance:) name:@"changeCompliance" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNonCompliance:) name:@"changeNonCompliance" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInspection:) name:@"changeInspection" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDExpese:) name:@"changeDExpese" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSummary:) name:@"changeSummary" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeComplianceForm) name:@"changeComplianceForm" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNonComplianceForm) name:@"changeNonComplianceForm" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInspectionForm) name:@"changeInspectionForm" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDExpeseForm) name:@"changeDExpeseForm" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSummaryForm) name:@"changeSummaryForm" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showComplianceForm) name:@"showComplianceForm" object:nil];
    
    [proStatusSeg addTarget:self action:@selector(pickOne:) forControlEvents:UIControlEventValueChanged];
    
    projectDetails=[[NSMutableArray alloc]init];
    projectDetailsSearch=[[NSMutableArray alloc]init];
    projectDetailsFiltered=[[NSMutableArray alloc]init];
    
    [self populateProjectList];
    [self.table reloadData];
    
    //NSLog(@"------- %@",projectDetails);
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"hideToolbar" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideToolbar) name:@"hideToolbar" object:nil];
}



-(void)btnEdit{
    // [self.table setEditing:YES animated:YES];
    //  [self.table setAllowsSelectionDuringEditing:YES];
    //   [self.table setAllowsMultipleSelectionDuringEditing:YES];
}


-(void)btnDelete{
    // [self.table setEditing:YES animated:YES];
    //  [self.table setAllowsSelectionDuringEditing:YES];
    //   [self.table setAllowsMultipleSelectionDuringEditing:YES];
}


-(void)hideToolbar
{
    toolbar.hidden=TRUE;
}

-(void)showToolbar
{
    toolbar.hidden=FALSE;
}

-(void) populateProjectList
{
    NSManagedObjectContext *context = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Projects" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    
    [projectDetails removeAllObjects];
    [projectDetailsFiltered removeAllObjects];
    [projectDetailsSearch removeAllObjects];
    [appDelegate.projectsArray removeAllObjects];
    
    id objectInstance;
    for (objectInstance in objects){
        [projectDetails addObject:objectInstance];
        [projectDetailsFiltered addObject:objectInstance];
        [projectDetailsSearch addObject:objectInstance];
        [appDelegate.projectsArray addObject:objectInstance];
    }
    
    appDelegate.projId=[[projectDetails objectAtIndex:0]valueForKey:@"projecct_id"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadAnnotations" object:nil];
    
    if ([objects count]>0) {
        for (NSManagedObject *aContact in objects) {
            NSLog(@"name=%@, address=%@, phone=%@",[aContact valueForKey:@"p_name"],[aContact valueForKey:@"city"],[aContact valueForKey:@"phone"]);
        }
    }
    else {
        NSLog(@"no matches found");
    }
}


-(void) pickOne:(id)sender{
    appDelegate.Tag=4;
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    NSString *text = [segmentedControl titleForSegmentAtIndex: [segmentedControl selectedSegmentIndex]];
    NSString *status=@"";
    if([text isEqualToString:@"Current"])
    {
        status=@"0";
    }
    else
    {
        status=@"1";
    }
    
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(status contains[c] %@)", status];
    filteredProjects = [projectDetailsSearch filteredArrayUsingPredicate:pred];
    [projectDetails removeAllObjects];
    [projectDetails addObjectsFromArray:filteredProjects];
    
    if([text isEqualToString:@""]|| text ==NULL || [segmentedControl selectedSegmentIndex]==0)
    {
        [projectDetails removeAllObjects];
        [projectDetails addObjectsFromArray:projectDetailsSearch];
        
    }
    [projectDetailsFiltered removeAllObjects];
    [projectDetailsFiltered addObjectsFromArray:projectDetails];
    if (searchBar.text.length!=0) {
        NSPredicate *predSearch = [NSPredicate predicateWithFormat:@"(p_name contains[c] %@ OR projecct_id contains[c] %@ OR address contains[c] %@)",
                                   searchBar.text,searchBar.text,searchBar.text];
        
        filteredProjects = [projectDetails filteredArrayUsingPredicate:predSearch];
        [projectDetails removeAllObjects];
        [projectDetails addObjectsFromArray:filteredProjects];
    }
    else if([searchBar.text isEqualToString:@""]|| searchBar.text ==NULL )
    {
        [projectDetails removeAllObjects];
        [projectDetails addObjectsFromArray:projectDetailsFiltered];
        
    }
    
    
    for (NSInteger j = 0; j < [table numberOfSections]; ++j)
    {
        for (NSInteger i = 0; i < [table numberOfRowsInSection:j]; ++i)
        {
            [table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]].backgroundColor=[UIColor clearColor];
            ProjectDetailsCell *cell=(ProjectDetailsCell *)[table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
            cell.lblCity.textColor=[UIColor blackColor];
            cell.lblProjectAddress.textColor=[UIColor blackColor];
            cell.lblProjectName.textColor=[UIColor blackColor];
            cell.lblProjectNo.textColor=[UIColor blackColor];
        }
    }
    
    [self.table reloadData];
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    appDelegate.Tag=4;
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(p_name contains[c] %@ OR projecct_id contains[c] %@ OR address contains[c] %@)",
                         text,text,text];
    filteredProjects = [projectDetails filteredArrayUsingPredicate:pred];
    
    [projectDetails removeAllObjects];
    [projectDetails addObjectsFromArray:filteredProjects];
    
    if([text isEqualToString:@""]|| text ==NULL )
    {
        [projectDetails removeAllObjects];
        [projectDetails addObjectsFromArray:projectDetailsFiltered];
        
    }
    
    for (NSInteger j = 0; j < [table numberOfSections]; ++j)
    {
        for (NSInteger i = 0; i < [table numberOfRowsInSection:j]; ++i)
        {
            [table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]].backgroundColor=[UIColor clearColor];
            ProjectDetailsCell *cell=(ProjectDetailsCell *)[table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
            cell.lblCity.textColor=[UIColor blackColor];
            cell.lblProjectAddress.textColor=[UIColor blackColor];
            cell.lblProjectName.textColor=[UIColor blackColor];
            cell.lblProjectNo.textColor=[UIColor blackColor];
        }
    }
    [self.table reloadData];
}


-(BOOL)shouldAutorotate
{
    if (UIInterfaceOrientationIsLandscape( [[UIDevice currentDevice] orientation])) {
        return  YES;
    }
    else
        return NO;
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    ;
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(appDelegate.Tag==1)
    {
        return 5;
        self.proStatusSeg.hidden=true;
    }
    else if (appDelegate.Tag==4)
    {
        return [projectDetails count];
    }
    else if (appDelegate.Tag==5)
    {
        return 4;
    }
    
    return [projectDetails count];;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ProjectDetailsCell";
    ProjectDetailsCell *cell =(ProjectDetailsCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ProjectDetailsCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    
    // use core-data
    NSLog(@"Tag: %ld", (long) appDelegate.Tag);
    
    if(appDelegate.Tag==1)
    {
        if (indexPath.section == 0) {
            
            NSArray *titles = @[@"Compliance Form", @"Non-Compliance Form", @"Daily Inspection Form", @"Expense Report", @"Summary Sheet", @""];
            cell.lblProjectName.text = titles[indexPath.row];
            cell.lblProjectNo.text =@"";
            cell.lblProjectAddress.text=@"";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.lblCity.text=@"";
            cell.imageTag.hidden=YES;
            self.searchBar.hidden=true;
        }
    }
    else if (appDelegate.Tag==4)
    {
        if (indexPath.section == 0) {
            
            [self populateProjectList];
            
            NSLog(@"Count: %ld", (long) [projectDetails count]);
            NSLog(@"Row: %ld", (long)indexPath.row);
            
            if ([projectDetails count] > indexPath.row) {
                NSManagedObject *aProject;
                for (aProject in projectDetails) {
                    NSLog(@"Project item %@", [aProject valueForKey:@"p_name"]);
                    cell.lblProjectName.text = [aProject valueForKey:@"p_name"];
                }
                cell.lblProjectName.text = [[projectDetails objectAtIndex:indexPath.row ]valueForKey:@"p_name"];
                cell.lblProjectNo.text = [[projectDetails objectAtIndex:indexPath.row ]valueForKey:@"projecct_id"];
                cell.lblProjectAddress.text = [[projectDetails objectAtIndex:indexPath.row ]valueForKey:@"street"];
                cell.lblCity.text = [[projectDetails objectAtIndex:indexPath.row ]valueForKey:@"city"];
            }
            
        }
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //brin
    return 100;
}


-(void)changeView
{
    FirstViewController*fdvc=[[FirstViewController alloc] init];
    [self.detailedNavigationController setViewControllers:[NSArray arrayWithObject:fdvc]];
    fdvc.title=[NSString stringWithFormat:@"Map"];
}



-(void)dashboard
{
    ComplianceReport*comR=[[ComplianceReport alloc] init];
    [self.detailedNavigationController setViewControllers:[NSArray arrayWithObject:comR]];
    comR.title=[NSString stringWithFormat:@"Map"];
}


-(void)changeTableView
{
    
    for (NSInteger j = 0; j < [table numberOfSections]; ++j)
    {
        for (NSInteger i = 0; i < [table numberOfRowsInSection:j]; ++i)
        {
            [table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]].backgroundColor=[UIColor clearColor];
            ProjectDetailsCell *cell=(ProjectDetailsCell *)[table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
            cell.lblCity.textColor=[UIColor blackColor];
            cell.lblProjectAddress.textColor=[UIColor blackColor];
            cell.lblProjectName.textColor=[UIColor blackColor];
            cell.lblProjectNo.textColor=[UIColor blackColor];
        }
    }
    
    [self populateProjectList];
    self.Frontimage.hidden=YES;
    [self showToolbar];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithTitle:NSLocalizedString(@"Project List", @"")
                                  style:UIBarButtonItemStyleDone
                                  target:self
                                  action:@selector(showFirst:)];
    self.navigationItem.leftBarButtonItem = addButton;
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName : [UIColor clearColor]
                                                                      }];
    
    UIBarButtonItem *Button = [[UIBarButtonItem alloc]
                               initWithTitle:NSLocalizedString(@"Search", @"")
                               style:UIBarButtonItemStyleDone
                               target:self
                               action:@selector(showSProject:)];
    self.navigationItem.rightBarButtonItem = Button;
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
    //showing the tableview-brin
    table.hidden=FALSE;
    self.proStatusSeg.hidden=FALSE;
    self.searchBar.hidden=FALSE;
}


-(void)changeDashboardTable
{
    
    for (NSInteger j = 0; j < [table numberOfSections]; ++j)
    {
        for (NSInteger i = 0; i < [table numberOfRowsInSection:j]; ++i)
        {
            [table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]].backgroundColor=[UIColor clearColor];
            ProjectDetailsCell *cell=(ProjectDetailsCell *)[table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
            cell.lblCity.textColor=[UIColor blackColor];
            cell.lblProjectAddress.textColor=[UIColor blackColor];
            cell.lblProjectName.textColor=[UIColor blackColor];
            cell.lblProjectNo.textColor=[UIColor blackColor];
        }
    }
    [self.table reloadData];
    self.Frontimage.hidden=YES;
    [self showToolbar];
    
}


-(void)popchangeView
{
    ComplianceViewController *cmpV=[[ComplianceViewController alloc] init];
    [self.detailedNavigationController setViewControllers:[NSArray arrayWithObject:cmpV]];
    cmpV.title=[NSString stringWithFormat:@"Compliance View"];
    //brin
    self.proStatusSeg.hidden=FALSE;
}


-(void)popchangeTableView
{
    appDelegate.Tag=1;
    for (NSInteger j = 0; j < [table numberOfSections]; ++j)
    {
        for (NSInteger i = 0; i < [table numberOfRowsInSection:j]; ++i)
        {
            [table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]].backgroundColor=[UIColor clearColor];
            ProjectDetailsCell *cell=(ProjectDetailsCell *)[table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
            cell.lblCity.textColor=[UIColor blackColor];
            cell.lblProjectAddress.textColor=[UIColor blackColor];
            cell.lblProjectName.textColor=[UIColor blackColor];
            cell.lblProjectNo.textColor=[UIColor blackColor];
        }
    }
    [self.table reloadData];
    self.Frontimage.hidden=YES;
    self.proStatusSeg.hidden=TRUE;
    [self showToolbar];
}


-(void)logoutView
{
    DetailedVC*dvc=[[DetailedVC alloc] init];
    [self.detailedNavigationController setViewControllers:[NSArray arrayWithObject:dvc]];
    
    UIBarButtonItem *Button = [[UIBarButtonItem alloc]
                               initWithTitle:NSLocalizedString(@"", @"")
                               style:UIBarButtonItemStyleDone
                               target:self
                               action:@selector(YourActionMethod:)];
    
    self.navigationItem.rightBarButtonItem = Button;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
}

-(void)logouttableView
{
    appDelegate.Tag=2;
    for (NSInteger j = 0; j < [table numberOfSections]; ++j)
    {
        for (NSInteger i = 0; i < [table numberOfRowsInSection:j]; ++i)
        {
            [table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]].backgroundColor=[UIColor clearColor];
            ProjectDetailsCell *cell=(ProjectDetailsCell *)[table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
            cell.lblCity.textColor=[UIColor blackColor];
            cell.lblProjectAddress.textColor=[UIColor blackColor];
            cell.lblProjectName.textColor=[UIColor blackColor];
            cell.lblProjectNo.textColor=[UIColor blackColor];
        }
    }
    
    [self.table reloadData];
    self.Frontimage.hidden=NO;
    [self hideToolbar];
    self.title=@"";
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithTitle:NSLocalizedString(@"", @"")
                                  style:UIBarButtonItemStyleDone
                                  target:self
                                  action:@selector(YourActionMethod:)];
    
    self.navigationItem.leftBarButtonItem = addButton;
    self.navigationItem.leftBarButtonItem.enabled = NO;
}


- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (NSInteger j = 0; j < [tableView numberOfSections]; ++j)
    {
        for (NSInteger i = 0; i < [tableView numberOfRowsInSection:j]; ++i)
        {
            [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]].backgroundColor=[UIColor clearColor];
            ProjectDetailsCell *cell=(ProjectDetailsCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
            cell.lblCity.textColor=[UIColor blackColor];
            cell.lblProjectAddress.textColor=[UIColor blackColor];
            cell.lblProjectName.textColor=[UIColor blackColor];
            cell.lblProjectNo.textColor=[UIColor blackColor];
        }
    }
    
    ProjectDetailsCell *selectedCell=(ProjectDetailsCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"Index---- %i",indexPath.row);
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:selectedCell.frame];
    bgView.backgroundColor = [UIColor orangeColor];
    selectedCell.selectedBackgroundView  = bgView;
    [selectedCell setSelected:YES animated:NO];
    selectedCell.lblCity.textColor=[UIColor whiteColor];
    selectedCell.lblProjectAddress.textColor=[UIColor whiteColor];
    selectedCell.lblProjectName.textColor=[UIColor whiteColor];
    selectedCell.lblProjectNo.textColor=[UIColor whiteColor];
    
    if(appDelegate.Tag==1)
    {
        proStatusSeg.hidden=true;
        if (indexPath.section == 0 && indexPath.row == 0)
        {
            ComplianceViewController *com= [[ComplianceViewController alloc]initWithNibName:@"ComplianceViewController" bundle:nil];
            com.title=[NSString stringWithFormat:@"Compliance Form"];
            [self.detailedNavigationController setViewControllers:[NSArray arrayWithObject:com]];
        }
        
        if (indexPath.section == 0 && indexPath.row == 1)
        {
            nonComplianceViewController *noncom= [[nonComplianceViewController alloc]initWithNibName:@"nonComplianceViewController" bundle:nil];
            noncom.title=[NSString stringWithFormat:@"Non-Compliance Form"];
            [self.detailedNavigationController setViewControllers:[NSArray arrayWithObject:noncom]];
        }
        
        
        if (indexPath.section == 0 && indexPath.row == 2)
        {
            DailyInspectionViewController *daily=[[DailyInspectionViewController alloc]init];
            daily.title=[NSString stringWithFormat:@"Daily Inspection Form"];
            [self.detailedNavigationController setViewControllers:[NSArray arrayWithObject:daily]];
        }
        
        if (indexPath.section == 0 && indexPath.row == 3)
        {
            ExpenceViewController *expence=[[ExpenceViewController alloc]init];
            expence.title=[NSString stringWithFormat:@"Expense Report"];
            [self.detailedNavigationController setViewControllers:[NSArray arrayWithObject:expence]];
        }
        
        if (indexPath.section == 0 && indexPath.row == 4)
        {
            SummaryReportViewController *summary=[[SummaryReportViewController alloc]init];
            summary.title=[NSString stringWithFormat:@"Summary Sheet"];
            [self.detailedNavigationController setViewControllers:[NSArray arrayWithObject:summary]];
        }
        
        
        if (indexPath.section == 0 && indexPath.row == 6)
        {
            appDelegate.Tag=2;
            DetailedVC *dvc=[[DetailedVC alloc]init];
            dvc.title=[NSString stringWithFormat:@"Login"];
            [self.detailedNavigationController setViewControllers:[NSArray arrayWithObject:dvc]];
            
            for (NSInteger j = 0; j < [table numberOfSections]; ++j)
            {
                for (NSInteger i = 0; i < [table numberOfRowsInSection:j]; ++i)
                {
                    [table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]].backgroundColor=[UIColor clearColor];
                    ProjectDetailsCell *cell=(ProjectDetailsCell *)[table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
                    cell.lblCity.textColor=[UIColor blackColor];
                    cell.lblProjectAddress.textColor=[UIColor blackColor];
                    cell.lblProjectName.textColor=[UIColor blackColor];
                    cell.lblProjectNo.textColor=[UIColor blackColor];
                }
            }
            
            [self.table reloadData];
            self.Frontimage.hidden=NO;
            [self hideToolbar];
            self.title=@"";
            
            UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                          initWithTitle:NSLocalizedString(@"", @"")
                                          style:UIBarButtonItemStyleDone
                                          target:self
                                          action:@selector(YourActionMethod:)];
            
            self.navigationItem.leftBarButtonItem = addButton;
            self.navigationItem.leftBarButtonItem.enabled = NO;
            
            UIBarButtonItem *Button = [[UIBarButtonItem alloc]
                                       initWithTitle:NSLocalizedString(@"", @"")
                                       style:UIBarButtonItemStyleDone
                                       target:self
                                       action:@selector(YourActionMethod:)];
            
            self.navigationItem.rightBarButtonItem = Button;
            self.navigationItem.rightBarButtonItem.enabled = NO;
            
        }
        
        else if (appDelegate.Tag==4)
        {
            NSLog(@"Select Proj----------------------");
            
            FirstViewController*fdvc=[[FirstViewController alloc] init];
            fdvc.title=[NSString stringWithFormat:@"Map View"];
            [self.detailedNavigationController setViewControllers:[NSArray arrayWithObject:fdvc]];
            
        }
        
        
        else if (appDelegate.Tag==5)
        {
            if (indexPath.section == 0 && indexPath.row == 0)
            {
                ComplianceReport*comR=[[ComplianceReport alloc] init];
                [self.detailedNavigationController setViewControllers:[NSArray arrayWithObject:comR]];
                comR.title=[NSString stringWithFormat:@"Dashboard"];
            }
        }
        
    }
    
    else if(appDelegate.Tag==4)
    {
        NSLog(@"-_---%i",indexPath.row);
        NSMutableDictionary *selectedValueDic = [[NSMutableDictionary alloc] init];
        selectedValueDic=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                          [NSString stringWithFormat:@"%i", indexPath.row],@"mapId",
                          nil];
        NSLog(@"-_---%@",selectedValueDic);
        
        
        appDelegate.projId=[[projectDetails objectAtIndex:indexPath.row]valueForKey:@"projecct_id"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ViewControllerAReloadData" object:nil userInfo:selectedValueDic];
        appDelegate.projDescription=[[projectDetails objectAtIndex:indexPath.row]valueForKey:@"p_description"];
        appDelegate.projTitle=[[projectDetails objectAtIndex:indexPath.row]valueForKey:@"p_title"];
        appDelegate.projName=[[projectDetails objectAtIndex:indexPath.row]valueForKey:@"p_name"];
        appDelegate.address=[[projectDetails objectAtIndex:indexPath.row]valueForKey:@"street"];
        appDelegate.city=[[projectDetails objectAtIndex:indexPath.row]valueForKey:@"city"];
        appDelegate.state=[[projectDetails objectAtIndex:indexPath.row]valueForKey:@"state"];
        appDelegate.tel=[[projectDetails objectAtIndex:indexPath.row]valueForKey:@"phone"];
        appDelegate.pm=[[projectDetails objectAtIndex:indexPath.row]valueForKey:@"project_manager"];
        appDelegate.zip=[[projectDetails objectAtIndex:indexPath.row]valueForKey:@"zip"];
    }
}



- (void)changeCompliance:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    NSLog(@"Map====%@",dict);
    
    NSString *CNo=[dict valueForKey:@"ConNo"];
    
    ComplianceReport*comp=[[ComplianceReport alloc] init];
    comp.title=[NSString stringWithFormat:@"Compliance Report"];
    comp.CNo=CNo;
    [self.detailedNavigationController setViewControllers:[NSArray arrayWithObject:comp]];
    
}


- (void)changeNonCompliance:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    NSLog(@"Map====%@",dict);
    NSString *CNo=[dict valueForKey:@"ConNo"];
    NonComplianceReport *noncom=[[NonComplianceReport alloc]init];
    noncom.title=[NSString stringWithFormat:@"Non-Compliance Report"];
    noncom.CNo=CNo;
    [self.detailedNavigationController setViewControllers:[NSArray arrayWithObject:noncom]];
}


- (void)changeInspection:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    NSLog(@"Map====%@",dict);
    
    NSString *CNo=[dict valueForKey:@"ConNo"];
    DailyInspectionReport *daily=[[DailyInspectionReport alloc]init];
    daily.CNo=CNo;
    daily.title=[NSString stringWithFormat:@"Daily Inspection Report"];
    [self.detailedNavigationController setViewControllers:[NSArray arrayWithObject:daily]];
    
    self.proStatusSeg.hidden=TRUE;
    
}



- (void)changeDExpese:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    NSLog(@"Map====%@",dict);
    NSString *CNo=[dict valueForKey:@"ConNo"];
    ExpenseReport *expnse=[[ExpenseReport alloc]init];
    expnse.eXReportNo=CNo;
    //expnse.=[NSString stringWithFormat:@"Expense Report"];
    [self.detailedNavigationController setViewControllers:[NSArray arrayWithObject:expnse]];
}


- (void)changeSummary:(NSNotification *)notification

{
    NSDictionary *dict = [notification userInfo];
    NSLog(@"Map====%@",dict);
    
    NSString *CNo=[dict valueForKey:@"ConNo"];
    
    SummaryReport *sumarry=[[SummaryReport alloc]init];
    sumarry.SMNo=CNo;
    sumarry.title=[NSString stringWithFormat:@"Summary Sheet"];
    [self.detailedNavigationController setViewControllers:[NSArray arrayWithObject:sumarry]];
}

- (void)changeComplianceForm
{
    ComplianceViewController *com=[[ComplianceViewController alloc]init];
    com.title=[NSString stringWithFormat:@"Compliance View"];
    [self.detailedNavigationController setViewControllers:[NSArray arrayWithObject:com]];
    
}


- (void)changeNonComplianceForm
{
    
    nonComplianceViewController *noncom=[[nonComplianceViewController alloc]init];
    noncom.title=[NSString stringWithFormat:@"Non-Compliance View"];
    [self.detailedNavigationController setViewControllers:[NSArray arrayWithObject:noncom]];
}


- (void)changeInspectionForm
{
    
    DailyInspectionViewController *daily=[[DailyInspectionViewController alloc]init];
    daily.title=[NSString stringWithFormat:@"Daily Inspection Report"];
    [self.detailedNavigationController setViewControllers:[NSArray arrayWithObject:daily]];
    
    
}


- (void)changeDExpeseForm
{
    ExpenceViewController *expence=[[ExpenceViewController alloc]init];
    expence.title=[NSString stringWithFormat:@"Expense Report"];
    [self.detailedNavigationController setViewControllers:[NSArray arrayWithObject:expence]];
}


- (void)changeSummaryForm

{
    
    SummaryReportViewController *summary=[[SummaryReportViewController alloc]init];
    summary.title=[NSString stringWithFormat:@"Summary Report"];
    [self.detailedNavigationController setViewControllers:[NSArray arrayWithObject:summary]];
}


- (void)changeDashboard:(NSNotification *)notification
{
    int type = [[[notification userInfo] valueForKey:@"index"] intValue];
    
    reportDashboard *report=[[reportDashboard alloc]init];
    report.title=[NSString stringWithFormat:@"Report"];
    report.proType=type;
    [self.detailedNavigationController setViewControllers:[NSArray arrayWithObject:report]];
}

-(void)showDashboard
{
    BOOL isFound=NO;
    Dashboard *das=[[Dashboard alloc] init];
    for (UIViewController* viewController in self.navigationController.viewControllers) {
        
        if ([viewController isKindOfClass:[das class]] ) {
            isFound=YES;
            Dashboard *dashViewController = (Dashboard*)viewController;
            [self.navigationController popToViewController:dashViewController animated:YES];
            
        }
    }
    if(!isFound)
    {
        // Dashboard *das=[[Dashboard alloc] init];
        das.title=@"Dashboard";
        [self.navigationController pushViewController:das animated:YES];
    }
}
-(IBAction)showSProject:(id)sender
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeDashboard" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showSProject" object:nil];
    
}

-(void)showSProject
{
    BOOL isFound=NO;
    SearchProject *search=[[SearchProject alloc] init];
    for (UIViewController* viewController in self.navigationController.viewControllers) {
        
        if ([viewController isKindOfClass:[search class]] ) {
            isFound=YES;
            SearchProject *searchViewController = (SearchProject*)viewController;
            [self.navigationController popToViewController:searchViewController animated:YES];
            
        }
    }
    if(!isFound)
    {
        search.title=@"Dashboard";
        [self.navigationController pushViewController:search animated:YES];
    }
    
}


-(IBAction)showSCompliance:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showCompliance" object:nil];
}


-(void)showCompliance
{
    ComplianceViewController *com=[[ComplianceViewController alloc]init];
    com.title=[NSString stringWithFormat:@"Compliance View"];
    [self.detailedNavigationController setViewControllers:[NSArray arrayWithObject:com]];
}

@end
