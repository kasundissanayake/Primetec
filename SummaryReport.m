//
//  SummaryReport.m
//  ComSMART
//
//  Created by Lingeswaran Kandasamy on 5/2/14.
//
//

#import "SummaryReport.h"

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
    [self loadSummerySheet];

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


-(void)loadSummerySheet
{
    NSString *strURL = [NSString stringWithFormat:@"http://data.privytext.us/contructionapi.php/api/summary1/single/%@",SMNo];
    
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
   
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection

{
    
    [HUD setHidden:YES];
    
    NSError *parseError = nil;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:_receivedData options:kNilOptions error:&parseError];
    NSLog(@"count--- %@",responseObject);
    txtContractor.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"Contractor"];
    txtPOBox.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"POBox"];
    txtCity.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"City"];
    txtState.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"State"];
    txtTpNumber.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"TelephoneNo"];
    //txtCheckedBy.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"POBox"];
    txtDate.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"Date"];
    txtDateOfWork.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"Date"];
   // txtReportNum.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"POBox"];
    txtContactorPerform.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"ConPeWork"];
    txtFederalAid.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"FederalAidNumber"];
    txtProjectNo.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"ProjectNo"];
    txvDesWork.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"Description"];
    txvConsOrder.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"ConstructionOrder"];
    txtClass1.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"LAClass1"];
    txtClass2.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"LAClass2"];
    txtClass3.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"LAClass3"];
    txtClass4.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"LAClass4"];
    txtClass5.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"LAClass5"];
    txtNo1.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"LANo1"];
    txtNo2.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"LANo2"];
    txtNo3.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"LANo3"];
    txtNo4.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"LANo4"];
    txtNo5.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"LANo5"];
    txtTotal1.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"LATotalHours1"];
    txtTotal2.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"LATotalHours2"];
    txtTotal3.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"LATotalHours3"];
    txtTotal4.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"LATotalHours4"];
    txtTotal5.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"LATotalHours5"];
    txtRate1.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"LARate1"];
    txtRate2.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"LARate2"];
    txtRate3.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"LARate3"];
    txtRate4.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"LARate4"];
    txtRate5.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"LARate5"];
    txtAmt1.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"LAAmount1"];
    txtAmt2.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"LAAmount2"];
    txtAmt3.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"LAAmount3"];
    txtAmt4.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"LAAmount4"];
    txtAmt5.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"LAAmount5"];
    txtTotalLabor.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"TotalLabor"];
    txtHealth.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"HealWelAndPension"];
    txtInsTax.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"InsAndTaxesOnItem1"];
    txt20Items.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"itemDescount20per"];
    txtTotalItems.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"total"];
    txtDes1.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"MEDescription1"];
    txtDes2.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"MEDescription2"];
    txtDes3.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"MEDescription3"];
    txtDes4.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"MEDescription4"];
    txtDES5.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"MEDescription5"];
    txtQuantity1.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"MEQuantity1"];
    txtQuantity2.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"MEQuantity2"];
    txtQuantity3.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"MEQuantity3"];
    txtQuantity4.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"MEQuantity4"];
    txtQuantity5.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"MEQuantity5"];
    txtUnitPrice1.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"MEUnitPrice1"];
    txtUnitPrice2.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"MEUnitPrice2"];
    txtUnitPrice3.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"MEUnitPrice3"];
    txtUnitPrice4.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"MEUnitPrice4"];
    txtUnitPrice5.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"MEUnitPrice5"];
    txtMAmt1.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"MEAmount1"];
    txtMAmt2.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"MEAmount2"];
    txtMAmt3.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"MEAmount3"];
    txtMAmt4.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"MEAmount4"];
    txtMAmt5.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"MEAmount5"];
    txtTotalMeterial.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"Total1"];
    txtLessDiscount.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"LessDiscount"];
    txtLessDisTotal.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"Total2"];
    txtAdditional.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"AdditionalDiscount"];
    txtAddTotal.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"Total3"];
    txtSize1.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"EQSizeandClass1"];
    txtSize2.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"EQSizeandClass2"];
    txtSize3.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"EQSizeandClass3"];
    txtSize4.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"EQSizeandClass4"];
    txtSize5.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"EQSizeandClass5"];
    txtActive1.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"EQAmount1"];
    txtActive2.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"EQAmount2"];
    txtActive3.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"EQAmount3"];
    txtActive4.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"EQAmount4"];
    txtActive5.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"EQAmount5"];
    txtENo1.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"EQNo1"];
    txtENo2.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"EQNo2"];
    txtENo3.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"EQNo3"];
    txtENo4.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"EQNo4"];
    txtENo5.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"EQNo5"];
    txtETotal1.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"EQTotalHours1"];
    txtETotal2.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"EQTotalHours2"];
    txtEtotal3.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"EQTotalHours3"];
    txtETotal4.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"EQTotalHours4"];
    txtETotal5.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"EQTotalHours5"];
    txtERate1.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"EQRAte1"];
    txtERate2.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"EQRAte2"];
    txtERate3.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"EQRAte3"];
    txtERate4.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"EQRAte4"];
    txtERate5.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"EQRAte5"];
    txtEAmt1.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"EQAmount1"];
    txtEAmt2.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"EQAmount2"];
    txtEAmt3.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"EQAmount3"];
    txtEAmt4.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"EQAmount4"];
    txtEAmt5.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"EQTotalHours5"];
    txtInspector.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"Inspector"];
    //txtEDate.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"Date1"];
    txtContractorRepresentative.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"ContractorRepresentative"];
    txtConReDate.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"Date2"];
    txtDailyTotal.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"DailyTotal"];
    txtTotalDate.text=[[responseObject valueForKey:@"expenseReport"]valueForKey:@"total_to_date"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://data.privytext.us/summery/%@",[NSString stringWithFormat:@"%@.jpg", [[responseObject valueForKey:@"expenseReport"]valueForKey:@"Signature1"]]]];
    NSLog(@"url----%@",url);
    NSData *imageData1 = [NSData dataWithContentsOfURL:url];
    UIImage *image = [[UIImage alloc] initWithData:imageData1];
    imgSignature.image=image;

    NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"http://data.privytext.us/summery/%@",[NSString stringWithFormat:@"%@.jpg", [[responseObject valueForKey:@"expenseReport"]valueForKey:@"Signature2"]]]];
    NSLog(@"url----%@",url2);
    NSData *imageData2 = [NSData dataWithContentsOfURL:url2];
    UIImage *image1 = [[UIImage alloc] initWithData:imageData2];
    imgSignature2.image=image1;

    
    

    
    
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
