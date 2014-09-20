//
//  SummaryReportViewController.m
//  TabAndSplitApp
//
//  Created by Lingeswaran Kandasamy on 4/2/14.
//
//

#import "SummaryReportViewController.h"
#import "Summary_2_ViewController.h"
#import "SignatureViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TabAndSplitAppAppDelegate.h"
#import "PRIMECMAPPUtils.h"
#import "PRIMECMController.h"

@interface SummaryReportViewController ()
{
    NSMutableArray *hotelAnnotations;
    UIPopoverController *popoverController;
    UITableView *tblView;
    NSArray *tableData;
    UIDatePicker *datePicker;
    NSInteger pickerTag;
    UIPickerView *pickerView;
    NSMutableArray *pickerDataArray;
    SignatureViewController *signatureViewController;
    NSString *isSignature;
    UIButton *btnCloseSignView;
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
    NSDictionary *sourceDictionary;
}

@end

@implementation SummaryReportViewController

@synthesize isEdit;
@synthesize city;
@synthesize conPeWork;
@synthesize constructionOrder;
@synthesize contractor;
@synthesize date;
@synthesize descr;
@synthesize federalAidNumber;
@synthesize healWelAndPension;
@synthesize insAndTaxesOnItem1;
@synthesize itemDescount20per;
@synthesize lAAmount1;
@synthesize lAAmount2;
@synthesize lAAmount3;
@synthesize lAAmount4;
@synthesize lAAmount5;
@synthesize lAClass1;
@synthesize lAClass2;
@synthesize lAClass3;
@synthesize lAClass4;
@synthesize lAClass5;
@synthesize lANo1;
@synthesize lANo2;
@synthesize lANo3;
@synthesize lANo4;
@synthesize lANo5;
@synthesize lARate1;
@synthesize lARate2;
@synthesize lARate3;
@synthesize lARate4;
@synthesize lARate5;
@synthesize lATotalHours1;
@synthesize lATotalHours2;
@synthesize lATotalHours3;
@synthesize lATotalHours4;
@synthesize lATotalHours5;
@synthesize pOBox;
@synthesize projectNo;
@synthesize sSHeader;
@synthesize state;
@synthesize telephoneNo;
@synthesize total;
@synthesize totalLabor;
@synthesize zip;
@synthesize scrollView;
@synthesize arrayImages;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithData:(NSDictionary *)sourceDictionaryParam
{
    self = [super init];
    sourceDictionary = sourceDictionaryParam;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];  
    
    comNoticeNo=@"";
    count=0;
    count1=0;
    
    appDelegate=(TabAndSplitAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.sketchesArray removeAllObjects];
    
    [descr.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [descr.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [descr.layer setBorderWidth: 1.0];
    [descr.layer setCornerRadius:8.0f];
    [descr.layer setMasksToBounds:YES];
    
    [constructionOrder.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [constructionOrder.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [constructionOrder.layer setBorderWidth: 1.0];
    [constructionOrder.layer setCornerRadius:8.0f];
    [constructionOrder.layer setMasksToBounds:YES];
    
    tblView=[[UITableView alloc] initWithFrame:CGRectMake(265, 680, 0, 0) style:UITableViewStylePlain];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMapData:) name:@"ViewControllerAReloadData" object:nil];
    // Do any additional setup after loading the view from its nib.
    scrollView.frame = CGRectMake(0,-10, 770, 2088);
    [scrollView setContentSize:CGSizeMake(620, 2300)];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back.jpg"]];
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormat stringFromDate:today];
    
    contractor.text=appDelegate.projId;
    pOBox.text=appDelegate.address;
    city.text=appDelegate.city;
    state.text=appDelegate.state;
    zip.text=appDelegate.zip;
    projectNo.text=appDelegate.projId;
    date.text=dateString;
    telephoneNo.text=appDelegate.tel;
    
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
    
}


-(void)populateValues
{
    
}


-(void)exit{
    UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Data Cached." delegate:self cancelButtonTitle:@"EXIT" otherButtonTitles: nil];
    [exportAlert show];    
}



-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField==lATotalHours1 || textField==lATotalHours2 || textField==lATotalHours3 || textField==lATotalHours4  || textField==lATotalHours4 ||textField==lATotalHours5 || textField==lARate1 || textField==lARate2 || textField==lARate3 || textField==lARate4 || textField==lARate5 || textField==healWelAndPension || textField==insAndTaxesOnItem1)
    {
        
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
        for (int i = 0; i < [string length]; i++)
        {
            unichar c = [string characterAtIndex:i];
            if (![myCharSet characterIsMember:c])
            {
                
                lATotalHours1.enabled=YES;
                lATotalHours2.enabled=YES;
                lATotalHours3.enabled=YES;
                lATotalHours4.enabled=YES;
                lATotalHours5.enabled=YES;
                lARate1.enabled=YES;
                lARate2.enabled=YES;
                lARate3.enabled=YES;
                lARate4.enabled=YES;
                lARate5.enabled=YES;
                healWelAndPension.enabled=YES;
                insAndTaxesOnItem1.enabled=YES;
                
                
                return NO;
            }
            
            else{
                
                //  federalAidNumber.enabled=NO;
                
            }
            
        }
        
        return YES;
    }
    
    return YES;
}



