//
//  reportDashboard.m
//  ComSMART
//
//  Created by Lingeswaran Kandasamy on 5/7/14.
//
//

#import "reportDashboard.h"
#import "ReportDetailsCell.h"
#import "TabAndSplitAppAppDelegate.h"
#import "PRIMECMAPPUtils.h"
#import "ComplianceReport.h"

@interface reportDashboard ()
{
    NSMutableArray *reports;
    // NSMutableArray *projectDetailsSearch;
    TabAndSplitAppAppDelegate *appDelegate;
    
    NSMutableData *_receivedData;
    NSURLResponse *_receivedResponse;
    NSError *_connectionError;
    NSArray *resPonse;
    
    //woornika
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
    // Do any additional setup after loading the view from its nib.
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
    // Dispose of any resources that can be recreated.
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
        if(proType==2)
        {
            cell.lblReportName.text =[[reports valueForKey:@"DIFHeader"]objectAtIndex:indexPath.row];
            cell.lblReportDate.text =[[reports valueForKey:@"Date"]objectAtIndex:indexPath.row];
            cell.lblReportInspectedBy.text =[[reports valueForKey:@"Project_id"]objectAtIndex:indexPath.row];
            cell.lblReportProjectManager.text =[[reports valueForKey:@"printedName"]objectAtIndex:indexPath.row];
            
            
        }
        else if(proType==3)
        {
            cell.lblReportName.text =[[reports valueForKey:@"ERFHeader"]objectAtIndex:indexPath.row];
            cell.lblReportDate.text =[[reports valueForKey:@"Date"]objectAtIndex:indexPath.row];
            cell.lblReportInspectedBy.text =[[reports valueForKey:@"projectid"]objectAtIndex:indexPath.row];
            cell.lblReportProjectManager.text =[[reports valueForKey:@"EMPName"]objectAtIndex:indexPath.row];
            
            
        }
        else if(proType==4)
        {
            cell.lblReportName.text =@"Summary Report";
            cell.lblReportDate.text =[[reports valueForKey:@"Date"]objectAtIndex:indexPath.row];
            cell.lblReportInspectedBy.text =[[reports valueForKey:@"Project_id"]objectAtIndex:indexPath.row];
            cell.lblReportProjectManager.text =[[reports valueForKey:@"printedName"]objectAtIndex:indexPath.row];
            
            
            
        }
        else
        {
            cell.lblReportName.text =[[reports valueForKey:@"Title"]objectAtIndex:indexPath.row];
            cell.lblReportDate.text =[[reports valueForKey:@"Date"]objectAtIndex:indexPath.row];
            cell.lblReportInspectedBy.text =[[reports valueForKey:@"projectid"]objectAtIndex:indexPath.row];
            cell.lblReportProjectManager.text =[[reports valueForKey:@"PrintedName"]objectAtIndex:indexPath.row];
            
            
            
            
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
    if (proType == 0)
    {
        noticeNo=[[reports objectAtIndex: indexPath.row]valueForKey:@"ComplianceNoticeNo"];
        NSDictionary* dict = [NSDictionary dictionaryWithObject: noticeNo forKey:@"ConNo"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCompliance" object:nil userInfo:dict];
    }
    
    
    if (proType == 1)
    {
        
        noticeNo=[[reports objectAtIndex: indexPath.row]valueForKey:@"Non_ComplianceNoticeNo"];
        NSDictionary* dict = [NSDictionary dictionaryWithObject:
                              noticeNo forKey:@"ConNo"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeNonCompliance" object:nil userInfo:dict];
    }
    
    
    if (proType == 2)
    {
        noticeNo=[[reports objectAtIndex: indexPath.row]valueForKey:@"inspectionID"];
        
        NSDictionary* dict = [NSDictionary dictionaryWithObject:
                              noticeNo forKey:@"ConNo"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeInspection" object:nil userInfo:dict];
    }
    
    
    if (proType == 3)
    {
        noticeNo=[[reports objectAtIndex: indexPath.row]valueForKey:@"EXReportNo"];
        NSDictionary* dict = [NSDictionary dictionaryWithObject:
                              noticeNo forKey:@"ConNo"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeDExpese" object:nil userInfo:dict];
    }
    
    
    if (proType == 4)
    {
        noticeNo=[[reports objectAtIndex: indexPath.row]valueForKey:@"SMSheetNo"];
        NSDictionary* dict = [NSDictionary dictionaryWithObject:
                              noticeNo forKey:@"ConNo"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSummary" object:nil userInfo:dict];
    }
    
    
    
}
-(void)loadComplianceForm
{
    NSString *strURL = [NSString stringWithFormat:@"%@/api/compliance/list/%@/%@", [PRIMECMAPPUtils getAPIEndpoint],
                        appDelegate.username,appDelegate.projId];
    
    NSURL *apiURL =
    [NSURL URLWithString:strURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:apiURL];
    
    
    
    
    
    [urlRequest setHTTPMethod:@"GET"];
    
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    
    
    _receivedData = [[NSMutableData alloc] init];
    
    
    [connection start];
    NSLog(@"URL---%@",strURL);
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.navigationController.view addSubview:hud];
    hud.labelText=@"";
    hud.dimBackground = YES;
    hud.delegate = self;
    [hud show:YES];
    
    
    
}-(void)loadNonComplianceForm
{
    NSString *strURL = [NSString stringWithFormat:@"%@/api/noncompliance/list/%@/%@", [PRIMECMAPPUtils getAPIEndpoint],
                        appDelegate.username,appDelegate.projId];
    
    NSURL *apiURL =
    [NSURL URLWithString:strURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:apiURL];
    
    
    
    
    
    [urlRequest setHTTPMethod:@"GET"];
    
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    
    
    _receivedData = [[NSMutableData alloc] init];
    
    
    [connection start];
    NSLog(@"URL---%@",strURL);
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.navigationController.view addSubview:hud];
    hud.labelText=@"";
    hud.dimBackground = YES;
    hud.delegate = self;
    [hud show:YES];
    
    
    
}
-(void)loadDailyInspectionForm
{
    NSString *strURL = [NSString stringWithFormat:@"%@/api/dailyinspection/list/%@/%@", [PRIMECMAPPUtils getAPIEndpoint],
                        appDelegate.username,appDelegate.projId];
    
    NSURL *apiURL =
    [NSURL URLWithString:strURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:apiURL];
    
    
    
    
    
    [urlRequest setHTTPMethod:@"GET"];
    
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    
    
    _receivedData = [[NSMutableData alloc] init];
    
    
    [connection start];
    NSLog(@"URL---%@",strURL);
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.navigationController.view addSubview:hud];
    hud.labelText=@"";
    hud.dimBackground = YES;
    hud.delegate = self;
    [hud show:YES];
    
    
    
}
-(void)loadExpenseForm
{
    NSString *strURL = [NSString stringWithFormat:@"%@/api/expense/list/%@/%@", [PRIMECMAPPUtils getAPIEndpoint],
                        appDelegate.username,appDelegate.projId];
    
    NSURL *apiURL = [NSURL URLWithString:strURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:apiURL];
    
    [urlRequest setHTTPMethod:@"GET"];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    _receivedData = [[NSMutableData alloc] init];
    [connection start];
    NSLog(@"URL---%@",strURL);
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.navigationController.view addSubview:hud];
    hud.labelText=@"";
    hud.dimBackground = YES;
    hud.delegate = self;
    [hud show:YES];
}

-(void)loadSummeryForm
{
    NSString *strURL = [NSString stringWithFormat:@"%@/api/summary1/list/%@/%@", [PRIMECMAPPUtils getAPIEndpoint], appDelegate.username,appDelegate.projId];
    NSURL *apiURL =
    [NSURL URLWithString:strURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:apiURL];
    [urlRequest setHTTPMethod:@"GET"];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    _receivedData = [[NSMutableData alloc] init];
    [connection start];
    NSLog(@"URL---%@",strURL);
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.navigationController.view addSubview:hud];
    hud.labelText=@"";
    hud.dimBackground = YES;
    hud.delegate = self;
    [hud show:YES];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _receivedResponse = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData  *)data
{
    [_receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [hud setHidden:YES];
    _connectionError = error;
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [hud setHidden:YES];
    NSError *parseError = nil;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:_receivedData options:kNilOptions error:&parseError];
    NSInteger count =[[responseObject valueForKey:@"complianceForm"] count];
    
    if(type==0)
    {
        reports=[[responseObject valueForKey:@"complianceForm"]mutableCopy];
    }
    else if (type==1)
    {
        reports=[[responseObject valueForKey:@"nonComplianceForm"]mutableCopy];
    }
    else if (type==2)
    {
        reports=[[responseObject valueForKey:@"dailyInspectionForm"]mutableCopy];
    }
    else if (type==3)
    {
        reports=[[responseObject valueForKey:@"expenseReport"]mutableCopy];
    }
    else if (type==4)
    {
        reports=[[responseObject valueForKey:@"summarySheet1"]mutableCopy];
    }
    [table reloadData];
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
