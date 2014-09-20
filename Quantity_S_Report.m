#import "Quantity_S_Report.h"
#import "quantityCellTableViewCell.h"
#import "TabAndSplitAppAppDelegate.h"



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
@synthesize scrollView,selectedDict;


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
    
    //    UIBarButtonItem *Button2 = [[UIBarButtonItem alloc]
    //                                initWithTitle:NSLocalizedString(@"Edit", @"")
    //                                style:UIBarButtonItemStyleDone
    //                                target:self
    //                                action:@selector(fnEdit:)];
    
    
    btnPrint = [[UIBarButtonItem alloc]
                initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(printReport)];
    
    self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:Button,btnEmail,btnPrint, nil];
    // self.navigationItem.leftBarButtonItem = Button2;
    
    appDelegate=(TabAndSplitAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"vvvvvvv,%@",appDelegate.city);
    
    itemDetails=[[NSMutableArray alloc]init];
    
    // [self loadSummerySheet];
    [self loadExpenseDetails];
    [self  loadExpenseEntries];
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
    NSLog(@"changeQuantitySummary in Quantity_S_Report");
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"changeQuantitySummary" object:nil userInfo:NULL];
    
}

-(void)loadExpenseEntries
{
    //QuantitySummaryItems
    //Radha
    //    NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
    //    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //    NSEntityDescription *entity = [NSEntityDescription entityForName:@"QuantitySummaryItems"
    //                                              inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
    //    [fetchRequest setEntity:entity];
    //    [fetchRequest setResultType:NSDictionaryResultType];
    //    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"item_no == %@",[selectedDict objectForKey:@"item_no"]];
    //    [fetchRequest setPredicate:predicate];
    //    //  [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:@"item_no"]];
    //    NSError *error = nil;
    //    NSArray *existingIDs = [managedContext executeFetchRequest:fetchRequest error:&error];
    //    NSLog(@"Down Table values are %@",existingIDs);
    itemDetails = [[NSMutableArray alloc] init];
    itemDetails = [NSMutableArray arrayWithArray:[PRIMECMController getQuantitySummaryDetailsForInspectionID:appDelegate.inspectionID AndItemNum:[selectedDict objectForKey:@"item_no"]]];
    [quantityTable reloadData];
    
    
    
    
    return;
    }

-(IBAction)fnEdit:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeQuantitySummary" object:nil userInfo:selectedDict];
}


-(void)loadExpenseDetails
{
    //Radha
    project.text=[selectedDict valueForKey:@"project"];
    itemNo.text=[selectedDict valueForKey:@"item_no"];
    item.text= [selectedDict valueForKey:@"Description"];
    estQty.text= [NSString stringWithFormat:@"%d",[[selectedDict valueForKey:@"est_qty"] intValue]];
    unit.text= [NSString stringWithFormat:@"%d",[[selectedDict valueForKey:@"unit"] intValue]];
    price.text= [selectedDict valueForKey:@"unit_price"];
    
    project.userInteractionEnabled = NO;
    itemNo.userInteractionEnabled = NO;
    item.userInteractionEnabled = NO;
    estQty.userInteractionEnabled = NO;
    unit.userInteractionEnabled = NO;
    price.userInteractionEnabled = NO;
    
    return;
    
    isquantityTable=YES;
    NSString *strURL = [NSString stringWithFormat:@"http://data.privytext.us/contructionapi.php/api/quantity_summary/report/Lin/%@",appDelegate.iddd];
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



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"aaaaaaaaaaaaaaaaaa");
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [itemDetails count];
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
    
    appDelegate=(TabAndSplitAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    cell.i_Date.text =  [formatter stringFromDate:[[itemDetails valueForKey:@"date"]objectAtIndex:indexPath.row]];
    cell.i_number.text = [[itemDetails valueForKey:@"no"]objectAtIndex:indexPath.row];
    cell.i_Accum.text = [NSString stringWithFormat:@"%d",[self calculateAccumForRowNumber:indexPath.row]]  ;
    cell.i_Daily.text = [NSString stringWithFormat:@"%d",[[[itemDetails valueForKey:@"qty"]objectAtIndex:indexPath.row] intValue]];
    cell.location_station.text = appDelegate.city;
    
    //    NSString *locationStr =  [[itemDetails valueForKey:@"location_station"]objectAtIndex:indexPath.row];
    //    if(locationStr)
    //    {
    //       if([locationStr isKindOfClass:[NSNull class]] || [locationStr length] == 0 || [locationStr isEqualToString:@"(null)"])
    //           locationStr = @"";
    //    }
    
    
    return cell;
}
-(int)calculateAccumForRowNumber:(int)count
{
    int accum = 0;
    for (int i = 0; i<= count; i++) {
        accum += [[[itemDetails valueForKey:@"qty"] objectAtIndex:i] intValue];
    }
    return accum;
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [HUD setHidden:YES];
    
    NSError *parseError = nil;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:_receivedData options:kNilOptions error:&parseError];
    
    NSLog(@"count---%@",responseObject);
    if(isquantityTable){
        
        isquantityTable=YES;
        
        project.text=[[responseObject valueForKey:@"quantity_summary"]valueForKey:@"project"];
        itemNo.text=[[responseObject valueForKey:@"quantity_summary"]valueForKey:@"item_no"];
        item.text= [[responseObject valueForKey:@"quantity_summary"]valueForKey:@"Description"];
        item.text= [[responseObject valueForKey:@"quantity_summary"]valueForKey:@"Description"];
        estQty.text= [[responseObject valueForKey:@"quantity_summary"]valueForKey:@"est_qty"];
        unit.text= [[responseObject valueForKey:@"quantity_summary"]valueForKey:@"unit"];
        price.text= [[responseObject valueForKey:@"quantity_summary"]valueForKey:@"unit_price"];
        
        [self loadExpenseEntries];
    }
    else    {
        /* itemDetails=[[responseObject valueForKey:@"quantity_summary"]mutableCopy];
         
         NSLog(@"Count-------%@",itemDetails);
         
         
         [self.quantityTable reloadData];
         [self loadExpenseEntries];*/
        
        NSInteger count =[[responseObject valueForKey:@"quantity_summary"] count];
        NSLog(@"count--- %i",count);
        itemDetails=[[NSMutableArray alloc]init];
        
        itemDetails=[[responseObject valueForKey:@"quantity_summary"]mutableCopy];
        NSLog(@"details---------%@",itemDetails);
        [quantityTable reloadData];
    }
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