/*************************************************************/

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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.section == 0 && indexPath.row == 0)
        
    {
        
    }
    if(indexPath.section==0 && indexPath.row==1)
    {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeDashboard" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showSProject" object:nil];
        
    }
    
    
    if(indexPath.section==0 && indexPath.row==2)
    {
        
    }
    
    [popoverController dismissPopoverAnimated:YES];
}




//brin
-(IBAction)selectType:(id)sender
{
    
    tableData = [NSArray arrayWithObjects:@"",@"Dashboard", @"Help",nil];
    
    UIViewController *popoverContent=[[UIViewController alloc] init];
    [tblView reloadData];
    UIView *popoverView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 300)];
    
    popoverView.backgroundColor=[UIColor whiteColor];
    
    popoverContent.view=popoverView;
    popoverContent.preferredContentSize=CGSizeMake(250, 150);
    popoverContent.view=tblView; //Adding tableView to popover
    tblView.delegate=self;
    tblView.dataSource=self;
    popoverController=[[UIPopoverController alloc]initWithContentViewController:popoverContent];
    [popoverController presentPopoverFromBarButtonItem:(UIBarButtonItem *)sender
                              permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}
//end


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    
    if(textField==lAAmount1)
    {
        double dist1 = [self.lATotalHours1.text doubleValue];
        double mileage1 = [self.lARate1.text doubleValue];
        lAAmount1.text =  [NSString stringWithFormat:@"%.2f",dist1 * mileage1];
        [lAAmount1 resignFirstResponder];
    }
    if(textField==lAAmount2)
    {
        double dist2 = [self.lATotalHours2.text doubleValue];
        double mileage2 = [self.lARate2.text doubleValue];
        lAAmount2.text =  [NSString stringWithFormat:@"%.2f",dist2 * mileage2];
        
        [lAAmount2 resignFirstResponder];
    }
    if(textField==lAAmount3)
    {
        double dist3 = [self.lATotalHours3.text doubleValue];
        double mileage3 = [self.lARate3.text doubleValue];
        lAAmount3.text =  [NSString stringWithFormat:@"%.2f",dist3 * mileage3];
        
        [lAAmount3 resignFirstResponder];
    }
    
    if(textField==lAAmount4)
    {
        
        double dist4 = [self.lATotalHours4.text doubleValue];
        double mileage4 = [self.lARate4.text doubleValue];
        lAAmount4.text =  [NSString stringWithFormat:@"%.2f",dist4 * mileage4];
        [lAAmount4 resignFirstResponder];
    }
    if(textField==lAAmount5)
    {
        
        double dist5 = [self.lATotalHours5.text doubleValue];
        double mileage5 = [self.lARate5.text doubleValue];
        lAAmount5.text =  [NSString stringWithFormat:@"%.2f",dist5 * mileage5];
        [lAAmount5 resignFirstResponder];
    }
    
    double tot1 = [self.lAAmount1.text doubleValue];
    double tot2 = [self.lAAmount2.text doubleValue];
    double tot3 = [self.lAAmount3.text doubleValue];
    double tot4 = [self.lAAmount4.text doubleValue];
    double tot5 = [self.lAAmount5.text doubleValue];
    double allTot = tot1 + tot2 + tot3 + tot4 + tot5;
    
    totalLabor.text =  [NSString stringWithFormat:@"%.2f",allTot];
    double insu  = [self.insAndTaxesOnItem1.text doubleValue];
    
    double health  = [self.healWelAndPension.text doubleValue];
    
    double calcpersentage  = allTot + insu + health;
    
    double t20  = calcpersentage * 0.2;
    
    double gtotal = t20 + calcpersentage;
    
    itemDescount20per.text = [NSString stringWithFormat:@"%.2f",t20];
    
    total.text = [NSString stringWithFormat:@"%.2f",gtotal];
    
    appDelegate.str1=total.text;
    
    
    
    if(textField.text.length==0)
    {
        textField.text=@" ";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)next:(id)sender {
    int totalRecords = [PRIMECMController totalObjectsOfSummarySheet];
    NSString *smNum;
    if(!isEdit)
    {
        //New Record
        smNum = [NSString stringWithFormat:@"SM_%d_%d",arc4random()%10000,totalRecords+1];
    }
    else
    {
        smNum =  appDelegate.sMSheetNo;
    }
    
    if(contractor.text==NULL || contractor.text.length==0 || pOBox.text==NULL || pOBox.text.length==0 || city.text==NULL || city.text.length==0 || state.text==NULL || state.text.length==0 || telephoneNo.text==NULL || telephoneNo.text.length==0 || date.text==NULL || date.text.length==0 || conPeWork.text==NULL || conPeWork.text.length==0 || federalAidNumber.text==NULL || federalAidNumber.text.length==0 || projectNo.text==NULL || projectNo.text.length==0 || descr.text==NULL || descr.text.length==0 || constructionOrder.text==NULL || constructionOrder.text.length==0 || total.text==NULL || total.text.length==0 || healWelAndPension.text==NULL || healWelAndPension.text.length==0 || insAndTaxesOnItem1.text==NULL || insAndTaxesOnItem1.text.length==0 || totalLabor.text==NULL || totalLabor.text.length==0 ||  itemDescount20per.text==NULL || itemDescount20per.text.length==0  || zip.text==NULL ||zip.text.length==0  )
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
        NSString *field21=@" ";
        NSString *field22=@" ";
        NSString *field23=@" ";
        NSString *field24=@" ";
        NSString *field25=@" ";
        
        
        
        
        if (lAClass1.text!=NULL && lAClass1.text.length!=0 ) {
            
            field1=lAClass1.text;
            
        }
        
        if (lANo1.text!=NULL && lANo1.text.length!=0 ) {
            
            field2=lANo1.text;
            
        }
        
        if (lATotalHours1.text!=NULL && lATotalHours1.text.length!=0 ) {
            
            field3=lATotalHours1.text;
            
        }
        
        if (lARate1.text!=NULL && lARate1.text.length!=0 ) {
            
            field4=lARate1.text;
            
        }
        
        if (lAAmount1.text!=NULL && lAAmount1.text.length!=0 ) {
            
            field5=lAAmount1.text;
            
        }
        
        if (lAClass2.text!=NULL && lAClass2.text.length!=0 ) {
            
            field6=lAClass2.text;
            
        }
        
        if (lANo2.text!=NULL && lANo2.text.length!=0 ) {
            
            field7=lANo2.text;
            
        }
        
        if (lATotalHours2.text!=NULL && lATotalHours2.text.length!=0 ) {
            
            field8=lATotalHours2.text;
            
        }
        
        if (lARate2.text!=NULL && lARate2.text.length!=0 ) {
            
            field9=lARate2.text;
            
        }
        
        
        if (lAAmount2.text!=NULL && lAAmount2.text.length!=0 ) {
            
            field10=lAAmount2.text;
            
        }
        
        
        if (lAClass3.text!=NULL && lAClass3.text.length!=0 ) {
            
            field11=lAClass3.text;
            
        }
        
        if (lANo3.text!=NULL && lANo3.text.length!=0 ) {
            
            field12=lANo3.text;
            
        }
        
        if (lATotalHours3.text!=NULL && lATotalHours3.text.length!=0 ) {
            
            field13=lATotalHours3.text;
            
        }
        
        if (lARate3.text!=NULL && lARate3.text.length!=0 ) {
            
            field14=lARate3.text;
            
        }
        
        if (lAAmount3.text!=NULL && lAAmount3.text.length!=0 ) {
            
            field15=lAAmount3.text;
            
        }
        
        if (lAClass4.text!=NULL && lAClass4.text.length!=0 ) {
            
            field16=lAClass4.text;
            
        }
        
        if (lANo4.text!=NULL && lANo4.text.length!=0 ) {
            
            field17=lANo4.text;
            
        }
        
        if (lATotalHours4.text!=NULL && lATotalHours4.text.length!=0 ) {
            
            field18=lATotalHours4.text;
            
        }
        
        if (lARate4.text!=NULL && lARate4.text.length!=0 ) {
            
            field19=lARate4.text;
            
        }
        
        if (lAAmount4.text!=NULL && lAAmount4.text.length!=0 ) {
            
            field20=lAAmount4.text;
            
        }
        
        if (lAClass5.text!=NULL && lAClass5.text.length!=0 ) {
            
            field21=lAClass5.text;
            
        }
        
        if (lANo5.text!=NULL && lANo5.text.length!=0 ) {
            
            field22=lANo5.text;
            
        }
        
        if (lATotalHours5.text!=NULL && lATotalHours5.text.length!=0 ) {
            
            field23=lATotalHours5.text;
            
        }
        
        if (lARate5.text!=NULL && lARate5.text.length!=0 ) {
            
            field24=lARate5.text;
            
        }
        
        if (lAAmount5.text!=NULL && lAAmount5.text.length!=0 ) {
            
            field25=lAAmount5.text;
            
        }
        
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.navigationController.view addSubview:HUD];
        HUD.labelText=@"";
        HUD.dimBackground = YES;
        HUD.delegate = self;
        [HUD show:YES];
        
        BOOL saveStatus = [PRIMECMController
                           saveSummarySheet1:appDelegate.username
                           city:appDelegate.city
                           conPeWork:conPeWork.text
                           constructionOrder:constructionOrder.text
                           contractor:appDelegate.projId
                           date:date.text
                           descr:descr.text
                           federalAidNumber:federalAidNumber.text
                           healWelAndPension:healWelAndPension.text
                           insAndTaxesOnItem1:insAndTaxesOnItem1.text
                           itemDescount20per:itemDescount20per.text
                           lAAmount1:lAAmount1.text
                           lAAmount2:lAAmount2.text
                           lAAmount3:lAAmount3.text
                           lAAmount4:lAAmount4.text
                           lAAmount5:lAAmount5.text
                           lAClass1:lAClass1.text
                           lAClass2:lAClass2.text
                           lAClass3:lAClass3.text
                           lAClass4:lAClass4.text
                           lAClass5:lAClass5.text
                           lANo1:lANo1.text
                           lANo2:lANo2.text
                           lANo3:lANo3.text
                           lANo4:lANo4.text
                           lANo5:lANo5.text
                           lARate1:lARate1.text
                           lARate2:lARate2.text
                           lARate3:lARate3.text
                           lARate4:lARate4.text
                           lARate5:lARate5.text
                           lATotalHours1:lATotalHours1.text
                           lATotalHours2:lATotalHours2.text
                           lATotalHours3:lATotalHours3.text
                           lATotalHours4:lATotalHours4.text
                           lATotalHours5:lATotalHours5.text
                           pOBox:appDelegate.address
                           printedName:appDelegate.username   //Radha
                           project_id:appDelegate.projId
                           projectNo:appDelegate.projId
                           reportNo:@""
                           sMSheetNo:smNum    //Radha
                           sSHeader:sSHeader.text
                           state:appDelegate.state
                           telephoneNo:appDelegate.tel
                           total:total.text
                           totalLabor:totalLabor.text
                           zip:appDelegate.zip                           
                           ];
        
        [HUD setHidden:YES];
        
        if (saveStatus){
            NSString *msg;
            if(isEdit)
                msg  = @"Updated Summary Sheet Report";
            else
                msg = @"Sheet1 is Saved.Fill the Sheet 2";
            
            UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [exportAlert show];
            [appDelegate.sketchesArray removeAllObjects];
            [arrayImages removeAllObjects];
            [self clearFormFields];
            
            Summary_2_ViewController *su=[[Summary_2_ViewController alloc] init];
            su.title=@"Summary Sheet";
            su.isEdit = isEdit;
            su.smSheetNumber = smNum;
            [self.navigationController pushViewController:su animated:YES];
            
        }else{
            UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to save summary sheet report." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [exportAlert show];
        }
    }
}

