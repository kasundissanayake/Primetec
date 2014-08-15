

#import "Summary_3_ViewController.h"
#import "SignatureViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TabAndSplitAppAppDelegate.h"


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
@synthesize  scrollView;
@synthesize StxtDateCR, StxtDateINS;
@synthesize imgSignatureCR, imgSignatureINS;
@synthesize txtRate1,txtRate2,txtRate3,txtRate4,txtRate5,arrayImages;

@synthesize class1,class2,class3,class4,class5,no1,no2,no3,no4,no5,active1,active2,active3,active4,active5,inspecter;

@synthesize txtTotal1,txtTotal2,txtTotal3,txtTotal4,txtTotal5;

@synthesize txtHours1,txtHours2,txtHours3,txtHours4,txtHours5,txtDailyTotal5,txtTotaToDatel5;

@synthesize pm;


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
    imgSignatureINS.userInteractionEnabled = YES;
    [imgSignatureINS addGestureRecognizer:singleTapInspec];
    
    
    UITapGestureRecognizer *singleTapReviewer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetectedReviewer)];
    // singleTap.numberOfTapsRequired = 1;
    imgSignatureCR.userInteractionEnabled = YES;
    [imgSignatureCR addGestureRecognizer:singleTapReviewer];
    
    
    
    appDelegate=(TabAndSplitAppAppDelegate *)[[UIApplication sharedApplication] delegate];
 
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormat stringFromDate:today];
    inspecter.text=appDelegate.projPrintedName;
    StxtDateINS.text=dateString;
    StxtDateCR.text= dateString;
    pm.text = appDelegate.pm;
    
}

-(void)getImageInspector1
{
    [self removeSignatureView];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    
    NSString *folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Signature"];
    imgSignatureINS.image=[self getImageFromFileName:[NSString stringWithFormat:@"%@.jpg",@"Signature"] folderPath:folderPath];
    
}

