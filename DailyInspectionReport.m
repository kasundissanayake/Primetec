#import "DailyInspectionReport.h"
#import "ImageHeaderCell.h"
#import "ImageCell.h"
#import "TabAndSplitAppAppDelegate.h"
#import "PRIMECMAPPUtils.h"
#import "PRIMECMController.h"
#import "DailyInspectionForm.h"
#import "Projects.h"

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
@synthesize  headerView;
@synthesize CNo;
@synthesize txtAdressPOBox,txtCity,txtCometentPerson,txtContractor,txtEmail,txtInspecName1,txtInspecName2,txtInspecName3,txtInspecTitle1,txtInspecTitle2,txtInspecTitle3,txtOfficeName1,txtOfficeName2,txtOfficeName3,txtOfficeName4,txtOfficeTitle1,
txtOfficeTitle2,txtOfficeTitle3,txtOfficeTitle4,txtState,txtTelephone,txtWorkDec1,txtWorkDec2,txtWorkDec3,txtWorkDone,
txtWorkDoneDepart1,txtWorkDoneDepart2,txtWorkDoneDepart3;
@synthesize lblProject;
@synthesize txtInspecName4,txtInspecTitle,txtWorkDec4,txtWorkDoneDepart4;
@synthesize txtHoursOfWork;
@synthesize imgInspectorSignature;
@synthesize txtZip,town,conName,weather,repNo,time,useddays,caldays;

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
    UIBarButtonItem *Button3 = [[UIBarButtonItem alloc]
                                initWithTitle:NSLocalizedString(@"Delete", @"")
                                style:UIBarButtonItemStyleDone
                                target:self
                                action:@selector(fnDelete:)];
    arrayImages=[[NSMutableArray alloc]init];
    sketchesArray=[[NSMutableArray alloc]init];
    
    UIBarButtonItem  *btnEmail = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(createPDF)];
    
    btnPrint = [[UIBarButtonItem alloc]
                initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(printReport)];
    
    
    self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:Button, btnEmail,btnPrint, nil];
    self.navigationItem.leftBarButtonItems=[NSArray arrayWithObjects:Button2, Button3, nil];
    
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
        town.text=[inspectionReportObject valueForKey:@"town_city"];
        weather.text=[inspectionReportObject valueForKey:@"weather"];
        time.text=[inspectionReportObject valueForKey:@"time"];
        conName.text=[inspectionReportObject valueForKey:@"con_Name"];
        repNo.text=[inspectionReportObject valueForKey:@"report_No"];
        txtZip.text=[inspectionReportObject valueForKey:@"zip_Code"];
        useddays.text=[inspectionReportObject valueForKey:@"original_Calendar_Days"];
        caldays.text=[inspectionReportObject valueForKey:@"calendar_Days_Used"];
        txtContractor.text=[inspectionReportObject valueForKey:@"contractor"];
        txtAdressPOBox.text=[inspectionReportObject valueForKey:@"p_o_Box"];
        txtCity.text=[inspectionReportObject valueForKey:@"city"];
        txtState.text=[inspectionReportObject valueForKey:@"state"];
        txtTelephone.text=[inspectionReportObject valueForKey:@"telephone_No"];
        txtCometentPerson.text=[inspectionReportObject valueForKey:@"competentPerson"];
        
        id project = [PRIMECMController getProjectFromID:[inspectionReportObject valueForKey:@"project_id"]];
        if (project != NULL){
            lblProject.text=  [project valueForKey:@"p_name"] ;
        }
        
        town.text=[inspectionReportObject valueForKey:@"town_city"];
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
        txtInspecName3.text=[inspectionReportObject valueForKey:@"iFName3"];
        txtInspecName4.text=[inspectionReportObject valueForKey:@"iFName4"];
        txtInspecTitle1.text=[inspectionReportObject valueForKey:@"iFTitle1"];
        txtInspecTitle2.text=[inspectionReportObject valueForKey:@"iFTitle2"];
        txtInspecTitle3.text=[inspectionReportObject valueForKey:@"iFTitle3"];
        txtInspecTitle.text=[inspectionReportObject valueForKey:@"iFTitle4"];
        txtWorkDoneDepart1.text=[inspectionReportObject valueForKey:@"wDODepartmentOrCompany1"];
        txtWorkDoneDepart2.text=[inspectionReportObject valueForKey:@"wDODepartmentOrCompany2"];
        txtWorkDoneDepart3.text=[inspectionReportObject valueForKey:@"wDODepartmentOrCompany3"];
        txtWorkDoneDepart4.text=[inspectionReportObject valueForKey:@"wDODepartmentOrCompany4"];
        txtWorkDec1.text=[inspectionReportObject valueForKey:@"wDODescriptionOfWork1"];
        txtWorkDec2.text=[inspectionReportObject valueForKey:@"wDODescriptionOfWork2"];
        txtWorkDec3.text=[inspectionReportObject valueForKey:@"wDODescriptionOfWork3"];
        txtWorkDec4.text=[inspectionReportObject valueForKey:@"wDODescriptionOfWork4"];
        txtHoursOfWork.text=[NSString stringWithFormat:@"%@", [inspectionReportObject valueForKey:@"contractorsHoursOfWork"]];
        NSString * signName = [inspectionReportObject valueForKey:@"inspectorSign"];
        imgInspectorSignature.image=[PRIMECMController getTheImage:signName];
        arrayImages  = [[[inspectionReportObject valueForKey:@"images_uploaded"] componentsSeparatedByString:@","]mutableCopy];
        sketchesArray  = [[[inspectionReportObject valueForKey:@"sketch_images"] componentsSeparatedByString:@","]mutableCopy];
        
        NSLog(@"array Images---%@",arrayImages);
        NSLog(@"array Sketches---%@",sketchesArray);
        NSArray *responseObject = [PRIMECMController getDailyInspectionItemsFromInspectionID:CNo];
        if ([responseObject count] > 0){
            _des1.text=[[responseObject objectAtIndex:0] valueForKey:@"desc"];
            _qua1.text=[[[responseObject objectAtIndex:0] valueForKey:@"qty"] stringValue];
            _itemno1.text=[[responseObject objectAtIndex:0] valueForKey:@"no"];
        }
        
        if ([responseObject count] > 1){
            _des2.text=[[responseObject objectAtIndex:1] valueForKey:@"desc"];
            _qua2.text=[[[responseObject objectAtIndex:1] valueForKey:@"qty"] stringValue];
            _itemno2.text=[[responseObject objectAtIndex:1] valueForKey:@"no"];
        }
        
        if ([responseObject count] > 2){
            _des3.text=[[responseObject objectAtIndex:2] valueForKey:@"desc"];
            _qua3.text=[[[responseObject objectAtIndex:2] valueForKey:@"qty"] stringValue];
            _itemno3.text=[[responseObject objectAtIndex:2] valueForKey:@"no"];
        }
        
        if ([responseObject count] > 3){
            _des4.text=[[responseObject objectAtIndex:3] valueForKey:@"desc"];
            _qua4.text=[[[responseObject objectAtIndex:3] valueForKey:@"qty"] stringValue];
            _itemno4.text=[[responseObject objectAtIndex:3] valueForKey:@"no"];
        }
        
        if ([responseObject count] > 4){
            _des5.text=[[responseObject objectAtIndex:4] valueForKey:@"desc"];
            _qua5.text=[[[responseObject objectAtIndex:4] valueForKey:@"qty"] stringValue];
            _itemno5.text=[[responseObject objectAtIndex:4] valueForKey:@"no"];
        }
    }else{
        NSLog(@"No matching ComplianceForm with ID: %@", CNo);
    }
    
    [self.tblView reloadData];
    [hud setHidden:YES];
}

