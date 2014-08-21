#import "SummaryReport.h"
#import "PRIMECMAPPUtils.h"

@interface SummaryReport ()
{
    NSMutableData *_receivedData;
    NSURLResponse *_receivedResponse;
    NSError *_connectionError;
    NSArray *resPonse;
    MBProgressHUD *HUD;
    UIBarButtonItem  *btnPrint;
}

@end

@implementation SummaryReport
@synthesize  scrollView;
@synthesize lblImageAttachmentTitle,viewImageAttachmentTitle;
@synthesize SMNo;
@synthesize txt20Items,txtActive1,txtActive2,txtActive3,txtActive4,txtActive5,txtAdditional,txtAddTotal,txtAmt1,txtAmt2,txtAmt3,txtAmt4,txtAmt5,txtCheckedBy,txtCity,txtClass1,txtClass2,txtClass3,txtClass4,txtClass5,txtConReDate,txtContactorPerform,txtContractor,txtContractorRepresentative,txtDailyTotal,txtDate,txtDateOfWork,txtDes1,txtDes2,txtDes3,txtDes4,txtDES5,txtENo1,txtENo2,txtENo3,txtENo4,txtENo5,txtETotal1,txtETotal2,txtEtotal3,txtETotal4,txtETotal5,txtFederalAid,txtHealth,txtInspector,txtInsTax,txtLessDiscount,txtLessDisTotal,txtMAmt1,txtMAmt2,txtMAmt3,txtMAmt4,txtMAmt5,txtNo1,txtNo2,txtNo3,txtNo4,txtNo5,txtPOBox,txtProjectNo,txtQuantity1,txtQuantity2,txtQuantity3,txtQuantity4,txtQuantity5,txtRate1,txtRate2,txtRate3,txtRate4,txtRate5,txtReportNum,txtSize1,txtSize2,txtSize3,txtSize4,txtSize5,txtState,txtTotal1,txtTotal2,txtTotal3,txtTotal4,txtTotal5,txtTotalDate,txtTotalItems,txtTotalLabor,txtTotalMeterial,txtTpNumber,txtUnitPrice1,txtUnitPrice2,txtUnitPrice3,txtUnitPrice4,txtUnitPrice5,txvConsOrder,txvDesWork,imgSignature,imgSignature2,txtERate1,txtERate2,txtERate3,txtERate4,txtERate5,txtEAmt1,txtEAmt2,txtEAmt3,txtEAmt4,txtEAmt5;


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
    
    [txvDesWork.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [txvDesWork.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [txvDesWork.layer setBorderWidth: 1.0];
    [txvDesWork.layer setCornerRadius:8.0f];
    
    [txvConsOrder.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [txvConsOrder.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [txvConsOrder.layer setBorderWidth: 1.0];
    [txvConsOrder.layer setCornerRadius:8.0f];
    
    scrollView.frame = CGRectMake(0, 0, 770, 3350);
    [scrollView setContentSize:CGSizeMake(620, 4000)];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *Button = [[UIBarButtonItem alloc]
                               initWithTitle:NSLocalizedString(@"New", @"")
                               style:UIBarButtonItemStyleDone
                               target:self
                               action:@selector(showSCompliance:)];
    
    self.navigationItem.rightBarButtonItem = Button;
    
    
    UIBarButtonItem *Button2 = [[UIBarButtonItem alloc]
                                initWithTitle:NSLocalizedString(@"Edit", @"")
                                style:UIBarButtonItemStyleDone
                                target:self
                                action:@selector(fnEdit:)];
    
    
    
    UIBarButtonItem  *btnEmail = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(createPDF)];
    
    
    btnPrint = [[UIBarButtonItem alloc]
                initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(printReport)];
    
    
    self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:Button, btnEmail,btnPrint, nil];
    self.navigationItem.leftBarButtonItem=Button2;
    [self populateSummerySheet];
}


-(void)printReport
{
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    viewImageAttachmentTitle.hidden=YES;
    lblImageAttachmentTitle.hidden=YES;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *directroyPath = nil;
    directroyPath = [documentsDirectory stringByAppendingPathComponent:@"PDF"];
    NSString *fileName=[NSString stringWithFormat:@"%@.pdf",@"Report"];
    NSString *filePath = [directroyPath stringByAppendingPathComponent:fileName];
    NSError *error;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
    } else {
        [[NSFileManager defaultManager] createDirectoryAtPath:directroyPath
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:&error];
    }
    
    CGContextRef pdfContext = [self createPDFContext:self.scrollView.bounds path:(CFStringRef)filePath];
    NSLog(@"PDF Context created");
    int count=5;
    for (int i = 0 ; i<count ; i++)
    {
        // page 1
        CGContextBeginPage (pdfContext,nil);
        
        //turn PDF upsidedown
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformMakeTranslation(0, (i+1) *900);
        transform = CGAffineTransformScale(transform, 1.0, -1.0);
        CGContextConcatCTM(pdfContext, transform);
        
        //Draw view into PDF
        [self.scrollView.layer renderInContext:pdfContext];
        CGContextEndPage (pdfContext);
        [self.scrollView setContentOffset:CGPointMake(0, (i+1) * 900) animated:NO];
    }
    
    CGContextRelease (pdfContext);
    NSData *pdfData = [NSData dataWithContentsOfFile:filePath];
    
    printController = [UIPrintInteractionController sharedPrintController];
    if(printController && [UIPrintInteractionController canPrintData:pdfData]) {
        printController.delegate = self;
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = [NSString stringWithFormat:@""];
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        printController.printInfo = printInfo;
        printController.showsPageRange = YES;
        printController.printingItem = pdfData;
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
            if (!completed && error) {
                
            }
        };
        [printController presentFromBarButtonItem:btnPrint animated:YES completionHandler:completionHandler];
    }
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, -self.scrollView.contentInset.top) animated:YES];
}

