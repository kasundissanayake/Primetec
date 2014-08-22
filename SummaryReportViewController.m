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
}

@end

@implementation SummaryReportViewController

@synthesize scrollView,arrayImages,sumContracter,sumAddress,sumCity,sumState,sumTel,sumDate,sumPW,sumFAN,sumProjectNum,sumDescription,sumConOrder,sumClass1,sumClass2,sumClass3,sumClass5,sumClass4,sumNo1,sumNo2,sumNo3,sumNo4,sumNo5,sumHr1,sumHr2,sumHr3,sumHr4,sumHr5,sumRate1,sumRate2,sumRate3,sumRate4,sumRate5,sumAmt1,sumAmt2,sumAmt3,sumAmt4,sumAmt5,sumTotLbr,sumHealth,sumIns,sum20,sumTotal,header,summeryZip;


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
    
    [sumDescription.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [sumDescription.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [sumDescription.layer setBorderWidth: 1.0];
    [sumDescription.layer setCornerRadius:8.0f];
    [sumDescription.layer setMasksToBounds:YES];
    
    [sumConOrder.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [sumConOrder.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [sumConOrder.layer setBorderWidth: 1.0];
    [sumConOrder.layer setCornerRadius:8.0f];
    [sumConOrder.layer setMasksToBounds:YES];

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
    
    sumContracter.text=appDelegate.projId;
    sumAddress.text=appDelegate.address;
    sumCity.text=appDelegate.city;
    sumState.text=appDelegate.state;
    summeryZip.text=appDelegate.zip;
    sumProjectNum.text=appDelegate.projId;
    sumDate.text=dateString;
    sumTel.text=appDelegate.tel;
}


/*********************numeric**************************************/


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField==sumHr1 || textField==sumHr2 || textField==sumHr3 || textField==sumHr4  || textField==sumHr4 ||textField==sumHr5 || textField==sumRate1 || textField==sumRate2 || textField==sumRate3 || textField==sumRate4 || textField==sumRate5 || textField==sumHealth || textField==sumIns)
    {
        
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
        for (int i = 0; i < [string length]; i++)
        {
            unichar c = [string characterAtIndex:i];
            if (![myCharSet characterIsMember:c])
            {
                
                sumHr1.enabled=YES;
                sumHr2.enabled=YES;
                sumHr3.enabled=YES;
                sumHr4.enabled=YES;
                sumHr5.enabled=YES;
                sumRate1.enabled=YES;
                sumRate2.enabled=YES;
                sumRate3.enabled=YES;
                sumRate4.enabled=YES;
                sumRate5.enabled=YES;
                sumHealth.enabled=YES;
                sumIns.enabled=YES;

                
                return NO;
            }
            
                else{
            
                //  sumFAN.enabled=NO;

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

- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"uuuuu");
    
    _receivedResponse = response;
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData
                                                                 *)data
{
    NSLog(@"ddddd");
    [_receivedData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError
                                                                   *)error
{
    NSLog(@"eeeeee");
    [HUD setHidden:YES];
    _connectionError = error;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection

{
    
    [HUD setHidden:YES];
    
    NSError *parseError = nil;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:_receivedData options:kNilOptions error:&parseError];
    
    NSLog(@"response---%@",responseObject);
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    if([[responseObject valueForKey:@"status"]isEqualToString:@"sucess"])
    {
        
        appDelegate.saveVal=[responseObject valueForKey:@"id"];
        Summary_2_ViewController *su=[[Summary_2_ViewController alloc] init];
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
  
    
    if(textField==sumAmt1)
    {
        double dist1 = [self.sumHr1.text doubleValue];
        double mileage1 = [self.sumRate1.text doubleValue];
        sumAmt1.text =  [NSString stringWithFormat:@"%.2f",dist1 * mileage1];
        [sumAmt1 resignFirstResponder];
    }
    if(textField==sumAmt2)
    {
        double dist2 = [self.sumHr2.text doubleValue];
        double mileage2 = [self.sumRate2.text doubleValue];
        sumAmt2.text =  [NSString stringWithFormat:@"%.2f",dist2 * mileage2];
        
        [sumAmt2 resignFirstResponder];
    }
    if(textField==sumAmt3)
    {
        double dist3 = [self.sumHr3.text doubleValue];
        double mileage3 = [self.sumRate3.text doubleValue];
        sumAmt3.text =  [NSString stringWithFormat:@"%.2f",dist3 * mileage3];
        
        [sumAmt3 resignFirstResponder];
    }
    
    if(textField==sumAmt4)
    {
        
        double dist4 = [self.sumHr4.text doubleValue];
        double mileage4 = [self.sumRate4.text doubleValue];
        sumAmt4.text =  [NSString stringWithFormat:@"%.2f",dist4 * mileage4];
        [sumAmt4 resignFirstResponder];
    }
    if(textField==sumAmt5)
    {
        
        double dist5 = [self.sumHr5.text doubleValue];
        double mileage5 = [self.sumRate5.text doubleValue];
        sumAmt5.text =  [NSString stringWithFormat:@"%.2f",dist5 * mileage5];
        [sumAmt5 resignFirstResponder];
    }
    
    double tot1 = [self.sumAmt1.text doubleValue];
    double tot2 = [self.sumAmt2.text doubleValue];
    double tot3 = [self.sumAmt3.text doubleValue];
    double tot4 = [self.sumAmt4.text doubleValue];
    double tot5 = [self.sumAmt5.text doubleValue];
    double allTot = tot1 + tot2 + tot3 + tot4 + tot5;
    
    sumTotLbr.text =  [NSString stringWithFormat:@"%.2f",allTot];
    double insu  = [self.sumIns.text doubleValue];
    
    double health  = [self.sumHealth.text doubleValue];
    
    double calcpersentage  = allTot + insu + health;
    
    double t20  = calcpersentage * 0.2;
    
    double gtotal = t20 + calcpersentage;
    
    sum20.text = [NSString stringWithFormat:@"%.2f",t20];
    
    sumTotal.text = [NSString stringWithFormat:@"%.2f",gtotal];
    
    appDelegate.str1=sumTotal.text;
    
    
    
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
   
    
    if(sumContracter.text==NULL || sumContracter.text.length==0 || sumAddress.text==NULL || sumAddress.text.length==0 || sumCity.text==NULL || sumCity.text.length==0 || sumState.text==NULL || sumState.text.length==0 || sumTel.text==NULL || sumTel.text.length==0 || sumDate.text==NULL || sumDate.text.length==0 || sumPW.text==NULL || sumPW.text.length==0 || sumFAN.text==NULL || sumFAN.text.length==0 || sumProjectNum.text==NULL || sumProjectNum.text.length==0 || sumDescription.text==NULL || sumDescription.text.length==0 || sumConOrder.text==NULL || sumConOrder.text.length==0 || sumTotal.text==NULL || sumTotal.text.length==0 || sumHealth.text==NULL || sumHealth.text.length==0 || sumIns.text==NULL || sumIns.text.length==0 || sumTotLbr.text==NULL || sumTotLbr.text.length==0 ||  sum20.text==NULL || sum20.text.length==0  || summeryZip.text==NULL ||summeryZip.text.length==0  )
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
        
        
        
        
        if (sumClass1.text!=NULL && sumClass1.text.length!=0 ) {
            
            field1=sumClass1.text;
            
        }
        
        if (sumNo1.text!=NULL && sumNo1.text.length!=0 ) {
            
            field2=sumNo1.text;
            
        }
        
        if (sumHr1.text!=NULL && sumHr1.text.length!=0 ) {
            
            field3=sumHr1.text;
            
        }
        
        if (sumRate1.text!=NULL && sumRate1.text.length!=0 ) {
            
            field4=sumRate1.text;
            
        }
        
        if (sumAmt1.text!=NULL && sumAmt1.text.length!=0 ) {
            
            field5=sumAmt1.text;
            
        }
        
        if (sumClass2.text!=NULL && sumClass2.text.length!=0 ) {
            
            field6=sumClass2.text;
            
        }
        
        if (sumNo2.text!=NULL && sumNo2.text.length!=0 ) {
            
            field7=sumNo2.text;
            
        }
        
        if (sumHr2.text!=NULL && sumHr2.text.length!=0 ) {
            
            field8=sumHr2.text;
            
        }
        
        if (sumRate2.text!=NULL && sumRate2.text.length!=0 ) {
            
            field9=sumRate2.text;
            
        }
        
        
        if (sumAmt2.text!=NULL && sumAmt2.text.length!=0 ) {
            
            field10=sumAmt2.text;
            
        }
        
        
        if (sumClass3.text!=NULL && sumClass3.text.length!=0 ) {
            
            field11=sumClass3.text;
            
        }
        
        if (sumNo3.text!=NULL && sumNo3.text.length!=0 ) {
            
            field12=sumNo3.text;
            
        }
        
        if (sumHr3.text!=NULL && sumHr3.text.length!=0 ) {
            
            field13=sumHr3.text;
            
        }
        
        if (sumRate3.text!=NULL && sumRate3.text.length!=0 ) {
            
            field14=sumRate3.text;
            
        }
        
        if (sumAmt3.text!=NULL && sumAmt3.text.length!=0 ) {
            
            field15=sumAmt3.text;
            
        }
        
        if (sumClass4.text!=NULL && sumClass4.text.length!=0 ) {
            
            field16=sumClass4.text;
            
        }
        
        if (sumNo4.text!=NULL && sumNo4.text.length!=0 ) {
            
            field17=sumNo4.text;
            
        }
        
        if (sumHr4.text!=NULL && sumHr4.text.length!=0 ) {
            
            field18=sumHr4.text;
            
        }
        
        if (sumRate4.text!=NULL && sumRate4.text.length!=0 ) {
            
            field19=sumRate4.text;
            
        }
        
        if (sumAmt4.text!=NULL && sumAmt4.text.length!=0 ) {
            
            field20=sumAmt4.text;
            
        }
        
        if (sumClass5.text!=NULL && sumClass5.text.length!=0 ) {
            
            field21=sumClass5.text;
            
        }
        
        if (sumNo5.text!=NULL && sumNo5.text.length!=0 ) {
            
            field22=sumNo5.text;
            
        }
        
        if (sumHr5.text!=NULL && sumHr5.text.length!=0 ) {
            
            field23=sumHr5.text;
            
        }
        
        if (sumRate5.text!=NULL && sumRate5.text.length!=0 ) {
            
            field24=sumRate5.text;
            
        }
        
        if (sumAmt5.text!=NULL && sumAmt5.text.length!=0 ) {
            
            field25=sumAmt5.text;
            
        }
        
        NSString *strURL = [NSString stringWithFormat:@"%@/api/summary1/create/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@", [PRIMECMAPPUtils getAPIEndpoint],
                            appDelegate.username,appDelegate.projId,header.text,sumContracter.text,sumAddress.text,sumCity.text,sumState.text,summeryZip.text,sumTel.text,sumDate.text,@"hi",sumPW.text,sumFAN.text,sumProjectNum.text,sumDescription.text,sumConOrder.text,field1,field2,field3,field4,field5,field6,field7,field8,field9,field10,field11,field12,field13,field14,field15,field16,field17,field18,field19,field20,field21,field22,field23,field24,field25,sumTotLbr.text,sumHealth.text,sumIns.text,sum20.text,sumTotal.text,appDelegate.projPrintedName];
        
        
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
        
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.navigationController.view addSubview:HUD];
        HUD.labelText=@"";
        HUD.dimBackground = YES;
        HUD.delegate = self;
        [HUD show:YES];
        
        sumContracter.text=NULL;
        sumAddress.text=NULL;
        sumCity.text=NULL;
        sumState.text=NULL;
        sumTel.text=NULL;
        sumDate.text=NULL;
        sumPW.text=NULL;
        sumFAN.text=NULL;
        sumProjectNum.text=NULL;
        sumDescription.text=NULL;
        sumConOrder.text=NULL;
        sumTotal.text=NULL;
        sumHealth.text=NULL;
        sumIns.text=NULL;
        sumTotLbr.text=NULL;
        sum20.text=NULL;
        sum20.text=@"";
        
        
        sumClass1.text=NULL;
        sumClass2.text=NULL;
        sumClass3.text=NULL;
        sumClass4.text=NULL;
        sumClass5.text=NULL;
        sumNo1.text=NULL;
        sumNo2.text=NULL;
        sumNo3.text=NULL;
        sumNo4.text=NULL;
        sumNo5.text=NULL;
        
        sumHr1.text=NULL;
        sumHr2.text=NULL;
        sumHr3.text=NULL;
        sumHr4.text=NULL;
        sumHr5.text=NULL;
        
        sumRate1.text=NULL;
        sumRate2.text=NULL;
        sumRate3.text=NULL;
        sumRate4.text=NULL;
        sumRate5.text=NULL;
        
        sumAmt1.text=NULL;
        sumAmt2.text=NULL;
        sumAmt3.text=NULL;
        sumAmt4.text=NULL;
        sumAmt5.text=NULL;
        
        
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


@end
