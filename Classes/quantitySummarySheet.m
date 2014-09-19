//
//  quantitySummarySheet.m
//  PRIMECMAPP
//
//  Created by Lingeswaran Kandasamy on 8/10/14.
//
//

#import "quantitySummarySheet.h"
#import "quantityCellTableViewCell.h"
#import "TabAndSplitAppAppDelegate.h"
#import "PRIMECMAPPUtils.h"
#import "PRIMECMController.h"
@interface quantitySummarySheet (){
    
    
    UIPopoverController *popoverController;
    
    
    
    BOOL isSubTableView;
    NSMutableArray *arrayItems;
    NSMutableArray *itemDetails;
    
    
    MBProgressHUD *HUD;
    TabAndSplitAppAppDelegate *appDelegate;
    NSMutableData *_receivedData;
    NSURLResponse *_receivedResponse;
    NSError *_connectionError;
    NSArray *resPonse;
    UIBarButtonItem  *btnPrint;
    
    NSString *itemNo;
    NSString *itemDes;
    
    
    NSString *value;
    
    NSMutableArray *pickerDataArray;
    NSInteger pickerTag;
    UIPickerView *pickerView1;
    UIPickerView *pickerViewCities;
    
    
    BOOL isSaved;
    
    
    NSUserDefaults *defaults;
    
    
    
    
    
    
    
}

@end

@implementation quantitySummarySheet
@synthesize qtyTable;
@synthesize scrollView;
@synthesize i_number,item,est_quantity,project,unit,unit_price;

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
    

    
    defaults= [NSUserDefaults standardUserDefaults];
    
    
    NSString* temp1 = [defaults objectForKey:@"project"];
    NSString* temp2 = [defaults objectForKey:@"i_number"];
    NSString* temp3 = [defaults objectForKey:@"item"];
    NSString* temp4 = [defaults objectForKey:@"est_quantity"];
    NSString* temp5 = [defaults objectForKey:@"unit"];
    NSString* temp6 = [defaults objectForKey:@"unit_price"];
    
    
    NSString* temp7 = [defaults objectForKey:@"i_number"];
    
    
    
    project.text=temp1;
    i_number.text=temp2;
    item.text=temp3;
    est_quantity.text=temp4;
    unit.text=temp5;
    unit_price.text=temp6;
    
    // appDelegate.coloumn1=temp7;
    
    
    
    UIBarButtonItem *Button = [[UIBarButtonItem alloc]
                               initWithTitle:NSLocalizedString(@"Exit", @"")
                               style:UIBarButtonItemStyleDone
                               target:self
                               action:@selector(exit)];
    
    self.navigationItem.rightBarButtonItem = Button;
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
    
    
    
    
    // Do any additional setup after loading the view from its nib.
    scrollView.frame = CGRectMake(0,0, 720, 1800);
    [scrollView setContentSize:CGSizeMake(700, 2300)];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back.jpg"]];
    
    appDelegate=(TabAndSplitAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    project.text=appDelegate.projName;
    
    
    NSLog(@"------- %@",itemDetails);
    
    // [self getAllItems];
    
}







-(void)exit{
    
    
    
    
    
    NSString* textField1Text = project.text;
    [defaults setObject:textField1Text forKey:@"project"];
    
    
    NSString* textField2Text = i_number.text;
    [defaults setObject:textField2Text forKey:@"i_number"];
    
    NSString* textField3Text = item.text;
    [defaults setObject:textField3Text forKey:@"item"];
    
    
    NSString* textField4Text = est_quantity.text;
    [defaults setObject:textField4Text forKey:@"est_quantity"];
    
    NSString* textField5Text = unit.text;
    [defaults setObject:textField5Text forKey:@"unit"];
    
    NSString* textField6Text = unit_price.text;
    [defaults setObject:textField6Text forKey:@"unit_price"];
    
    
    [defaults synchronize];
    
    UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Data Cached." delegate:self cancelButtonTitle:@"EXIT" otherButtonTitles: nil];
    
    [exportAlert show];
    
    
    
    
}











-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    //value=i_number.text;
    
    NSLog(@"------11111------------");
    
    //  [self getAllItems];
    
    //  }
}