-(void)populateSummerySheet
{
    /*
    NSString *strURL = [NSString stringWithFormat:@"%@/api/summary1/single/%@", [PRIMECMAPPUtils getAPIEndpoint], SMNo];
    NSURL *apiURL =
    [NSURL URLWithString:strURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:apiURL];
    [urlRequest setHTTPMethod:@"GET"];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    */
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.navigationController.view addSubview:HUD];
    HUD.labelText=@"";
    HUD.dimBackground = YES;
    HUD.delegate = self;
    [HUD show:YES];
    
    NSManagedObjectContext *context = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SummarySheet1" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY sMSheetNo == %@", SMNo];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    
    if([objects count] > 0){
        
        NSManagedObject *summaryReportObject = (NSManagedObject *) [objects objectAtIndex:0];
        NSLog(@"Summary Sheet Form object sMSheetNo: %@", [summaryReportObject valueForKey:@"sMSheetNo"]);
        
        txtContractor.text=[summaryReportObject valueForKey:@"contractor"];
        txtPOBox.text=[summaryReportObject valueForKey:@"pOBox"];
        txtCity.text=[summaryReportObject valueForKey:@"city"];
        txtState.text=[summaryReportObject valueForKey:@"state"];
        txtTpNumber.text=[summaryReportObject valueForKey:@"telephoneNo"];
        
        txtDate.text=[NSDateFormatter localizedStringFromDate:[summaryReportObject valueForKey:@"date"]
                                                    dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
        txtDateOfWork.text=[NSDateFormatter localizedStringFromDate:[summaryReportObject valueForKey:@"date"]
                                                          dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
        
        txtContactorPerform.text=[summaryReportObject valueForKey:@"conPeWork"];
        txtFederalAid.text=[summaryReportObject valueForKey:@"federalAidNumber"];
        txtProjectNo.text=[summaryReportObject valueForKey:@"projectNo"];
        txvDesWork.text=[summaryReportObject valueForKey:@"descr"];
        txvConsOrder.text=[summaryReportObject valueForKey:@"constructionOrder"];
        txtClass1.text=[summaryReportObject valueForKey:@"lAClass1"];
        txtClass2.text=[summaryReportObject valueForKey:@"lAClass2"];
        txtClass3.text=[summaryReportObject valueForKey:@"lAClass3"];
        txtClass4.text=[summaryReportObject valueForKey:@"lAClass4"];
        txtClass5.text=[summaryReportObject valueForKey:@"lAClass5"];
        txtNo1.text=[summaryReportObject valueForKey:@"lANo1"];
        txtNo2.text=[summaryReportObject valueForKey:@"lANo2"];
        txtNo3.text=[summaryReportObject valueForKey:@"lANo3"];
        txtNo4.text=[summaryReportObject valueForKey:@"lANo4"];
        txtNo5.text=[summaryReportObject valueForKey:@"lANo5"];
        txtTotal1.text=[summaryReportObject valueForKey:@"lATotalHours1"];
        txtTotal2.text=[summaryReportObject valueForKey:@"lATotalHours2"];
        txtTotal3.text=[summaryReportObject valueForKey:@"lATotalHours3"];
        txtTotal4.text=[summaryReportObject valueForKey:@"lATotalHours4"];
        txtTotal5.text=[summaryReportObject valueForKey:@"lATotalHours5"];
        txtRate1.text=[summaryReportObject valueForKey:@"lARate1"];
        txtRate2.text=[summaryReportObject valueForKey:@"lARate2"];
        txtRate3.text=[summaryReportObject valueForKey:@"lARate3"];
        txtRate4.text=[summaryReportObject valueForKey:@"lARate4"];
        txtRate5.text=[summaryReportObject valueForKey:@"lARate5"];
        txtAmt1.text=[summaryReportObject valueForKey:@"lAAmount1"];
        txtAmt2.text=[summaryReportObject valueForKey:@"lAAmount2"];
        txtAmt3.text=[summaryReportObject valueForKey:@"lAAmount3"];
        txtAmt4.text=[summaryReportObject valueForKey:@"lAAmount4"];
        txtAmt5.text=[summaryReportObject valueForKey:@"lAAmount5"];
        txtTotalLabor.text=[summaryReportObject valueForKey:@"totalLabor"];
        txtHealth.text=[summaryReportObject valueForKey:@"healWelAndPension"];
        txtInsTax.text=[summaryReportObject valueForKey:@"insAndTaxesOnItem1"];
        txt20Items.text=[summaryReportObject valueForKey:@"itemDescount20per"];
        txtTotalItems.text=[summaryReportObject valueForKey:@"total"];
        txtDes1.text=[summaryReportObject valueForKey:@"mEDescription1"];
        txtDes2.text=[summaryReportObject valueForKey:@"mEDescription2"];
        txtDes3.text=[summaryReportObject valueForKey:@"mEDescription3"];
        txtDes4.text=[summaryReportObject valueForKey:@"mEDescription4"];
        txtDES5.text=[summaryReportObject valueForKey:@"mEDescription5"];
        txtQuantity1.text=[summaryReportObject valueForKey:@"mEQuantity1"];
        txtQuantity2.text=[summaryReportObject valueForKey:@"mEQuantity2"];
        txtQuantity3.text=[summaryReportObject valueForKey:@"mEQuantity3"];
        txtQuantity4.text=[summaryReportObject valueForKey:@"mEQuantity4"];
        txtQuantity5.text=[summaryReportObject valueForKey:@"mEQuantity5"];
        txtUnitPrice1.text=[summaryReportObject valueForKey:@"mEUnitPrice1"];
        txtUnitPrice2.text=[summaryReportObject valueForKey:@"mEUnitPrice2"];
        txtUnitPrice3.text=[summaryReportObject valueForKey:@"mEUnitPrice3"];
        txtUnitPrice4.text=[summaryReportObject valueForKey:@"mEUnitPrice4"];
        txtUnitPrice5.text=[summaryReportObject valueForKey:@"mEUnitPrice5"];
        txtMAmt1.text=[summaryReportObject valueForKey:@"mEAmount1"];
        txtMAmt2.text=[summaryReportObject valueForKey:@"mEAmount2"];
        txtMAmt3.text=[summaryReportObject valueForKey:@"mEAmount3"];
        txtMAmt4.text=[summaryReportObject valueForKey:@"mEAmount4"];
        txtMAmt5.text=[summaryReportObject valueForKey:@"mEAmount5"];
        txtTotalMeterial.text=[summaryReportObject valueForKey:@"total1"];
        txtLessDiscount.text=[summaryReportObject valueForKey:@"lessDiscount"];
        txtLessDisTotal.text=[summaryReportObject valueForKey:@"total2"];
        txtAdditional.text=[summaryReportObject valueForKey:@"additionalDiscount"];
        txtAddTotal.text=[summaryReportObject valueForKey:@"total3"];
        txtSize1.text=[summaryReportObject valueForKey:@"eQSizeandClass1"];
        txtSize2.text=[summaryReportObject valueForKey:@"eQSizeandClass2"];
        txtSize3.text=[summaryReportObject valueForKey:@"eQSizeandClass3"];
        txtSize4.text=[summaryReportObject valueForKey:@"eQSizeandClass4"];
        txtSize5.text=[summaryReportObject valueForKey:@"eQSizeandClass5"];
        txtActive1.text=[summaryReportObject valueForKey:@"eQAmount1"];
        txtActive2.text=[summaryReportObject valueForKey:@"eQAmount2"];
        txtActive3.text=[summaryReportObject valueForKey:@"eQAmount3"];
        txtActive4.text=[summaryReportObject valueForKey:@"eQAmount4"];
        txtActive5.text=[summaryReportObject valueForKey:@"eQAmount5"];
        txtENo1.text=[summaryReportObject valueForKey:@"eQNo1"];
        txtENo2.text=[summaryReportObject valueForKey:@"eQNo2"];
        txtENo3.text=[summaryReportObject valueForKey:@"eQNo3"];
        txtENo4.text=[summaryReportObject valueForKey:@"eQNo4"];
        txtENo5.text=[summaryReportObject valueForKey:@"eQNo5"];
        txtETotal1.text=[summaryReportObject valueForKey:@"eQTotalHours1"];
        txtETotal2.text=[summaryReportObject valueForKey:@"eQTotalHours2"];
        txtEtotal3.text=[summaryReportObject valueForKey:@"eQTotalHours3"];
        txtETotal4.text=[summaryReportObject valueForKey:@"eQTotalHours4"];
        txtETotal5.text=[summaryReportObject valueForKey:@"eQTotalHours5"];
        txtERate1.text=[summaryReportObject valueForKey:@"eQRAte1"];
        txtERate2.text=[summaryReportObject valueForKey:@"eQRAte2"];
        txtERate3.text=[summaryReportObject valueForKey:@"eQRAte3"];
        txtERate4.text=[summaryReportObject valueForKey:@"eQRAte4"];
        txtERate5.text=[summaryReportObject valueForKey:@"eQRAte5"];
        txtEAmt1.text=[summaryReportObject valueForKey:@"eQAmount1"];
        txtEAmt2.text=[summaryReportObject valueForKey:@"eQAmount2"];
        txtEAmt3.text=[summaryReportObject valueForKey:@"eQAmount3"];
        txtEAmt4.text=[summaryReportObject valueForKey:@"eQAmount4"];
        txtEAmt5.text=[summaryReportObject valueForKey:@"eQTotalHours5"];
        txtInspector.text=[summaryReportObject valueForKey:@"inspector"];
        //txtEDate.text=[responseObject valueForKey:@"Date1"];
        txtContractorRepresentative.text=[summaryReportObject valueForKey:@"contractorRepresentative"];
        txtConReDate.text=[summaryReportObject valueForKey:@"date2"];
        txtDailyTotal.text=[summaryReportObject valueForKey:@"dailyTotal"];
        txtTotalDate.text=[summaryReportObject valueForKey:@"total_to_date"];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://data.privytext.us/summery/%@",
                                           [NSString stringWithFormat:@"%@.jpg", [summaryReportObject valueForKey:@"signature1"]]]];
        NSLog(@"url----%@",url);
        NSData *imageData1 = [NSData dataWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc] initWithData:imageData1];
        imgSignature.image=image;
        
        NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"http://data.privytext.us/summery/%@",
                                            [NSString stringWithFormat:@"%@.jpg", [summaryReportObject valueForKey:@"signature2"]]]];
        NSLog(@"url----%@",url2);
        NSData *imageData2 = [NSData dataWithContentsOfURL:url2];
        UIImage *image1 = [[UIImage alloc] initWithData:imageData2];
        imgSignature2.image=image1;
    }
    
    [HUD setHidden:YES];
}

