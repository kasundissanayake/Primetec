/*#import "DailyInspectionReport.h"
#import "ImageHeaderCell.h"
#import "ImageCell.h"
#import "TabAndSplitAppAppDelegate.h"
#import "PRIMECMAPPUtils.h"

@interface DailyInspectionReport (){
    NSMutableArray *arrayImages;
    NSMutableArray *sketchesArray;
    NSMutableData *_receivedData;
    NSURLResponse *_receivedResponse;
    NSError *_connectionError;
    NSArray *resPonse;
    MBProgressHUD *hud;
    TabAndSplitAppAppDelegate *appDelegate;
    UIBarButtonItem  *btnPrint;
}
@end

@implementation DailyInspectionReport
@synthesize  scrollView,headerView;
@synthesize lblImageAttachmentTitle,viewImageAttachmentTitle;
@synthesize CNo;
@synthesize txtAdressPOBox,txtCity,txtCometentPerson,txtContractor,txtEmail,txtHowToWork,txtInspecName1,txtInspecName2,txtInspecName3,txtInspecTitle1,txtInspecTitle2,txtInspecTitle3,txtOfficeName1,txtOfficeName2,txtOfficeName3,txtOfficeName4,txtOfficeTitle1,
txtOfficeTitle2,txtOfficeTitle3,txtOfficeTitle4,txtState,txtTelephone,txtTown,txtWorkDec1,txtWorkDec2,txtWorkDec3,txtWorkDone,
txtWorkDoneDepart1,txtWorkDoneDepart2,txtWorkDoneDepart3;
@synthesize lblProject;
@synthesize txtInspecName4,txtInspecTitle,txtWorkDec4,txtWorkDoneDepart4;
@synthesize txtHoursOfWork;
@synthesize imgInspectorSignature;
@synthesize txtZip;

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
    
    [lblProject.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [lblProject.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [lblProject.layer setBorderWidth: 1.0];
    [lblProject.layer setCornerRadius:8.0f];
    
    [txtWorkDone.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [txtWorkDone.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [txtWorkDone.layer setBorderWidth: 1.0];
    [txtWorkDone.layer setCornerRadius:8.0f];
    
    //scrollView.scrollsToTop=NO;
    self.tblView.scrollsToTop=YES;
    self.tblView.tableHeaderView = headerView;
    appDelegate=(TabAndSplitAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    
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
    
    arrayImages=[[NSMutableArray alloc]init];
    sketchesArray=[[NSMutableArray alloc]init];
    
    UIBarButtonItem  *btnEmail = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(createPDF)];
    
    btnPrint = [[UIBarButtonItem alloc]
                initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(printReport)];
    
    
    self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:Button, btnEmail,btnPrint, nil];
    self.navigationItem.leftBarButtonItem=Button2;
    
    [self populateInspectionForm];
}

-(void) populateInspectionForm
{
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.navigationController.view addSubview:hud];
    hud.labelText=@"";
    hud.dimBackground = YES;
    hud.delegate = self;
    [hud show:YES];
    
    NSManagedObjectContext *context = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DailyInspectionForm" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY inspectionID == %@", CNo];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    
    if([objects count] > 0){
        
        NSManagedObject *inspectionReportObject = (NSManagedObject *) [objects objectAtIndex:0];
        NSLog(@"Inspection Form object inspectionID: %@", [inspectionReportObject valueForKey:@"inspectionID"]);
        
        txtContractor.text=[inspectionReportObject valueForKey:@"contractor"];
        txtAdressPOBox.text=[inspectionReportObject valueForKey:@"p_o_Box"];
        txtCity.text=[inspectionReportObject valueForKey:@"city"];
        txtState.text=[inspectionReportObject valueForKey:@"state"];
        txtTelephone.text=[inspectionReportObject valueForKey:@"telephone_No"];
        txtCometentPerson.text=[inspectionReportObject valueForKey:@"competentPerson"];
        lblProject.text=[inspectionReportObject valueForKey:@"project"];
        txtTown.text=[inspectionReportObject valueForKey:@"town_city"];
        txtZip.text=[inspectionReportObject valueForKey:@"zip_Code"];
        
        txtEmail.text=[inspectionReportObject valueForKey:@"e_Mail"];
        txtWorkDone.text=[inspectionReportObject valueForKey:@"workDoneBy"];
        txtOfficeName1.text=[inspectionReportObject valueForKey:@"oVJName1"];
        txtOfficeName2.text=[inspectionReportObject valueForKey:@"oVJName2"];
        txtOfficeName3.text=[inspectionReportObject valueForKey:@"oVJName3"];
        txtOfficeName4.text=[inspectionReportObject valueForKey:@"oVJName4"];
        
        txtOfficeTitle1.text=[inspectionReportObject valueForKey:@"oVJTitle1"];
        txtOfficeTitle2.text=[inspectionReportObject valueForKey:@"oVJTitle2"];
        txtOfficeTitle3.text=[inspectionReportObject valueForKey:@"oVJTitle3"];
        txtOfficeTitle4.text=[inspectionReportObject valueForKey:@"oVJTitle4"];
        txtInspecName1.text=[inspectionReportObject valueForKey:@"iFName1"];
        txtInspecName2.text=[inspectionReportObject valueForKey:@"iFName2"];
        txtInspecName3.text=[inspectionReportObject valueForKey:@"iFTitle3"];
        txtInspecName4.text=[inspectionReportObject valueForKey:@"iFName4"];
        
        txtInspecTitle1.text=[inspectionReportObject valueForKey:@"iFTitle1"];
        txtInspecTitle2.text=[inspectionReportObject valueForKey:@"iFTitle2"];
        txtInspecTitle3.text=[inspectionReportObject valueForKey:@"iFTitle3"];
        txtInspecName4.text=[inspectionReportObject valueForKey:@"iFTitle4"];
        
        txtWorkDoneDepart1.text=[inspectionReportObject valueForKey:@"wDODepartmentOrCompany1"];
        txtWorkDoneDepart2.text=[inspectionReportObject valueForKey:@"wDODepartmentOrCompany2"];
        txtWorkDoneDepart3.text=[inspectionReportObject valueForKey:@"wDODepartmentOrCompany3"];
        txtWorkDoneDepart4.text=[inspectionReportObject valueForKey:@"wDODepartmentOrCompany4"];
        txtWorkDec1.text=[inspectionReportObject valueForKey:@"wDODescriptionOfWork1"];
        txtWorkDec2.text=[inspectionReportObject valueForKey:@"wDODescriptionOfWork2"];
        txtWorkDec3.text=[inspectionReportObject valueForKey:@"wDODescriptionOfWork3"];
        txtWorkDec4.text=[inspectionReportObject valueForKey:@"wDODescriptionOfWork4"];
        txtHoursOfWork.text=[NSString stringWithFormat:@"%@", [inspectionReportObject valueForKey:@"contractorsHoursOfWork"]];
        
        arrayImages  = [[[inspectionReportObject valueForKey:@"images_uploaded"] componentsSeparatedByString:@","]mutableCopy];
        sketchesArray  = [[[inspectionReportObject valueForKey:@"sketch_images"] componentsSeparatedByString:@","]mutableCopy];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://data.privytext.us/dailyinspection/%@",
                                           [NSString stringWithFormat:@"%@.jpg", [inspectionReportObject valueForKey:@"InspectorSign"]]]];
        
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        imgInspectorSignature.image=image;
        
        for (int i=1; i<sketchesArray.count; i++) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://data.privytext.us/dailyinspection/%@",[NSString stringWithFormat:@"%@.jpg", [sketchesArray objectAtIndex:i]]]];
            NSLog(@"url----%@",url);
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            [self saveImageTaken:image imgName:[NSString stringWithFormat:@"%@.jpg", [sketchesArray objectAtIndex:i]]];
        }
        
        for (int i=1; i<arrayImages.count; i++) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://data.privytext.us/dailyinspection/%@",[NSString stringWithFormat:@"%@.jpg", [arrayImages objectAtIndex:i]]]];
            NSLog(@"url----%@",url);
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            [self saveImageTaken:image imgName:[NSString stringWithFormat:@"%@.jpg", [arrayImages objectAtIndex:i]]];
        }
    }
    
    [self.tblView reloadData];
    [hud setHidden:YES];
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
        if(! ( [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error]))
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
        [[NSFileManager defaultManager] createDirectoryAtPath:directroyPath withIntermediateDirectories:NO attributes:nil error:&error];
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
        transform = CGAffineTransformMakeTranslation(0, (i+1) *850);
        transform = CGAffineTransformScale(transform, 1.0, -1.0);
        CGContextConcatCTM(pdfContext, transform);
        
        //Draw view into PDF
        [self.tblView.layer renderInContext:pdfContext];
        CGContextEndPage (pdfContext);
        [self.tblView setContentOffset:CGPointMake(0, (i+1) * 770) animated:NO];
        
    }
    CGContextRelease (pdfContext);
    // [self createImagesPDF];
    
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
    int count=4+arrayImages.count+sketchesArray.count;
    for (int i = 0 ; i<count ; i++)
    {
        
        // page 1
        CGContextBeginPage (pdfContext,nil);
        
        //turn PDF upsidedown
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformMakeTranslation(0, (i+1) *700);
        transform = CGAffineTransformScale(transform, 1.0, -1.0);
        CGContextConcatCTM(pdfContext, transform);
        
        //Draw view into PDF
        [self.tblView.layer renderInContext:pdfContext];
        CGContextEndPage (pdfContext);
        [self.tblView setContentOffset:CGPointMake(0, (i+1) * 670) animated:NO];
        
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


-(IBAction)showSCompliance:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeInspectionForm" object:nil];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
        return 160;
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end*/