-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField==i_number)
    {
        [i_number resignFirstResponder];
        pickerDataArray=[[NSMutableArray alloc]initWithObjects:@"INO-01",@"INO-02",@"INO-03",@"INO-04",@"INO-05",@"INO-06",@"INO-07",@"INO-08",@"INO-09",@"INO-10",@"INO-11",@"INO-12",@"INO-13",@"INO-14",@"INO-15",@"INO-16",@"INO-17",@"INO-18",@"INO-19",@"INO-20",@"INO-21",@"INO-22",@"INO-23",@"INO-24",@"INO-25",@"INO-26",@"INO-27",@"INO-28",@"INO-29",@"INO-30",@"INO-31",@"INO-32",@"INO-33",@"INO-34",@"INO-35",@"INO-36",@"INO-37",@"INO-38",@"INO-39",@"INO-40",@"INO-41",@"INO-42",@"INO-43",@"INO-44",@"INO-45",@"INO-46",@"INO-47",@"INO-48",@"INO-49",@"INO-50",@"INO-51",@"INO-52",@"INO-53",@"INO-54",nil];
        [self createPicker:i_number];
        pickerTag=1;
    }
}

-(void)createPicker:(UITextField *)txtField
{
    
    
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolbar sizeToFit];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(selectionDone)];
    [barItems addObject:doneBtn];
    
    [pickerToolbar setItems:barItems animated:YES];
    
    
    pickerViewCities = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 320, 300)];
    pickerViewCities.delegate = self;
    
    
    pickerViewCities.showsSelectionIndicator = YES;
    
    
    UIViewController* popoverContent = [[UIViewController alloc] init];
    UIView* popoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 344)];
    popoverView.backgroundColor = [UIColor whiteColor];
    
    
    [popoverView addSubview:pickerToolbar];
    [popoverView addSubview:pickerViewCities];
    popoverContent.view = popoverView;
    
    popoverContent.preferredContentSize = CGSizeMake(320, 244);
    
    //create a popover controller
    popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    CGRect popoverRect = [self.view convertRect:[txtField frame]
                                       fromView:[txtField superview]];
    
    popoverRect.size.width = MIN(popoverRect.size.width, 100) ;
    popoverRect.origin.x  = popoverRect.origin.x;
    // popoverRect.size.height  = ;
    
    [popoverController
     presentPopoverFromRect:popoverRect
     inView:self.view
     permittedArrowDirections:UIPopoverArrowDirectionUp
     animated:YES];
    
}






- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    
    return pickerDataArray.count;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [pickerDataArray objectAtIndex:row];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
    if(pickerTag==1)
    {
        i_number.text=[pickerDataArray objectAtIndex:[pickerView selectedRowInComponent:0]];
        
    }
    
    
    
}
// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}



// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    CGFloat componentWidth = 0.0;
    componentWidth = 320.0;
    
    return componentWidth;
}


-(void)selectionDone
{
    [popoverController dismissPopoverAnimated:YES];
    
    value=i_number.text;
    
    NSLog(@"------11111------------");
    
    [self getAllItems];
}