-(void)clearFormFields
{
    contractor.text=NULL;
    pOBox.text=NULL;
    city.text=NULL;
    state.text=NULL;
    telephoneNo.text=NULL;
    date.text=NULL;
    conPeWork.text=NULL;
    federalAidNumber.text=NULL;
    projectNo.text=NULL;
    descr.text=NULL;
    constructionOrder.text=NULL;
    total.text=NULL;
    healWelAndPension.text=NULL;
    insAndTaxesOnItem1.text=NULL;
    totalLabor.text=NULL;
    itemDescount20per.text=NULL;
    itemDescount20per.text=@"";
    
    
    lAClass1.text=NULL;
    lAClass2.text=NULL;
    lAClass3.text=NULL;
    lAClass4.text=NULL;
    lAClass5.text=NULL;
    lANo1.text=NULL;
    lANo2.text=NULL;
    lANo3.text=NULL;
    lANo4.text=NULL;
    lANo5.text=NULL;
    
    lATotalHours1.text=NULL;
    lATotalHours2.text=NULL;
    lATotalHours3.text=NULL;
    lATotalHours4.text=NULL;
    lATotalHours5.text=NULL;
    
    lARate1.text=NULL;
    lARate2.text=NULL;
    lARate3.text=NULL;
    lARate4.text=NULL;
    lARate5.text=NULL;
    
    lAAmount1.text=NULL;
    lAAmount2.text=NULL;
    lAAmount3.text=NULL;
    lAAmount4.text=NULL;
    lAAmount5.text=NULL;
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


@end