//start brin

//
//  DailyInspectionReport.m
//  ComSMART
//
//  Created by Lingeswaran Kandasamy on 5/2/14.
//
//

#import "DailyInspectionReport.h"
#import "ImageHeaderCell.h"
#import "ImageCell.h"
#import "TabAndSplitAppAppDelegate.h"



@interface DailyInspectionReport (){
    
    
    NSMutableArray *arrayImages;
    NSMutableArray *sketchesArray;
    
    NSMutableData *_receivedData;
    NSURLResponse *_receivedResponse;
    NSError *_connectionError;
    NSArray *resPonse;
    
    //woornika
    MBProgressHUD *HUD;
    TabAndSplitAppAppDelegate *appDelegate;
    UIBarButtonItem  *btnPrint;
    
}
@end

@implementation DailyInspectionReport
@synthesize  scrollView,headerView;
@synthesize lblImageAttachmentTitle,viewImageAttachmentTitle;
@synthesize CNo;
@synthesize txtAdressPOBox,txtCity,txtCometentPerson,txtContractor,txtEmail,txtHowToWork,txtInspecName1,txtInspecName2,txtInspecName3,txtInspecTitle1,txtInspecTitle2,txtInspecTitle3,txtOfficeName1,txtOfficeName2,txtOfficeName3,txtOfficeName4,txtOfficeTitle1,
txtOfficeTitle2,txtOfficeTitle3,txtOfficeTitle4,txtState,txtTelephone,txtTown,txtWorkDec1,txtWorkDec2,txtWorkDec3,txtWorkDone,
txtWorkDoneDepart1,txtWorkDoneDepart2,txtWorkDoneDepart3;
@synthesize lblProject;
@synthesize txtInspecName4,txtInspecTitle,txtWorkDec4,txtWorkDoneDepart4;
@synthesize txtHoursOfWork;
@synthesize imgInspectorSignature;
@synthesize txtZip;

