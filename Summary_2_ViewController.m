//
//  Summary_2_ViewController.m
//  TabAndSplitApp
//
//  Created by Lingeswaran Kandasamy on 4/2/14.
//
//

#import "Summary_2_ViewController.h"
#import "Summary_3_ViewController.h"
#import "TabAndSplitAppAppDelegate.h"
#import "PRIMECMAPPUtils.h"

@interface Summary_2_ViewController ()

{
    NSMutableArray *hotelAnnotations;
    
    UIPopoverController *popoverController;
    UITableView *tblView;
    NSArray *tableData;
    UIViewController *popoverContent;
    
    NSInteger count;
    
    MBProgressHUD *HUD;
    
    NSMutableData *_receivedData;
    NSURLResponse *_receivedResponse;
    NSError *_connectionError;
    NSArray *resPonse;
    
    BOOL *uploading;
    BOOL *uploadingsketch;
    int count1;
    int count2;
    NSString *comNoticeNo;
    
    BOOL isUploadingSignature;
    
    TabAndSplitAppAppDelegate *appDelegate;
    
}
@end

@implementation Summary_2_ViewController


@synthesize scrollView;
@synthesize txtRate1,txtRate2,txtRate3,txtRate4,txtRate5;
@synthesize txtTotal1,txtTotal2,txtTotal3,txtTotal4,txtTotal5;
@synthesize txtQTY1,txtQTY2,txtQTY3,txtQTY4,txtQTY5,tTotal,txtGRTotal,txt20,txtLTotal,txtInsu;
@synthesize txtDescription1,txtDescription2,txtDescription3,txtDescription4,txtDescription5;

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
    
    
    scrollView.frame = CGRectMake(0,-10, 770, 2088);
    [scrollView setContentSize:CGSizeMake(620, 2300)];
    popoverContent=[[UIViewController alloc] init];
    
    tblView=[[UITableView alloc] initWithFrame:CGRectMake(265, 680, 0, 0) style:UITableViewStylePlain];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMapData:) name:@"ViewControllerAReloadData" object:nil];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back.jpg"]];
    // Do any additional setup after loading the view from its nib.
    
    appDelegate=(TabAndSplitAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    
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
    
    
    UIView *popoverView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 300)];
    
    popoverView.backgroundColor=[UIColor whiteColor];
    
    popoverContent.view=popoverView;
    popoverContent.preferredContentSize=CGSizeMake(250, 250);
    popoverContent.view=tblView; //Adding tableView to popover
    tblView.delegate=self;
    tblView.dataSource=self;
    
    popoverController=[[UIPopoverController alloc]initWithContentViewController:popoverContent];
    
    [popoverController presentPopoverFromBarButtonItem:(UIBarButtonItem *)sender
                              permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField==txtQTY1 || textField==txtQTY2 || textField==txtQTY3 || textField==txtQTY4  || textField==txtQTY5 ||textField==txtRate1 || textField==txtRate2 || textField==txtRate3 || textField==txtRate4 || textField==txtRate5 || textField==tTotal || textField==txtInsu || textField==txtLTotal || textField==txt20 || txtGRTotal)
    {
        
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
        for (int i = 0; i < [string length]; i++)
        {
            unichar c = [string characterAtIndex:i];
            if (![myCharSet characterIsMember:c])
            {
                
                txtQTY1.enabled=YES;
                txtQTY2.enabled=YES;
                txtQTY3.enabled=YES;
                txtQTY4.enabled=YES;
                txtQTY5.enabled=YES;
                txtRate1.enabled=YES;
                txtRate2.enabled=YES;
                txtRate3.enabled=YES;
                txtRate4.enabled=YES;
                txtRate5.enabled=YES;
                tTotal.enabled=YES;
                txtInsu.enabled=YES;
                txtLTotal.enabled=YES;
                txt20.enabled=YES;
                txtGRTotal.enabled=YES;

                
                return NO;
            }
            else{
                
             
             
            }
        }
        
        return YES;
    }
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField==txtTotal1)
    {
        
        double dist1 = [self.txtQTY1.text doubleValue];
        double mileage1 = [self.txtRate1.text doubleValue];
        txtTotal1.text =  [NSString stringWithFormat:@"%.2f",dist1 * mileage1];
        
        [txtTotal1 resignFirstResponder];
    }
    if(textField==txtTotal2)
    {
        double dist2 = [self.txtQTY2.text doubleValue];
        double mileage2 = [self.txtRate2.text doubleValue];
        txtTotal2.text =  [NSString stringWithFormat:@"%.2f",dist2 * mileage2];
        
        [txtTotal2 resignFirstResponder];
    }
    if(textField==txtTotal3)
    {
        double dist3 = [self.txtQTY3.text doubleValue];
        double mileage3 = [self.txtRate3.text doubleValue];
        txtTotal3.text =  [NSString stringWithFormat:@"%.2f",dist3 * mileage3];
        
        [txtTotal3 resignFirstResponder];
    }
    
    if(textField==txtTotal4)
    {
        
        double dist4 = [self.txtQTY4.text doubleValue];
        double mileage4 = [self.txtRate4.text doubleValue];
        txtTotal4.text =  [NSString stringWithFormat:@"%.2f",dist4 * mileage4];
        [txtTotal4 resignFirstResponder];
    }
    if(textField==txtTotal5)
    {
        
        double dist5 = [self.txtQTY5.text doubleValue];
        double mileage5 = [self.txtRate5.text doubleValue];
        txtTotal5.text =  [NSString stringWithFormat:@"%.2f",dist5 * mileage5];
        [txtTotal5 resignFirstResponder];
    }
    
    double tot1 = [self.txtTotal1.text doubleValue];
    double tot2 = [self.txtTotal2.text doubleValue];
    double tot3 = [self.txtTotal3.text doubleValue];
    double tot4 = [self.txtTotal4.text doubleValue];
    double tot5 = [self.txtTotal5.text doubleValue];
    
    double allTot = tot1 + tot2 + tot3 + tot4 + tot5;
    
    
    double insu  = [self.txtInsu.text doubleValue];
    
    
    double calcpersentage  = allTot - insu;
    
    double t20  = calcpersentage * 0.15;
    
    double gtotal = t20 + calcpersentage;
    tTotal.text =  [NSString stringWithFormat:@"%.2f",allTot];
    
    
    txt20.text = [NSString stringWithFormat:@"%.2f",t20];
    txtLTotal.text = [NSString stringWithFormat:@"%.2f",calcpersentage];
        
    txtGRTotal.text = [NSString stringWithFormat:@"%.2f",gtotal];
    
    appDelegate.str2=txtGRTotal.text;
    
    
    if(textField.text.length==0)
    {
        textField.text=@" ";
    }
}




