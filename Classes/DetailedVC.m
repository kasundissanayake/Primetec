


#import "DetailedVC.h"
#import "FirstViewController.h"
#import "TabAndSplitAppAppDelegate.h"
#import "RootVC.h"
#import "MenuOption.h"
#import "Reachability.h"
#import "userdetails.h"


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
    
    //woornika
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
        UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Oooops" message:@"Your username and password does not match" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [loginAlert show];
    }else{
        

        
        
        
        if ([self connected]) {
            
            
            
            
            NSString *strURL = [NSString stringWithFormat:@"http://data.privytext.us/contructionapi.php/api/user/login/check/%@/%@",_usernameField.text, _passwordField.text];
            
            
            
            
            NSURL *apiURL =
            [NSURL URLWithString:strURL];
            NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:apiURL];
            
            
            
            
            
            [urlRequest setHTTPMethod:@"GET"];
            
            
            NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
            
            
            
            _receivedData = [[NSMutableData alloc] init];
            
            
            [connection start];
            
            
            NSLog(@"URL---%@",strURL);
            
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.navigationController.view addSubview:HUD];
            HUD.labelText=@"";
            HUD.dimBackground = YES;
            HUD.delegate = self;
            [HUD show:YES];
            
            
            

        } else if(![self connected]){
            
            appDelegate=(TabAndSplitAppAppDelegate *)[[UIApplication sharedApplication] delegate];

            
            NSManagedObjectContext *context = [appDelegate managedObjectContext];
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
            
            NSArray *result = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
            

            for (NSManagedObject *obj in fetchedObjects) {
                NSLog(@"username: %@", [obj valueForKey:@"username"]);
                NSLog(@"password: %@", [obj valueForKey:@"password"]);
                NSLog(@"type: %@", [obj valueForKey:@"user_type"]);

            }

            
            if ((result != nil) && ([result count]) && (error == nil)){
                
   

                NSManagedObject *obj = [result objectAtIndex:0];

                appDelegate.userTypeOffline= [obj valueForKey:@"user_type"];
                
                selectedObject = obj;

                
               NSLog(@"type======%@",[obj valueForKey:@"user_type"]);

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



- (void) saveData
{
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSManagedObject *newContact;
    

    
    newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Users" inManagedObjectContext:context];
    
    [newContact setValue:@"lin" forKey:@"username"];
    [newContact setValue:@"12345" forKey:@"password"];
    
    
    NSError *error;
    [context save:&error];
    
    NSLog(@"-----------user saved--------");
    
    
}



- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response
{
    
    _receivedResponse = response;
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData
                                                                 *)data
{
    
    [_receivedData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError
                                                                   *)error
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
    
    
    NSLog(@"response obj------%@",responseObject);
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
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}




@end