@synthesize itemno1,itemno2,itemno3,itemno4,itemno5,caldays,useddays;

@synthesize repNo,conName,town,weather,time,des1,des2,des3,des4,des5,qua1,qua2,qua3,qua4,qua5;

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
    
    [lblProject.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [lblProject.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [lblProject.layer setBorderWidth: 1.0];
    [lblProject.layer setCornerRadius:8.0f];
    
    [txtWorkDone.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [txtWorkDone.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [txtWorkDone.layer setBorderWidth: 1.0];
    [txtWorkDone.layer setCornerRadius:8.0f];
    
    
    
    //scrollView.scrollsToTop=NO;
    self.tblView.scrollsToTop=YES;
    self.tblView.tableHeaderView = headerView;
    appDelegate=(TabAndSplitAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIBarButtonItem *Button = [[UIBarButtonItem alloc]
                               initWithTitle:NSLocalizedString(@"New", @"")
                               style:UIBarButtonItemStyleDone
                               target:self
                               action:@selector(showSCompliance:)];
    
    arrayImages=[[NSMutableArray alloc]init];
    sketchesArray=[[NSMutableArray alloc]init];
    
    
    
    
    UIBarButtonItem  *btnEmail = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(createPDF)];
    
    btnPrint = [[UIBarButtonItem alloc]
                initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(printReport)];
    
    
    
    self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:Button, btnEmail,btnPrint, nil];
    [self loadInspectionForm];
    
    
    
}
-(void)loadInspectionForm
{
    NSString *strURL = [NSString stringWithFormat:@"http://data.privytext.us/contructionapi.php/api/dailyinspection/single/%@/%@",appDelegate.username,CNo];
    
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
    txtContractor.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"Contractor"];
    txtAdressPOBox.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"P_O_Box"];
    txtCity.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"City"];
    txtState.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"State"];
    txtTelephone.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"Telephone_No"];
    txtCometentPerson.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"CompetentPerson"];
    lblProject.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"Project"];
    txtTown.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"Town/City"];
    txtZip.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"Zip_Code"];
    
    
    
    
    txtEmail.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"E_Mail"];
    txtWorkDone.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"WorkDoneBy"];
    txtOfficeName1.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"OVJName1"];
    txtOfficeName2.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"OVJName2"];
    txtOfficeName3.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"OVJName3"];
    txtOfficeName4.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"OVJName4"];
    
    txtOfficeTitle1.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"OVJTitle1"];
    txtOfficeTitle2.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"OVJTitle2"];
    txtOfficeTitle3.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"OVJTitle3"];
    txtOfficeTitle4.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"OVJTitle4"];
    txtInspecName1.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"IFName1"];
    txtInspecName2.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"IFName2"];
    txtInspecName3.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"IFName3"];
    txtInspecName4.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"IFName4"];
    
    txtInspecTitle1.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"IFTitle1"];
    txtInspecTitle2.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"IFTitle2"];
    txtInspecTitle3.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"IFTitle3"];
    txtInspecTitle.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"IFTitle4"];
    
    txtWorkDoneDepart1.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"WDODepartmentOrCompany1"];
    txtWorkDoneDepart2.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"WDODepartmentOrCompany2"];
    txtWorkDoneDepart3.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"WDODepartmentOrCompany3"];
    txtWorkDoneDepart4.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"WDODepartmentOrCompany4"];
    
    
    
    txtWorkDec1.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"WDODescriptionOfWork1"];
    txtWorkDec2.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"WDODescriptionOfWork2"];
    txtWorkDec3.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"WDODescriptionOfWork3"];
    txtWorkDec4.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"WDODescriptionOfWork4"];
    txtHoursOfWork.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"ContractorsHoursOfWork"];
    repNo.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"report_No"];
    conName.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"con_Name"];
    town.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"Town_City"];
    weather.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"weather"];
    des1.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"I_No1"];
    des2.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"I_No2"];
    des3.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"I_No3"];
    des4.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"I_No4"];
    des5.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"I_No5"];
    qua1.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"I_QTY1"];
    qua2.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"I_QTY2"];
    qua3.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"I_QTY3"];
    qua4.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"I_QTY4"];
    qua5.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"I_QTY5"];
    caldays.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"original_Calendar_Days"];
    useddays.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"calendar_Days_Used"];
    itemno1.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"I_Desc1"];
    itemno2.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"I_Desc2"];
    itemno3.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"I_Desc3"];
    itemno4.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"I_Desc4"];
    itemno5.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"I_Desc5"];
    time.text=[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"time"];
    
    
    
    
    
    
    
    
    
    
    
    arrayImages  = [[[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"images_uploaded"] componentsSeparatedByString:@","]mutableCopy];
    sketchesArray  = [[[[responseObject valueForKey:@"dailyinspection"]valueForKey:@"sketch_images"] componentsSeparatedByString:@","]mutableCopy];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://data.privytext.us/dailyinspection/%@",[NSString stringWithFormat:@"%@.jpg", [[responseObject valueForKey:@"dailyinspection"]valueForKey:@"InspectorSign"]]]];
    
    
    NSLog(@"url----%@",url);
    
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    imgInspectorSignature.image=image;
    
    
    
    for (int i=1; i<sketchesArray.count; i++) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://data.privytext.us/dailyinspection/%@",[NSString stringWithFormat:@"%@.jpg", [sketchesArray objectAtIndex:i]]]];
        NSLog(@"url----%@",url);
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        [self saveImageTaken:image imgName:[NSString stringWithFormat:@"%@.jpg", [sketchesArray objectAtIndex:i]]];
        
        
    }
    
    
    NSLog(@"array Images---%@",arrayImages);
    
    
    
    
    for (int i=1; i<arrayImages.count; i++) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://data.privytext.us/dailyinspection/%@",[NSString stringWithFormat:@"%@.jpg", [arrayImages objectAtIndex:i]]]];
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
        transform = CGAffineTransformMakeTranslation(0, (i+1) *850);
        transform = CGAffineTransformScale(transform, 1.0, -1.0);
        CGContextConcatCTM(pdfContext, transform);
        
        //Draw view into PDF
        [self.tblView.layer renderInContext:pdfContext];
        CGContextEndPage (pdfContext);
        [self.tblView setContentOffset:CGPointMake(0, (i+1) * 770) animated:NO];
        
    }
    CGContextRelease (pdfContext);
    // [self createImagesPDF];
    
    
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





