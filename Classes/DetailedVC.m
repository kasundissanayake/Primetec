#import "DetailedVC.h"
#import "FirstViewController.h"
#import "TabAndSplitAppAppDelegate.h"
#import "RootVC.h"
#import "MenuOption.h"
#import "Reachability.h"
#import "PRIMECMAPPUtils.h"

@interface DetailedVC ()
{
    TabAndSplitAppAppDelegate *appDelegate;
    RootVC *root;
    FirstViewController *frst;
    NSMutableArray *hotelAnnotations;
    UIPopoverController *popoverController;
    UITableView *tblView;
    NSArray *tableData;
    NSMutableData *_receivedData;
    NSURLResponse *_receivedResponse;
    NSError *_connectionError;
    NSArray *resPonse;
    MBProgressHUD *HUD;
    Reachability *internetReachableFoo;
    NSArray *fetchedObjects;
    NSManagedObject *selectedObject;
}
@end

@implementation DetailedVC

-(IBAction)showFirst
{
	FirstViewController *fv=[[FirstViewController alloc] init];
	fv.title=@"First VC";
	[self.navigationController pushViewController:fv animated:NO];
}


- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate=(TabAndSplitAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    tblView=[[UITableView alloc] initWithFrame:CGRectMake(265, 680, 0, 0) style:UITableViewStylePlain];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMapData:) name:@"ViewControllerAReloadData" object:nil];
    appDelegate=(TabAndSplitAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home.jpg"]];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
    if(appDelegate.Tag==1)
    {
        UIBarButtonItem *Button = [[UIBarButtonItem alloc]
                                   initWithTitle:NSLocalizedString(@"Menu", @"")
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(selectType:)];
        
        self.navigationItem.rightBarButtonItem = Button;
        
        self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        self.navigationController.navigationBar.translucent = NO;
        
    }
    else
    {
        UIBarButtonItem *Button = [[UIBarButtonItem alloc]
                                   initWithTitle:NSLocalizedString(@"", @"")
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(selectType:)];
        
        self.navigationItem.rightBarButtonItem = Button;
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.text =[tableData objectAtIndex:indexPath.row];
    return cell;
}


-(IBAction)selectType:(id)sender
{
    tableData = [NSArray arrayWithObjects:@"Map", @"Compliance Form", nil];
    UIViewController *popoverContent=[[UIViewController alloc] init];
    UIView *popoverView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 300)];
    popoverView.backgroundColor=[UIColor whiteColor];
    popoverContent.view=popoverView;
    popoverContent.preferredContentSize=CGSizeMake(200, 420);
    popoverContent.view=tblView; //Adding tableView to popover
    tblView.delegate=self;
    tblView.dataSource=self;
    popoverController=[[UIPopoverController alloc]initWithContentViewController:popoverContent];
    [popoverController presentPopoverFromBarButtonItem:(UIBarButtonItem *)sender
                              permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (IBAction)LoginUser:(id)sender {
    
    if ([_usernameField.text isEqualToString:@""] || [_passwordField.text isEqualToString:@"" ]) {
        UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Oooops" message:@"Your username and password are empty." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [loginAlert show];
    }else{
        if ([self connected]) {
            
            NSLog(@"Login in online mode");
            
            NSString *strURL = [NSString stringWithFormat:@"%@/api/user/login/check/%@/%@", [PRIMECMAPPUtils getAPIEndpoint] , _usernameField.text, _passwordField.text];
            NSURL *apiURL =
            [NSURL URLWithString:strURL];
            NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:apiURL];
            [urlRequest setHTTPMethod:@"GET"];
            NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
            _receivedData = [[NSMutableData alloc] init];
            [connection start];
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.navigationController.view addSubview:HUD];
            HUD.labelText=@"";
            HUD.dimBackground = YES;
            HUD.delegate = self;
            [HUD show:YES];
            
        } else if(![self connected]){
            
            NSLog(@"Login in offline mode");
            
            NSManagedObjectContext *context = [PRIMECMAPPUtils getManagedObjectContext];
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription
                                           entityForName:@"Users" inManagedObjectContext:context];
            [fetchRequest setEntity:entity];
            NSError *error;
            fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:entity];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(username == %@ && password == %@)", [_TUserName text], [_TPassword text]];
            [request setPredicate:predicate];
            NSArray *result = [context executeFetchRequest:request error:&error];
            
            if ((result != nil) && ([result count] > 0) && (error == nil)){
                NSManagedObject *obj = [result objectAtIndex:0];
                appDelegate.userTypeOffline= [obj valueForKey:@"user_type"];
                selectedObject = obj;
                appDelegate.Tag=4;
                
                NSString *fname=[obj valueForKey:@"firstname"];
                NSString *lname=[obj valueForKey:@"lastname"];
                NSString *combined = [NSString stringWithFormat:@"%@ %@", fname, lname];
                
                appDelegate.userId=[obj valueForKey:@"id_no"];
                appDelegate.username=[obj valueForKey:@"username"];
                appDelegate.projPrintedName=combined;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeView" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeTableView" object:nil];
                
                NSLog(@"--------Login Success Offline---------");
            }
            else{
                NSLog(@"-------Login Error Offline------------");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed"
                                                                message:@"Incorrect username or password.Please try again"
                                                               delegate:self
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                alert.delegate=self;
                [alert show];
            }
        }
    }
}


-(void)displayManagedObject:(NSManagedObject *)obj {
    appDelegate.userTypeOffline = [obj valueForKey:@"user_type"];
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
    [HUD setHidden:YES];
    _connectionError = error;
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [HUD setHidden:YES];
    NSError *parseError = nil;
    NSArray *responseObject = [NSJSONSerialization JSONObjectWithData:_receivedData options:0
                                                                error:&parseError];
    
    
    NSString *loginStatus = [[responseObject  valueForKey:@"message"]valueForKey:@"status"];
    NSString *fname=[responseObject valueForKey:@"firstname"];
    NSString *lname=[responseObject valueForKey:@"lastname"];
    
    NSString *combined = [NSString stringWithFormat:@"%@ %@", fname, lname];
    
    appDelegate.userId=[responseObject valueForKey:@"id_no"];
    appDelegate.projPrintedName=combined;
    if ([loginStatus isEqualToString: @"sucess"] ) {
        
        appDelegate.username=_usernameField.text;
        
        appDelegate.userType=[responseObject  valueForKey:@"user_type"];
        
        appDelegate.Tag=4;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeView" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeTableView" object:nil];
        [root.Frontimage setHidden:TRUE];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed"
                                                        message:@"Incorrect username or password.Please try again"
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        alert.delegate=self;
        [alert show];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [super viewDidUnload];

}
@end
