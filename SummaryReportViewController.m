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
    NSUserDefaults *defaults;
    
}

@end

@implementation SummaryReportViewController

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
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormat stringFromDate:today];
    
    contractor.text=appDelegate.projId;
    pOBox.text=appDelegate.address;
    city.text=appDelegate.city;
    state.text=appDelegate.state;
    zip.text=appDelegate.zip;
    projectNo.text=appDelegate.projId;
    date.text=dateString;
    telephoneNo.text=appDelegate.tel;
    defaults= [NSUserDefaults standardUserDefaults];
    
    
    NSString* temp1 = [defaults objectForKey:@"conPeWork"];
    NSString* temp2 = [defaults objectForKey:@"federalAidNumber"];
    NSString* temp3 = [defaults objectForKey:@"descr"];
    NSString* temp4 = [defaults objectForKey:@"constructionOrder"];
    NSString* temp5 = [defaults objectForKey:@"lAClass1"];
    NSString* temp6 = [defaults objectForKey:@"lAClass2"];
    NSString* temp7 = [defaults objectForKey:@"lAClass3"];
    NSString* temp8 = [defaults objectForKey:@"lAClass4"];
    NSString* temp9 = [defaults objectForKey:@"lAClass5"];
    NSString* temp10 = [defaults objectForKey:@"lANo1"];
    NSString* temp11 = [defaults objectForKey:@"lANo2"];
    NSString* temp12 = [defaults objectForKey:@"lANo3"];
    NSString* temp13 = [defaults objectForKey:@"lANo4"];
    NSString* temp14 = [defaults objectForKey:@"lANo5"];
    NSString* temp15 = [defaults objectForKey:@"lATotalHours1"];
    NSString* temp16 = [defaults objectForKey:@"lATotalHours2"];
    NSString* temp17 = [defaults objectForKey:@"lATotalHours3"];
    NSString* temp18 = [defaults objectForKey:@"lATotalHours4"];
    NSString* temp19 = [defaults objectForKey:@"lATotalHours5"];
    NSString* temp20 = [defaults objectForKey:@"lARate1"];
    NSString* temp21 = [defaults objectForKey:@"lARate2"];
    NSString* temp22 = [defaults objectForKey:@"lARate3"];
    NSString* temp23 = [defaults objectForKey:@"lARate4"];
    NSString* temp24 = [defaults objectForKey:@"lARate5"];
    NSString* temp25 = [defaults objectForKey:@"lAAmount1"];
    NSString* temp26 = [defaults objectForKey:@"lAAmount2"];
    NSString* temp27 = [defaults objectForKey:@"lAAmount3"];
    NSString* temp28 = [defaults objectForKey:@"lAAmount4"];
    NSString* temp29 = [defaults objectForKey:@"lAAmount5"];
    NSString* temp30 = [defaults objectForKey:@"totalLabor"];
    
    NSString* temp31 = [defaults objectForKey:@"healWelAndPension"];
    
    NSString* temp32 = [defaults objectForKey:@"insAndTaxesOnItem1"];
    
    NSString* temp33 = [defaults objectForKey:@"itemDescount20per"];
    
    NSString* temp34= [defaults objectForKey:@"total"];
    NSData* imageData1 = [defaults objectForKey:@"complianceSignature"];
    UIImage* image1 = [UIImage imageWithData:imageData1];
    
    conPeWork.text=temp1;
    federalAidNumber.text=temp2;
    descr.text=temp3;
    constructionOrder.text=temp4;
    lAClass1.text=temp5;
    lAClass2.text=temp6;
    lAClass3.text=temp7;
    lAClass4.text=temp8;
    lAClass5.text=temp9;
    lANo1.text=temp10;
    lANo2.text=temp11;
    
    lANo3.text=temp12;
    lANo4.text=temp13;
    lANo5.text=temp14;
    lATotalHours1.text=temp15;
    lATotalHours2.text=temp16;
    lATotalHours3.text=temp17;
    lATotalHours4.text=temp18;
    lATotalHours5.text=temp19;
    lARate1.text=temp20;
    lARate2.text=temp21;
    lARate3.text=temp22;
    lARate4.text=temp23;
    lARate5.text=temp24;
    lAAmount1.text=temp25;
    lAAmount2.text=temp26;
    lAAmount3.text=temp27;
    lAAmount4.text=temp28;
    lAAmount5.text=temp29;
    totalLabor.text=temp30;
    healWelAndPension.text=temp31;
    insAndTaxesOnItem1.text=temp32;
    itemDescount20per.text=temp33;
    total.text=temp34;
    
    
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


