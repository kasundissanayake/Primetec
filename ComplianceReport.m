//
//  ComplianceReport.m
//  ComSMART
//
//  Created by Lingeswaran Kandasamy on 5/2/14.
//
//

#import "ComplianceReport.h"
#import "RootVC.h"
#import "ImageCell.h"
#import "ImageHeaderCell.h"
#import "TabAndSplitAppAppDelegate.h"
#import "PRIMECMAPPUtils.h"
#import "PRIMECMController.h"
#import "ComplianceViewController.h"
#import "ComplianceForm.h"
#import "Projects.h"

@interface ComplianceReport ()
{
    NSMutableArray *arrayImages;
    NSMutableArray *sketchesArray;
    NSMutableData *_receivedData;
    NSURLResponse *_receivedResponse;
    NSError *_connectionError;
    NSArray *resPonse;
    MBProgressHUD *hud;
    TabAndSplitAppAppDelegate *appDelegate;
    // ComplianceViewController *CompliForm;
    UIBarButtonItem  *btnPrint;
}

@end

@implementation ComplianceReport
@synthesize  scrollView,headerView;
@synthesize txtTo,txtPrintedName,txtTitle,txtDateIssued,txtContractNo,txtdate,txtDateContactCompleted,txtDateContracStarted,txtDateRawReport,txtProject, comNoticeNo;
@synthesize lblConRes,lblCorrective,lblProjDec;
@synthesize CNo;
@synthesize txtNoticeNo;
@synthesize imgSignature;
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
    [lblProjDec.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [lblProjDec.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [lblProjDec.layer setBorderWidth: 1.0];
    [lblProjDec.layer setCornerRadius:8.0f];
    [lblCorrective.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [lblCorrective.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [lblCorrective.layer setBorderWidth: 1.0];
    [lblCorrective.layer setCornerRadius:8.0f];
    [lblConRes.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [lblConRes.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [lblConRes.layer setBorderWidth: 1.0];
    [lblConRes.layer setCornerRadius:8.0f];
    scrollView.scrollsToTop=NO;
    self.tblView.scrollsToTop=YES;
    self.tblView.tableHeaderView = headerView;
    appDelegate=(TabAndSplitAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    UIBarButtonItem  *btnEmail = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(createPDF)];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithTitle:NSLocalizedString(@"", @"")
                                  style:UIBarButtonItemStyleDone
                                  target:self
                                  action:@selector(showFirst:)];
    self.navigationItem.leftBarButtonItem = addButton;
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName : [UIColor clearColor]
                                                                      }];
    UIBarButtonItem *Button = [[UIBarButtonItem alloc]
                               initWithTitle:NSLocalizedString(@"New", @"")
                               style:UIBarButtonItemStyleDone
                               target:self
                               action:@selector(showSCompliance:)];
    
    UIBarButtonItem *Button02 = [[UIBarButtonItem alloc]
                                initWithTitle:NSLocalizedString(@"Edit", @"")
                                style:UIBarButtonItemStyleDone
                                target:self
                                action:@selector(fnEdit:)];
    
    UIBarButtonItem *Button3 = [[UIBarButtonItem alloc]
                                initWithTitle:NSLocalizedString(@"Delete", @"")
                                style:UIBarButtonItemStyleDone
                                target:self
                                action:@selector(fnDelete:)];
    
    btnPrint = [[UIBarButtonItem alloc]
                initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(printReport)];
    
    self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:Button, btnEmail,btnPrint, nil];

    self.navigationItem.leftBarButtonItems=[NSArray arrayWithObjects:Button3, Button02, nil];;
    

    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    arrayImages=[[NSMutableArray alloc]init];
    sketchesArray=[[NSMutableArray alloc]init];
    [self populateComplianceForm];
}

-(void) populateComplianceForm
{
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.navigationController.view addSubview:hud];
    hud.labelText=@"";
    hud.dimBackground = YES;
    hud.delegate = self;
    [hud show:YES];
    
    NSManagedObjectContext *context = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ComplianceForm" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY complianceNoticeNo == %@", CNo];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    
    if([objects count] > 0){
        NSManagedObject *complianceReportObject = (NSManagedObject *) [objects objectAtIndex:0];
        NSLog(@"Compliance Form object CNo: %@", [complianceReportObject valueForKey:@"complianceNoticeNo"]);
        txtTitle.text=[complianceReportObject valueForKey:@"comHeader"];
        comNoticeNo.text=[complianceReportObject valueForKey:@"complianceNoticeNo"];
        
        id project = [PRIMECMController getProjectFromID:[complianceReportObject valueForKey:@"project_id"]];
        if (project != NULL){
            lblProjDec.text=[project valueForKey:@"p_description"];
            txtProject.text=[project valueForKey:@"p_name"];
        }
        
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:@"yyyy-MM-dd"];
        
        txtContractNo.text=[complianceReportObject valueForKey:@"project_id"];
        txtTitle.text=[complianceReportObject valueForKey:@"title"];
        
        txtDateIssued.text=[dateFormater stringFromDate:[complianceReportObject valueForKey:@"dateIssued"]];
        lblConRes.text=[complianceReportObject valueForKey:@"ContractorResponsible"];
        txtTo.text=[complianceReportObject valueForKey:@"to"];
        txtDateContracStarted.text=[dateFormater stringFromDate:[complianceReportObject valueForKey:@"dateContractorStarted"]];
        txtDateContactCompleted.text=[dateFormater stringFromDate:[complianceReportObject valueForKey:@"dateContractorCompleted"]];
        txtDateRawReport.text=[dateFormater stringFromDate:[complianceReportObject valueForKey:@"dateOfDWRReported"]];
        lblCorrective.text=[complianceReportObject valueForKey:@"correctiveActionCompliance"];
        txtPrintedName.text=[complianceReportObject valueForKey:@"printedName"];
        txtdate.text=[dateFormater stringFromDate:[complianceReportObject valueForKey:@"date"]];
        txtNoticeNo.text=[complianceReportObject valueForKey:@"complianceNoticeNo"];
        
        arrayImages  = [[[complianceReportObject valueForKey:@"images_uploaded"] componentsSeparatedByString:@","]mutableCopy];
        sketchesArray  = [[[complianceReportObject valueForKey:@"sketch_images"] componentsSeparatedByString:@","]mutableCopy];
        
        sigImgName = [complianceReportObject valueForKey:@"signature"];
        imgSignature.image=[PRIMECMController getTheImage:sigImgName];
        NSLog(@"array Images---%@",arrayImages);
        NSLog(@"array Sketches---%@",sketchesArray);
    }else{
        NSLog(@"No matching ComplianceForm with ID: %@", CNo);
    }
    
    [self.tblView reloadData];
    [hud setHidden:YES];
}

