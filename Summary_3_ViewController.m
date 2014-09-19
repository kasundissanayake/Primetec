

#import "Summary_3_ViewController.h"
#import "SignatureViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TabAndSplitAppAppDelegate.h"
#import "PRIMECMAPPUtils.h"
#import "PRIMECMController.h"

@interface Summary_3_ViewController ()
{
    UIPopoverController *popoverController;
    UIDatePicker *datePicker;
    UIPickerView *pickerView;
    NSMutableArray *pickerDataArray;
    
    
    NSMutableArray *hotelAnnotations;
    UITableView *tblView;
    NSArray *tableData;
    UIViewController *popoverContent;
    NSInteger pickerTag;
    SignatureViewController *signatureViewController;
    NSString *isSignature;
    UIButton *btnCloseSignView;
    NSInteger * STag;
    
    
    TabAndSplitAppAppDelegate *appDelegate;
    
    
    NSString *imgName;
    
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
    
    BOOL uploadingSignature2;
    BOOL uploadingSignature1;
    
    NSString *sigName1;
    NSString *sigName2;
       
}

@end

@implementation Summary_3_ViewController
@synthesize contractorRepresentative;
@synthesize dailyTotal;
@synthesize date1;
@synthesize date2;
@synthesize eQAmount1;
@synthesize eQAmount2;
@synthesize eQAmount3;
@synthesize eQAmount4;
@synthesize eQAmount5;
@synthesize eQIdleActive1;
@synthesize eQIdleActive2;
@synthesize eQIdleActive3;
@synthesize eQIdleActive4;
@synthesize eQIdleActive5;
@synthesize eQNo1;
@synthesize eQNo2;
@synthesize eQNo3;
@synthesize eQNo4;
@synthesize eQNo5;
@synthesize eQRAte1;
@synthesize eQRAte2;
@synthesize eQRAte3;
@synthesize eQRAte4;
@synthesize eQRAte5;
@synthesize eQSizeandClass1;
@synthesize eQSizeandClass2;
@synthesize eQSizeandClass3;
@synthesize arrayImages;
@synthesize eQSizeandClass4;
@synthesize eQSizeandClass5;
@synthesize eQTotalHours1;
@synthesize eQTotalHours2;
@synthesize eQTotalHours3;
@synthesize eQTotalHours4;
@synthesize eQTotalHours5;
@synthesize inspector;
@synthesize project_id;
@synthesize signature1;
@synthesize signature2;
@synthesize sMSheetNo;
@synthesize total_to_date;
@synthesize  scrollView;



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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getImageReviewer1) name:@"DoneSignatureReviewer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getImageInspector1) name:@"DoneSignatureInspector" object:nil];
    
    
    scrollView.frame = CGRectMake(0,-10, 770, 2088);
    [scrollView setContentSize:CGSizeMake(620, 2300)];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back.jpg"]];
    // Do any additional setup after loading the view from its nib.
    
    
    UITapGestureRecognizer *singleTapInspec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetectedInspector)];
    
    // singleTap.numberOfTapsRequired = 1;
    signature1.userInteractionEnabled = YES;
    [signature1 addGestureRecognizer:singleTapInspec];
    
    
    UITapGestureRecognizer *singleTapReviewer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetectedReviewer)];
    // singleTap.numberOfTapsRequired = 1;
    signature2.userInteractionEnabled = YES;
    [signature2 addGestureRecognizer:singleTapReviewer];
    
    
    
    appDelegate=(TabAndSplitAppAppDelegate *)[[UIApplication sharedApplication] delegate];
 
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormat stringFromDate:today];
    inspector.text=appDelegate.projPrintedName;
    date1.text=dateString;
    date2.text= dateString;
    contractorRepresentative.text = appDelegate.pm;
    
}

-(void)getImageInspector1
{
    [self removeSignatureView];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    
    NSString *folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Signature"];
    signature1.image=[self getImageFromFileName:[NSString stringWithFormat:@"%@.jpg",@"Signature"] folderPath:folderPath];
    
    
}

-(void)getImageReviewer1
{
    [self removeSignatureView];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    
    NSString *folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Signature"];
    signature2.image=[self getImageFromFileName:[NSString stringWithFormat:@"%@.jpg",@"Signature_R"] folderPath:folderPath];
    
    
    }

-(UIImage *)getImageFromFileName:(NSString *)fileName folderPath:(NSString *)folderPath
{
    //get images from document directory
    NSLog(@"image name......%@",fileName);
    UIImage *current_img;
    NSString *fullPath = [folderPath stringByAppendingPathComponent:fileName];
    current_img=[UIImage imageWithContentsOfFile:fullPath];
    NSLog(@"current_img %@",current_img);
    return current_img;
}