-(void)exit{
    NSString* textField1Text = conPeWork.text;
    [defaults setObject:textField1Text forKey:@"conPeWork"];
    
    
    NSString* textField2Text = federalAidNumber.text;
    [defaults setObject:textField2Text forKey:@"federalAidNumber"];
    
    NSString* textField3Text = descr.text;
    [defaults setObject:textField3Text forKey:@"descr"];
    
    
    NSString* textField4Text = constructionOrder.text;
    [defaults setObject:textField4Text forKey:@"constructionOrder"];
    
    NSString* textField5Text = lAClass1.text;
    [defaults setObject:textField5Text forKey:@"lAClass1"];
    
    NSString* textField6Text = lAClass2.text;
    [defaults setObject:textField6Text forKey:@"lAClass2"];
    
    
    NSString* textField7Text = lAClass3.text;
    [defaults setObject:textField7Text forKey:@"lAClass3"];
    
    
    
    NSString* textField8Text = lAClass4.text;
    [defaults setObject:textField8Text forKey:@"lAClass4"];
    
    
    
    NSString* textField9Text = lAClass5.text;
    [defaults setObject:textField9Text forKey:@"lAClass5"];
    
    NSString* textField10Text = lANo1.text;
    [defaults setObject:textField10Text forKey:@"lANo1"];
    
    
    NSString* textField11Text = lANo2.text;
    [defaults setObject:textField11Text forKey:@"lANo2"];
    
    NSString* textField12Text = lANo3.text;
    [defaults setObject:textField12Text forKey:@"lANo3"];
    
    NSString* textField13Text = lANo4.text;
    [defaults setObject:textField13Text forKey:@"lANo4"];
    
    NSString* textField14Text = lANo5.text;
    [defaults setObject:textField14Text forKey:@"lANo5"];
    
    NSString* textField15Text = lATotalHours1.text;
    [defaults setObject:textField15Text forKey:@"lATotalHours1"];
    
    NSString* textField16Text = lATotalHours2.text;
    [defaults setObject:textField16Text forKey:@"lATotalHours2"];
    
    NSString* textField17Text = lATotalHours3.text;
    [defaults setObject:textField17Text forKey:@"lATotalHours3"];
    
    NSString* textField18Text = lATotalHours4.text;
    [defaults setObject:textField18Text forKey:@"lATotalHours4"];
    
    NSString* textField19Text = lATotalHours5.text;
    [defaults setObject:textField19Text forKey:@"lATotalHours5"];
    
    NSString* textField20Text = lARate1.text;
    [defaults setObject:textField20Text forKey:@"lARate1"];
    
    NSString* textField21Text = lARate2.text;
    [defaults setObject:textField21Text forKey:@"lARate2"];
    
    NSString* textField22Text = lARate3.text;
    [defaults setObject:textField22Text forKey:@"lARate3"];
    
    NSString* textField23Text = lARate4.text;
    [defaults setObject:textField23Text forKey:@"lARate4"];
    
    NSString* textField24Text = lARate5.text;
    [defaults setObject:textField24Text forKey:@"lARate5"];
    
    NSString* textField25Text = lAAmount1.text;
    [defaults setObject:textField25Text forKey:@"lAAmount1"];
    
    NSString* textField26Text = lAAmount2.text;
    [defaults setObject:textField26Text forKey:@"lAAmount2"];
    
    NSString* textField27Text = lAAmount3.text;
    [defaults setObject:textField27Text forKey:@"lAAmount3"];
    
    NSString* textField28Text = lAAmount4.text;
    [defaults setObject:textField28Text forKey:@"lAAmount4"];
    
    NSString* textField29Text = lAAmount5.text;
    [defaults setObject:textField29Text forKey:@"lAAmount5"];
    
    NSString* textField30Text = totalLabor.text;
    [defaults setObject:textField30Text forKey:@"totalLabor"];
    
    
    NSString* textField31Text = healWelAndPension.text;
    [defaults setObject:textField31Text forKey:@"healWelAndPension"];
    
    
    
    NSString* textField32Text = insAndTaxesOnItem1.text;
    [defaults setObject:textField32Text forKey:@"insAndTaxesOnItem1"];
    
    
    
    NSString* textField33Text = itemDescount20per.text;
    [defaults setObject:textField33Text forKey:@"itemDescount20per"];
    
    
    NSString* textField34Text = total.text;
    [defaults setObject:textField34Text forKey:@"total"];
    
    
    [defaults synchronize];
    
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
        /*
         NSString *strURL = [NSString stringWithFormat:@"%@/api/summary1/create/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@", [PRIMECMAPPUtils getAPIEndpoint],
         appDelegate.username,appDelegate.projId,sSHeader.text,contractor.text,pOBox.text,city.text,state.text,zip.text,telephoneNo.text,date.text,@"hi",conPeWork.text,federalAidNumber.text,projectNo.text,descr.text,constructionOrder.text,field1,field2,field3,field4,field5,field6,field7,field8,field9,field10,field11,field12,field13,field14,field15,field16,field17,field18,field19,field20,field21,field22,field23,field24,field25,totalLabor.text,healWelAndPension.text,insAndTaxesOnItem1.text,itemDescount20per.text,total.text,appDelegate.projPrintedName];
         
         
         // NSString *uencodedUrl = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
         
         NSString *uencodedUrl = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
         NSLog(@"URL---- %@",uencodedUrl);
         
         NSURL *apiURL =
         [NSURL URLWithString:uencodedUrl];
         NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:apiURL];
         [urlRequest setHTTPMethod:@"POST"];
         
         
         NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
         
         _receivedData = [[NSMutableData alloc] init];
         
         [connection start];
         // NSLog(@"URL---%@",strURL);
         */
        
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.navigationController.view addSubview:HUD];
        HUD.labelText=@"";
        HUD.dimBackground = YES;
        HUD.delegate = self;
        [HUD show:YES];
        
        BOOL saveStatus = [PRIMECMController
                           saveSummarySheet1:appDelegate.username
                           city:city.text
                           conPeWork:conPeWork.text
                           constructionOrder:constructionOrder.text
                           contractor:contractor.text
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
                           pOBox:pOBox.text
                           printedName:appDelegate.projPrintedName
                           project_id:appDelegate.projId
                           projectNo:projectNo.text
                           reportNo:@""
                           sMSheetNo:@""
                           sSHeader:sSHeader.text
                           state:state.text
                           telephoneNo:telephoneNo.text
                           total:total.text
                           totalLabor:totalLabor.text
                           zip:zip.text
                           ];
        
        [HUD setHidden:YES];
        
        if (saveStatus){
            UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Successfully saved compliance report." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [exportAlert show];
            [appDelegate.sketchesArray removeAllObjects];
            [arrayImages removeAllObjects];
            [self clearFormFields];
        }else{
            UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to save compliance report." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
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
