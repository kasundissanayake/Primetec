//
//  Summary_2_ViewController.m
//  TabAndSplitApp
//
//  Created by Lingeswaran Kandasamy on 4/2/14.
//
//


/*
#import "Summary_2_ViewController.h"
#import "Summary_3_ViewController.h"
#import "TabAndSplitAppAppDelegate.h"
#import "PRIMECMAPPUtils.h"
#import "PRIMECMController.h"

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




@synthesize additionalDiscount;
@synthesize lessDiscount;
@synthesize mEAmount1;
@synthesize mEAmount2;
@synthesize mEAmount3;
@synthesize mEAmount4;
@synthesize mEAmount5;
@synthesize mEDescription1;
@synthesize mEDescription2;
@synthesize mEDescription3;
@synthesize mEDescription4;
@synthesize mEDescription5;
@synthesize mEQuantity1;
@synthesize mEQuantity2;
@synthesize mEQuantity3;
@synthesize mEQuantity4;
@synthesize mEQuantity5;
@synthesize mEUnitPrice1;
@synthesize mEUnitPrice2;
@synthesize mEUnitPrice3;
@synthesize mEUnitPrice4;
@synthesize mEUnitPrice5;
@synthesize total1;
@synthesize  total2;
@synthesize total3;
@synthesize scrollView;


@synthesize sMSSheetNo;




 

 
 


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
    if(textField==mEQuantity1 || textField==mEQuantity2 || textField==mEQuantity3 || textField==mEQuantity4  || textField==mEQuantity5 ||textField==mEUnitPrice1 || textField==mEUnitPrice2 || textField==mEUnitPrice3 || textField==mEUnitPrice4 || textField==mEUnitPrice5 || textField==total1 || textField==lessDiscount || textField==total2 || textField==additionalDiscount || total3)
    {
        
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
        for (int i = 0; i < [string length]; i++)
        {
            unichar c = [string characterAtIndex:i];
            if (![myCharSet characterIsMember:c])
            {
                
                mEQuantity1.enabled=YES;
                mEQuantity2.enabled=YES;
                mEQuantity3.enabled=YES;
                mEQuantity4.enabled=YES;
                mEQuantity5.enabled=YES;
                mEUnitPrice1.enabled=YES;
                mEUnitPrice2.enabled=YES;
                mEUnitPrice3.enabled=YES;
                mEUnitPrice4.enabled=YES;
                mEUnitPrice5.enabled=YES;
                total1.enabled=YES;
                lessDiscount.enabled=YES;
                total2.enabled=YES;
                additionalDiscount.enabled=YES;
                total3.enabled=YES;

                
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
    if(textField==mEAmount1)
    {
        
        double dist1 = [self.mEQuantity1.text doubleValue];
        double mileage1 = [self.mEUnitPrice1.text doubleValue];
        mEAmount1.text =  [NSString stringWithFormat:@"%.2f",dist1 * mileage1];
        
        [mEAmount1 resignFirstResponder];
    }
    if(textField==mEAmount2)
    {
        double dist2 = [self.mEQuantity2.text doubleValue];
        double mileage2 = [self.mEUnitPrice2.text doubleValue];
        mEAmount2.text =  [NSString stringWithFormat:@"%.2f",dist2 * mileage2];
        
        [mEAmount2 resignFirstResponder];
    }
    if(textField==mEAmount3)
    {
        double dist3 = [self.mEQuantity3.text doubleValue];
        double mileage3 = [self.mEUnitPrice3.text doubleValue];
        mEAmount3.text =  [NSString stringWithFormat:@"%.2f",dist3 * mileage3];
        
        [mEAmount3 resignFirstResponder];
    }
    
    if(textField==mEAmount4)
    {
        
        double dist4 = [self.mEQuantity4.text doubleValue];
        double mileage4 = [self.mEUnitPrice4.text doubleValue];
        mEAmount4.text =  [NSString stringWithFormat:@"%.2f",dist4 * mileage4];
        [mEAmount4 resignFirstResponder];
    }
    if(textField==mEAmount5)
    {
        
        double dist5 = [self.mEQuantity5.text doubleValue];
        double mileage5 = [self.mEUnitPrice5.text doubleValue];
        mEAmount5.text =  [NSString stringWithFormat:@"%.2f",dist5 * mileage5];
        [mEAmount5 resignFirstResponder];
    }
    
    double tot1 = [self.mEAmount1.text doubleValue];
    double tot2 = [self.mEAmount2.text doubleValue];
    double tot3 = [self.mEAmount3.text doubleValue];
    double tot4 = [self.mEAmount4.text doubleValue];
    double tot5 = [self.mEAmount5.text doubleValue];
    
    double allTot = tot1 + tot2 + tot3 + tot4 + tot5;
    
    
    double insu  = [self.lessDiscount.text doubleValue];
    
    
    double calcpersentage  = allTot - insu;
    
    double t20  = calcpersentage * 0.15;
    
    double gtotal = t20 + calcpersentage;
    total1.text =  [NSString stringWithFormat:@"%.2f",allTot];
    
    
    additionalDiscount.text = [NSString stringWithFormat:@"%.2f",t20];
    total2.text = [NSString stringWithFormat:@"%.2f",calcpersentage];
        
    total3.text = [NSString stringWithFormat:@"%.2f",gtotal];
    
    appDelegate.str2=total3.text;
    
    
    if(textField.text.length==0)
    {
        textField.text=@" ";
    }
}




-(IBAction)shownext
{
    
      if(total1.text==NULL || total1.text.length==0 || lessDiscount.text==NULL || lessDiscount.text.length==0 || total2.text==NULL || total2.text.length==0  || additionalDiscount.text==NULL || additionalDiscount.text.length==0 || total3.text==NULL || total3.text.length==0     )
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
        
        if (mEDescription1.text!=NULL && mEDescription1.text.length!=0 ) {
            
            field1=mEDescription1.text;
            
        }
        
        if (mEQuantity1.text!=NULL && mEQuantity1.text.length!=0 ) {
            
            field2=mEQuantity1.text;
            
        }
        
        if (mEUnitPrice1.text!=NULL && mEUnitPrice1.text.length!=0 ) {
            
            field3=mEUnitPrice1.text;
            
        }
        
        if (mEAmount1.text!=NULL && mEAmount1.text.length!=0 ) {
            
            field4=mEAmount1.text;
            
        }
        
        //
        
        if (mEDescription2.text!=NULL && mEDescription2.text.length!=0 ) {
            
            field5=mEDescription2.text;
            
        }
        
        if (mEQuantity2.text!=NULL && mEQuantity2.text.length!=0 ) {
            
            field6=mEQuantity2.text;
            
        }
        
        if (mEUnitPrice2.text!=NULL && mEUnitPrice2.text.length!=0 ) {
            
            field7=mEUnitPrice2.text;
            
        }
        
        if (mEAmount2.text!=NULL && mEAmount2.text.length!=0 ) {
            
            field8=mEAmount2.text;
            
        }
        
        
        //
        
        if (mEDescription3.text!=NULL && mEDescription3.text.length!=0 ) {
            
            field9=mEDescription3.text;
            
        }
        
        
        if (mEQuantity3.text!=NULL && mEQuantity3.text.length!=0 ) {
            
            field10=mEQuantity3.text;
            
        }
        
        
        if (mEUnitPrice3.text!=NULL && mEUnitPrice3.text.length!=0 ) {
            
            field11=mEUnitPrice3.text;
            
        }
        
        if (mEAmount3.text!=NULL && mEAmount3.text.length!=0 ) {
            
            field12=mEAmount3.text;
            
        }
        
        
        //
        
        if (mEDescription4.text!=NULL && mEDescription4.text.length!=0 ) {
            
            field13=mEDescription4.text;
            
        }
        
        if (mEQuantity4.text!=NULL && mEQuantity4.text.length!=0 ) {
            
            field14=mEQuantity4.text;
            
        }
        
        if (mEUnitPrice4.text!=NULL && mEUnitPrice4.text.length!=0 ) {
            
            field15=mEUnitPrice4.text;
            
        }
        
        
        if (mEAmount4.text!=NULL && mEAmount4.text.length!=0 ) {
            
            field16=mEAmount4.text;
            
        }
        
        
        
        //
        
        
        
        if (mEDescription5.text!=NULL && mEDescription5.text.length!=0 ) {
            
            field17=mEDescription5.text;
            
        }
        
        if (mEQuantity5.text!=NULL && mEQuantity5.text.length!=0 ) {
            
            field18=mEQuantity5.text;
            
        }
        
        if (mEUnitPrice5.text!=NULL && mEUnitPrice5.text.length!=0 ) {
            
            field19=mEUnitPrice5.text;
            
        }
        
        
        if (mEAmount5.text!=NULL && mEAmount5.text.length!=0 ) {
            
            field20=mEAmount5.text;
            
        }
        
       
    
        BOOL saveStatus = [PRIMECMController
                           saveSummery2:appDelegate.username
                           additionalDiscount:additionalDiscount.text
                           lessDiscount:lessDiscount.text
                           mEAmount1:mEAmount1.text
                           mEAmount2:mEAmount2.text
                           mEAmount3:mEAmount3.text
                           mEAmount4:mEAmount4.text
                           mEAmount5:mEAmount5.text
                           mEDescription1:mEDescription1.text
                           mEDescription2:mEDescription2.text
                           mEDescription3:mEDescription3.text
                           mEDescription4:mEDescription4.text
                           mEDescription5:mEDescription5.text
                           mEQuantity1:mEQuantity1.text
                           mEQuantity2:mEQuantity2.text
                           mEQuantity3:mEQuantity3.text
                           mEQuantity4:mEQuantity4.text
                           mEQuantity5:mEQuantity5.text
                           mEUnitPrice1:mEUnitPrice1.text
                           mEUnitPrice2:mEUnitPrice2.text
                           mEUnitPrice3:mEUnitPrice3.text
                           mEUnitPrice4:mEUnitPrice4.text
                           mEUnitPrice5:mEUnitPrice5.text
                           project_id:appDelegate.projId
                           sMSSheetNo:@""
                           total1:total1.text
                           total2:total2.text
                           total3:total3.text];
        
        [HUD setHidden:YES];
        
        if (saveStatus){
            UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Successfully saved summary sheet report." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [exportAlert show];
            [appDelegate.sketchesArray removeAllObjects];
           // [arrayImages removeAllObjects];
           // [self clearFormFields];
            
            Summary_3_ViewController *su=[[Summary_3_ViewController alloc] init];
            su.title=@"Summary Sheet";
            [self.navigationController pushViewController:su animated:YES];
            

            
        }else{
            UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to save summary sheet report." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [exportAlert show];
        }
        
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

@end */




