#import "Quantity_S_Report.h"
#import "quantityCellTableViewCell.h"
#import "TabAndSplitAppAppDelegate.h"
#import "QuantityEstimateForm.h"


@interface Quantity_S_Report ()
@end
@implementation Quantity_S_Report



NSMutableData *_receivedData;
NSURLResponse *_receivedResponse;
NSError *_connectionError;
NSArray *resPonse;
MBProgressHUD *HUD;
UIBarButtonItem  *btnPrint;
BOOL isquantityTable;
NSMutableArray *itemDetails;
TabAndSplitAppAppDelegate *appDelegate;
NSDictionary *sourceDictionary;

@synthesize QNo,project,item,itemNo,estQty,unit,price,quantityTable,tblView;
@synthesize scrollView,selectedDict,date;


- (id)initWithData:(NSDictionary *)sourceDictionaryParam
{
    self = [super init];
    sourceDictionary = sourceDictionaryParam;
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // scrollView.frame = CGRectMake(0,0, 720, 1800);
    [scrollView setContentSize:CGSizeMake(700, 1500)];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back.jpg"]];
    
    UIBarButtonItem  *btnEmail = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(createPDF)];
    
    UIBarButtonItem *Button = [[UIBarButtonItem alloc]
                               initWithTitle:NSLocalizedString(@"New", @"")
                               style:UIBarButtonItemStyleDone
                               target:self
                               action:@selector(showQuantitySummaryForm:)];
    
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
    
    
    btnPrint = [[UIBarButtonItem alloc]
                initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(printReport)];
    
    self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:Button,btnEmail,btnPrint, nil];
    self.navigationItem.leftBarButtonItems=[NSArray arrayWithObjects:Button2, Button3, nil];
    
    appDelegate=(TabAndSplitAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    itemDetails=[[NSMutableArray alloc]init];
    
    [self populateQtySumReport];
}


-(void) populateQtySumReport
{
    
    NSManagedObjectContext *context = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"QuantityEstimateForm" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"qtyEstID=%@", QNo];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    
    NSLog(@"Test Lin%@",objects);
    
    if([objects count] > 0){
        
        
        NSManagedObject *qtySummaryReportObject = (NSManagedObject *) [objects objectAtIndex:0];
        NSLog(@"QuantityEstimateForm object QNo: %@", [qtySummaryReportObject valueForKey:@"qtyEstID"]);
        
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:@"yyyy-MM-dd"];
        
        itemNo.text=[qtySummaryReportObject valueForKey:@"item_no"];
        estQty.text= [NSString stringWithFormat:@"%d",[[qtySummaryReportObject valueForKey:@"est_qty"] intValue]];
        unit.text= [qtySummaryReportObject valueForKey:@"unit"];
        price.text= [NSString stringWithFormat:@"%d",[[qtySummaryReportObject valueForKey:@"unit_price"] intValue]];
        
        date.text=[dateFormater stringFromDate:[qtySummaryReportObject valueForKey:@"date"]];
        
        NSArray *arr = [PRIMECMAPPUtils getItemFromNo:itemNo.text];
        if (arr && [arr count] > 0){
            item.text=[arr objectAtIndex:1];
        }
        
        project.userInteractionEnabled = NO;
        itemNo.userInteractionEnabled = NO;
        item.userInteractionEnabled = NO;
        estQty.userInteractionEnabled = NO;
        unit.userInteractionEnabled = NO;
        price.userInteractionEnabled = NO;
        
        id projectObj = [PRIMECMController getProjectFromID:[qtySummaryReportObject valueForKey:@"project_id"]];
        if (projectObj != NULL){
            
            project.text=[projectObj valueForKey:@"p_name"];
        }
        
        itemDetails  =  [NSMutableArray arrayWithArray:[PRIMECMController
                                                        getInspectionSummaryForItemID:itemNo.text]];
        
        
    }else{
        NSLog(@"No matching QuantityEstimateForm with ID: %@", QNo);
    }
    
    [self.quantityTable reloadData];
}

-(IBAction)fnEdit:(id)sender
{
    NSMutableDictionary *qtyEstimateReportDTO = [[NSMutableDictionary alloc] init];
    
    [qtyEstimateReportDTO setValue:itemNo.text forKey:@"item_no"];
    [qtyEstimateReportDTO setValue:estQty.text forKey:@"est_qty"];
    [qtyEstimateReportDTO setValue:unit.text forKey:@"unit"];
    [qtyEstimateReportDTO setValue:price.text forKey:@"unit_price"];
    [qtyEstimateReportDTO setValue:item.text forKey:@"item"];
    //[qtyEstimateReportDTO setValue:date.text forKey:@"date"];
    [qtyEstimateReportDTO setValue:QNo forKey:@"qtyEstID"];
    [qtyEstimateReportDTO setValue:project.text forKey:@"project"];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeQuantitySummaryForm" object:nil userInfo:qtyEstimateReportDTO];
}


-(IBAction)fnDelete:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeDashboard" object:nil];
    
    QuantityEstimateForm *assp;
    NSError *retrieveError;
    
    NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"QuantityEstimateForm"
                                              inManagedObjectContext:managedContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(qtyEstID = %@)", QNo];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedObjects = [managedContext executeFetchRequest:fetchRequest error:&retrieveError];
    
    if (fetchedObjects && [fetchedObjects count] > 0) {
        assp = [fetchedObjects objectAtIndex:0];
        [managedContext deleteObject:assp];
        if (![managedContext save:&retrieveError]) {
            NSLog(@"Whoops, couldn't delete: %@", [retrieveError localizedDescription]);
        } else {
            NSLog(@"Deleted: %@", QNo);
        }
    }
    
}

-(void)printReport
{
    //[self.tblView setContentOffset:CGPointZero animated:YES];
    [self.quantityTable scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    
    
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
    
    CGContextRef pdfContext = [self createPDFContext:self.quantityTable.bounds path:(CFStringRef)filePath];
    NSLog(@"PDF Context created");
    int count=4;
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
        [self.quantityTable.layer renderInContext:pdfContext];
        CGContextEndPage (pdfContext);
        [self.quantityTable setContentOffset:CGPointMake(0, (i+1) * 730) animated:NO];
        
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
    [self.quantityTable setContentOffset:CGPointMake(self.quantityTable.contentOffset.x, -self.quantityTable.contentInset.top) animated:YES];
    
}

-(void)createPDF
{
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    
    
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
    int count=2;
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
    //  CGContextScaleCTM(pdfContext, 0.773f, 0.1773f);
    
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




-(IBAction)showQuantitySummaryForm:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeQuantitySummary" object:nil userInfo:NULL];
    
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"quantityCell";
    
    quantityCellTableViewCell *cell = (quantityCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"quantityCellTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    cell.i_Date.text =  [formatter stringFromDate:[[itemDetails valueForKey:@"date"]objectAtIndex:indexPath.row]];
    cell.i_number.text = [[itemDetails valueForKey:@"no"]objectAtIndex:indexPath.row];
    cell.i_Accum.text = [NSString stringWithFormat:@"%d",[self calculateAccumForRowNumber:indexPath.row]]  ;
    cell.i_Daily.text = [NSString stringWithFormat:@"%d",[[[itemDetails valueForKey:@"qty"]objectAtIndex:indexPath.row] intValue]];
    cell.location_station.text = appDelegate.city;
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return itemDetails.count;
}

-(int)calculateAccumForRowNumber:(int)count
{
    int accum = 0;
    for (int i = 0; i<= count; i++) {
        accum += [[[itemDetails valueForKey:@"qty"] objectAtIndex:i] intValue];
    }
    return accum;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end