-(void)tapDetectedInspector
{
    isSignature=@"1";
    signatureViewController=[[SignatureViewController alloc]initWithNibName:@"SignatureViewController" bundle:nil];
    signatureViewController.imageViewTag=@"1";
    NSLog(@"get URL image");
    [self.navigationController.view addSubview:signatureViewController.view];
    [self createSignatureCloseBtn];
    [self.navigationController.view addSubview:btnCloseSignView];
    
}

-(void)tapDetectedReviewer
{
    isSignature=@"1";
    signatureViewController=[[SignatureViewController alloc]initWithNibName:@"SignatureViewController" bundle:nil];
    signatureViewController.imageViewTag=@"2";
    NSLog(@"get URL image");
    [self.navigationController.view addSubview:signatureViewController.view];
    [self createSignatureCloseBtn];
    [self.navigationController.view addSubview:btnCloseSignView];
    
}


-(void)createSignatureCloseBtn
{
    UIImage* imageNormal = [UIImage imageNamed:@"closeBtn.png"];
    UIImage* imageHighLighted = [UIImage imageNamed:@"closeBtn.png"];
    CGRect frame;
    frame = CGRectMake(617,115,40,40);
    btnCloseSignView = [[UIButton alloc]initWithFrame:frame];
    [btnCloseSignView setBackgroundImage:imageNormal forState:UIControlStateNormal];
    [btnCloseSignView setBackgroundImage:imageHighLighted forState:UIControlStateHighlighted];
    [btnCloseSignView setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnCloseSignView setTitle:@"" forState:UIControlStateNormal];
    [btnCloseSignView setShowsTouchWhenHighlighted:YES];
    [btnCloseSignView addTarget:self action:@selector(removeSignatureView) forControlEvents:UIControlEventTouchUpInside];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField==eQTotalHours1 || textField==eQTotalHours2 || textField==eQTotalHours3 || textField==eQTotalHours4  || textField==eQTotalHours5 ||textField==eQRAte1 || textField==eQRAte2 || textField==eQRAte3 || textField==eQRAte4 || textField==eQRAte5 || textField==dailyTotal )
    {
        
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
        for (int i = 0; i < [string length]; i++)
        {
            unichar c = [string characterAtIndex:i];
            if (![myCharSet characterIsMember:c])
            {
                
                eQTotalHours1.enabled=YES;
                eQTotalHours2.enabled=YES;
                eQTotalHours3.enabled=YES;
                eQTotalHours4.enabled=YES;
                eQTotalHours5.enabled=YES;
                eQRAte1.enabled=YES;
                eQRAte2.enabled=YES;
                eQRAte3.enabled=YES;
                eQRAte4.enabled=YES;
                eQRAte5.enabled=YES;
                dailyTotal.enabled=YES;
                
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
    if(textField==eQAmount1)
    {
        
        double dist1 = [self.eQTotalHours1.text doubleValue];
        double mileage1 = [self.eQRAte1.text doubleValue];
        eQAmount1.text =  [NSString stringWithFormat:@"%.2f",dist1 * mileage1];
        [eQAmount1 resignFirstResponder];
        
    }
    if(textField==eQAmount2)
    {
        double dist2 = [self.eQTotalHours2.text doubleValue];
        double mileage2 = [self.eQRAte2.text doubleValue];
        eQAmount2.text =  [NSString stringWithFormat:@"%.2f",dist2 * mileage2];
        
        [eQAmount2 resignFirstResponder];
    }
    if(textField==eQAmount3)
    {
        double dist3 = [self.eQTotalHours3.text doubleValue];
        double mileage3 = [self.eQRAte3.text doubleValue];
        eQAmount3.text =  [NSString stringWithFormat:@"%.2f",dist3 * mileage3];
        
        [eQAmount3 resignFirstResponder];
    }
    
    if(textField==eQAmount4)
    {
        
        double dist4 = [self.eQTotalHours4.text doubleValue];
        double mileage4 = [self.eQRAte4.text doubleValue];
        eQAmount4.text =  [NSString stringWithFormat:@"%.2f",dist4 * mileage4];
        [eQAmount4 resignFirstResponder];
    }
    if(textField==eQAmount5)
    {
        
        double dist5 = [self.eQTotalHours5.text doubleValue];
        double mileage5 = [self.eQRAte5.text doubleValue];
        eQAmount5.text =  [NSString stringWithFormat:@"%.2f",dist5 * mileage5];
        [eQAmount5 resignFirstResponder];
    }
    double tot1 = [self.eQAmount1.text doubleValue];
    double tot2 = [self.eQAmount2.text doubleValue];
    double tot3 = [self.eQAmount3.text doubleValue];
    double tot4 = [self.eQAmount4.text doubleValue];
    double tot5 = [self.eQAmount5.text doubleValue];
    
    double allTot = tot1 + tot2 + tot3 + tot4 + tot5;
    
    dailyTotal.text = [NSString stringWithFormat:@"%.2f",allTot];
    
    
    double sum = [appDelegate.str1 doubleValue];
    double sum1 = [appDelegate.str2 doubleValue];
    double totdate = sum+sum1;
    
    
    total_to_date.text = [NSString stringWithFormat:@"%.2f",totdate];
    
    
    
    
    if(textField.text.length==0)
    {
        textField.text=@" ";
    }
    //clearField = NO;
}




-(void)removeSignatureView
{
    [btnCloseSignView removeFromSuperview];
    [signatureViewController.view removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(IBAction)saveCompliance:(id)sender
{
    uploading = NO;
    
    uploadingsketch=NO;
    
    uploadingSignature1=NO;
    uploadingSignature2=NO;
    
    
    
    if(inspector.text==NULL || inspector.text.length==0 || signature1.image==NULL ||  date1.text==NULL || date1.text.length==0  || date2.text==NULL || date2.text.length==0 || signature2.image==NULL || signature2.image==NULL || dailyTotal.text==NULL || dailyTotal.text.length==0 || total_to_date.text==NULL || total_to_date.text.length==0  )
    {
      //  contractorRepresentative.text==NULL || contractorRepresentative.text.length==0
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty"
                                                        message:@"Please fill all the fields"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        
    }
    else
    {
        
        uploadingSignature1=NO;
        uploadingSignature2=NO;
        
        
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
        NSString *field26=@" ";
        NSString *field27=@" ";
        NSString *field28=@" ";
        NSString *field29=@" ";
        NSString *field30=@" ";
        
        
        if (eQSizeandClass1.text!=NULL && eQSizeandClass1.text.length!=0 ) {
            
            field1=eQSizeandClass1.text;
            
        }
        
        if (eQIdleActive1.text!=NULL && eQIdleActive1.text.length!=0 ) {
            
            field2=eQIdleActive1.text;
            
        }
        
        if (eQNo1.text!=NULL && eQNo1.text.length!=0 ) {
            
            field3=eQNo1.text;
            
        }
        
        if (eQTotalHours1.text!=NULL && eQTotalHours1.text.length!=0 ) {
            
            field4=eQTotalHours1.text;
            
        }
        
        if (eQRAte1.text!=NULL && eQRAte1.text.length!=0 ) {
            
            field5=eQRAte1.text;
            
        }
        
        if (eQAmount1.text!=NULL && eQAmount1.text.length!=0 ) {
            
            field6=eQAmount1.text;
            
        }
        
        
        //
        
        if (eQSizeandClass2.text!=NULL && eQSizeandClass2.text.length!=0 ) {
            
            field7=eQSizeandClass2.text;
            
        }
        
        if (eQIdleActive2.text!=NULL && eQIdleActive2.text.length!=0 ) {
            
            field8=eQIdleActive2.text;
            
        }
        
        if (eQNo2.text!=NULL && eQNo2.text.length!=0 ) {
            
            field9=eQNo2.text;
            
        }
        
        if (eQTotalHours2.text!=NULL && eQTotalHours2.text.length!=0 ) {
            
            field10=eQTotalHours2.text;
            
        }
        
        if (eQRAte2.text!=NULL && eQRAte2.text.length!=0 ) {
            
            field11=eQRAte2.text;
            
        }
        
        if (eQAmount2.text!=NULL && eQAmount2.text.length!=0 ) {
            
            field12=eQAmount2.text;
            
        }
        
        
        //
        
        if (eQSizeandClass3.text!=NULL && eQSizeandClass3.text.length!=0 ) {
            
            field13=eQSizeandClass3.text;
            
        }
        
        if (eQIdleActive3.text!=NULL && eQIdleActive3.text.length!=0 ) {
            
            field14=eQIdleActive3.text;
            
        }
        
        if (eQNo3.text!=NULL && eQNo3.text.length!=0 ) {
            
            field15=eQNo3.text;
            
        }
        
        if (eQTotalHours3.text!=NULL && eQTotalHours3.text.length!=0 ) {
            
            field16=eQTotalHours3.text;
            
        }
        
        if (eQRAte2.text!=NULL && eQRAte2.text.length!=0 ) {
            
            field17=eQRAte2.text;
            
        }
        
        if (eQAmount3.text!=NULL && eQAmount3.text.length!=0 ) {
            
            field18=eQAmount3.text;
            
        }
        
        //
        
        if (eQSizeandClass4.text!=NULL && eQSizeandClass4.text.length!=0 ) {
            
            field19=eQSizeandClass4.text;
            
        }
        
        if (eQIdleActive4.text!=NULL && eQIdleActive4.text.length!=0 ) {
            
            field20=eQIdleActive4.text;
            
        }
        
        if (eQNo4.text!=NULL && eQNo4.text.length!=0 ) {
            
            field21=eQNo4.text;
            
        }
        
        if (eQTotalHours4.text!=NULL && eQTotalHours4.text.length!=0 ) {
            
            field22=eQTotalHours4.text;
            
        }
        
        if (eQRAte4.text!=NULL && eQRAte4.text.length!=0 ) {
            
            field23=eQRAte4.text;
            
        }
        
        if (eQAmount4.text!=NULL && eQAmount4.text.length!=0 ) {
            
            field24=eQAmount4.text;
            
        }
        
        //
        
        
        
        if (eQSizeandClass5.text!=NULL && eQSizeandClass5.text.length!=0 ) {
            
            field25=eQSizeandClass5.text;
            
        }
        
        if (eQIdleActive5.text!=NULL && eQIdleActive5.text.length!=0 ) {
            
            field26=eQIdleActive5.text;
            
        }
        
        if (eQNo5.text!=NULL && eQNo5.text.length!=0 ) {
            
            field27=eQNo5.text;
            
        }
        
        if (eQTotalHours5.text!=NULL && eQTotalHours5.text.length!=0 ) {
            
            field28=eQTotalHours5.text;
            
        }
        
        if (eQRAte5.text!=NULL && eQRAte5.text.length!=0 ) {
            
            field29=eQRAte5.text;
            
        }
        
        if (eQAmount5.text!=NULL && eQAmount5.text.length!=0 ) {
            
            field30=eQAmount5.text;
            
        }
       
        
        sigName1=[NSString stringWithFormat:@"Signature_%@",[self getCurrentDateTimeAsNSString]];
        sigName2=[NSString stringWithFormat:@"Signature_R%@",[self getCurrentDateTimeAsNSString]];
        
        BOOL saveStatus = [PRIMECMController
                           saveSummery3:appDelegate.username
                           contractorRepresentative:appDelegate.pm
                           dailyTotal:dailyTotal.text
                           date1:date1.text
                           date2:date2.text
                           eQAmount1:eQAmount1.text
                           eQAmount2:eQAmount2.text
                           eQAmount3:eQAmount3.text
                           eQAmount4:eQAmount4.text
                           eQAmount5:eQAmount5.text
                           eQIdleActive1:eQIdleActive1.text
                           eQIdleActive2:eQIdleActive2.text
                           eQIdleActive3:eQIdleActive3.text
                           eQIdleActive4:eQIdleActive4.text
                           eQIdleActive5:eQIdleActive5.text
                           eQNo1:eQNo1.text
                           eQNo2:eQNo2.text
                           eQNo3:eQNo3.text
                           eQNo4:eQNo4.text
                           eQNo5:eQNo5.text
                           eQRAte1:eQRAte1.text
                           eQRAte2:eQRAte2.text
                           eQRAte3:eQRAte3.text
                           eQRAte4:eQRAte4.text
                           eQRAte5:eQRAte5.text
                           eQSizeandClass1:eQSizeandClass1.text
                           eQSizeandClass2:eQSizeandClass2.text
                           eQSizeandClass3:eQSizeandClass3.text
                           eQSizeandClass4:eQSizeandClass4.text
                           eQSizeandClass5:eQSizeandClass5.text
                           eQTotalHours1:eQTotalHours1.text
                           eQTotalHours2:eQTotalHours2.text
                           eQTotalHours3:eQTotalHours3.text
                           eQTotalHours4:eQTotalHours4.text
                           eQTotalHours5:eQTotalHours5.text
                           inspector:appDelegate.projPrintedName
                           project_id:appDelegate.projId
                           signature1:sigName1
                           signature2:sigName2
                           sMSheetNo:@""
                           total_to_date:total_to_date.text
                           ];
        
        [HUD setHidden:YES];
        
        BOOL singSaveState;
        BOOL singSaveState2;

        
        NSArray *pathsSign = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectorySign = [pathsSign objectAtIndex:0];
        
        NSString *folderPathSign= [documentsDirectorySign stringByAppendingPathComponent:@"/Signature"];
        
        
        UIImage *imageSign=[self getSignatureFromFileName:[NSString stringWithFormat:@"%@.jpg",@"Signature_R"] folderPath:folderPathSign];
        NSData *imaDataSign1 = UIImageJPEGRepresentation(imageSign,0.3);
        NSData *imaDataSign2 = UIImageJPEGRepresentation(imageSign,0.3);

        singSaveState = [PRIMECMController saveAllImages:sigName1 img:imaDataSign1 syncStatus:SYNC_STATUS_PENDING];
        
        
        singSaveState2 = [PRIMECMController saveAllImages:sigName2 img:imaDataSign2 syncStatus:SYNC_STATUS_PENDING];

        
        
        
        if (saveStatus){
            UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Successfully saved summary sheet report." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [exportAlert show];
            [appDelegate.sketchesArray removeAllObjects];
            // [arrayImages removeAllObjects];
            // [self clearFormFields];
            
            
        }else{
            UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to save summary sheet report." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [exportAlert show];
        }
    }
}


-(void)uploadSignature2
{
    
    uploadingSignature2=YES;
    
    
    
    NSString *urlLink = [NSString stringWithFormat:@"%@/api/summary3/uploadimages/%@/%@", [PRIMECMAPPUtils getAPIEndpoint], appDelegate.username,sigName2];
    
    NSString *unicodeLink = [urlLink stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"URL---%@",unicodeLink);
    
    NSURL *apiURL =
    [NSURL URLWithString:unicodeLink];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:apiURL cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                          timeoutInterval:60.0];
    
    [urlRequest setHTTPMethod:@"POST"];
    NSLog(@"URL DESK----- %@",unicodeLink);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    
    
    NSString *folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Signature"];
    NSMutableData *postbody = [NSMutableData data];
    
    
    
    UIImage *image=[self getImageFromFileName:[NSString stringWithFormat:@"%@.jpg", @"Signature_R"] folderPath:folderPath];
    NSData *imaData = UIImageJPEGRepresentation(image,0.3);
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [urlRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@.jpg\"\r\n",sigName2] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[NSData dataWithData:imaData]];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"^^^^^^^^^^^^^%@",postbody);
    
    [urlRequest setHTTPBody:postbody];
    uploadingSignature2=YES;
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    _receivedData = [[NSMutableData alloc] init];
    
    [connection start];
    
    
    NSLog(@"sent");
    
}


-(void)uploadSignature1
{
    
    uploadingSignature1=YES;
    
    
    
    NSString *urlLink = [NSString stringWithFormat:@"%@/api/summary3/uploadimages/%@/%@", [PRIMECMAPPUtils getAPIEndpoint], appDelegate.username,sigName1];
    
    NSString *unicodeLink = [urlLink stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"URL---%@",unicodeLink);
    
    NSURL *apiURL =
    [NSURL URLWithString:unicodeLink];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:apiURL cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                          timeoutInterval:60.0];
    
    [urlRequest setHTTPMethod:@"POST"];
    NSLog(@"URL DESK----- %@",unicodeLink);
    //isSendingDecs=YES;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    
    
    NSString *folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Signature"];
    NSMutableData *postbody = [NSMutableData data];
    
    
    
    UIImage *image=[self getImageFromFileName:[NSString stringWithFormat:@"%@.jpg", @"Signature"] folderPath:folderPath];
    NSData *imaData = UIImageJPEGRepresentation(image,0.3);
    // NSLog(@"********************* UPloadinggggg %i  %@",count1,[arrayImages objectAtIndex:count1]);
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [urlRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@.jpg\"\r\n",sigName1] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[NSData dataWithData:imaData]];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"^^^^^^^^^^^^^%@",postbody);
    
    [urlRequest setHTTPBody:postbody];
    uploadingSignature1=YES;
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    _receivedData = [[NSMutableData alloc] init];
    
    [connection start];
    
    
    NSLog(@"sent");
    
}

-(UIImage *)getSignatureFromFileName:(NSString *)fileName folderPath:(NSString *)folderPath
{
    
    //get images from document directory
    NSLog(@"image name......%@",fileName);
    UIImage *current_img;
    NSString *fullPath = [folderPath stringByAppendingPathComponent:fileName];
    current_img=[UIImage imageWithContentsOfFile:fullPath];
    NSLog(@"current_img %@",current_img);
    return current_img;
    
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
