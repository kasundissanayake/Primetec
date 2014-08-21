//
//  SearchProject.m
//  ComSMART
//
//  Created by Lingeswaran Kandasamy on 5/5/14.
//
//

#import "SearchProject.h"
#import "Dashboard.h"
#import "TabAndSplitAppAppDelegate.h"
#import "ComplianceReport.h"
#import "NonComplianceReport.h"
#import "DailyInspectionReport.h"
#import "ExpenseReport.h"
#import "SummaryReport.h"
#import "ProjectDetailsCell.h"

@interface SearchProject ()
{
    TabAndSplitAppAppDelegate *appDelegate;
    NSArray *filteredProjects;
    BOOL isFiltered;
    NSMutableArray *projectDetails;
    NSMutableArray *projectDetailsSearch;
}

@end

@implementation SearchProject

//@synthesize searchProject;
@synthesize searchBar;

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
    isFiltered=NO;
    
    appDelegate=(TabAndSplitAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.tag=1;
    searchBar.delegate=self;
    projectDetails=[[NSMutableArray alloc]init];
    projectDetailsSearch=[[NSMutableArray alloc]init];
    projectDetails=[appDelegate.projectsArray mutableCopy];
    projectDetailsSearch=[appDelegate.projectsArray mutableCopy];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showDashboard) name:@"showDashboard" object:nil];
}

-(void)showDashboard
{
    NSLog(@"In SearchProject, showDashboard");
    BOOL isFound=NO;
    for (UIViewController* viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[Dashboard class]] ) {
            isFound=YES;
            Dashboard *dashViewController = (Dashboard*)viewController;
            [self.navigationController popToViewController:dashViewController animated:YES];
        }
    }
    if(!isFound)
    {
        Dashboard *das=[[Dashboard alloc] init];
        das.title=@"Dashboard";
        [self.navigationController pushViewController:das animated:YES];
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [projectDetails count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ProjectDetailsCell";
    ProjectDetailsCell *cell =(ProjectDetailsCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        //  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ProjectDetailsCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    
    if (indexPath.section == 0) {
        //start brin
        cell.lblProjectName.text =[[projectDetails valueForKey:@"p_name"]objectAtIndex:indexPath.row];
        //projectDetails[indexPath.row];
        cell.lblProjectNo.text = [[projectDetails valueForKey:@"projecct_id"]objectAtIndex:indexPath.row];
        cell.lblProjectAddress.text = [[projectDetails valueForKey:@"street"]objectAtIndex:indexPath.row];
        
        cell.lblCity.text = [[projectDetails valueForKey:@"city"]objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;    }
    
    //end brin
    
    
	return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
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
    
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:selectedCell.frame];
    bgView.backgroundColor = [UIColor orangeColor];
    
    appDelegate.projId=[[projectDetails objectAtIndex:indexPath.row]valueForKey:@"projecct_id"];
    
    selectedCell.selectedBackgroundView  = bgView;
    [selectedCell setSelected:YES animated:NO];
    selectedCell.lblCity.textColor=[UIColor whiteColor];
    selectedCell.lblProjectAddress.textColor=[UIColor whiteColor];
    selectedCell.lblProjectName.textColor=[UIColor whiteColor];
    selectedCell.lblProjectNo.textColor=[UIColor whiteColor];
    
    Dashboard *das=[[Dashboard alloc] init];
    das.title=@"";
    [self.navigationController pushViewController:das animated:YES];
    self.navigationController.navigationBar.translucent = NO;
    
    NSDictionary* dict = [NSDictionary dictionaryWithObject:
                          [NSNumber numberWithInt:0]
                                                     forKey:@"index"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeDashboard" object:nil userInfo:dict];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    appDelegate.Tag=1;
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(projectName contains[c] %@ OR projectNo contains[c] %@ OR address contains[c] %@)",
                         text,text,text];
    filteredProjects = [projectDetailsSearch filteredArrayUsingPredicate:pred];
    [projectDetails removeAllObjects];
    [projectDetails addObjectsFromArray:filteredProjects];
    
    if([text isEqualToString:@""]|| text ==NULL)
    {
        [projectDetails removeAllObjects];
        [projectDetails addObjectsFromArray:projectDetailsSearch];
        
    }
    [self.table reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
