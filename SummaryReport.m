#import "SummaryReport.h"
#import "PRIMECMAPPUtils.h"
#import "PRIMECMController.h"
#import "SummarySheet1.h"
#import "SummarySheet2.h"
#import "SummarySheet3.h"

@interface SummaryReport ()
{
    NSMutableData *_receivedData;
    NSURLResponse *_receivedResponse;
    NSError *_connectionError;
    NSArray *resPonse;
    MBProgressHUD *hud;
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
    
    UIBarButtonItem *Button3 = [[UIBarButtonItem alloc]
                                initWithTitle:NSLocalizedString(@"Delete", @"")
                                style:UIBarButtonItemStyleDone
                                target:self
                                action:@selector(fnDelete:)];
    
    UIBarButtonItem  *btnEmail = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(createPDF)];
    
    
    btnPrint = [[UIBarButtonItem alloc]
                initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(printReport)];
    
    
    self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:Button, btnEmail,btnPrint, nil];
    self.navigationItem.leftBarButtonItems=[NSArray arrayWithObjects:Button2, Button3, nil];
    [self populateSummerySheet];
}


-(IBAction)fnEdit:(id)sender
{
    NSMutableDictionary *summaryReportDTO = [[NSMutableDictionary alloc] init];
    
    //[summaryReportDTO setValue:txtContractor.text forKey:@"contractor"];
    [summaryReportDTO setValue:txtContactorPerform.text forKey:@"conPeWork"];
    [summaryReportDTO setValue:txtFederalAid.text forKey:@"federalAidNumber"];
    [summaryReportDTO setValue:txvDesWork.text forKey:@"descr"];
    [summaryReportDTO setValue:txvConsOrder.text forKey:@"constructionOrder"];
    [summaryReportDTO setValue:txtClass1.text forKey:@"lAClass1"];
    [summaryReportDTO setValue:txtClass2.text forKey:@"lAClass2"];
    [summaryReportDTO setValue:txtClass3.text forKey:@"lAClass3"];
    [summaryReportDTO setValue:txtClass4.text forKey:@"lAClass4"];
    [summaryReportDTO setValue:txtClass5.text forKey:@"lAClass5"];
    [summaryReportDTO setValue:txtNo1.text forKey:@"lANo1"];
    [summaryReportDTO setValue:txtNo2.text forKey:@"lANo2"];
    [summaryReportDTO setValue:txtNo3.text forKey:@"lANo3"];
    [summaryReportDTO setValue:txtNo4.text forKey:@"lANo4"];
    [summaryReportDTO setValue:txtNo5.text forKey:@"lANo5"];
    [summaryReportDTO setValue:txtTotal1.text forKey:@"lATotalHours1"];
    [summaryReportDTO setValue:txtTotal2.text forKey:@"lATotalHours2"];
    [summaryReportDTO setValue:txtTotal3.text forKey:@"lATotalHours3"];
    [summaryReportDTO setValue:txtTotal4.text forKey:@"lATotalHours4"];
    [summaryReportDTO setValue:txtTotal5.text forKey:@"lATotalHours5"];
    [summaryReportDTO setValue:txtRate1.text forKey:@"lARate1"];
    [summaryReportDTO setValue:txtRate2.text forKey:@"lARate2"];
    [summaryReportDTO setValue:txtRate3.text forKey:@"lARate3"];
    [summaryReportDTO setValue:txtRate4.text forKey:@"lARate4"];
    [summaryReportDTO setValue:txtRate5.text forKey:@"lARate5"];
    [summaryReportDTO setValue:txtAmt1.text forKey:@"lAAmount1"];
    [summaryReportDTO setValue:txtAmt2.text forKey:@"lAAmount2"];
    [summaryReportDTO setValue:txtAmt3.text forKey:@"lAAmount3"];
    [summaryReportDTO setValue:txtAmt4.text forKey:@"lAAmount4"];
    [summaryReportDTO setValue:txtAmt5.text forKey:@"lAAmount5"];
    [summaryReportDTO setValue:txtTotalLabor.text forKey:@"totalLabor"];
    [summaryReportDTO setValue:txtHealth.text forKey:@"healWelAndPension"];
    [summaryReportDTO setValue:txtInsTax.text forKey:@"insAndTaxesOnItem1"];
    [summaryReportDTO setValue:txt20Items.text forKey:@"itemDescount20per"];
    [summaryReportDTO setValue:txtTotalItems.text forKey:@"total"];
    
    
    [summaryReportDTO setValue:txtDes1.text forKey:@"mEDescription1"];
    [summaryReportDTO setValue:txtDes2.text forKey:@"mEDescription2"];
    [summaryReportDTO setValue:txtDes3.text forKey:@"mEDescription3"];
    [summaryReportDTO setValue:txtDes4.text forKey:@"mEDescription4"];
    [summaryReportDTO setValue:txtDES5.text forKey:@"mEDescription5"];
    [summaryReportDTO setValue:txtQuantity1.text forKey:@"mEQuantity1"];
    [summaryReportDTO setValue:txtQuantity2.text forKey:@"mEQuantity2"];
    [summaryReportDTO setValue:txtQuantity3.text forKey:@"mEQuantity3"];
    [summaryReportDTO setValue:txtQuantity4.text forKey:@"mEQuantity4"];
    [summaryReportDTO setValue:txtQuantity5.text forKey:@"mEQuantity5"];
    [summaryReportDTO setValue:txtUnitPrice1.text forKey:@"mEUnitPrice1"];
    [summaryReportDTO setValue:txtUnitPrice2.text forKey:@"mEUnitPrice2"];
    [summaryReportDTO setValue:txtUnitPrice3.text forKey:@"mEUnitPrice3"];
    [summaryReportDTO setValue:txtUnitPrice4.text forKey:@"mEUnitPrice4"];
    [summaryReportDTO setValue:txtUnitPrice5.text forKey:@"mEUnitPrice5"];
    [summaryReportDTO setValue:txtMAmt1.text forKey:@"mEAmount1"];
    [summaryReportDTO setValue:txtMAmt2.text forKey:@"mEAmount2"];
    [summaryReportDTO setValue:txtMAmt3.text forKey:@"mEAmount3"];
    [summaryReportDTO setValue:txtMAmt4.text forKey:@"mEAmount4"];
    [summaryReportDTO setValue:txtMAmt5.text forKey:@"mEAmount5"];
    [summaryReportDTO setValue:txtTotalMeterial.text forKey:@"total1"];
    [summaryReportDTO setValue:txtLessDiscount.text forKey:@"lessDiscount"];
    [summaryReportDTO setValue:txtLessDisTotal.text forKey:@"total2"];
    [summaryReportDTO setValue:txtAdditional.text forKey:@"additionalDiscount"];
    [summaryReportDTO setValue:txtAddTotal.text forKey:@"total3"];
//
//    
//    
    [summaryReportDTO setValue:txtSize1.text forKey:@"eQSizeandClass1"];
    [summaryReportDTO setValue:txtSize2.text forKey:@"eQSizeandClass2"];
    [summaryReportDTO setValue:txtSize3.text forKey:@"eQSizeandClass3"];
    [summaryReportDTO setValue:txtSize4.text forKey:@"eQSizeandClass4"];
    [summaryReportDTO setValue:txtSize5.text forKey:@"eQSizeandClass5"];
    [summaryReportDTO setValue:txtActive1.text forKey:@"eQIdleActive1"];
    [summaryReportDTO setValue:txtActive2.text forKey:@"eQIdleActive2"];
    [summaryReportDTO setValue:txtActive3.text forKey:@"eQIdleActive3"];
    [summaryReportDTO setValue:txtActive4.text forKey:@"eQIdleActive4"];
    [summaryReportDTO setValue:txtActive5.text forKey:@"eQIdleActive5"];
    [summaryReportDTO setValue:txtENo1.text forKey:@"eQNo1"];
    [summaryReportDTO setValue:txtENo2.text forKey:@"eQNo2"];
    [summaryReportDTO setValue:txtENo3.text forKey:@"eQNo3"];
    [summaryReportDTO setValue:txtENo4.text forKey:@"eQNo4"];
    [summaryReportDTO setValue:txtENo5.text forKey:@"eQNo5"];
    [summaryReportDTO setValue:txtETotal1.text forKey:@"eQTotalHours1"];
    [summaryReportDTO setValue:txtETotal2.text forKey:@"eQTotalHours2"];
    [summaryReportDTO setValue:txtEtotal3.text forKey:@"eQTotalHours3"];
    [summaryReportDTO setValue:txtETotal4.text forKey:@"eQTotalHours4"];
    [summaryReportDTO setValue:txtETotal5.text forKey:@"eQTotalHours5"];
    
    
      [summaryReportDTO setValue:txtRate1.text forKey:@"eQRAte1"];
      [summaryReportDTO setValue:txtRate2.text forKey:@"eQRAte2"];
      [summaryReportDTO setValue:txtRate3.text forKey:@"eQRAte3"];
      [summaryReportDTO setValue:txtRate4.text forKey:@"eQRAte4"];
      [summaryReportDTO setValue:txtRate5.text forKey:@"eQRAte5"];
    [summaryReportDTO setValue:txtEAmt1.text forKey:@"eQAmount1"];
    [summaryReportDTO setValue:txtEAmt2.text forKey:@"eQAmount2"];
    [summaryReportDTO setValue:txtEAmt3.text forKey:@"eQAmount3"];
    [summaryReportDTO setValue:txtEAmt4.text forKey:@"eQAmount4"];
    [summaryReportDTO setValue:txtEAmt5.text forKey:@"eQAmount5"];
    [summaryReportDTO setValue:txtDailyTotal.text forKey:@"dailyTotal"];
    [summaryReportDTO setValue:txtTotalDate.text forKey:@"total_to_date"];
    
    [summaryReportDTO setValue:SMNo forKey:@"sMSheetNo"];


//
//




    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSummaryForm" object:nil userInfo:summaryReportDTO];
}


