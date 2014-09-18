//
//  ExpenseReport.m



/*

#import "ExpenseReport.h"
#import "ImageCell.h"
#import "ImageHeaderCell.h"
#import "ExpenseReportCell.h"
#import "TabAndSplitAppAppDelegate.h"
#import "PRIMECMAPPUtils.h"
#import "PRIMECMController.h"

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
    self.tblView.scrollsToTop=YES;
    self.tblView.tableHeaderView = headerView;
    appDelegate=(TabAndSplitAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *Button = [[UIBarButtonItem alloc]
                               initWithTitle:NSLocalizedString(@"New", @"")
                               style:UIBarButtonItemStyleDone
                               target:self
                               action:@selector(showSCompliance:)];
    
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
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.navigationController.view addSubview:hud];
    hud.labelText=@"";
    hud.dimBackground = YES;
    hud.delegate = self;
    [hud show:YES];
    
    [self populateExpenseEntries];
    [self populateExpenseDetails];
    
    [hud setHidden:YES];
}


-(void) populateExpenseEntries
{
    NSManagedObjectContext *context = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Expensedata" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY eXReportNo == %@", ExNo];
    //[fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    NSLog(@"obbbbbjjjjjjjjjjctttsssss%@",objects);
    
    if([objects count] > 0){
        
        NSManagedObject *expensedataObject = (NSManagedObject *) [objects objectAtIndex:0];
        NSLog(@"Expensedata object eXReportNo: %@", [expensedataObject valueForKey:@"eXReportNo"]);
        
        arrayExpenses=[NSMutableArray arrayWithArray:objects];
        NSInteger sum;
        
        for(int i=0; i<arrayExpenses.count; i++)
        {
            sum += (NSInteger) [[arrayExpenses objectAtIndex:i] valueForKey:@"eRTotal1"];
            tempImageArray  = [[[[arrayExpenses objectAtIndex:i] valueForKey:@"images_uploaded"] componentsSeparatedByString:@","]mutableCopy];
            for(int i=1; i<tempImageArray.count; i++)
            {
                [arrayImages addObject:[tempImageArray objectAtIndex:i]];
            }
        }
        
        NSLog(@"Array Images--- %@",arrayImages);
        isSubTableView=NO;
        appDelegate.reImp=[NSString stringWithFormat: @"%d", (int)sum];
        txtReimbursement.text =  [NSString stringWithFormat:@"%@", appDelegate.reImp];
        appDelegate.reImp=txtReimbursement.text;
        NSLog(@"appdelegate value: %@", appDelegate.reImp);
        
        for (int i=0; i<arrayImages.count; i++) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://data.privytext.us/expense/%@",[NSString stringWithFormat:@"%@.jpg", [arrayImages objectAtIndex:i]]]];
            NSLog(@"url----%@",url);
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            [self saveImageTaken:image imgName:[NSString stringWithFormat:@"%@.jpg", [arrayImages objectAtIndex:i]]];
        }
    }
    [self.tblSubView reloadData];
}


-(void)populateExpenseDetails
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
        
        NSManagedObject *expenseReportModelObject = (NSManagedObject *) [objects objectAtIndex:0];
        NSLog(@"ExpenseReportModel object eXReportNo: %@", [expenseReportModelObject valueForKey:@"eXReportNo"]);
        
        txtApprovedBy.text=[expenseReportModelObject valueForKey:@"approvedBy"];
        txtCashAdvance.text=[NSString stringWithFormat:@"%@", [expenseReportModelObject valueForKey:@"eRCashAdvance"]];
        txtCheckNumber.text=[expenseReportModelObject valueForKey:@"checkNo"];
        
        txtDate.text=[NSDateFormatter localizedStringFromDate:[expenseReportModelObject valueForKey:@"date"]
                                                    dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
        
        
        txtEmpName.text=[expenseReportModelObject valueForKey:@"eMPName"];
        txtEmpNo.text=[expenseReportModelObject valueForKey:@"employeeNo"];
        txtWeakEnding.text=[NSDateFormatter localizedStringFromDate:[expenseReportModelObject valueForKey:@"weekEnding"]
                                                          dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
        
        NSString * signName = [expenseReportModelObject valueForKey:@"Signature"];
        imgSignature.image=[PRIMECMController getTheImage:signName];
        
        
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
        if( !([[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error]))
            NSLog(@"[%@] ERROR: attempting to write create Images directory", [self class]);
    }
    
    NSData *imagData = UIImageJPEGRepresentation(imageNew,0.75f);
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeDExpeseForm" object:nil];
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
    if(tableView==tblSubView)
    {
        static NSString *simpleTableIdentifier = @"ExpenseReportCell";
        ExpenseReportCell *cell = (ExpenseReportCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ExpenseReportCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.lblDate.text=[NSDateFormatter localizedStringFromDate:[[arrayExpenses objectAtIndex:indexPath.row] valueForKey:@"eRDate1"]
                                                         dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
        cell.lblDescription.text=[[arrayExpenses objectAtIndex:indexPath.row]valueForKey:@"eRDescription1"];
        cell.lblJobNo.text=[[arrayExpenses objectAtIndex:indexPath.row]valueForKey:@"eRJobNo1"];
        cell.lblMilage.text=cell.lblRate.text=[NSString stringWithFormat:@"%@", [[arrayExpenses objectAtIndex:indexPath.row] valueForKey:@"eRPAMilage1"]];
        cell.lblRate.text=[NSString stringWithFormat:@"%@", [[arrayExpenses objectAtIndex:indexPath.row] valueForKey:@"eRPARate1"]];
        cell.lblTotal.text=[NSString stringWithFormat:@"%@", [[arrayExpenses objectAtIndex:indexPath.row] valueForKey:@"eRTotal1"]];
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

@end */