-(void)getImageReviewer1
{
    [self removeSignatureView];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    
    NSString *folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Signature"];
    imgSignatureCR.image=[self getImageFromFileName:[NSString stringWithFormat:@"%@.jpg",@"Signature_R"] folderPath:folderPath];
    
    
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
    if(textField==txtHours1 || textField==txtHours2 || textField==txtHours3 || textField==txtHours4  || textField==txtHours5 ||textField==txtRate1 || textField==txtRate2 || textField==txtRate3 || textField==txtRate4 || textField==txtRate5 || textField==txtDailyTotal5 )
    {
        
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
        for (int i = 0; i < [string length]; i++)
        {
            unichar c = [string characterAtIndex:i];
            if (![myCharSet characterIsMember:c])
            {
                
                txtHours1.enabled=YES;
                txtHours2.enabled=YES;
                txtHours3.enabled=YES;
                txtHours4.enabled=YES;
                txtHours5.enabled=YES;
                txtRate1.enabled=YES;
                txtRate2.enabled=YES;
                txtRate3.enabled=YES;
                txtRate4.enabled=YES;
                txtRate5.enabled=YES;
                txtDailyTotal5.enabled=YES;
                
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
        
        double dist1 = [self.txtHours1.text doubleValue];
        double mileage1 = [self.txtRate1.text doubleValue];
        txtTotal1.text =  [NSString stringWithFormat:@"%.2f",dist1 * mileage1];
        [txtTotal1 resignFirstResponder];
        
    }
    if(textField==txtTotal2)
    {
        double dist2 = [self.txtHours2.text doubleValue];
        double mileage2 = [self.txtRate2.text doubleValue];
        txtTotal2.text =  [NSString stringWithFormat:@"%.2f",dist2 * mileage2];
        
        [txtTotal2 resignFirstResponder];
    }
    if(textField==txtTotal3)
    {
        double dist3 = [self.txtHours3.text doubleValue];
        double mileage3 = [self.txtRate3.text doubleValue];
        txtTotal3.text =  [NSString stringWithFormat:@"%.2f",dist3 * mileage3];
        
        [txtTotal3 resignFirstResponder];
    }
    
    if(textField==txtTotal4)
    {
        
        double dist4 = [self.txtHours4.text doubleValue];
        double mileage4 = [self.txtRate4.text doubleValue];
        txtTotal4.text =  [NSString stringWithFormat:@"%.2f",dist4 * mileage4];
        [txtTotal4 resignFirstResponder];
    }
    if(textField==txtTotal5)
    {
        
        double dist5 = [self.txtHours5.text doubleValue];
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
    
    txtDailyTotal5.text = [NSString stringWithFormat:@"%.2f",allTot];
    
    
    double sum = [appDelegate.str1 doubleValue];
    double sum1 = [appDelegate.str2 doubleValue];
    double totdate = sum+sum1;
    
    
    txtTotaToDatel5.text = [NSString stringWithFormat:@"%.2f",totdate];
    
    
    
    
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
    
    
    
    if(inspecter.text==NULL || inspecter.text.length==0 || imgSignatureINS.image==NULL ||  StxtDateINS.text==NULL || StxtDateINS.text.length==0  || StxtDateCR.text==NULL || StxtDateCR.text.length==0 || imgSignatureCR.image==NULL || StxtDateCR.text==NULL || StxtDateCR.text.length==0 || txtDailyTotal5.text==NULL || txtDailyTotal5.text.length==0 || txtTotaToDatel5.text==NULL || txtTotaToDatel5.text.length==0 || pm.text==NULL || pm.text.length==0)
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
        
        
        if (class1.text!=NULL && class1.text.length!=0 ) {
            
            field1=class1.text;
            
        }
        
        if (active1.text!=NULL && active1.text.length!=0 ) {
            
            field2=active1.text;
            
        }
        
        if (no1.text!=NULL && no1.text.length!=0 ) {
            
            field3=no1.text;
            
        }
        
        if (txtHours1.text!=NULL && txtHours1.text.length!=0 ) {
            
            field4=txtHours1.text;
            
        }
        
        if (txtRate1.text!=NULL && txtRate1.text.length!=0 ) {
            
            field5=txtRate1.text;
            
        }
        
        if (txtTotal1.text!=NULL && txtTotal1.text.length!=0 ) {
            
            field6=txtTotal1.text;
            
        }
        
        
        //
        
        if (class2.text!=NULL && class2.text.length!=0 ) {
            
            field7=class2.text;
            
        }
        
        if (active2.text!=NULL && active2.text.length!=0 ) {
            
            field8=active2.text;
            
        }
        
        if (no2.text!=NULL && no2.text.length!=0 ) {
            
            field9=no2.text;
            
        }
        
        if (txtHours2.text!=NULL && txtHours2.text.length!=0 ) {
            
            field10=txtHours2.text;
            
        }
        
        if (txtRate2.text!=NULL && txtRate2.text.length!=0 ) {
            
            field11=txtRate2.text;
            
        }
        
        if (txtTotal2.text!=NULL && txtTotal2.text.length!=0 ) {
            
            field12=txtTotal2.text;
            
        }
        
        
        //
        
        if (class3.text!=NULL && class3.text.length!=0 ) {
            
            field13=class3.text;
            
        }
        
        if (active3.text!=NULL && active3.text.length!=0 ) {
            
            field14=active3.text;
            
        }
        
        if (no3.text!=NULL && no3.text.length!=0 ) {
            
            field15=no3.text;
            
        }
        
        if (txtHours3.text!=NULL && txtHours3.text.length!=0 ) {
            
            field16=txtHours3.text;
            
        }
        
        if (txtRate2.text!=NULL && txtRate2.text.length!=0 ) {
            
            field17=txtRate2.text;
            
        }
        
        if (txtTotal3.text!=NULL && txtTotal3.text.length!=0 ) {
            
            field18=txtTotal3.text;
            
        }
        
        //
        
        if (class4.text!=NULL && class4.text.length!=0 ) {
            
            field19=class4.text;
            
        }
        
        if (active4.text!=NULL && active4.text.length!=0 ) {
            
            field20=active4.text;
            
        }
        
        if (no4.text!=NULL && no4.text.length!=0 ) {
            
            field21=no4.text;
            
        }
        
        if (txtHours4.text!=NULL && txtHours4.text.length!=0 ) {
            
            field22=txtHours4.text;
            
        }
        
        if (txtRate4.text!=NULL && txtRate4.text.length!=0 ) {
            
            field23=txtRate4.text;
            
        }
        
        if (txtTotal4.text!=NULL && txtTotal4.text.length!=0 ) {
            
            field24=txtTotal4.text;
            
        }
        
        //
        
        
        
        if (class5.text!=NULL && class5.text.length!=0 ) {
            
            field25=class5.text;
            
        }
        
        if (active5.text!=NULL && active5.text.length!=0 ) {
            
            field26=active5.text;
            
        }
        
        if (no5.text!=NULL && no5.text.length!=0 ) {
            
            field27=no5.text;
            
        }
        
        if (txtHours5.text!=NULL && txtHours5.text.length!=0 ) {
            
            field28=txtHours5.text;
            
        }
        
        if (txtRate5.text!=NULL && txtRate5.text.length!=0 ) {
            
            field29=txtRate5.text;
            
        }
        
        if (txtTotal5.text!=NULL && txtTotal5.text.length!=0 ) {
            
            field30=txtTotal5.text;
            
        }
       
        
        sigName1=[NSString stringWithFormat:@"Signature_%@",[self getCurrentDateTimeAsNSString]];
        sigName2=[NSString stringWithFormat:@"Signature_R%@",[self getCurrentDateTimeAsNSString]];
        
        NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                                stringForKey:@"summery id"];
        NSLog(@"saved val%@",savedValue);
        
        
        NSString *strURL = [NSString stringWithFormat:@"http://data.privytext.us/contructionapi.php/api/summary3/create/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@",appDelegate.username,appDelegate.saveVal,appDelegate.projId,field1,field2,field3,field4,field5,field6,field7,field8,field9,field10,field11,field12,field13,field14,field15,field16,field17,field18,field19,field20,field21,field22,field23,field24,field25,field26,field27,field28,field29,field30,inspecter.text,sigName1,StxtDateINS.text,pm.text,sigName2,StxtDateCR.text,txtDailyTotal5.text,txtTotaToDatel5.text];
        
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
        
        txtHours1.text=@"";
        txtHours2.text=@"";
        txtHours3.text=@"";
        txtHours4.text=@"";
        txtHours5.text=@"";
        
        no1.text=@"";
        no2.text=@"";
        no3.text=@"";
        no4.text=@"";
        no5.text=@"";
        
        active1.text=@"";
        active2.text=@"";
        active3.text=@"";
        active4.text=@"";
        active5.text=@"";
        
        class5.text=@"";
        class4.text=@"";
        class3.text=@"";
        class2.text=@"";
        class1.text=@"";
        
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
        
        inspecter.text=@"";
      
        StxtDateCR.text=NULL;
        StxtDateINS.text=NULL;
        txtDailyTotal5.text=@"";
        txtTotaToDatel5.text=@"";
        pm.text=@"";
        
        imgSignatureCR.image=NULL;
        imgSignatureINS.image=NULL;
        
       }
    
}




-(void)uploadSignature2
{
    
    uploadingSignature2=YES;
    
    
    
    NSString *urlLink = [NSString stringWithFormat:@"http://data.privytext.us/contructionapi.php/api/summary3/uploadimages/%@/%@",appDelegate.username,sigName2];
    
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
    
    
    
    NSString *urlLink = [NSString stringWithFormat:@"http://data.privytext.us/contructionapi.php/api/summary3/uploadimages/%@/%@",appDelegate.username,sigName1];
    
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
    
    
    if (uploadingSignature1) {
        
        uploadingSignature1=NO;
        
        
        
        
        [self uploadSignature2];
        
        
        
    }
    else if (uploadingSignature2) {
        
        uploadingSignature2=NO;
        
        
        UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Successfully added." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [exportAlert show];
        
        
    }
   
    else
    {
        
        if([[responseObject valueForKey:@"status"]isEqualToString:@"sucess"])
        {
            
            
            [self uploadSignature1];
            
        }
        else
        {
            UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [exportAlert show];
        }
        
        
    }

    
}



@end