-(void)createPDF
{
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    viewImageAttachmentTitle.hidden=YES;
    lblImageAttachmentTitle.hidden=YES;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *directroyPath = nil;
    directroyPath = [documentsDirectory stringByAppendingPathComponent:@"PDF"];
    NSString *fileName=[NSString stringWithFormat:@"%@.pdf",@"Report"];
    NSString *filePath = [directroyPath stringByAppendingPathComponent:fileName];
    
    // check for the "PDF" directory
    NSError *error;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
    } else {
        [[NSFileManager defaultManager] createDirectoryAtPath:directroyPath
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:&error];
    }
    
    CGContextRef pdfContext = [self createPDFContext:self.scrollView.bounds path:(CFStringRef)filePath];
    NSLog(@"PDF Context created");
    int count=3;
    for (int i = 0 ; i<count ; i++)
    {
        // page 1
        CGContextBeginPage (pdfContext,nil);
        
        //turn PDF upsidedown
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformMakeTranslation(0, (i+1) *1020);
        transform = CGAffineTransformScale(transform, 1.0, -1.0);
        CGContextConcatCTM(pdfContext, transform);
        
        //Draw view into PDF
        [self.scrollView.layer renderInContext:pdfContext];
        CGContextEndPage (pdfContext);
        [self.scrollView setContentOffset:CGPointMake(0, (i+1) * 1020) animated:NO];
        
    }
    CGContextRelease (pdfContext);
    // [self createImagesPDF];
    
    NSData *pdfData = [NSData dataWithContentsOfFile:filePath];
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"Inspection Report"];
        
        [mailer addAttachmentData:pdfData mimeType:@"application/pdf" fileName:[NSString stringWithFormat:@"%@.pdf",self.navigationItem.title]];
        
        NSString *emailBody = [NSString stringWithFormat:@"Inspection Report of  %@",@"Pro 001"];
        [mailer setMessageBody:emailBody isHTML:NO];
        [self presentViewController:mailer animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, -self.scrollView.contentInset.top) animated:YES];
}


