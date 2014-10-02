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
    NSDictionary *sourceDictionary;
    NSString *sm3value1,*value2,*value3,*value4,*value5,*value6,*value7,*value8,*value9,*value10,*value11,*value12,*value13,*value14,*value15,*value16,*value17,*value18,*value19,*value20,*value21,*value22,*value23,*value24,*value25,*value26,*value27,*value28,*value29,*value30,*value31,*value32;
    
    
    
    
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

@synthesize smSheetNumber;
@synthesize sm2description1,sm2description2,sm2description3,sm2description4,sm2description5,sm2Qty1,sm2Qty2,sm2Qty3,sm2Qty4,sm2Qty5,sm2price1,sm2price2,sm2price3,sm2price4,sm2price5,sm2amt1,sm2amt2,sm2amt3,sm2amt4,sm2amt5,sm2total1,sm2total2,sm2total3,sm2additional;


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
    
    
    mEDescription1.text=sm2description1;
    mEDescription2.text=sm2description2;
    mEDescription3.text=sm2description3;
    mEDescription4.text=sm2description4;
    mEDescription5.text=sm2description5;
    mEQuantity1.text=sm2Qty1;
    mEQuantity2.text=sm2Qty2;
    mEQuantity3.text=sm2Qty3;
    mEQuantity4.text=sm2Qty4;
    mEQuantity5.text=sm2Qty5;
    mEUnitPrice1.text=sm2price1;
    mEUnitPrice2.text=sm2price2;
    mEUnitPrice3.text=sm2price3;
    mEUnitPrice4.text=sm2price4;
    mEUnitPrice5.text=sm2price5;
    mEAmount1.text=sm2amt1;
    mEAmount2.text=sm2amt2;
    mEAmount3.text=sm2amt3;
    mEAmount4.text=sm2amt4;
    mEAmount5.text=sm2amt5;
    total1.text=sm2total1;
    total2.text=sm2total2;
    total3.text=sm2total3;
    lessDiscount.text=sm2description1;
    additionalDiscount.text=sm2additional;
    
    
    
    scrollView.frame = CGRectMake(0,-10, 770, 2088);
    [scrollView setContentSize:CGSizeMake(620, 2300)];
    popoverContent=[[UIViewController alloc] init];
    
    tblView=[[UITableView alloc] initWithFrame:CGRectMake(265, 680, 0, 0) style:UITableViewStylePlain];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMapData:) name:@"ViewControllerAReloadData" object:nil];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back.jpg"]];
    // Do any additional setup after loading the view from its nib.
    
    appDelegate=(TabAndSplitAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    if (sourceDictionary != nil && [sourceDictionary valueForKey:@"userInfo"] != nil){
        
        smSheetNumber = [[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"sMSheetNo"];
        sm3value1=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eQSizeandClass1"];
        
        
        
        
        value2=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eQSizeandClass2"];
        value3=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eQSizeandClass3"];
        value4=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eQSizeandClass4"];
        value5=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eQSizeandClass5"];
        
        value6=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eQIdleActive1"];
        value7=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eQIdleActive2"];
        value8=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eQIdleActive3"];
        value9=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eQIdleActive4"];
        value10=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eQIdleActive5"];
        
        value11=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eQNo1"];
        value12=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eQNo2"];
        value13=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eQNo3"];
        value14=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eQNo4"];
        value15=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eQNo5"];
        
        value16=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eQTotalHours1"];
        value17=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eQTotalHours2"];
        value18=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eQTotalHours3"];
        value19=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eQTotalHours4"];
        value20=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eQTotalHours5"];
        
        value21=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eQRAte1"];
        value22=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eQRAte2"];
        value23=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eQRAte3"];
        value24=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eQRAte4"];
        value25=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eQRAte5"];
        value26=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eQAmount1"];
        value27=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eQAmount2"];
        value28=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eQAmount3"];
        value29=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eQAmount4"];
        value30=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eQAmount5"];
        value31=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"dailyTotal"];
        value32=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"total_to_date"];
        
        
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
                           
                           //pass summary sheet number
                           sMSSheetNo:smSheetNumber
                           
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
            
            //brin-passing summary sheet no
            su.smSheetNumber = smSheetNumber;
            
            
            NSLog(@"xdsdfsdfsfsd%@", sm3value1);
            //sample
            su.sm3class1=sm3value1;
            su.sm3class2=value2;
            su.sm3class3=value3;
            su.sm3class4=value4;
            su.sm3class5=value5;
            
            su.sm3act1=value6;
            su.sm3act2=value7;
            su.sm3act3=value8;
            su.sm3act4=value9;
            su.sm3act5=value10;
            
            su.sm3no1=value11;
            su.sm3no2=value12;
            su.sm3no3=value13;
            su.sm3no4=value14;
            su.sm3no5=value15;
            
            su.sm3hr1=value16;
            su.sm3hr2=value17;
            su.sm3hr3=value18;
            su.sm3hr4=value19;
            su.sm3hr5=value20;
            
            su.sm3rate1=value21;
            su.sm3rate2=value22;
            su.sm3rate3=value23;
            su.sm3rate4=value24;
            su.sm3rate5=value25;
            
            su.sm3amt1=value26;
            su.sm3amt2=value27;
            su.sm3amt3=value28;
            su.sm3amt4=value29;
            su.sm3amt5=value30;
            
            su.sm3dtotal=value31;
            su.sm3dtotaldate=value32;
            
            
            
            
            
            
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


-(void)viewDidUnload
{
    
    self.scrollView=nil;
    
    
    self.scrollView=nil;
    self->hotelAnnotations=nil;
    
    self->popoverController=nil;
    self->tblView=nil;
    self->tableData=nil;
    self->popoverContent=nil;
    self->count=nil;
    
    self->HUD=nil;
    self->_receivedData=nil;
    self->_receivedResponse=nil;
    self->_connectionError=nil;
    self->resPonse=nil;
    self->count=nil;
    self->HUD=nil;
    self->_receivedData=nil;
    self->_receivedResponse=nil;
    self->_connectionError=nil;
    
    self->resPonse=nil;
    self->uploading=nil;
    self->uploadingsketch=nil;
    self->count1=nil;
    self->count2=nil;
    self->comNoticeNo=nil;
    self->isUploadingSignature=nil;
    self->appDelegate=nil;
    self->sourceDictionary=nil;
    
    self->sm3value1=nil;
    self->value2=nil;
    self->value3=nil;
    self->value4=nil;
    self->value5=nil;
    
    self->value6=nil;
    self->value7=nil;
    self->value8=nil;
    self->value9=nil;
    self->value10=nil;
    self->value11=nil;
    self->value12=nil;
    self->value13=nil;
    self->value14=nil;
    self->value15=nil;
    
    self->value16=nil;
    self->value17=nil;
    self->value18=nil;
    self->value19=nil;
    self->value20=nil;
    self->value21=nil;
    self->value22=nil;
    self->value23=nil;
    self->value24=nil;
    self->value25=nil;
    
    self->value26=nil;
    self->value27=nil;
    self->value28=nil;
    self->value29=nil;
    self->value30=nil;
    self->value31=nil;
    self->value32=nil;
    
}


@end