-(IBAction)fnEdit:(id)sender
{
    NSMutableDictionary *complianceReportDTO1 = [[NSMutableDictionary alloc] init];
    [complianceReportDTO1 setValue:txtTitle.text forKey:@"comHeader"];
    [complianceReportDTO1 setValue:CNo forKey:@"complianceNoticeNo"];
    [complianceReportDTO1 setValue:txtContractNo.text forKey:@"contractNo"];
    [complianceReportDTO1 setValue:lblConRes.text forKey:@"contractorResponsible"];
    [complianceReportDTO1 setValue:lblCorrective.text forKey:@"correctiveActionCompliance"];
    [complianceReportDTO1 setValue:txtdate.text forKey:@"date"];
    [complianceReportDTO1 setValue:txtDateContactCompleted.text forKey:@"dateContractorCompleted"];
    [complianceReportDTO1 setValue:txtDateContracStarted.text forKey:@"dateContractorStarted"];
    [complianceReportDTO1 setValue:txtDateIssued.text forKey:@"dateIssued"];
    [complianceReportDTO1 setValue:txtDateRawReport.text forKey:@"dateOfDWRReported"];
    
    NSMutableArray *arrM1 = [[NSMutableArray alloc] init];
    int i = 0;
    for (id obj in arrayImages){
        
        NSMutableDictionary *imageDictionary = [[NSMutableDictionary alloc] init];
        imageDictionary=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                         [NSString stringWithFormat:@"%i",i], @"tag",
                         @"", @"description",
                         obj, @"name",
                         nil];
        
        
        [arrM1 addObject:imageDictionary];
        i++;
    }
    
    NSMutableArray *arrM2 = [[NSMutableArray alloc] init];
    i = 0;
    for (id obj in sketchesArray){
        
        NSMutableDictionary *imageDictionary = [[NSMutableDictionary alloc] init];
        imageDictionary=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                         [NSString stringWithFormat:@"%i",i], @"tag",
                         @"", @"description",
                         obj, @"name",
                         nil];
        
        
        [arrM2 addObject:imageDictionary];
        i++;
    }
    
    [complianceReportDTO1 setValue:sigImgName forKey:@"signature"];
    [complianceReportDTO1 setValue:arrM2 forKey:@"sketch_images"];
    [complianceReportDTO1 setValue:arrM1 forKey:@"images_uploaded"];
    
    
    [complianceReportDTO1 setValue:txtTo.text forKey:@"to"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeComplianceForm" object:nil userInfo:complianceReportDTO1];
}