-(IBAction)fnDelete:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeDashboard" object:nil];
    
    SummarySheet1 *summarySheet1;
    NSError *retrieveError;
    
    NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SummarySheet1" inManagedObjectContext:managedContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(sMSheetNo = %@)", SMNo];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedObjects = [managedContext executeFetchRequest:fetchRequest error:&retrieveError];
    
    if (fetchedObjects && [fetchedObjects count] > 0) {
        summarySheet1 = [fetchedObjects objectAtIndex:0];
        [managedContext deleteObject:summarySheet1];
        if (![managedContext save:&retrieveError]) {
            NSLog(@"Whoops, couldn't delete: %@", [retrieveError localizedDescription]);
        } else {
            NSLog(@"Deleted: %@", SMNo);
        }
    }
    
    SummarySheet2 *summarySheet2;
    entity = [NSEntityDescription entityForName:@"SummarySheet2" inManagedObjectContext:managedContext];
    [fetchRequest setEntity:entity];
    predicate = [NSPredicate predicateWithFormat:@"(sMSSheetNo = %@)", SMNo];
    [fetchRequest setPredicate:predicate];
    
    fetchedObjects = [managedContext executeFetchRequest:fetchRequest error:&retrieveError];
    
    if (fetchedObjects && [fetchedObjects count] > 0) {
        summarySheet2 = [fetchedObjects objectAtIndex:0];
        [managedContext deleteObject:summarySheet2];
        if (![managedContext save:&retrieveError]) {
            NSLog(@"Whoops, couldn't delete: %@", [retrieveError localizedDescription]);
        } else {
            NSLog(@"Deleted: %@", SMNo);
        }
    }
    
    
    SummarySheet3 *summarySheet3;
    entity = [NSEntityDescription entityForName:@"SummarySheet3" inManagedObjectContext:managedContext];
    [fetchRequest setEntity:entity];
    predicate = [NSPredicate predicateWithFormat:@"(sMSheetNo = %@)", SMNo];
    [fetchRequest setPredicate:predicate];
    
    fetchedObjects = [managedContext executeFetchRequest:fetchRequest error:&retrieveError];
    
    if (fetchedObjects && [fetchedObjects count] > 0) {
        summarySheet3 = [fetchedObjects objectAtIndex:0];
        [managedContext deleteObject:summarySheet3];
        if (![managedContext save:&retrieveError]) {
            NSLog(@"Whoops, couldn't delete: %@", [retrieveError localizedDescription]);
        } else {
            NSLog(@"Deleted: %@", SMNo);
        }
    }
    
    
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
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.navigationController.view addSubview:hud];
    hud.labelText=@"";
    hud.dimBackground = YES;
    hud.delegate = self;
    [hud show:YES];
    
    NSManagedObjectContext *context = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSError *error = nil;
    NSEntityDescription *summarySheet1Entity = [NSEntityDescription entityForName:@"SummarySheet1" inManagedObjectContext:context];
    NSEntityDescription *summarySheet2Entity = [NSEntityDescription entityForName:@"SummarySheet2" inManagedObjectContext:context];
    NSEntityDescription *summarySheet3Entity = [NSEntityDescription entityForName:@"SummarySheet3" inManagedObjectContext:context];
    
    [fetchRequest setEntity:summarySheet1Entity];
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"ANY sMSheetNo == %@", SMNo];
    [fetchRequest setPredicate:predicate1];
    NSArray *summary1 = [context executeFetchRequest:fetchRequest error:&error];
    
    NSManagedObject *summary1Obj = (NSManagedObject *) [summary1 objectAtIndex:0];
    NSArray *keys = [[[summary1Obj entity] attributesByName] allKeys];
    NSMutableDictionary *summary1Dict =  [[summary1Obj dictionaryWithValuesForKeys:keys] mutableCopy];
    
    [fetchRequest setEntity:summarySheet2Entity];
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"ANY sMSSheetNo == %@", SMNo];
    [fetchRequest setPredicate:predicate2];
    NSArray *summary2 = [context executeFetchRequest:fetchRequest error:&error];
    
    if ([summary2 count] > 0){
        NSManagedObject *summary2Obj = (NSManagedObject *) [summary2 objectAtIndex:0];
        NSArray *keys = [[[summary2Obj entity] attributesByName] allKeys];
        NSDictionary *summary2Dict = [summary2Obj dictionaryWithValuesForKeys:keys];
        [summary1Dict addEntriesFromDictionary:summary2Dict];
    }
    
    [fetchRequest setEntity:summarySheet3Entity];
    NSPredicate *predicate3 = [NSPredicate predicateWithFormat:@"ANY sMSheetNo == %@", SMNo];
    [fetchRequest setPredicate:predicate3];
    NSArray *summary3 = [context executeFetchRequest:fetchRequest error:&error];
    
    if ([summary3 count] > 0){
        NSManagedObject *summary3Obj = (NSManagedObject *) [summary3 objectAtIndex:0];
        NSArray *keys = [[[summary3Obj entity] attributesByName] allKeys];
        NSDictionary *summary3Dict = [summary3Obj dictionaryWithValuesForKeys:keys];
        [summary1Dict addEntriesFromDictionary:summary3Dict];
    }
    
    if([summary1Dict count] > 0){
        
        id summaryReportObject = summary1Dict;
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
        
        txtActive1.text=[summaryReportObject valueForKey:@"eQIdleActive1"];
        txtActive2.text=[summaryReportObject valueForKey:@"eQIdleActive2"];
        txtActive3.text=[summaryReportObject valueForKey:@"eQIdleActive3"];
        txtActive4.text=[summaryReportObject valueForKey:@"eQIdleActive4"];
        txtActive5.text=[summaryReportObject valueForKey:@"eQIdleActive5"];
        
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
        txtEAmt5.text=[summaryReportObject valueForKey:@"eQAmount5"];
        
        txtInspector.text=[summaryReportObject valueForKey:@"inspector"];
        
        txtContractorRepresentative.text=[summaryReportObject valueForKey:@"contractorRepresentative"];
        txtConReDate.text=[NSDateFormatter localizedStringFromDate:[summaryReportObject valueForKey:@"date2"]
                                                         dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
        
        txtDailyTotal.text=[summaryReportObject valueForKey:@"dailyTotal"];
        txtTotalDate.text=[summaryReportObject valueForKey:@"total_to_date"];
        
        NSString * signName1 = [summaryReportObject valueForKey:@"signature1"];
        NSString * signName2 = [summaryReportObject valueForKey:@"signature2"];
        
        
        imgSignature.image=[PRIMECMController getTheImage:signName1];
        imgSignature2.image=[PRIMECMController getTheImage:signName2];
        
        
    }
    
    [hud setHidden:YES];
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