/*
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
 
 UIFont*font = [UIFont fontWithName:@"HelveticaNeue-Light" size:30.0];
 
 NSLog(@"PDF Context created");
 int count=1+arrayImages.count+sketchesArray.count;
 for (int i = 0 ; i<count ; i++)
 {
 
 // page 1
 CGContextBeginPage (pdfContext,nil);
 
 //turn PDF upsidedown
 CGAffineTransform transform = CGAffineTransformIdentity;
 transform = CGAffineTransformMakeTranslation(0, (i+1) *700);
 transform = CGAffineTransformScale(transform, 1.0, -1.0);
 CGContextConcatCTM(pdfContext, transform);
 
 //Draw view into PDF
 [self.tblView.layer renderInContext:pdfContext];
 
 CGContextEndPage (pdfContext);
 [self.tblView setContentOffset:CGPointMake(0, (i+1) * 670) animated:NO];
 
 
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
 
 
 
 }*/







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
    
    //  CGContextRef pdfContext = [self createPDFContext:self.tblView.bounds path:(CFStringRef)filePath];
    
    CGContextRef pdfContext = [self createPDFContext:CGRectMake(-100, 0, 900, 1250) path:(CFStringRef)filePath];
    
    
    //UIFont*font = [UIFont fontWithName:@"HelveticaNeue-Light" size:30.0];
    
    NSLog(@"PDF Context created");
    long count=arrayImages.count+sketchesArray.count;
    for (int i = 0 ; i<count ; i++)
    {
        
        // page 1
        CGContextBeginPage (pdfContext,nil);
        
        //turn PDF upsidedown
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformMakeTranslation(0, (i+1) *1065);
        transform = CGAffineTransformScale(transform, 1.0, -1.0);
        CGContextConcatCTM(pdfContext, transform);
        
        //Draw view into PDF
        
        [self.tblView.layer renderInContext:pdfContext];
        [self.headerView.layer renderInContext:pdfContext];
        
        
        
        CGContextEndPage (pdfContext);
        [self.tblView setContentOffset:CGPointMake(0, (i+1) * 470) animated:YES];
        
        
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







-(IBAction)showSCompliance:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeInspectionForm" object:nil];
    
    
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
        return 160;
    }
    else
    {
        return 350                                                                                                                                                                           ;
    }
}

- (BOOL)presentFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated completionHandler:(UIPrintInteractionCompletionHandler)completion {
    return YES;
}

- (BOOL)presentFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated completionHandler:(UIPrintInteractionCompletionHandler)completion {
    return YES;
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


//end brin