-(IBAction)fnDelete:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeDashboard" object:nil];
    
    ComplianceForm *assp;
    NSError *retrieveError;
    
    NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ComplianceForm"
                                              inManagedObjectContext:managedContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(complianceNoticeNo = %@)", CNo];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedObjects = [managedContext executeFetchRequest:fetchRequest error:&retrieveError];
    
    if (fetchedObjects && [fetchedObjects count] > 0) {
        assp = [fetchedObjects objectAtIndex:0];
        
        [managedContext deleteObject:assp];
        
        if (![managedContext save:&retrieveError]) {
            NSLog(@"Whoops, couldn't delete: %@", [retrieveError localizedDescription]);
        }else{
            NSLog(@"Deleted: %@", CNo);
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
        if( ! [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error]) {
            NSLog(@"[%@] ERROR: attempting to write create Images directory", [self class]);
        }
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
    int count=3+arrayImages.count-1+sketchesArray.count;
    for (int i = 0 ; i<count ; i++)
    {
        
        // page 1
        CGContextBeginPage (pdfContext,nil);
        
        //turn PDF upsidedown
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformMakeTranslation(0, (i+1) *710);
        transform = CGAffineTransformScale(transform, 1.0, -1.0);
        CGContextConcatCTM(pdfContext, transform);
        
        //Draw view into PDF
        [self.tblView.layer renderInContext:pdfContext];
        CGContextEndPage (pdfContext);
        [self.tblView setContentOffset:CGPointMake(0, (i+1) * 710) animated:NO];
        
    }
    CGContextRelease (pdfContext);
    
    
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
    url = CFURLCreateWithFileSystemPath (NULL, path, kCFURLPOSIXPathStyle, false);
    
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
}


-(void)createPDFfromUIView:(UIScrollView*)aView saveToDocumentsWithFileName:(NSString*)aFilename
{
    NSMutableData *pdfData = [NSMutableData data];
    UIGraphicsBeginPDFContextToData(pdfData, aView.bounds, nil);
    UIGraphicsBeginPDFPage();
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    [aView.layer renderInContext:pdfContext];
    
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


-(void)changeTableView
{
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)showSCompliance:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeComplianceForm" object:nil userInfo:NULL];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
    {
        return [arrayImages count] + 1;
    }
    else
    {
        return [sketchesArray count] + 1;
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
            //cell.lblTitle.hidden=NO;
            //cell.imgView.image=[self getImageFromFileName:[NSString stringWithFormat:@"%@.jpg",[arrayImages objectAtIndex:indexPath.row]]];
            cell.imgView.image=[PRIMECMController getTheImage:[arrayImages objectAtIndex:indexPath.row-1]];
        }
        else
        {
            //cell.lblTitle.hidden=YES;
            //cell.imgView.image=[self getImageFromFileName:[NSString stringWithFormat:@"%@.jpg",[sketchesArray objectAtIndex:indexPath.row]]];
            cell.imgView.image=[PRIMECMController getTheImage:[sketchesArray objectAtIndex:indexPath.row-1]];
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
        return 550                                                                                                                                                                   ;
    }
}
- (BOOL)presentFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated completionHandler:(UIPrintInteractionCompletionHandler)completion {
    return YES;
}

- (BOOL)presentFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated completionHandler:(UIPrintInteractionCompletionHandler)completion {
    return YES;
}


@end