-(IBAction)fnEdit:(id)sender
{
    NSMutableDictionary *dailyInspectionReportDTO = [[NSMutableDictionary alloc] init];
    
    [dailyInspectionReportDTO setValue:town.text forKey:@"town_city"];
    [dailyInspectionReportDTO setValue:CNo forKey:@"inspectionID"];
    [dailyInspectionReportDTO setValue:weather.text forKey:@"weather"];
    [dailyInspectionReportDTO setValue:time.text forKey:@"time"];
    [dailyInspectionReportDTO setValue:conName.text forKey:@"con_Name"];
    [dailyInspectionReportDTO setValue:repNo.text forKey:@"report_No"];
    [dailyInspectionReportDTO setValue:txtZip.text forKey:@"zip_Code"];
    [dailyInspectionReportDTO setValue:useddays.text forKey:@"original_Calendar_Days"];
    [dailyInspectionReportDTO setValue:caldays.text forKey:@"calendar_Days_Used"];
    [dailyInspectionReportDTO setValue:txtContractor.text forKey:@"contractor"];
    [dailyInspectionReportDTO setValue:txtAdressPOBox.text forKey:@"p_o_Box"];
    [dailyInspectionReportDTO setValue:txtCity.text forKey:@"city"];
    [dailyInspectionReportDTO setValue:txtState.text forKey:@"state"];
    [dailyInspectionReportDTO setValue:txtTelephone.text forKey:@"telephone_No"];
    [dailyInspectionReportDTO setValue:txtCometentPerson.text forKey:@"competentPerson"];
    [dailyInspectionReportDTO setValue:lblProject.text forKey:@"project"];
    [dailyInspectionReportDTO setValue:town.text forKey:@"town_city"];
    [dailyInspectionReportDTO setValue:txtEmail.text forKey:@"e_Mail"];
    [dailyInspectionReportDTO setValue:txtWorkDone.text forKey:@"workDoneBy"];
    [dailyInspectionReportDTO setValue:txtOfficeName1.text forKey:@"oVJName1"];
    [dailyInspectionReportDTO setValue:txtOfficeName2.text forKey:@"oVJName2"];
    [dailyInspectionReportDTO setValue:txtOfficeName3.text forKey:@"oVJName3"];
    [dailyInspectionReportDTO setValue:txtOfficeName4.text forKey:@"oVJName4"];
    [dailyInspectionReportDTO setValue:txtOfficeTitle1.text forKey:@"oVJTitle1"];
    [dailyInspectionReportDTO setValue:txtOfficeTitle2.text forKey:@"oVJTitle2"];
    [dailyInspectionReportDTO setValue:txtOfficeTitle3.text forKey:@"oVJTitle3"];
    [dailyInspectionReportDTO setValue:txtOfficeTitle4.text forKey:@"oVJTitle4"];
    [dailyInspectionReportDTO setValue:txtInspecName1.text forKey:@"iFName1"];
    [dailyInspectionReportDTO setValue:txtInspecName2.text forKey:@"iFName2"];
    [dailyInspectionReportDTO setValue:txtInspecName3.text forKey:@"iFName3"];
    [dailyInspectionReportDTO setValue:txtInspecName4.text forKey:@"iFName4"];
    [dailyInspectionReportDTO setValue:txtInspecTitle.text forKey:@"iFTitle1"];
    [dailyInspectionReportDTO setValue:txtInspecTitle1.text forKey:@"iFTitle2"];
    [dailyInspectionReportDTO setValue:txtInspecTitle2.text forKey:@"iFTitle3"];
    [dailyInspectionReportDTO setValue:txtInspecTitle3.text forKey:@"iFTitle4"];
    [dailyInspectionReportDTO setValue:txtWorkDoneDepart1.text forKey:@"wDODepartmentOrCompany1"];
    [dailyInspectionReportDTO setValue:txtWorkDoneDepart2.text forKey:@"wDODepartmentOrCompany2"];
    [dailyInspectionReportDTO setValue:txtWorkDoneDepart3.text forKey:@"wDODepartmentOrCompany3"];
    [dailyInspectionReportDTO setValue:txtWorkDoneDepart4.text forKey:@"wDODepartmentOrCompany4"];
    [dailyInspectionReportDTO setValue:txtWorkDec1.text forKey:@"wDODescriptionOfWork1"];
    [dailyInspectionReportDTO setValue:txtWorkDec2.text forKey:@"wDODescriptionOfWork2"];
    [dailyInspectionReportDTO setValue:txtWorkDec3.text forKey:@"wDODescriptionOfWork3"];
    [dailyInspectionReportDTO setValue:txtWorkDec4.text forKey:@"wDODescriptionOfWork4"];
    [dailyInspectionReportDTO setValue:txtHoursOfWork.text forKey:@"contractorsHoursOfWork"];
    [dailyInspectionReportDTO setValue:_des1.text forKey:@"i_Desc1"];
    [dailyInspectionReportDTO setValue:_qua1.text forKey:@"i_QTY1"];
    [dailyInspectionReportDTO setValue:_itemno1.text forKey:@"i_No1"];
    [dailyInspectionReportDTO setValue:_des2.text forKey:@"i_Desc2"];
    [dailyInspectionReportDTO setValue:_qua2.text forKey:@"i_QTY2"];
    [dailyInspectionReportDTO setValue:_itemno2.text forKey:@"i_No2"];
    [dailyInspectionReportDTO setValue:_des3.text forKey:@"i_Desc3"];
    [dailyInspectionReportDTO setValue:_qua3.text forKey:@"i_QTY3"];
    [dailyInspectionReportDTO setValue:_itemno3.text forKey:@"i_No3"];
    [dailyInspectionReportDTO setValue:_des4.text forKey:@"i_Desc4"];
    [dailyInspectionReportDTO setValue:_qua4.text forKey:@"i_QTY4"];
    [dailyInspectionReportDTO setValue:_itemno4.text forKey:@"i_No4"];
    [dailyInspectionReportDTO setValue:_des5.text forKey:@"i_Desc5"];
    [dailyInspectionReportDTO setValue:_qua5.text forKey:@"i_QTY5"];
    [dailyInspectionReportDTO setValue:_itemno5.text forKey:@"i_No5"];
    
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
    
    [dailyInspectionReportDTO setValue:arrM1 forKey:@"images_uploaded"];
    [dailyInspectionReportDTO setValue:arrM2 forKey:@"sketch_images"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeInspectionForm" object:nil userInfo:dailyInspectionReportDTO];
}

-(IBAction)fnDelete:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeDashboard" object:nil];
    
    DailyInspectionForm *assp;
    NSError *retrieveError;
    
    NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DailyInspectionForm"
                                              inManagedObjectContext:managedContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(inspectionID = %@)", CNo];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedObjects = [managedContext executeFetchRequest:fetchRequest error:&retrieveError];
    
    if (fetchedObjects && [fetchedObjects count] > 0) {
        assp = [fetchedObjects objectAtIndex:0];
        [managedContext deleteObject:assp];
        if (![managedContext save:&retrieveError]) {
            NSLog(@"Whoops, couldn't delete: %@", [retrieveError localizedDescription]);
        } else {
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
        if(! ( [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error]))
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
        return [arrayImages count]+1;
    }
    else
    {
        return [sketchesArray count]+1;
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

            cell.imgView.image=[PRIMECMController getTheImage:[arrayImages objectAtIndex:indexPath.row-1]];
        }
        else
        {
            //cell.lblTitle.hidden=YES;
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
        return 650;
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