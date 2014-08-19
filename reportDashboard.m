#import "reportDashboard.h"
#import "ReportDetailsCell.h"
#import "TabAndSplitAppAppDelegate.h"
#import "PRIMECMAPPUtils.h"
#import "ComplianceReport.h"

@interface reportDashboard ()
{
    NSMutableArray *reports;
    TabAndSplitAppAppDelegate *appDelegate;
    NSMutableData *_receivedData;
    NSURLResponse *_receivedResponse;
    NSError *_connectionError;
    NSArray *resPonse;
    MBProgressHUD *hud;
    int type;
}

@end

@implementation reportDashboard
@synthesize detailedNavigationController;
@synthesize table;
@synthesize proType;

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
    
    reports=[[NSMutableArray alloc]init];
    appDelegate=(TabAndSplitAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadProjectList:) name:@"reloadProjectList" object:nil];
    [self reloadProjectInLoad];
    UIBarButtonItem  *newButton = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(addNewForm)];
    self.navigationItem.rightBarButtonItem = newButton;
    UIBarButtonItem  *newButton1 = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStylePlain target:self action:@selector(DeleteReport)];
    self.navigationItem.leftBarButtonItem = newButton1;
    self.table.scrollEnabled=YES;
}


-(void)addNewForm
{
    UIViewController *currentVC = self.navigationController.visibleViewController;
    
    if(proType==0 && ![NSStringFromClass([currentVC class]) isEqualToString:@"ComplianceViewController"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeComplianceForm" object:nil];
    }
    else if (proType==1 && ![NSStringFromClass([currentVC class]) isEqualToString:@"nonComplianceViewController"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeNonComplianceForm" object:nil];
    }
    else if (proType==2 && ![NSStringFromClass([currentVC class]) isEqualToString:@"DailyInspectionViewController"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeInspectionForm" object:nil];
    }
    else if (proType==3 && ![NSStringFromClass([currentVC class]) isEqualToString:@"ExpenceViewController"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeDExpeseForm" object:nil];
    }
    else if (proType==4 && ![NSStringFromClass([currentVC class]) isEqualToString:@"SummaryReportViewController"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSummaryForm" object:nil];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Date" ascending:FALSE];
    [reports sortUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    return reports.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ReportDetailsCell";
    ReportDetailsCell *cell =(ReportDetailsCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ReportDetailsCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    
    if (indexPath.section == 0) {
        
        // Daily Inspection Report
        if(proType==2)
        {
            cell.lblReportName.text =[[reports valueForKey:@"dIFHeader"]objectAtIndex:indexPath.row];
            cell.lblReportDate.text = [NSDateFormatter localizedStringFromDate:[[reports valueForKey:@"date"]objectAtIndex:indexPath.row]
                                       dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
            
            cell.lblReportInspectedBy.text =[[reports valueForKey:@"project_id"]objectAtIndex:indexPath.row];
            cell.lblReportProjectManager.text =[[reports valueForKey:@"printedName"]objectAtIndex:indexPath.row];
        }
        
        // Expense Report
        else if(proType==3)
        {
            cell.lblReportName.text =[[reports valueForKey:@"eRFHeader"]objectAtIndex:indexPath.row];
            cell.lblReportDate.text =[NSDateFormatter localizedStringFromDate:[[reports valueForKey:@"date"]objectAtIndex:indexPath.row]
                                                                    dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
            cell.lblReportInspectedBy.text =[[reports valueForKey:@"project_id"]objectAtIndex:indexPath.row];
            cell.lblReportProjectManager.text =[[reports valueForKey:@"eMPName"]objectAtIndex:indexPath.row];
        }
        
        // Summary Sheet 1
        else if(proType==4)
        {
            cell.lblReportName.text =@"Summary Report";
            cell.lblReportDate.text =[NSDateFormatter localizedStringFromDate:[[reports valueForKey:@"date"]objectAtIndex:indexPath.row]
                                      dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
            cell.lblReportInspectedBy.text =[[reports valueForKey:@"project_id"]objectAtIndex:indexPath.row];
            cell.lblReportProjectManager.text =[[reports valueForKey:@"printedName"]objectAtIndex:indexPath.row];
        }
        
        // Compliance and Non-compliance Reports
        else
        {
            cell.lblReportName.text =[[reports valueForKey:@"title"]objectAtIndex:indexPath.row];
            cell.lblReportDate.text =[NSDateFormatter localizedStringFromDate:[[reports valueForKey:@"date"]objectAtIndex:indexPath.row]
                                      dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
            cell.lblReportInspectedBy.text =[[reports valueForKey:@"project_id"]objectAtIndex:indexPath.row];
            cell.lblReportProjectManager.text =[[reports valueForKey:@"printedName"]objectAtIndex:indexPath.row];
        }
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
	return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *noticeNo;
    // Compliance Report
    if (proType == 0)
    {
        noticeNo=[[reports objectAtIndex: indexPath.row]valueForKey:@"complianceNoticeNo"];
        NSDictionary* dict = [NSDictionary dictionaryWithObject: noticeNo forKey:@"contractNo"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCompliance" object:nil userInfo:dict];
    }
    
    // Non-compliance Report
    if (proType == 1)
    {
        
        noticeNo=[[reports objectAtIndex: indexPath.row]valueForKey:@"non_ComplianceNoticeNo"];
        NSDictionary* dict = [NSDictionary dictionaryWithObject: noticeNo forKey:@"contractNo"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeNonCompliance" object:nil userInfo:dict];
    }
    
    // Daily Inspection Report
    if (proType == 2)
    {
        noticeNo=[[reports objectAtIndex: indexPath.row]valueForKey:@"inspectionID"];
        NSDictionary* dict = [NSDictionary dictionaryWithObject: noticeNo forKey:@"ConNo"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeInspection" object:nil userInfo:dict];
    }
    
    // Expense Report
    if (proType == 3)
    {
        noticeNo=[[reports objectAtIndex: indexPath.row]valueForKey:@"eXReportNo"];
        NSDictionary* dict = [NSDictionary dictionaryWithObject: noticeNo forKey:@"ConNo"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeDExpese" object:nil userInfo:dict];
    }
    
    // Summary Sheet 1
    if (proType == 4)
    {
        noticeNo=[[reports objectAtIndex: indexPath.row]valueForKey:@"sMSheetNo"];
        NSDictionary* dict = [NSDictionary dictionaryWithObject: noticeNo forKey:@"ConNo"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSummary" object:nil userInfo:dict];
    }
}

-(void)loadComplianceForm
{
    NSManagedObjectContext *context = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ComplianceForm" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY project_id == %@", appDelegate.projId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.navigationController.view addSubview:hud];
    hud.labelText=@"";
    hud.dimBackground = YES;
    hud.delegate = self;
    [hud show:YES];
    
    [reports addObjectsFromArray: objects];
    [table reloadData];
    
    [hud setHidden:YES];
}

-(void)loadNonComplianceForm
{
    NSManagedObjectContext *context = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"NonComplianceForm" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY project_id == %@", appDelegate.projId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.navigationController.view addSubview:hud];
    hud.labelText=@"";
    hud.dimBackground = YES;
    hud.delegate = self;
    [hud show:YES];
    
    [reports addObjectsFromArray: objects];
    [table reloadData];
    
    [hud setHidden:YES];}


-(void)loadDailyInspectionForm
{
    NSManagedObjectContext *context = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DailyInspectionForm" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY project_id == %@", appDelegate.projId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.navigationController.view addSubview:hud];
    hud.labelText=@"";
    hud.dimBackground = YES;
    hud.delegate = self;
    [hud show:YES];
    
    [reports addObjectsFromArray: objects];
    [table reloadData];
    
    [hud setHidden:YES];
}


-(void)loadExpenseForm
{
    
    NSManagedObjectContext *context = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ExpenseReport" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY project_id == %@", appDelegate.projId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.navigationController.view addSubview:hud];
    hud.labelText=@"";
    hud.dimBackground = YES;
    hud.delegate = self;
    [hud show:YES];
    
    [reports addObjectsFromArray: objects];
    [table reloadData];
    
    [hud setHidden:YES];
    
}

-(void)loadSummeryForm
{
    NSManagedObjectContext *context = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SummarySheet1" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY project_id == %@", appDelegate.projId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.navigationController.view addSubview:hud];
    hud.labelText=@"";
    hud.dimBackground = YES;
    hud.delegate = self;
    [hud show:YES];
    
    [reports addObjectsFromArray: objects];
    [table reloadData];
    [hud setHidden:YES];
}


-(void)reloadProjectList:(NSNotification *)notification
{
    type = [[[notification userInfo] valueForKey:@"index"] intValue];
    [reports removeAllObjects];
    if(type==0)
    {
        [self loadComplianceForm];
    }
    else if(type==1)
    {
        [self loadNonComplianceForm];
    }
    
    else if(type==2)
    {
        [self loadDailyInspectionForm];
    }
    else if(type==3)
    {        [self loadExpenseForm];
    }
    else if(type==4)
    {
        [self loadSummeryForm];
    }
}


-(void)reloadProjectInLoad
{
    type =proType;
    [reports removeAllObjects];
    if(type==0)
    {
        [self loadComplianceForm];
    }
    else if(type==1)
    {
        [self loadNonComplianceForm];
    }
    
    else if(type==2)
    {
        [self loadDailyInspectionForm];
    }
    else if(type==3)
    {
        [self loadExpenseForm];
    }
    else if(type==4)
    {
        [self loadSummeryForm];
    }
}

@end