- (CGContextRef) createPDFContext:(CGRect)inMediaBox path:(CFStringRef) path
{
    CGContextRef myOutContext = NULL;
    CFURLRef url;
    url = CFURLCreateWithFileSystemPath (NULL, path,
                                         kCFURLPOSIXPathStyle,
                                         false);
    
    if (url != NULL) {
        myOutContext = CGPDFContextCreateWithURL (url,
                                                  &inMediaBox,
                                                  NULL);
        CFRelease(url);
    }
    return myOutContext;
}


-(void)createPDFfromUIView:(UIScrollView*)aView saveToDocumentsWithFileName:(NSString*)aFilename
{
    // Creates a mutable data object for updating with binary data, like a byte array
    NSMutableData *pdfData = [NSMutableData data];
    
    // Points the pdf converter to the mutable data object and to the UIView to be converted
    UIGraphicsBeginPDFContextToData(pdfData, aView.bounds, nil);
    UIGraphicsBeginPDFPage();
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    
    // draws rect to the view and thus this is captured by UIGraphicsBeginPDFContextToData
    [aView.layer renderInContext:pdfContext];
    
    // remove PDF rendering context
    UIGraphicsEndPDFContext();
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"Inspection Form"];
        
        
        
        
        [mailer addAttachmentData:pdfData mimeType:@"application/pdf" fileName:[NSString stringWithFormat:@"%@.pdf",aFilename]];
        NSString *emailBody = [NSString stringWithFormat:@"Inspection Report of  %@",@"Pro 001"];
        
        [mailer setMessageBody:emailBody isHTML:NO];
        [self presentViewController:mailer animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    NSString *statusMessage;
    switch (result)
    {
        case MFMailComposeResultCancelled:
            statusMessage = @"Mail cancelled: you cancelled the operation and no email message was queued.";
            break;
        case MFMailComposeResultSaved:
            statusMessage = @"Mail saved: you saved the email message in the drafts folder.";
            break;
        case MFMailComposeResultSent:
            statusMessage = @"Mail send: the email message is queued in the outbox. It is ready to send.";
            break;
        case MFMailComposeResultFailed:
            statusMessage = @"Mail failed: the email message was not saved or queued, possibly due to an error.";
            break;
        default:
            statusMessage = @"Mail not sent.";
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    viewImageAttachmentTitle.hidden=NO;
    lblImageAttachmentTitle.hidden=NO;
}


-(IBAction)showSCompliance:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSummaryForm" object:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