-(IBAction)shownext
{
    
      if(tTotal.text==NULL || tTotal.text.length==0 || txtInsu.text==NULL || txtInsu.text.length==0 || txtLTotal.text==NULL || txtLTotal.text.length==0  || txt20.text==NULL || txt20.text.length==0 || txtGRTotal.text==NULL || txtGRTotal.text.length==0     )
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty"
                                                        message:@"Please fill all the fields"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        
    }
    else
    {
        
        NSString *field1=@" ";
        NSString *field2=@" ";
        NSString *field3=@" ";
        NSString *field4=@" ";
        NSString *field5=@" ";
        NSString *field6=@" ";
        NSString *field7=@" ";
        NSString *field8=@" ";
        NSString *field9=@" ";
        NSString *field10=@" ";
        NSString *field11=@" ";
        NSString *field12=@" ";
        NSString *field13=@" ";
        NSString *field14=@" ";
        NSString *field15=@" ";
        NSString *field16=@" ";
        NSString *field17=@" ";
        NSString *field18=@" ";
        NSString *field19=@" ";
        NSString *field20=@" ";
        
        if (txtDescription1.text!=NULL && txtDescription1.text.length!=0 ) {
            
            field1=txtDescription1.text;
            
        }
        
        if (txtQTY1.text!=NULL && txtQTY1.text.length!=0 ) {
            
            field2=txtQTY1.text;
            
        }
        
        if (txtRate1.text!=NULL && txtRate1.text.length!=0 ) {
            
            field3=txtRate1.text;
            
        }
        
        if (txtTotal1.text!=NULL && txtTotal1.text.length!=0 ) {
            
            field4=txtTotal1.text;
            
        }
        
        //
        
        if (txtDescription2.text!=NULL && txtDescription2.text.length!=0 ) {
            
            field5=txtDescription2.text;
            
        }
        
        if (txtQTY2.text!=NULL && txtQTY2.text.length!=0 ) {
            
            field6=txtQTY2.text;
            
        }
        
        if (txtRate2.text!=NULL && txtRate2.text.length!=0 ) {
            
            field7=txtRate2.text;
            
        }
        
        if (txtTotal2.text!=NULL && txtTotal2.text.length!=0 ) {
            
            field8=txtTotal2.text;
            
        }
        
        
        //
        
        if (txtDescription3.text!=NULL && txtDescription3.text.length!=0 ) {
            
            field9=txtDescription3.text;
            
        }
        
        
        if (txtQTY3.text!=NULL && txtQTY3.text.length!=0 ) {
            
            field10=txtQTY3.text;
            
        }
        
        
        if (txtRate3.text!=NULL && txtRate3.text.length!=0 ) {
            
            field11=txtRate3.text;
            
        }
        
        if (txtTotal3.text!=NULL && txtTotal3.text.length!=0 ) {
            
            field12=txtTotal3.text;
            
        }
        
        
        //
        
        if (txtDescription4.text!=NULL && txtDescription4.text.length!=0 ) {
            
            field13=txtDescription4.text;
            
        }
        
        if (txtQTY4.text!=NULL && txtQTY4.text.length!=0 ) {
            
            field14=txtQTY4.text;
            
        }
        
        if (txtRate4.text!=NULL && txtRate4.text.length!=0 ) {
            
            field15=txtRate4.text;
            
        }
        
        
        if (txtTotal4.text!=NULL && txtTotal4.text.length!=0 ) {
            
            field16=txtTotal4.text;
            
        }
        
        
        
        //
        
        
        
        if (txtDescription5.text!=NULL && txtDescription5.text.length!=0 ) {
            
            field17=txtDescription5.text;
            
        }
        
        if (txtQTY5.text!=NULL && txtQTY5.text.length!=0 ) {
            
            field18=txtQTY5.text;
            
        }
        
        if (txtRate5.text!=NULL && txtRate5.text.length!=0 ) {
            
            field19=txtRate5.text;
            
        }
        
        
        if (txtTotal5.text!=NULL && txtTotal5.text.length!=0 ) {
            
            field20=txtTotal5.text;
            
        }
        
        NSString *strURL = [NSString stringWithFormat:@"%@/api/summary2/create/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@", [PRIMECMAPPUtils getAPIEndpoint], appDelegate.username,appDelegate.saveVal,appDelegate.projId,field1,field2,field3,field4,field5,field6,field7,field8,field9,field10,field11,field12,field13,field14,field15,field16,field17,field18,field19,field20,tTotal.text,txtInsu.text,txtLTotal.text,txt20.text,txtGRTotal.text];
        
        NSLog(@"URL---- %@",strURL);
        
        NSString *uencodedUrl = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *apiURL =
        [NSURL URLWithString:uencodedUrl];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:apiURL];
        [urlRequest setHTTPMethod:@"POST"];
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
        tTotal.text=NULL ;
        txtInsu.text=NULL ;
        txtLTotal.text=NULL ;
        txt20.text=NULL;
        txtGRTotal.text=NULL;
        txt20.text=@"";
        txtDescription1.text=@"";
        txtDescription2.text=@"";
        txtDescription3.text=@"";
        txtDescription4.text=@"";
        txtDescription5.text=@"";
        txtQTY1.text=@"";
        txtQTY2.text=@"";
        txtQTY3.text=@"";
        txtQTY4.text=@"";
        txtQTY5.text=@"";
        txtRate1.text=@"";
        txtRate2.text=@"";
        txtRate3.text=@"";
        txtRate4.text=@"";
        txtRate5.text=@"";
        txtTotal1.text=@"";
        txtTotal2.text=@"";
        txtTotal3.text=@"";
        txtTotal4.text=@"";
        txtTotal5.text=@"";
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _receivedResponse = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
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
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:_receivedData options:kNilOptions error:&parseError];
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
   // [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    if([[responseObject valueForKey:@"status"]isEqualToString:@"sucess"])
    {
        Summary_3_ViewController *su=[[Summary_3_ViewController alloc] init];
        su.title=@"Summary Sheet";
        [self.navigationController pushViewController:su animated:YES];
        
        UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Successfully added." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [exportAlert show];
    }
    else
    {
        UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [exportAlert show];
    }
    
}

-(NSString*)getCurrentDateTimeAsNSString
{
    //get current datetime as image name
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-ddHH:mm:ss"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [format setLocale:locale];
    NSDate *now = [NSDate date];
    NSString *retStr = [format stringFromDate:now];
    return retStr;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
