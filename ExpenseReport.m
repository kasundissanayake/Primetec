//
//  ExpenseReport.m
//  ComSMART
//
//  Created by Lingeswaran Kandasamy on 5/2/14.
//
//

#import "ExpenseReport.h"
#import "ImageCell.h"
#import "ImageHeaderCell.h"
#import "ExpenseReportCell.h"
#import "TabAndSplitAppAppDelegate.h"

@interface ExpenseReport (){
    
    
    
    NSMutableArray *arrayImages;
    NSMutableArray *sketchesArray;
    BOOL isSubTableView;
    NSMutableArray *arrayExpenses;
    
    MBProgressHUD *HUD;
    TabAndSplitAppAppDelegate *appDelegate;
    NSMutableArray *tempImageArray;
    
    NSMutableData *_receivedData;
    NSURLResponse *_receivedResponse;
    NSError *_connectionError;
    NSArray *resPonse;
    UIBarButtonItem  *btnPrint;
    double sum1;
    
    NSString *reimpval;
    
    
}

@end

@implementation ExpenseReport
@synthesize  headerView,scrollView;
@synthesize lblImageAttachmentTitle,viewImageAttachmentTitle;
@synthesize tblView;
@synthesize tblSubView;
@synthesize ExNo;
@synthesize txtApprovedBy,txtCashAdvance,txtCheckNumber,txtDate,txtEmpName,txtEmpNo,txtReimbursement,txtWeakEnding,imgSignature;



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
   
    
    NSLog(@"hhhhhhhwwwwwwwlllllllll%@",  [NSString stringWithFormat:@"%@", appDelegate.reImp]);
    scrollView.scrollsToTop=NO;
    self.tblView.scrollsToTop=YES;
    self.tblView.tableHeaderView = headerView;
    appDelegate=(TabAndSplitAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Do any additional setup after loading the view from its nib.
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
    
    
    
    self.navigationItem.rightBarButtonItem = Button;
    
    
    
    arrayImages=[[NSMutableArray alloc]init];
    sketchesArray=[[NSMutableArray alloc]init];
    arrayExpenses=[[NSMutableArray alloc]init];
    tempImageArray=[[NSMutableArray alloc]init];
    
    
    
    
    UIBarButtonItem  *btnEmail = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(createPDF)];
    
    
    btnPrint = [[UIBarButtonItem alloc]
                initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(printReport)];
    
    
    
    self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:Button, btnEmail,btnPrint, nil];
    self.navigationItem.leftBarButtonItem=Button2;


    [self loadExpenseEntries];
    
}
-(void)loadExpenseEntries
{
    NSString *strURL = [NSString stringWithFormat:@"http://data.privytext.us/contructionapi.php/api/expense/expensedata/%@",ExNo];
    
    NSURL *apiURL =
    [NSURL URLWithString:strURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:apiURL];
    
    isSubTableView=YES;
    
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
-(void)loadExpenseDetails
{
    NSString *strURL = [NSString stringWithFormat:@"http://data.privytext.us/contructionapi.php/api/expense/single/%@",ExNo];
    
    NSURL *apiURL =
    [NSURL URLWithString:strURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:apiURL];
    
    isSubTableView=NO;
    
    
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
    isSubTableView=NO;
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection

{
    
    [HUD setHidden:YES];
    
    NSError *parseError = nil;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:_receivedData options:kNilOptions error:&parseError];
    NSLog(@"count--- %@",responseObject);
    if(isSubTableView)
    {
        isSubTableView=NO;
        appDelegate.reImp=[[responseObject  valueForKey:@"sum"]valueForKey:@"total"];
    
        txtReimbursement.text =  [NSString stringWithFormat:@"%@", appDelegate.reImp];
        
        appDelegate.reImp=txtReimbursement.text;
        
        NSLog(@"appdelegate value%@", appDelegate.reImp);
        
        arrayExpenses=[[responseObject valueForKey:@"expensedata"]mutableCopy];
        for(int i=0; i<arrayExpenses.count; i++)
        {
        tempImageArray  = [[[[arrayExpenses objectAtIndex:i] valueForKey:@"images_uploaded"] componentsSeparatedByString:@","]mutableCopy];
            for(int i=1; i<tempImageArray.count; i++)
            {
                [arrayImages addObject:[tempImageArray objectAtIndex:i]];
            }
            
        }
        NSLog(@"Array Images--- %@",arrayImages);
        
        for (int i=0; i<arrayImages.count; i++) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://data.privytext.us/expense/%@",[NSString stringWithFormat:@"%@.jpg", [arrayImages objectAtIndex:i]]]];
            NSLog(@"url----%@",url);
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            [self saveImageTaken:image imgName:[NSString stringWithFormat:@"%@.jpg", [arrayImages objectAtIndex:i]]];
            
            
        }
        
        [self.tblSubView reloadData];
        [self loadExpenseDetails];
        
    }
    else
    {
        txtApprovedBy.text=[[responseObject valueForKey:@"expenseReport"] valueForKey:@"ApprovedBy"];
        txtCashAdvance.text=[[responseObject valueForKey:@"expenseReport"] valueForKey:@"ERCashAdvance"];
        txtCheckNumber.text=[[responseObject valueForKey:@"expenseReport"] valueForKey:@"CheckNo"];
        txtDate.text=[[responseObject valueForKey:@"expenseReport"] valueForKey:@"Date"];
        txtEmpName.text=[[responseObject valueForKey:@"expenseReport"] valueForKey:@"EMPName"];
        txtEmpNo.text=[[responseObject valueForKey:@"expenseReport"] valueForKey:@"EmployeeNo"];
       // txtReimbursement.text=[[responseObject valueForKey:@"expenseReport"] valueForKey:@"ERReimbursement"];
        txtWeakEnding.text=[[responseObject valueForKey:@"expenseReport"] valueForKey:@"WeekEnding"];
        // imgSignature.image=[responseObject valueForKey:@""];
        
       ;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://data.privytext.us/expense/%@",[NSString stringWithFormat:@"%@.jpg", [[responseObject valueForKey:@"expenseReport"]valueForKey:@"Signature"]]]];
        NSLog(@"url----%@",url);
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        imgSignature.image=image;
        [self.tblView reloadData];
        
        
    }
    
    
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
    
    //[self.tblView setContentOffset:CGPointZero animated:YES];
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
        transform = CGAffineTransformMakeTranslation(0, (i+1) *730);
        transform = CGAffineTransformScale(transform, 1.0, -1.0);
        CGContextConcatCTM(pdfContext, transform);
        
        //Draw view into PDF
        [self.tblView.layer renderInContext:pdfContext];
        CGContextEndPage (pdfContext);
        [self.tblView setContentOffset:CGPointMake(0, (i+1) * 730) animated:NO];
        
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
    int count=2+arrayImages.count+sketchesArray.count;
    for (int i = 0 ; i<count ; i++)
    {
        
        // page 1
        CGContextBeginPage (pdfContext,nil);
        
        //turn PDF upsidedown
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformMakeTranslation(0, (i+1) *730);
        transform = CGAffineTransformScale(transform, 1.0, -1.0);
        CGContextConcatCTM(pdfContext, transform);
        
        //Draw view into PDF
        [self.tblView.layer renderInContext:pdfContext];
        CGContextEndPage (pdfContext);
        [self.tblView setContentOffset:CGPointMake(0, (i+1) * 730) animated:NO];
        
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
//    UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Email Sent Successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//    
//    [exportAlert show];
    // Remove the mail view
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)showSCompliance:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeDExpeseForm" object:nil];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"aaaaaaaaaaaaaaaaaa");
    if (tableView==tblSubView) {
        return 1;
    }
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"bbbbbbbbbbbbbbbbbbbbbbbbbbbbb");
    if(tableView==tblSubView)
    {
        return [arrayExpenses count];
    }
    else
    {
        if(section==0)
        {
            return [arrayImages count]+1;
        }
        else
        {
            return [sketchesArray count];
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==tblSubView)
    {
        static NSString *simpleTableIdentifier = @"ExpenseReportCell";
        
        ExpenseReportCell *cell = (ExpenseReportCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ExpenseReportCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.lblDate.text=[[arrayExpenses objectAtIndex:indexPath.row]valueForKey:@"ERDate1"];
        cell.lblDescription.text=[[arrayExpenses objectAtIndex:indexPath.row]valueForKey:@"ERDescription1"];
        cell.lblJobNo.text=[[arrayExpenses objectAtIndex:indexPath.row]valueForKey:@"ERJobNo1"];
        cell.lblMilage.text=[[arrayExpenses objectAtIndex:indexPath.row]valueForKey:@"ERPAMilage1"];
        cell.lblRate.text=[[arrayExpenses objectAtIndex:indexPath.row]valueForKey:@"ERPARate1"];
        cell.lblTotal.text=[[arrayExpenses objectAtIndex:indexPath.row]valueForKey:@"ERTotal1"];
        
        
        return cell;
    }
    
    else
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
            
                cell.imgView.image=[self getImageFromFileName:[NSString stringWithFormat:@"%@.jpg",[arrayImages objectAtIndex:indexPath.row-1]]];
                
                     }
            else
            {
                
                cell.lblTitle.hidden=YES;
                cell.imgView.image=[self getImageFromFileName:[NSString stringWithFormat:@"%@.jpg",[[sketchesArray objectAtIndex:indexPath.row]valueForKey:@"name"]]];
                
                
            }
            
            
            
            return cell;
        }
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
    if (tableView!=tblSubView) {
        
        if((indexPath.section==0 && indexPath.row==0)|| (indexPath.section==1 && indexPath.row==0))
        {
            return 160;
        }
        else
        {
            return 650                                                                                                                                                                         ;
        }
    }
    else
    {
        return 62;
    }
    
}

- (BOOL)presentFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated completionHandler:(UIPrintInteractionCompletionHandler)completion {
    return YES;
}

- (BOOL)presentFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated completionHandler:(UIPrintInteractionCompletionHandler)completion {
    return YES;
}


@end
