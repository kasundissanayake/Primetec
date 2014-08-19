//
//  NonComplianceReport.m
//  ComSMART
//
//  Created by Lingeswaran Kandasamy on 5/2/14.
//
//

#import "NonComplianceReport.h"
#import "ImageCell.h"
#import "ImageHeaderCell.h"
#import "TabAndSplitAppAppDelegate.h"
#import "PRIMECMAPPUtils.h"

@interface NonComplianceReport ()
{
    NSMutableArray *arrayImages;
    NSMutableArray *sketchesArray;
    
    NSMutableData *_receivedData;
    NSURLResponse *_receivedResponse;
    NSError *_connectionError;
    NSArray *resPonse;
    MBProgressHUD *HUD;
    TabAndSplitAppAppDelegate *appDelegate;
        UIBarButtonItem  *btnPrint;
}

@end

@implementation NonComplianceReport

@synthesize  scrollView,headerView;
@synthesize lblImageAttachmentTitle,viewImageAttachmentTitle;
@synthesize txtContactNo,txtDate,txtPrintedName,txtTo,txtDateIssued,txtProject,txtTitle,txtDateContractCompleted,txtDateContractorStarted,txtDateOfRawReport;
@synthesize lblProjDec,lblContractorRes,lblCorrectiveActionComp, nonComNotNo, dateCRC;
@synthesize CNo;
@synthesize imgSignature;

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
    
    [lblProjDec.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [lblProjDec.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [lblProjDec.layer setBorderWidth: 1.0];
    [lblProjDec.layer setCornerRadius:8.0f];
    
    [lblCorrectiveActionComp.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [lblCorrectiveActionComp.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [lblCorrectiveActionComp.layer setBorderWidth: 1.0];
    [lblCorrectiveActionComp.layer setCornerRadius:8.0f];
    
    
    [lblContractorRes.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [lblContractorRes.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [lblContractorRes.layer setBorderWidth: 1.0];
    [lblContractorRes.layer setCornerRadius:8.0f];
    
    
    
    scrollView.scrollsToTop=NO;
    self.tblView.scrollsToTop=YES;
    self.tblView.tableHeaderView = headerView;
    appDelegate=(TabAndSplitAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    UIBarButtonItem  *btnEmail = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(createPDF)];
    
    
    UIBarButtonItem *Button = [[UIBarButtonItem alloc]
                               initWithTitle:NSLocalizedString(@"New", @"")
                               style:UIBarButtonItemStyleDone
                               target:self
                               action:@selector(showSCompliance:)];
    
    UIBarButtonItem *Button2 = [[UIBarButtonItem alloc]
                               initWithTitle:NSLocalizedString(@"Edit", @"")
                               style:UIBarButtonItemStyleDone
                               target:self
                               action:@selector(fnEdit:)];
    
    
    btnPrint = [[UIBarButtonItem alloc]
                initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(printReport)];
    

    self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:Button, btnEmail,btnPrint, nil];
    
    
    self.navigationItem.leftBarButtonItem=Button2;
    
    arrayImages=[[NSMutableArray alloc]init];
    sketchesArray=[[NSMutableArray alloc]init];
    [self loadNonComplianceForm];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)showSCompliance:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeNonComplianceForm" object:nil];
    
    
}
-(void)loadNonComplianceForm
{
    NSString *strURL = [NSString stringWithFormat:@"%@/api/noncompliance/single/%@/%@", [PRIMECMAPPUtils getAPIEndpoint], appDelegate.username,CNo];
    
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
    //NSLog(@"count--- %@",responseObject);
    txtTitle.text=[[responseObject valueForKey:@"nonComplianceForm"]valueForKey:@"Non_ComHeader"];
    nonComNotNo.text=[[responseObject valueForKey:@"nonComplianceForm"]valueForKey:@"Non_ComplianceNoticeNo"];
    lblProjDec.text=[[responseObject valueForKey:@"nonComplianceForm"]valueForKey:@"ProjectDescription"];
    txtContactNo.text=[[responseObject valueForKey:@"nonComplianceForm"]valueForKey:@"ContractNo"];
    
    txtTitle.text=[[responseObject valueForKey:@"nonComplianceForm"]valueForKey:@"Title"];
    
    txtProject.text=[[responseObject valueForKey:@"nonComplianceForm"]valueForKey:@"Project"];
    
    txtDateIssued.text=[[responseObject valueForKey:@"nonComplianceForm"]valueForKey:@"DateIssued"];
    lblContractorRes.text=[[responseObject valueForKey:@"nonComplianceForm"]valueForKey:@"ContractorResponsible"];
    
    txtTo.text=[[responseObject valueForKey:@"nonComplianceForm"]valueForKey:@"To"];
    txtDateContractorStarted.text=[[responseObject valueForKey:@"nonComplianceForm"]valueForKey:@"DateContractorStarted"];
    dateCRC.text=[[responseObject valueForKey:@"nonComplianceForm"]valueForKey:@"DateCRTCB"];
    
    txtDateContractCompleted.text=[[responseObject valueForKey:@"nonComplianceForm"]valueForKey:@"DateContractorCompleted"];
    txtDateOfRawReport.text=[[responseObject valueForKey:@"nonComplianceForm"]valueForKey:@"DateOfDWRReported"];
    lblCorrectiveActionComp.text=[[responseObject valueForKey:@"nonComplianceForm"]valueForKey:@"DescriptionOfNonCompliance"];
    txtPrintedName.text=[[responseObject valueForKey:@"nonComplianceForm"]valueForKey:@"PrintedName"];
    txtDate.text=[[responseObject valueForKey:@"nonComplianceForm"]valueForKey:@"Date"];
    
    arrayImages  = [[[[responseObject valueForKey:@"nonComplianceForm"]valueForKey:@"images_uploaded"] componentsSeparatedByString:@","]mutableCopy];
    sketchesArray  = [[[[responseObject valueForKey:@"nonComplianceForm"]valueForKey:@"sketch_images"] componentsSeparatedByString:@","]mutableCopy];
    NSLog(@"array Images---%@",arrayImages);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://data.privytext.us/noncompliance/%@",[NSString stringWithFormat:@"%@.jpg", [[responseObject valueForKey:@"nonComplianceForm"]valueForKey:@"Signature"]]]];
    NSLog(@"url----%@",url);
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    imgSignature.image=image;
    
    
    for (int i=1; i<sketchesArray.count; i++) {
        
        
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://data.privytext.us/noncompliance/%@",[NSString stringWithFormat:@"%@.jpg", [sketchesArray objectAtIndex:i]]]];
        NSLog(@"url----%@",url);
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        [self saveImageTaken:image imgName:[NSString stringWithFormat:@"%@.jpg", [sketchesArray objectAtIndex:i]]];
        
        
    }
    
    
    for (int i=1; i<arrayImages.count; i++) {
        
        
        
        //  http://data.privytext.us/noncompliance/
        
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://data.privytext.us/noncompliance/%@",[NSString stringWithFormat:@"%@.jpg", [arrayImages objectAtIndex:i]]]];
        NSLog(@"url----%@",url);
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        [self saveImageTaken:image imgName:[NSString stringWithFormat:@"%@.jpg", [arrayImages objectAtIndex:i]]];
        
    }
       [self.tblView reloadData];
    
}

-(void)saveImageTaken:(UIImage *)imageNew imgName:(NSString *)imgName
{
    //store image in ducument directory.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:@"/Images"];
    NSLog(@"folderPath--- %@",folderPath);
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath]){
        
        NSError *error;
        if(  [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error])
            ;// success
        
        
        else
        {
            NSLog(@"[%@] ERROR: attempting to write create Images directory", [self class]);
        }
    }
    
    NSData *imagData = UIImageJPEGRepresentation(imageNew,0.75f);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fullPath = [folderPath stringByAppendingPathComponent:imgName];
    [fileManager createFileAtPath:fullPath contents:imagData attributes:nil];
}
-(void)printReport
{
    
    [self.tblView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
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
    
    CGContextRef pdfContext = [self createPDFContext:self.tblView.bounds path:(CFStringRef)filePath];
    NSLog(@"PDF Context created");
    int count=4+arrayImages.count+sketchesArray.count;
    for (int i = 0 ; i<count ; i++)
    {
        
        // page 1
        CGContextBeginPage (pdfContext,nil);
        
        //turn PDF upsidedown
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformMakeTranslation(0, (i+1) *830);
        transform = CGAffineTransformScale(transform, 1.0, -1.0);
        CGContextConcatCTM(pdfContext, transform);
        
        //Draw view into PDF
        [self.tblView.layer renderInContext:pdfContext];
        CGContextEndPage (pdfContext);
        [self.tblView setContentOffset:CGPointMake(0, (i+1) * 830) animated:NO];
        
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
    
    
    
    [self.tblView setContentOffset:CGPointMake(self.tblView.contentOffset.x, -self.tblView.contentInset.top) animated:YES];
    
    
    
    
}




-(void)createPDF
{
    [self.tblView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
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
    
    CGContextRef pdfContext = [self createPDFContext:self.tblView.bounds path:(CFStringRef)filePath];
    NSLog(@"PDF Context created");
    int count=3+arrayImages.count+sketchesArray.count;
    for (int i = 0 ; i<count ; i++)
    {
        
        // page 1
        CGContextBeginPage (pdfContext,nil);
        
        //turn PDF upsidedown
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformMakeTranslation(0, (i+1) *630);
        transform = CGAffineTransformScale(transform, 1.0, -1.0);
        CGContextConcatCTM(pdfContext, transform);
        
        //Draw view into PDF
        [self.tblView.layer renderInContext:pdfContext];
        CGContextEndPage (pdfContext);
        [self.tblView setContentOffset:CGPointMake(0, (i+1) * 630) animated:NO];
        
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
    
    
    [self.tblView setContentOffset:CGPointMake(self.tblView.contentOffset.x, -self.tblView.contentInset.top) animated:YES];
    
    
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"aaaaaaaaaaaaaaaaaa");
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"bbbbbbbbbbbbbbbbbbbbbbbbbbbbb");
    if(section==0)
    {
        return [arrayImages count];
    }
    else
    {
        return [sketchesArray count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if((indexPath.section==0 && indexPath.row==0) || (indexPath.section==1 && indexPath.row==0))
    {
        static NSString *simpleTableIdentifier = @"ImageHeaderCell";
        
        ImageHeaderCell *cell = (ImageHeaderCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ImageHeaderCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        NSLog(@"ddddddddddddddddddddd");
        if(indexPath.section==0)
        {
            cell.lblAttachement.text=@"Image attachments";
        }
        else
        {
            cell.lblAttachement.text=@"Sketch attachments";
        }
        
        return cell;
        
    }
    
    else
    {
        
        
        static NSString *simpleTableIdentifier = @"ImageCell";
        
        ImageCell *cell = (ImageCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ImageCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        NSLog(@"ddddddddddddddddddddd");
        
        
        if(indexPath.section==0)
        {
            cell.lblTitle.hidden=NO;
            
            
            cell.imgView.image=[self getImageFromFileName:[NSString stringWithFormat:@"%@.jpg",[arrayImages objectAtIndex:indexPath.row]]];
            
            
            
        }
        else
        {
            
            cell.lblTitle.hidden=YES;
            cell.imgView.image=[self getImageFromFileName:[NSString stringWithFormat:@"%@.jpg",[sketchesArray objectAtIndex:indexPath.row]]];
            
        }
        
        
        
        return cell;
    }
}
-(UIImage *)getImageFromFileName:(NSString *)fileName
{
    //get images from document directory
    NSLog(@"image name......%@",fileName);
    UIImage *current_img;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *folderPath;
    
    
    folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Images"];
    NSString *fullPath = [folderPath stringByAppendingPathComponent:fileName];
    current_img=[UIImage imageWithContentsOfFile:fullPath];
    NSLog(@"current_img %@",current_img);
    return current_img;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if((indexPath.section==0 && indexPath.row==0)|| (indexPath.section==1 && indexPath.row==0))
    {
        return 63;
    }
    else
    {
        return 650                                                                                                                                                                           ;
    }
}

- (BOOL)presentFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated completionHandler:(UIPrintInteractionCompletionHandler)completion {
    return YES;
}

- (BOOL)presentFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated completionHandler:(UIPrintInteractionCompletionHandler)completion {
    return YES;
}



@end