-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"quantityCell";
    
    quantityCellTableViewCell *cell = (quantityCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"quantityCellTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    cell.i_Date.text = [[itemDetails valueForKey:@"date"]objectAtIndex:indexPath.row];
    cell.i_number.text = [[itemDetails valueForKey:@"No"]objectAtIndex:indexPath.row];
    cell.i_Accum.text = [[itemDetails valueForKey:@"accum"]objectAtIndex:indexPath.row];
    cell.i_Daily.text = [[itemDetails valueForKey:@"Qty"]objectAtIndex:indexPath.row];
    cell.location_station.text=appDelegate.address ;
    
    appDelegate=(TabAndSplitAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.coloumn1=cell.i_number.text;
    appDelegate.coloumn2=cell.i_Date.text;
    appDelegate.coloumn3=cell.location_station.text;
    appDelegate.coloumn4=cell.i_Daily.text;
    appDelegate.coloumn5=cell.i_Accum.text;
    
    
    
    
    NSString* textField1Text = appDelegate.coloumn1;
    [defaults setObject:textField1Text forKey:@"i_number"];
    
    
    
    
    
    
    
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return itemDetails.count;
    
}





- (IBAction)saveQuantitySumSheet:(id)sender {
    
    if(project.text==NULL || project.text.length==0|| i_number.text==NULL || i_number.text.length==0 || item.text==NULL || item.text.length==0 || est_quantity.text==NULL || est_quantity.text.length==0||unit.text==NULL || unit.text.length==0||unit_price.text==NULL || unit_price.text.length==0)
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
        // http://data.privytext.us/contructionapi.php/api/quantity_summary/save/`project/ item_no/ est_qty/unit/unit_price
        isSaved=YES;
        NSString *strURL;
        strURL= [NSString stringWithFormat:@"http://data.privytext.us/contructionapi.php/api/quantity_summary/save/%@/%@/%@/%@/%@/%@/%@",appDelegate.projId ,project.text,value,est_quantity.text,unit.text,unit_price.text,appDelegate.username];
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
        
        
        BOOL saveStatus = [PRIMECMController saveQuantitySummaryDetails: appDelegate.username
                                                                est_qty: est_quantity.text
                                                                item_no: i_number.text
                                                                project: project.text
                                                             project_id: appDelegate.projId
                                                                   unit: unit.text
                                                             unit_price: unit_price.text
                                                                   user: appDelegate.userId
                           ];
        
        
        
        project.text = @"";
        i_number.text=@"";
        est_quantity.text=@"";
        unit.text=@"";
        unit_price.text=@"";
        
        
        [HUD setHidden:YES];
        
        if (saveStatus ){
            UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Successfully saved QuantitySummaryDetails report." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [exportAlert show];
        }else{
            UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to save QuantitySummaryDetails report." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [exportAlert show];
        }
    }
}





-(void) populateItem
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.navigationController.view addSubview:HUD];
    HUD.labelText=@"";
    HUD.dimBackground = YES;
    HUD.delegate = self;
    [HUD show:YES];
    
    NSManagedObjectContext *context = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DailyInspectionItem" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY no == %@", value];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    
    if([objects count] > 0){
        NSManagedObject *complianceReportObject = (NSManagedObject *) [objects objectAtIndex:0];
        NSLog(@"Compliance Form object CNo: %@", [complianceReportObject valueForKey:@"no"]);
        
        
        item.text=[complianceReportObject valueForKey:@"desc"];
        
        
    }else{
        NSLog(@"No matching ComplianceForm with ID: %@", value);
    }
    
    
    [HUD setHidden:YES];
}




-(void)getAllItems
{
    NSString *strURL;
    
    isSaved=NO;
    
    
    strURL= [NSString stringWithFormat:@"http://data.privytext.us/contructionapi.php/api/quantity_summary/list/Lin/%@",value];
    
    
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
    isSubTableView=NO;
}









- (void)connectionDidFinishLoading:(NSURLConnection *)connection

{
    
    [HUD setHidden:YES];
    
    NSError *parseError = nil;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:_receivedData options:kNilOptions error:&parseError];
    
    
    
    NSLog(@"response---%@",responseObject);
    
    
    
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    //[[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    
    if(isSaved){
        
        isSaved=YES;
        if([[responseObject valueForKey:@"status"]isEqualToString:@"sucess"])
            
        {
            
            UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Successfully added." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [exportAlert show];
            
        }
        
        else
        {
            UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [exportAlert show];
        }
        
    }
    
    
    else{
        
        
        
        NSInteger count =[[responseObject valueForKey:@"quantity_summary"] count];
        NSLog(@"count--- %i",count);
        itemDetails=[[NSMutableArray alloc]init];
        
        itemDetails=[[responseObject valueForKey:@"quantity_summary"]mutableCopy];
        itemNo=[[itemDetails objectAtIndex:0]valueForKey:@"No"];
        itemDes=[[itemDetails objectAtIndex:0]valueForKey:@"Description"];
        
        
        NSLog(@"details---------%@",itemDetails);
        
        
        NSLog(@"iteeem%@",itemNo);
        NSLog(@"fsddsdf%@",[[itemDetails objectAtIndex:0]valueForKey:@"No"]);
        
        
        item.text=itemDes;
        
        
        // appDelegate.projectsArray=[[responseObject valueForKey:@"quantity_summary"] mutableCopy];
        // appDelegate.projId=[[itemDetails objectAtIndex:0]valueForKey:@"No"];
        
        NSLog(@"response obj------%@",itemDetails);
        // NSLog(@"response obj1------%@",appDelegate.projectsArray);
        
        
        [qtyTable reloadData];
        

        
        
    }
    
    
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
