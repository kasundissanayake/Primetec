//
//  ExpenseReport.m

#import "ExpenseReport.h"
#import "ImageCell.h"
#import "ImageHeaderCell.h"
#import "ExpenseReportCell.h"
#import "TabAndSplitAppAppDelegate.h"
#import "PRIMECMAPPUtils.h"
#import "PRIMECMController.h"
#import "ExpenseReportModel.h"

@interface ExpenseReport (){
    NSMutableArray *arrayImages;
    NSMutableArray *sketchesArray;
    BOOL isSubTableView;
    NSMutableArray *arrayExpenses;
    MBProgressHUD *hud;
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
@synthesize  headerView;
@synthesize tblView;
@synthesize tblSubView;
@synthesize ExNo;
@synthesize txtApprovedBy;
@synthesize txtCashAdvance;
@synthesize txtCheckNumber;
@synthesize txtDate;
@synthesize txtEmpName;
@synthesize txtReimbursement;
@synthesize txtWeakEnding;
@synthesize imgSignature;
@synthesize txtMil1;
@synthesize txtRate1;
@synthesize txtTotal1;
@synthesize header;
@synthesize ERdate6;
@synthesize ERDescription;
@synthesize ERJobNo;
@synthesize ERType;
@synthesize sigImgName;


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
    
    UIBarButtonItem *Button3 = [[UIBarButtonItem alloc]
                                initWithTitle:NSLocalizedString(@"Delete", @"")
                                style:UIBarButtonItemStyleDone
                                target:self
                                action:@selector(fnDelete:)];
    
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
    self.navigationItem.leftBarButtonItems=[NSArray arrayWithObjects:Button2, Button3, nil];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.navigationController.view addSubview:hud];
    hud.labelText=@"";
    hud.dimBackground = YES;
    hud.delegate = self;
    [hud show:YES];
    
    [self populateExpenseEntries];
    [hud setHidden:YES];
}



-(void) populateExpenseEntries
{
    NSManagedObjectContext *context = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ExpenseReportModel" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY eXReportNo == %@", ExNo];
    [fetchRequest setPredicate:predicate];
    
    
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    
    if([objects count] > 0){
        NSManagedObject *expensedataObject = (NSManagedObject *) [objects objectAtIndex:0];
        NSLog(@"Compliance Form object CNo: %@", [expensedataObject valueForKey:@"eXReportNo"]);
        
        //NSLog(@"TEST EMPNAME%@",expensedataObject);
        
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:@"yyyy-MM-dd"];
        
        txtApprovedBy.text=[expensedataObject valueForKey:@"approvedBy"];
        txtCashAdvance.text=[[expensedataObject valueForKey:@"eRCashAdvance"]stringValue];
        txtCheckNumber.text=[expensedataObject valueForKey:@"checkNo"];
        txtDate.text=[dateFormater stringFromDate:[expensedataObject valueForKey:@"date"]];
        txtEmpName.text=[expensedataObject valueForKey:@"eMPName"];
        txtReimbursement.text=[[expensedataObject valueForKey:@"eRReimbursement"]stringValue];
        txtWeakEnding.text=[dateFormater stringFromDate:[expensedataObject valueForKey:@"weekEnding"]];
        txtMil1.text=[expensedataObject valueForKey:@"eRPAMilage1"];
        txtRate1.text=[[expensedataObject valueForKey:@"eRPARate1"]stringValue];
        txtTotal1.text=[[expensedataObject valueForKey:@"eRTotal1"] stringValue];
        header.text=[expensedataObject valueForKey:@"eRFHeader"];
        ERdate6.text=[dateFormater stringFromDate:[expensedataObject valueForKey:@"eRDate1"]];
        
        ERDescription.text=[expensedataObject valueForKey:@"eRDescription1"];
        ERJobNo.text=[expensedataObject valueForKey:@"eRJobNo1"];
        ERType.text=[expensedataObject valueForKey:@"eRType1"];
        arrayImages  = [[[expensedataObject valueForKey:@"images_uploaded"] componentsSeparatedByString:@","]mutableCopy];
        sigImgName = [expensedataObject valueForKey:@"signature"];
        imgSignature.image=[PRIMECMController getTheImage:sigImgName];
        NSLog(@"array Images---%@",arrayImages);
        NSLog(@"array Sketches---%@",sketchesArray);
    }else{
        NSLog(@"No matching ComplianceForm with ID: %@", ExNo);
    }
    
    [self.tblView reloadData];
    
}