/*******************Radha*******************/

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
#import "PRIMECMController.h"

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




@synthesize additionalDiscount;
@synthesize lessDiscount;
@synthesize mEAmount1;
@synthesize mEAmount2;
@synthesize mEAmount3;
@synthesize mEAmount4;
@synthesize mEAmount5;
@synthesize mEDescription1;
@synthesize mEDescription2;
@synthesize mEDescription3;
@synthesize mEDescription4;
@synthesize mEDescription5;
@synthesize mEQuantity1;
@synthesize mEQuantity2;
@synthesize mEQuantity3;
@synthesize mEQuantity4;
@synthesize mEQuantity5;
@synthesize mEUnitPrice1;
@synthesize mEUnitPrice2;
@synthesize mEUnitPrice3;
@synthesize mEUnitPrice4;
@synthesize mEUnitPrice5;
@synthesize total1;
@synthesize  total2;
@synthesize total3;
@synthesize scrollView,smSheetNumber,isEdit;
@synthesize sMSSheetNo;

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
    if(isEdit)
    {
        [self populateValues];
    }
    
}
-(void)populateValues
{
    mEDescription1.text=appDelegate.EditxtDes1;
    mEDescription2.text=appDelegate.EditxtDes2;
    mEDescription3.text=appDelegate.EditxtDes3;
    mEDescription4.text=appDelegate.EditxtDes4;
    mEDescription5.text=appDelegate.EditxtDES5;
    
    mEQuantity1.text=appDelegate.EditxtQuantity1;
    mEQuantity2.text=appDelegate.EditxtQuantity2;
    mEQuantity3.text=appDelegate.EditxtQuantity3;
    mEQuantity4.text=appDelegate.EditxtQuantity4;
    mEQuantity5.text=appDelegate.EditxtQuantity5;
    
    mEUnitPrice1.text=appDelegate.EditxtUnitPrice1;
    mEUnitPrice2.text=appDelegate.EditxtUnitPrice2;
    mEUnitPrice3.text=appDelegate.EditxtUnitPrice3;
    mEUnitPrice4.text=appDelegate.EditxtUnitPrice4;
    mEUnitPrice5.text=appDelegate.EditxtUnitPrice5;
    
    mEAmount1.text=appDelegate.EditxtMAmt1;
    mEAmount2.text=appDelegate.EditxtMAmt2;
    mEAmount3.text=appDelegate.EditxtMAmt3;
    mEAmount4.text=appDelegate.EditxtMAmt4;
    mEAmount5.text=appDelegate.EditxtMAmt5;
    
    total1.text=appDelegate.EditxtTotalMeterial;
    lessDiscount.text=appDelegate.EditxtLessDiscount;
    total2.text=appDelegate.EditxtLessDisTotal;
    additionalDiscount.text=appDelegate.EditxtAdditional;
    total3.text=appDelegate.EditxtAddTotal;
    
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
    if(textField==mEQuantity1 || textField==mEQuantity2 || textField==mEQuantity3 || textField==mEQuantity4  || textField==mEQuantity5 ||textField==mEUnitPrice1 || textField==mEUnitPrice2 || textField==mEUnitPrice3 || textField==mEUnitPrice4 || textField==mEUnitPrice5 || textField==total1 || textField==lessDiscount || textField==total2 || textField==additionalDiscount || total3)
    {
        
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
        for (int i = 0; i < [string length]; i++)
        {
            unichar c = [string characterAtIndex:i];
            if (![myCharSet characterIsMember:c])
            {
                
                mEQuantity1.enabled=YES;
                mEQuantity2.enabled=YES;
                mEQuantity3.enabled=YES;
                mEQuantity4.enabled=YES;
                mEQuantity5.enabled=YES;
                mEUnitPrice1.enabled=YES;
                mEUnitPrice2.enabled=YES;
                mEUnitPrice3.enabled=YES;
                mEUnitPrice4.enabled=YES;
                mEUnitPrice5.enabled=YES;
                total1.enabled=YES;
                lessDiscount.enabled=YES;
                total2.enabled=YES;
                additionalDiscount.enabled=YES;
                total3.enabled=YES;
                
                
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
    if(textField==mEAmount1)
    {
        
        double dist1 = [self.mEQuantity1.text doubleValue];
        double mileage1 = [self.mEUnitPrice1.text doubleValue];
        mEAmount1.text =  [NSString stringWithFormat:@"%.2f",dist1 * mileage1];
        
        [mEAmount1 resignFirstResponder];
    }
    if(textField==mEAmount2)
    {
        double dist2 = [self.mEQuantity2.text doubleValue];
        double mileage2 = [self.mEUnitPrice2.text doubleValue];
        mEAmount2.text =  [NSString stringWithFormat:@"%.2f",dist2 * mileage2];
        
        [mEAmount2 resignFirstResponder];
    }
    if(textField==mEAmount3)
    {
        double dist3 = [self.mEQuantity3.text doubleValue];
        double mileage3 = [self.mEUnitPrice3.text doubleValue];
        mEAmount3.text =  [NSString stringWithFormat:@"%.2f",dist3 * mileage3];
        
        [mEAmount3 resignFirstResponder];
    }
    
    if(textField==mEAmount4)
    {
        
        double dist4 = [self.mEQuantity4.text doubleValue];
        double mileage4 = [self.mEUnitPrice4.text doubleValue];
        mEAmount4.text =  [NSString stringWithFormat:@"%.2f",dist4 * mileage4];
        [mEAmount4 resignFirstResponder];
    }
    if(textField==mEAmount5)
    {
        
        double dist5 = [self.mEQuantity5.text doubleValue];
        double mileage5 = [self.mEUnitPrice5.text doubleValue];
        mEAmount5.text =  [NSString stringWithFormat:@"%.2f",dist5 * mileage5];
        [mEAmount5 resignFirstResponder];
    }
    
    double tot1 = [self.mEAmount1.text doubleValue];
    double tot2 = [self.mEAmount2.text doubleValue];
    double tot3 = [self.mEAmount3.text doubleValue];
    double tot4 = [self.mEAmount4.text doubleValue];
    double tot5 = [self.mEAmount5.text doubleValue];
    
    double allTot = tot1 + tot2 + tot3 + tot4 + tot5;
    
    
    double insu  = [self.lessDiscount.text doubleValue];
    
    
    double calcpersentage  = allTot - insu;
    
    double t20  = calcpersentage * 0.15;
    
    double gtotal = t20 + calcpersentage;
    total1.text =  [NSString stringWithFormat:@"%.2f",allTot];
    
    
    additionalDiscount.text = [NSString stringWithFormat:@"%.2f",t20];
    total2.text = [NSString stringWithFormat:@"%.2f",calcpersentage];
    
    total3.text = [NSString stringWithFormat:@"%.2f",gtotal];
    
    appDelegate.str2=total3.text;
    
    
    if(textField.text.length==0)
    {
        textField.text=@" ";
    }
}




-(IBAction)shownext
{
    
    if(total1.text==NULL || total1.text.length==0 || lessDiscount.text==NULL || lessDiscount.text.length==0 || total2.text==NULL || total2.text.length==0  || additionalDiscount.text==NULL || additionalDiscount.text.length==0 || total3.text==NULL || total3.text.length==0     )
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
        
        if (mEDescription1.text!=NULL && mEDescription1.text.length!=0 ) {
            
            field1=mEDescription1.text;
            
        }
        
        if (mEQuantity1.text!=NULL && mEQuantity1.text.length!=0 ) {
            
            field2=mEQuantity1.text;
            
        }
        
        if (mEUnitPrice1.text!=NULL && mEUnitPrice1.text.length!=0 ) {
            
            field3=mEUnitPrice1.text;
            
        }
        
        if (mEAmount1.text!=NULL && mEAmount1.text.length!=0 ) {
            
            field4=mEAmount1.text;
            
        }
        
        //
        
        if (mEDescription2.text!=NULL && mEDescription2.text.length!=0 ) {
            
            field5=mEDescription2.text;
            
        }
        
        if (mEQuantity2.text!=NULL && mEQuantity2.text.length!=0 ) {
            
            field6=mEQuantity2.text;
            
        }
        
        if (mEUnitPrice2.text!=NULL && mEUnitPrice2.text.length!=0 ) {
            
            field7=mEUnitPrice2.text;
            
        }
        
        if (mEAmount2.text!=NULL && mEAmount2.text.length!=0 ) {
            
            field8=mEAmount2.text;
            
        }
        
        
        //
        
        if (mEDescription3.text!=NULL && mEDescription3.text.length!=0 ) {
            
            field9=mEDescription3.text;
            
        }
        
        
        if (mEQuantity3.text!=NULL && mEQuantity3.text.length!=0 ) {
            
            field10=mEQuantity3.text;
            
        }
        
        
        if (mEUnitPrice3.text!=NULL && mEUnitPrice3.text.length!=0 ) {
            
            field11=mEUnitPrice3.text;
            
        }
        
        if (mEAmount3.text!=NULL && mEAmount3.text.length!=0 ) {
            
            field12=mEAmount3.text;
            
        }
        
        
        //
        
        if (mEDescription4.text!=NULL && mEDescription4.text.length!=0 ) {
            
            field13=mEDescription4.text;
            
        }
        
        if (mEQuantity4.text!=NULL && mEQuantity4.text.length!=0 ) {
            
            field14=mEQuantity4.text;
            
        }
        
        if (mEUnitPrice4.text!=NULL && mEUnitPrice4.text.length!=0 ) {
            
            field15=mEUnitPrice4.text;
            
        }
        
        
        if (mEAmount4.text!=NULL && mEAmount4.text.length!=0 ) {
            
            field16=mEAmount4.text;
            
        }
        
        
        
        //
        
        
        
        if (mEDescription5.text!=NULL && mEDescription5.text.length!=0 ) {
            
            field17=mEDescription5.text;
            
        }
        
        if (mEQuantity5.text!=NULL && mEQuantity5.text.length!=0 ) {
            
            field18=mEQuantity5.text;
            
        }
        
        if (mEUnitPrice5.text!=NULL && mEUnitPrice5.text.length!=0 ) {
            
            field19=mEUnitPrice5.text;
            
        }
        
        
        if (mEAmount5.text!=NULL && mEAmount5.text.length!=0 ) {
            
            field20=mEAmount5.text;
            
        }
        
        
        
        BOOL saveStatus = [PRIMECMController
                           saveSummery2:appDelegate.username
                           additionalDiscount:additionalDiscount.text
                           lessDiscount:lessDiscount.text
                           mEAmount1:mEAmount1.text
                           mEAmount2:mEAmount2.text
                           mEAmount3:mEAmount3.text
                           mEAmount4:mEAmount4.text
                           mEAmount5:mEAmount5.text
                           mEDescription1:mEDescription1.text
                           mEDescription2:mEDescription2.text
                           mEDescription3:mEDescription3.text
                           mEDescription4:mEDescription4.text
                           mEDescription5:mEDescription5.text
                           mEQuantity1:mEQuantity1.text
                           mEQuantity2:mEQuantity2.text
                           mEQuantity3:mEQuantity3.text
                           mEQuantity4:mEQuantity4.text
                           mEQuantity5:mEQuantity5.text
                           mEUnitPrice1:mEUnitPrice1.text
                           mEUnitPrice2:mEUnitPrice2.text
                           mEUnitPrice3:mEUnitPrice3.text
                           mEUnitPrice4:mEUnitPrice4.text
                           mEUnitPrice5:mEUnitPrice5.text
                           project_id:appDelegate.projId
                           sMSSheetNo:smSheetNumber
                           total1:total1.text
                           total2:total2.text
                           total3:total3.text
                           isEdit:isEdit];
        
        [HUD setHidden:YES];
        
        if (saveStatus){
            UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Summary Sheet 2 is saved.Fill the Sheet 3" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [exportAlert show];
            [appDelegate.sketchesArray removeAllObjects];
            // [arrayImages removeAllObjects];
            // [self clearFormFields];
            
            Summary_3_ViewController *su = [[Summary_3_ViewController alloc] init];
            su.title=@"Summary Sheet";
            su.isEdit = isEdit;
            su.smSheetNumber = smSheetNumber;
            
            [self.navigationController pushViewController:su animated:YES];
            
            
            
        }else{
            UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to save summary sheet report." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [exportAlert show];
        }
        
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



/*******************************************/