/********************************Radha**************************/


//
//  ExpenseReport.m

#import "ExpenseReport.h"
#import "ImageCell.h"
#import "ImageHeaderCell.h"
#import "ExpenseReportCell.h"
#import "TabAndSplitAppAppDelegate.h"
#import "PRIMECMAPPUtils.h"
#import "PRIMECMController.h"

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
    //scrollView.scrollsToTop=NO;
    self.tblView.scrollsToTop=YES;
    self.tblView.tableHeaderView = headerView;
    appDelegate=(TabAndSplitAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *Button = [[UIBarButtonItem alloc]
                               initWithTitle:NSLocalizedString(@"New", @"")
                               style:UIBarButtonItemStyleDone
                               target:self
                               action:@selector(showSCompliance:)];
    
    UIBarButtonItem *Button1 = [[UIBarButtonItem alloc]
                                initWithTitle:NSLocalizedString(@"Edit", @"")
                                style:UIBarButtonItemStyleDone
                                target:self
                                action:@selector(fnEdit:)];
    
    
    self.navigationItem.rightBarButtonItem = Button;
    self.navigationItem.leftBarButtonItem = Button1;
    
    arrayImages=[[NSMutableArray alloc]init];
    sketchesArray=[[NSMutableArray alloc]init];
    arrayExpenses=[[NSMutableArray alloc]init];
    tempImageArray=[[NSMutableArray alloc]init];
    UIBarButtonItem  *btnEmail = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(createPDF)];
    
    btnPrint = [[UIBarButtonItem alloc]
                initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(printReport)];
    self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:Button, btnEmail,btnPrint, nil];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.navigationController.view addSubview:hud];
    hud.labelText=@"";
    hud.dimBackground = YES;
    hud.delegate = self;
    [hud show:YES];
    
    NSLog(@"////////////////////// \n Selected ExNo in ExpenseReports are %@",ExNo);
    [self populateExpenseEntries];
    [self populateExpenseDetails];
    
    [hud setHidden:YES];
}

-(IBAction)fnEdit:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeDExpeseForm" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:ExNo,@"eXReportNo", nil]];
}