-(IBAction)fnEdit:(id)sender
{
    NSMutableDictionary *expenseReportDTO = [[NSMutableDictionary alloc] init];
    
    [expenseReportDTO setValue:txtApprovedBy.text forKey:@"approvedBy"];
    [expenseReportDTO setValue:txtCashAdvance.text forKey:@"eRCashAdvance"];
    [expenseReportDTO setValue:txtCheckNumber.text forKey:@"checkNo"];
    [expenseReportDTO setValue:txtDate.text forKey:@"date"];
    [expenseReportDTO setValue:txtEmpName.text forKey:@"eMPName"];
    [expenseReportDTO setValue:txtReimbursement.text forKey:@"eRReimbursement"];
    [expenseReportDTO setValue:txtWeakEnding.text forKey:@"weekEnding"];
    [expenseReportDTO setValue:txtMil1.text forKey:@"eRPAMilage1"];
    [expenseReportDTO setValue:txtRate1.text forKey:@"eRPARate1"];
    [expenseReportDTO setValue:txtTotal1.text forKey:@"eRTotal1"];
    [expenseReportDTO setValue:header.text forKey:@"eRFHeader"];
    [expenseReportDTO setValue:ERdate6.text forKey:@"eRDate1"];
    [expenseReportDTO setValue:ERDescription.text forKey:@"eRDescription1"];
    [expenseReportDTO setValue:ERJobNo.text forKey:@"eRJobNo1"];
    [expenseReportDTO setValue:ERType.text forKey:@"eRType1"];
    [expenseReportDTO setValue:ExNo forKey:@"eXReportNo"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeExpenceForm" object:nil userInfo:expenseReportDTO];
}


-(IBAction)fnDelete:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeDashboard" object:nil];
    
    ExpenseReportModel *assp;
    NSError *retrieveError;
    
    NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ExpenseReportModel"
                                              inManagedObjectContext:managedContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(eXReportNo = %@)", ExNo];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedObjects = [managedContext executeFetchRequest:fetchRequest error:&retrieveError];
    
    if (fetchedObjects && [fetchedObjects count] > 0) {
        assp = [fetchedObjects objectAtIndex:0];
        [managedContext deleteObject:assp];
        if (![managedContext save:&retrieveError]) {
            NSLog(@"Whoops, couldn't delete: %@", [retrieveError localizedDescription]);
        } else {
            NSLog(@"Deleted: %@", ExNo);
        }
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
        if( !([[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error]))
            NSLog(@"[%@] ERROR: attempting to write create Images directory", [self class]);
    }
    
    NSData *imagData = UIImageJPEGRepresentation(imageNew,1.0);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fullPath = [folderPath stringByAppendingPathComponent:imgName];
    [fileManager createFileAtPath:fullPath contents:imagData attributes:nil];
}


-(void)printReport
{
    
    [self.tblView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    
    
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
    
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"changeDExpeseForm" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeExpenceForm" object:nil userInfo:NULL];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView==tblSubView) {
        return 1;
    }
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    
    if((indexPath.section==0 && indexPath.row==0) || (indexPath.section==1 && indexPath.row==0))
    {
        static NSString *simpleTableIdentifier = @"ImageHeaderCell";
        ImageHeaderCell *cell = (ImageHeaderCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ImageHeaderCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        if(indexPath.section==0)
        {
            cell.lblAttachement.text=@"Image attachments";
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
        
        if(indexPath.section==0)
        {
            // cell.lblTitle.hidden=NO;
            cell.imgView.image=[self getImageFromFileName:[NSString stringWithFormat:@"%@.jpg",[arrayImages objectAtIndex:indexPath.row-1]]];
        }
        else
        {
            //cell.lblTitle.hidden=YES;
            cell.imgView.image=[self getImageFromFileName:[NSString stringWithFormat:@"%@.jpg",[[sketchesArray objectAtIndex:indexPath.row]valueForKey:@"name"]]];
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView!=tblSubView) {
        if((indexPath.section==0 && indexPath.row==0)|| (indexPath.section==1 && indexPath.row==0))
        {
            return 160;
        }
        else
        {
            return 350;
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