-(void) populateExpenseEntries
{
    NSManagedObjectContext *context = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Expensedata" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    ////
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY eXReportNo == %@", ExNo];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    NSLog(@"obbbbbjjjjjjjjjjctttsssss%@",objects);
    
    if([objects count] > 0){
        
        NSManagedObject *expensedataObject = (NSManagedObject *) [objects objectAtIndex:0];
        NSLog(@"Expensedata object eXReportNo: %@", [expensedataObject valueForKey:@"eXReportNo"]);
        
        arrayExpenses=[NSMutableArray arrayWithArray:objects];
        NSInteger sum;
        
        for(int i=0; i<arrayExpenses.count; i++)
        {
            sum += (NSInteger) [[arrayExpenses objectAtIndex:i] valueForKey:@"eRTotal1"];
            tempImageArray  = [[[[arrayExpenses objectAtIndex:i] valueForKey:@"images_uploaded"] componentsSeparatedByString:@","]mutableCopy];
            for(int i=0; i<tempImageArray.count; i++)
            {
                [arrayImages addObject:[tempImageArray objectAtIndex:i]];
            }
        }
        
        NSLog(@"Array Images--- %@",arrayImages);
        isSubTableView=NO;
        appDelegate.reImp=[NSString stringWithFormat: @"%d", (int)sum];
        txtReimbursement.text =  [NSString stringWithFormat:@"%@", appDelegate.reImp];
        appDelegate.reImp=txtReimbursement.text;
        NSLog(@"appdelegate value: %@", appDelegate.reImp);
        
        for (int i=0; i<arrayImages.count; i++) {
            NSURL *url =  [NSURL fileURLWithPath:[arrayImages objectAtIndex:i]];  //[NSURL URLWithString:[NSString stringWithFormat:@"http://data.privytext.us/expense/%@",[NSString stringWithFormat:@"%@.jpg", [arrayImages objectAtIndex:i]]]];
            NSLog(@"url----%@",url);
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            [self saveImageTaken:image imgName:[NSString stringWithFormat:@"%@",  [[arrayImages objectAtIndex:i] lastPathComponent]]];
        }
    }
    NSLog(@"Radha Final Images Array is %@",arrayImages);
    
    [self.tblSubView reloadData];
}
-(void)populateExpenseDetails
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
        
        NSManagedObject *expenseReportModelObject = (NSManagedObject *) [objects objectAtIndex:0];
        NSLog(@"ExpenseReportModel object eXReportNo: %@", [expenseReportModelObject valueForKey:@"eXReportNo"]);
        
        txtApprovedBy.text=[expenseReportModelObject valueForKey:@"approvedBy"];
        txtCashAdvance.text=[NSString stringWithFormat:@"%ld", (long)[[expenseReportModelObject valueForKey:@"eRCashAdvance"] integerValue]];
        txtCheckNumber.text=[expenseReportModelObject valueForKey:@"checkNo"];
        
        txtDate.text=[NSDateFormatter localizedStringFromDate:[expenseReportModelObject valueForKey:@"date"]
                                                    dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
        
        
        txtEmpName.text=[expenseReportModelObject valueForKey:@"eMPName"];
        txtEmpNo.text=[expenseReportModelObject valueForKey:@"employeeNo"];
        txtWeakEnding.text=[NSDateFormatter localizedStringFromDate:[expenseReportModelObject valueForKey:@"weekEnding"]
                                                          dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
        
        //        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://data.privytext.us/expense/%@",
        //                                           [NSString stringWithFormat:@"%@.jpg", [expenseReportModelObject valueForKey:@"signature"]]]];
        //        NSLog(@"url----%@",url);
        //        NSData *imageData = [NSData dataWithContentsOfURL:url];
        //        UIImage *image = [[UIImage alloc] initWithData:imageData];
        // imgSignature.image=image;
        
        NSString * signName = [expenseReportModelObject valueForKey:@"Signature"];
        //        if(signName)
        //            imgSignature.image= [UIImage imageWithData:[NSData dataWithContentsOfFile:signName]];
        
        if(!imgSignature.image)
            imgSignature.image=  [PRIMECMController getTheImage:signName];
        
        
        //Edit Expense Report//
        
        appDelegate.EEApprovedBy=txtApprovedBy.text;
        appDelegate.EECashAdvance=txtCashAdvance.text;
        appDelegate.EEChequeNumber=txtCheckNumber.text;
        appDelegate.EEdate=txtDate.text;
        appDelegate.EEEmpName=txtEmpName.text;
        appDelegate.EEEmpNo=txtEmpNo.text;
        appDelegate.EEweekEnding=txtWeakEnding.text;
        appDelegate.EESign=imgSignature.image;
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
        if( !([[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error]))
            NSLog(@"[%@] ERROR: attempting to write create Images directory", [self class]);
    }
    
    NSData *imagData = UIImageJPEGRepresentation(imageNew,0.75f);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fullPath = [folderPath stringByAppendingPathComponent:imgName];
    if(![[NSFileManager defaultManager] fileExistsAtPath:fullPath])
        [fileManager createFileAtPath:fullPath contents:imagData attributes:nil];
}


-(void)printReport
{
    
    //[self.tblView setContentOffset:CGPointZero animated:YES];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeDExpeseForm" object:nil];
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
    if(tableView==tblSubView)
    {
        static NSString *simpleTableIdentifier = @"ExpenseReportCell";
        ExpenseReportCell *cell = (ExpenseReportCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ExpenseReportCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.lblDate.text=[NSDateFormatter localizedStringFromDate:[[arrayExpenses objectAtIndex:indexPath.row] valueForKey:@"eRDate1"]
                                                         dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
        cell.lblDescription.text=[[arrayExpenses objectAtIndex:indexPath.row]valueForKey:@"eRDescription1"];
        cell.lblJobNo.text=[[arrayExpenses objectAtIndex:indexPath.row]valueForKey:@"eRJobNo1"];
        cell.lblMilage.text=cell.lblRate.text=[NSString stringWithFormat:@"%@", [[arrayExpenses objectAtIndex:indexPath.row] valueForKey:@"eRPAMilage1"]];
        cell.lblRate.text=[NSString stringWithFormat:@"%@", [[arrayExpenses objectAtIndex:indexPath.row] valueForKey:@"eRPARate1"]];
        cell.lblTotal.text=[NSString stringWithFormat:@"%@", [[arrayExpenses objectAtIndex:indexPath.row] valueForKey:@"eRTotal1"]];
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
            
            if(indexPath.section==0)
            {
              //  cell.lblTitle.hidden=NO;
                if(indexPath.row <= [arrayImages count])
                {
                    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfFile:[arrayImages objectAtIndex:indexPath.row - 1]]];
                    if(img)
                        cell.imgView.image = img;
                }
                //[self getImageFromFileName:[NSString stringWithFormat:@"%@.jpg",[arrayImages objectAtIndex:indexPath.row-1]]];
            }
            else
            {
                //cell.lblTitle.hidden=YES;
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



/***************************************************************/






