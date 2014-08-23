//
//  ComplianceViewController.m
//  TabAndSplitApp
//
//  Created by Lingeswaran Kandasamy on 4/1/14.
//
//

#import "ComplianceViewController.h"
#import "SignatureViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CMShowImagesViewController.h"
#import "TabAndSplitAppAppDelegate.h"
#import "SDDrawingFileNames.h"
#import "SDDrawingsViewController.h"
#import "PRIMECMAPPUtils.h"
#import "PRIMECMController.h"

@interface ComplianceViewController ()
{
    UIPopoverController *popoverController;
    UIPickerView *pickerView1;
    NSMutableArray *pickerDataArray;
    NSMutableArray *hotelAnnotations;
    UITableView *tblView;
    NSArray *tableData;
    NSInteger pickerTag;
    SignatureViewController *signatureViewController;
    NSString *isSignature;
    UIButton *btnCloseSignView;
    UIPickerView *pickerViewCities;
    NSString *ifImage;
    TabAndSplitAppAppDelegate *appDelegate;
    NSString *imgName;
    NSInteger count;
    MBProgressHUD *hud;
    NSMutableData *_receivedData;
    NSURLResponse *_receivedResponse;
    NSError *_connectionError;
    NSArray *resPonse;
    BOOL *uploading;
    BOOL *uploadingsketch;
    int count1;
    int count2;
    NSString *comNoticeNo;
    BOOL isUploadingSignature;
}

@end

UILabel *cno;
@implementation ComplianceViewController
@synthesize txtDateIssued, txtDateContractorStarted, txtDateContractorCompleted, txtDate,txtDateofRawReprote;
@synthesize  scrollView;
@synthesize  conRes, correctAction;
@synthesize imageSubView;
@synthesize txtSignature;
@synthesize COtextProject, COtextTitle;
@synthesize imagePicker;
@synthesize btnAttachImage;
@synthesize imageAddSubView;
@synthesize imgViewAdd;
@synthesize txvDescription;
@synthesize txtDescription;
@synthesize scrollViewLibrary,pageControl;
@synthesize viewGallery;
@synthesize lblTitle;
@synthesize isFromSketches;
@synthesize isFromReport;
@synthesize librarySubView;
@synthesize arrayImages;
@synthesize txtTitle;
@synthesize datePicker;
@synthesize txtComNoticeNo,title,txtContactNo,txtPrintedName,txtProDesc,txtTo,txtUserId;

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
    //[self deleteAllFiles];
    
    comNoticeNo=@"";
    count=0;
    count1=0;
    
    appDelegate=(TabAndSplitAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.sketchesArray removeAllObjects];
    
    self.imagePicker=[[UIImagePickerController alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getImageReviewer) name:@"DoneSignatureReviewer" object:nil];
    
    //Text View border and styles
    [correctAction.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [correctAction.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [correctAction.layer setBorderWidth: 1.0];
    [correctAction.layer setCornerRadius:8.0f];
    [correctAction.layer setMasksToBounds:YES];
    
    [conRes.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [conRes.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [conRes.layer setBorderWidth: 1.0];
    [conRes.layer setCornerRadius:8.0f];
    [conRes.layer setMasksToBounds:YES];
    
    [txtProDesc.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [txtProDesc.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [txtProDesc.layer setBorderWidth: 1.0];
    [txtProDesc.layer setCornerRadius:8.0f];
    [txtProDesc.layer setMasksToBounds:YES];
    tblView=[[UITableView alloc] initWithFrame:CGRectMake(265, 680, 0, 0) style:UITableViewStylePlain];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back.jpg"]];
    cno.layer.borderWidth = 1.0f;
    cno.layer.cornerRadius = 5.0f;
    cno.layer.borderColor = [UIColor blueColor].CGColor;
    scrollView.frame = CGRectMake(0,860, 820, 1500);
    [scrollView setContentSize:CGSizeMake(420, 2700)];
    UITapGestureRecognizer *singleTapInspec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetectedInspector)];
    txtSignature.userInteractionEnabled = YES;
    [txtSignature addGestureRecognizer:singleTapInspec];
    arrayImages=[[NSMutableArray alloc]init];
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:today];
    txtContactNo.text=appDelegate.projId;
    txtProDesc.text=appDelegate.projDescription;
    COtextTitle.text=appDelegate.projTitle;
    COtextProject.text=appDelegate.projName;
    txtPrintedName.text=appDelegate.projPrintedName;
    txtDate.text=dateString;
    txtUserId.text=appDelegate.userId;
}


-(void)tapDetectedTextField
{
    txtTitle.userInteractionEnabled = YES;
}


-(void)uploadImage
{
    NSString *urlLink = [NSString stringWithFormat:@"%@/api/compliance/uploadimages/%@/%@/%@/", [PRIMECMAPPUtils getAPIEndpoint],
                         appDelegate.username, comNoticeNo, [[arrayImages objectAtIndex:count1] valueForKey:@"name"]];
    
    NSString *unicodeLink = [urlLink stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"URL---%@",unicodeLink);
    
    NSURL *apiURL =
    [NSURL URLWithString:unicodeLink];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:apiURL cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                          timeoutInterval:60.0];
    
    [urlRequest setHTTPMethod:@"POST"];
    NSLog(@"URL DESK----- %@",unicodeLink);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    
    
    NSString *folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Images"];
    NSMutableData *postbody = [NSMutableData data];
    
    
    
    UIImage *image=[self getImageFromFileName:[NSString stringWithFormat:@"%@.jpg", [[arrayImages objectAtIndex:count1] valueForKey:@"name"]] folderPath:folderPath];
    NSData *imaData = UIImageJPEGRepresentation(image,0.3);
    // NSLog(@"********************* UPloadinggggg %i  %@",count1,[arrayImages objectAtIndex:count1]);
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [urlRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@.jpg\"\r\n",[[arrayImages objectAtIndex:count1] valueForKey:@"name"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[NSData dataWithData:imaData]];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"^^^^^^^^^^^^^%@",postbody);
    
    [urlRequest setHTTPBody:postbody];
    uploading=YES;
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    _receivedData = [[NSMutableData alloc] init];
    
    [connection start];
    
    
    NSLog(@"sent");
    
}

-(void)uploadSignature
{
    NSString *urlLink = [NSString stringWithFormat:@"%@/api/compliance/uploadimages/%@/%@/%@/", [PRIMECMAPPUtils getAPIEndpoint],
                         appDelegate.username,comNoticeNo,[[arrayImages objectAtIndex:count1] valueForKey:@"name"]];
    
    NSString *unicodeLink = [urlLink stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"URL---%@",unicodeLink);
    
    NSURL *apiURL =
    [NSURL URLWithString:unicodeLink];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:apiURL cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                          timeoutInterval:60.0];
    
    [urlRequest setHTTPMethod:@"POST"];
    NSLog(@"URL DESK----- %@",unicodeLink);
    //isSendingDecs=YES;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    
    
    NSString *folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Images"];
    NSMutableData *postbody = [NSMutableData data];
    
    
    
    UIImage *image=[self getImageFromFileName:[NSString stringWithFormat:@"%@.jpg", [[arrayImages objectAtIndex:count1] valueForKey:@"name"]] folderPath:folderPath];
    NSData *imaData = UIImageJPEGRepresentation(image,0.3);
    // NSLog(@"********************* UPloadinggggg %i  %@",count1,[arrayImages objectAtIndex:count1]);
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [urlRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@.jpg\"\r\n",[[arrayImages objectAtIndex:count1] valueForKey:@"name"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[NSData dataWithData:imaData]];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"^^^^^^^^^^^^^%@",postbody);
    
    [urlRequest setHTTPBody:postbody];
    uploading=YES;
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    _receivedData = [[NSMutableData alloc] init];
    
    [connection start];
    
    
    NSLog(@"sent");
    
}

-(void)uploadSketch

{
    uploadingsketch=YES;
    NSString *urlLink = [NSString stringWithFormat:@"%@/api/compliance/uploadsketches/%@/%@/%@/", [PRIMECMAPPUtils getAPIEndpoint],
                         appDelegate.username,comNoticeNo,[[appDelegate.sketchesArray objectAtIndex:count2] valueForKey:@"name"]];
    
    NSString *unicodeLink = [urlLink stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"URL---%@",unicodeLink);
    
    NSURL *apiURL =
    [NSURL URLWithString:unicodeLink];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:apiURL cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                          timeoutInterval:60.0];
    
    [urlRequest setHTTPMethod:@"POST"];
    NSLog(@"URL DESK----- %@",unicodeLink);
    //isSendingDecs=YES;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    
    
    NSString *folderPath= [documentsDirectory stringByAppendingPathComponent:@"/DESK"];
    NSMutableData *postbody = [NSMutableData data];
    
    
    
    UIImage *image=[self getImageFromFileName:[NSString stringWithFormat:@"%@.jpg", [[appDelegate.sketchesArray objectAtIndex:count2] valueForKey:@"name"]] folderPath:folderPath];
    NSData *imaData = UIImageJPEGRepresentation(image,0.3);
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [urlRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@.jpg\"\r\n",[[appDelegate.sketchesArray objectAtIndex:count2] valueForKey:@"name"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[NSData dataWithData:imaData]];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"^^^^^^^^^^^^^%@",postbody);
    
    [urlRequest setHTTPBody:postbody];
    
    uploadingsketch=YES;
    
    
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    _receivedData = [[NSMutableData alloc] init];
    
    [connection start];
    
    
    NSLog(@"sent");
    
    
}

-(void)getImageReviewer
{
    [self removeSignatureView];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    
    NSString *folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Signature"];
    txtSignature.image=[self getImageFromFileName:[NSString stringWithFormat:@"%@.jpg",@"Signature_R"] folderPath:folderPath];
}


-(UIImage *)getImageFromFileName:(NSString *)fileName folderPath:(NSString *)folderPath
{
    //get images from document directory
    NSLog(@"image name......%@",fileName);
    UIImage *current_img;
    NSString *fullPath = [folderPath stringByAppendingPathComponent:fileName];
    current_img=[UIImage imageWithContentsOfFile:fullPath];
    NSLog(@"current_img %@",current_img);
    return current_img;
}


-(UIImage *)getSignatureFromFileName:(NSString *)fileName folderPath:(NSString *)folderPath
{
    //get images from document directory
    NSLog(@"image name......%@",fileName);
    UIImage *current_img;
    NSString *fullPath = [folderPath stringByAppendingPathComponent:fileName];
    current_img=[UIImage imageWithContentsOfFile:fullPath];
    NSLog(@"current_img %@",current_img);
    return current_img;
}


-(void)tapDetectedInspector
{
    isSignature=@"1";
    signatureViewController=[[SignatureViewController alloc]initWithNibName:@"SignatureViewController" bundle:nil];
    NSLog(@"get URL image");
    [self.navigationController.view addSubview:signatureViewController.view];
    [self createSignatureCloseBtn];
    [self.navigationController.view addSubview:btnCloseSignView];
    
}

-(void)tapDetectedReviewer
{
    isSignature=@"1";
    signatureViewController=[[SignatureViewController alloc]initWithNibName:@"SignatureViewController" bundle:nil];
    NSLog(@"get URL image");
    [self.navigationController.view addSubview:signatureViewController.view];
    [self createSignatureCloseBtn];
    [self.navigationController.view addSubview:btnCloseSignView];
}


-(void)createSignatureCloseBtn
{
    UIImage* imageNormal = [UIImage imageNamed:@"closeBtn.png"];
    UIImage* imageHighLighted = [UIImage imageNamed:@"closeBtn.png"];
    CGRect frame;
    frame = CGRectMake(617,115,40,40);
    btnCloseSignView = [[UIButton alloc]initWithFrame:frame];
    [btnCloseSignView setBackgroundImage:imageNormal forState:UIControlStateNormal];
    [btnCloseSignView setBackgroundImage:imageHighLighted forState:UIControlStateHighlighted];
    [btnCloseSignView setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnCloseSignView setTitle:@"" forState:UIControlStateNormal];
    [btnCloseSignView setShowsTouchWhenHighlighted:YES];
    [btnCloseSignView addTarget:self action:@selector(removeSignatureView) forControlEvents:UIControlEventTouchUpInside];
}

-(void)removeSignatureView
{
    [btnCloseSignView removeFromSuperview];
    [signatureViewController.view removeFromSuperview];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text =[tableData objectAtIndex:indexPath.row];
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        
    }
    
    if(indexPath.section==0 && indexPath.row==1)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeDashboard" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showSProject" object:nil];
    }
    
    if(indexPath.section==0 && indexPath.row==2)
    {
        
    }
    
    [popoverController dismissPopoverAnimated:YES];
}



-(IBAction)saveCompliance:(id)sender
{
    if(txtTitle.text==NULL || txtTitle.text.length==0|| txtContactNo.text==NULL || txtContactNo.text.length==0 ||  txtProDesc.text==NULL || txtProDesc.text.length==0 || COtextTitle.text==NULL || COtextTitle.text.length==0||COtextProject.text==NULL || COtextProject.text.length==0||txtDateIssued.text==NULL || txtDateIssued.text.length==0||conRes.text==NULL || conRes.text.length==0|| txtTo.text==NULL || txtTo.text.length==0|| txtDateContractorStarted.text==NULL || txtDateContractorStarted.text.length==0|| txtDateContractorCompleted.text==NULL || txtDateContractorCompleted.text.length==0||txtDateofRawReprote.text==NULL || txtDateofRawReprote.text.length==0 || correctAction.text==NULL || correctAction.text.length==0 || txtSignature.image== NULL || txtPrintedName.text==NULL || txtPrintedName.text.length==0 )
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty"
                                                        message:@"Please fill all the fields"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        
    }
    else
    {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.navigationController.view addSubview:hud];
        hud.labelText=@"";
        hud.dimBackground = YES;
        hud.delegate = self;
        [hud show:YES];
        
        NSString *sigName=[NSString stringWithFormat:@"Signature_R%@",[self getCurrentDateTimeAsNSString]];
        
        BOOL saveStatus = [PRIMECMController
                           saveComplianceForm: appDelegate.username
                           title:txtTitle.text
                           contractNo:txtContactNo.text
                           proDesc:txtProDesc.text
                           comTitle:COtextTitle.text
                           project:COtextProject.text
                           dateIssued:txtDateIssued.text
                           conRespon:conRes.text
                           to:txtTo.text
                           dateConStarted:txtDateContractorStarted.text
                           dateConComplteted:txtDateContractorCompleted.text
                           dateRawReport:txtDateofRawReprote.text
                           userId:txtUserId.text
                           correctiveAction:correctAction.text
                           signature:sigName
                           printedName:txtPrintedName.text
                           projId:appDelegate.projId];
        
        txtContactNo.text = @"";
        txtProDesc.text=@"";
        COtextTitle.text=@"";
        COtextProject.text=@"";
        COtextTitle.text=@"";
        COtextProject.text=@"";
        txtDateIssued.text=@"";
        conRes.text=@"";
        txtTo.text=@"";
        txtDateContractorStarted.text=@"";
        txtDateContractorCompleted.text=@"";
        txtDateofRawReprote.text=@"";
        correctAction.text=@"";
        txtSignature.image=NULL;
        txtPrintedName.text=@"";
        txtDate.text=@"";
        
        [hud setHidden:YES];
        BOOL imageSaveState;
        BOOL sketchSaveState;
        BOOL singSaveState;
        
        //Signature to coredata
        
        NSArray *pathsSign = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectorySign = [pathsSign objectAtIndex:0];
        
        NSString *folderPathSign= [documentsDirectorySign stringByAppendingPathComponent:@"/Signature"];
        
        
        UIImage *imageSign=[self getSignatureFromFileName:[NSString stringWithFormat:@"%@.jpg",@"Signature_R"] folderPath:folderPathSign];
        NSData *imaDataSign = UIImageJPEGRepresentation(imageSign,0.3);
        singSaveState = [PRIMECMController saveAllImages:sigName img:imaDataSign];
        
        if(arrayImages.count>0)
        {
            for (int i = 0; i < arrayImages.count;i++) {
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString* imggName = [[arrayImages objectAtIndex:count1] valueForKey:@"name"];
                NSString *folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Images"];
                
                UIImage *image=[self getImageFromFileName:[NSString stringWithFormat:@"%@.jpg", imggName] folderPath:folderPath];
                NSData *imgData = UIImageJPEGRepresentation(image,0.3);
                
                imageSaveState = [PRIMECMController saveAllImages:imggName img:imgData];
                
            }
            
        }
        
        if(appDelegate.sketchesArray.count>0)
        {
            for (int i=0;i < appDelegate.sketchesArray.count;i++) {
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                
                NSString *folderPath= [documentsDirectory stringByAppendingPathComponent:@"/DESK"];
                NSString *imggName = [[appDelegate.sketchesArray objectAtIndex:i] valueForKey:@"name"];
                UIImage *image=[self getImageFromFileName:[NSString stringWithFormat:@"%@.jpg", imggName] folderPath:folderPath];
                NSData *imgData = UIImageJPEGRepresentation(image,0.3);
                singSaveState = [PRIMECMController saveAllImages:imggName img:imgData];
                
            }
            
        }
        
        [hud setHidden:YES];
        
        if (saveStatus && singSaveState){
            UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Successfully saved compliance report." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [exportAlert show];
        }else{
            UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to save compliance report." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [exportAlert show];
        }
    }
}




-(IBAction)selectType:(id)sender
{
    tableData = [NSArray arrayWithObjects:@"",@"Dashboard", @"Help",nil];
    
    UIViewController *popoverContent=[[UIViewController alloc] init];
    [tblView reloadData];
    UIView *popoverView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 300)];
    
    popoverView.backgroundColor=[UIColor whiteColor];
    popoverContent.view=popoverView;
    popoverContent.preferredContentSize=CGSizeMake(250, 150);
    popoverContent.view=tblView; //Adding tableView to popover
    tblView.delegate=self;
    tblView.dataSource=self;
    
    popoverController=[[UIPopoverController alloc]initWithContentViewController:popoverContent];
    //[popoverController presentPopoverFromRect:CGRectMake(400, 675, 0, 0) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    [popoverController presentPopoverFromBarButtonItem:(UIBarButtonItem *)sender
                              permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}
//end


-(void)createPicker:(UITextField *)txtField
{
    
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolbar sizeToFit];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(selectionDone)];
    [barItems addObject:doneBtn];
    [pickerToolbar setItems:barItems animated:YES];
    
    
    pickerViewCities = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 320, 300)];
    pickerViewCities.delegate = self;
    pickerViewCities.showsSelectionIndicator = YES;
    
    
    UIViewController* popoverContent = [[UIViewController alloc] init];
    UIView* popoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 344)];
    popoverView.backgroundColor = [UIColor whiteColor];
    
    
    [popoverView addSubview:pickerToolbar];
    [popoverView addSubview:pickerViewCities];
    popoverContent.view = popoverView;
    
    
    //resize the popover view shown
    //in the current view to the view's size
    popoverContent.preferredContentSize = CGSizeMake(320, 244);
    
    //create a popover controller
    popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    CGRect popoverRect = [self.view convertRect:[txtField frame]
                                       fromView:[txtField superview]];
    
    popoverRect.size.width = MIN(popoverRect.size.width, 100) ;
    popoverRect.origin.x  = popoverRect.origin.x;
    // popoverRect.size.height  = ;
    
    [popoverController
     presentPopoverFromRect:popoverRect
     inView:self.view
     permittedArrowDirections:UIPopoverArrowDirectionUp
     animated:YES];
    
}



-(void)createDatePicker:(UITextField *)txtField{
    
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolbar sizeToFit];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(selectionDone)];
    [barItems addObject:doneBtn];
    
    [pickerToolbar setItems:barItems animated:YES];
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 320, 300)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.hidden = NO;
    datePicker.date = [NSDate date];
    
    
    [datePicker addTarget:self action:@selector(TextChange:) forControlEvents:UIControlEventValueChanged];
    UIViewController* popoverContent = [[UIViewController alloc] init];
    UIView* popoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 344)];
    popoverView.backgroundColor = [UIColor whiteColor];
    
    [popoverView addSubview:pickerToolbar];
    [popoverView addSubview:datePicker];
    popoverContent.view = popoverView;
    popoverContent.preferredContentSize = CGSizeMake(320, 244);
    
    //create a popover controller
    popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    CGRect popoverRect = [self.view convertRect:[txtField frame] fromView:[txtField superview]];
    [popoverController presentPopoverFromRect:popoverRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)selectionDone
{
    [popoverController dismissPopoverAnimated:YES];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField==COtextTitle)
    {
        [COtextTitle resignFirstResponder];
        pickerDataArray=[[NSMutableArray alloc]initWithObjects:@"Middletown Construction",@"Hartford Construction",@"Rockyhill Construction",nil];
        [self createPicker:COtextTitle];
        pickerTag=6;
    }
    if(textField==COtextProject)
    {
        [COtextProject resignFirstResponder];
        pickerDataArray=[[NSMutableArray alloc]initWithObjects:@"Middletown Project",@"Hartford Project",@"Rockyhill project",nil];
        
        [self createPicker:COtextProject];
        pickerTag=7;
    }
    
    if(textField==txtDateIssued)
    {
        [txtDateIssued resignFirstResponder];
        [self createDatePicker:txtDateIssued];
        pickerTag=1;
    }
    if(textField==txtDateContractorStarted)
    {
        [txtDateContractorStarted resignFirstResponder];
        [self createDatePicker:txtDateContractorStarted];
        pickerTag=2;
    }
    if(textField==txtDateContractorCompleted)
    {
        [txtDateContractorCompleted resignFirstResponder];
        [self createDatePicker:txtDateContractorCompleted];
        pickerTag=3;
    }
    if(textField==txtDate)
    {
        [txtDate resignFirstResponder];
        [self createDatePicker:txtDate];
        pickerTag=4;
    }
    if(textField==txtDateofRawReprote)
    {
        [txtDateofRawReprote resignFirstResponder];
        [self createDatePicker:txtDateofRawReprote];
        pickerTag=5;
    }
    if(textField==txtTitle)
    {
        txtTitle.borderStyle=UITextBorderStyleLine;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField==txtTitle)
    {
        txtTitle.borderStyle=UITextBorderStyleNone;
    }
    
}

-(void)textFieldShouldReturn:(UITextField *)textField
{
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return pickerDataArray.count;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if(pickerTag==6)
    {
        COtextTitle.text=[pickerDataArray objectAtIndex:[pickerView selectedRowInComponent:0]];
        
    }
    else if(pickerTag==7)
    {
        COtextProject.text=[pickerDataArray objectAtIndex:[pickerView selectedRowInComponent:0]];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [pickerDataArray objectAtIndex:row];
}


// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    CGFloat componentWidth = 0.0;
	componentWidth = 320.0;
	
	return componentWidth;
}


- (void)TextChange:(id)sender{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    if(pickerTag==1)
    {
        txtDateIssued.text=[df stringFromDate:datePicker.date];
    }
    else if(pickerTag==2)
    {
        txtDateContractorStarted.text=[df stringFromDate:datePicker.date];
    }
    
    else if(pickerTag==3)
    {
        txtDateContractorCompleted.text=[df stringFromDate:datePicker.date];
    }
    else if(pickerTag==4)
    {
        txtDate.text=[df stringFromDate:datePicker.date];
    }
    else if(pickerTag==5)
    {
        txtDateofRawReprote.text=[df stringFromDate:datePicker.date];
    }
    
}

-(void)selectDone
{
    [popoverController dismissPopoverAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)showAddImageView
{
    imageAddSubView.layer.cornerRadius=5;
    imageAddSubView.layer.masksToBounds=YES;
    imageAddSubView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    imageAddSubView.layer.borderWidth = 3.0f;
    
    [self.navigationController.view addSubview:imageAddSubView];
    [self.navigationController.view bringSubviewToFront:imageAddSubView];
    
    NSLog(@"hello");
    // NSLog(@"Add Image----------------%@",imgName);
}


-(IBAction)attachImage:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attach an image"
                                                    message:@""
                                                   delegate:nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Library",@"Camera", nil];
    alert.delegate=self;
    alert.tag=200;
    [alert show];
}


- (IBAction)handwritingButtonClicked:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"NAVIGATE_TO_DRAW"];
    //instantiate the view controller
    NSBundle *bundle = [NSBundle bundleForClass:[SDDrawingsViewController class]];
    UIStoryboard *storyboard;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        storyboard = [UIStoryboard storyboardWithName:@"SDSimpleDrawing_iPad" bundle:bundle];
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"SDSimpleDrawing_iPhone" bundle:bundle];
    }
    SDDrawingsViewController *viewController = [storyboard instantiateInitialViewController];
    //viewController.delegate = self;
    //present the view controller
    [self presentViewController:viewController animated:YES completion:nil];
}

#pragma mark -
#pragma mark imagePicker delegates
#pragma mark -

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    count++;
    UIImage *newImage=[info objectForKey:UIImagePickerControllerOriginalImage];
    
    [popoverController dismissPopoverAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    imgViewAdd.image=newImage;
    [self showAddImageView];
}

-(NSString*)getCurrentDateTimeAsNSString
{
    //get current datetime as image name
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-ddHH:mm:ss"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [format setLocale:locale];
    NSDate *now = [NSDate date];
    NSString *retStr = [format stringFromDate:now];
    return retStr;
}

-(void)saveImageTaken:(UIImage *)image imgName:(NSString *)imgNam
{
    //store image in ducument directory.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *folderPath;
    folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Images"];
    
    NSLog(@"folderPath--- %@",folderPath);
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath]){
        
        NSError *error;
        if(!(  [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error]))
            NSLog(@"[%@] ERROR: attempting to write create Images directory", [self class]);
        
    }
    
    NSData *imagData = UIImageJPEGRepresentation(image,0.75f);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fullPath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", imgNam]];
    [fileManager createFileAtPath:fullPath contents:imagData attributes:nil];
}

-(IBAction)saveImage:(id)sender
{
    imgName=[NSString stringWithFormat:@"CM_%i",count];
    // imageName=@"new";
    // NSLog(@"Add Image----------------%@",imgName);
    if(txvDescription.text.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty"
                                                        message:@"Please add photo Description."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        
    }
    else
    {
        NSLog(@"Add Image----------------%@",imgName);
        NSMutableDictionary *imageDictionary = [[NSMutableDictionary alloc] init];
        imageDictionary=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                         [NSString stringWithFormat:@"%i",count], @"tag",
                         txvDescription.text, @"description",
                         imgName, @"name",
                         nil];
        
        
        NSLog(@"Add Image objjjjjjj-------");
        [arrayImages addObject:imageDictionary];
        [self saveImageTaken:imgViewAdd.image imgName:imgName];
        [self removeAddImageView];
    }
}


-(IBAction)gotoImageLibrary:(id)sender
{
    if(arrayImages.count!=0)
    {
        CMShowImagesViewController *nextView= [[CMShowImagesViewController alloc]initWithNibName:@"CMShowImagesViewController" bundle:nil];
        //nextView.tag=[NSString stringWithFormat:@"%i",btn.tag];
        NSLog(@"Arrayyy--------- %i",arrayImages.count);
        nextView.arrayImages=arrayImages;
        nextView.isFromSketches=NO;
        nextView.isFromReport=NO;
        //nextView.view.frame=CGRectMake(100, 150, 600, 800);
        
        [nextView setModalPresentationStyle:UIModalPresentationFormSheet];
        [self presentViewController:nextView animated:true completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty"
                                                        message:@"No images to display"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        
    }
    
}

-(IBAction)gotoSketches:(id)sender
{
    if(appDelegate.sketchesArray.count!=0)
    {
        CMShowImagesViewController *nextView= [[CMShowImagesViewController alloc]initWithNibName:@"CMShowImagesViewController" bundle:nil];
        //nextView.tag=@"0";
        NSLog(@"Arrayyy--------- %i",appDelegate.sketchesArray.count);
        nextView.arrayImages=appDelegate.sketchesArray;
        nextView.isFromSketches=YES;
        nextView.isFromReport=NO;
        //nextView.view.frame=CGRectMake(100, 150, 600, 800);
        [nextView setModalPresentationStyle:UIModalPresentationFormSheet];
        [self presentViewController:nextView animated:true completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty"
                                                        message:@"No sketches to display"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        
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
    
    if(isFromSketches)
    {
        folderPath= [documentsDirectory stringByAppendingPathComponent:@"/DESK"];
    }
    else
    {
        
        folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Images"];
    }
    
    NSString *fullPath = [folderPath stringByAppendingPathComponent:fileName];
    current_img=[UIImage imageWithContentsOfFile:fullPath];
    NSLog(@"current_img %@",current_img);
    return current_img;
}


-(UIImage *)getSignatureFromFileName:(NSString *)fileName
{
    //get images from document directory
    NSLog(@"image name......%@",fileName);
    UIImage *current_img;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *folderPath;
    
    if(isFromSketches)
    {
        folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Signature"];
    }
    else
    {
        
        folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Signature_R"];
    }
    
    NSString *fullPath = [folderPath stringByAppendingPathComponent:fileName];
    current_img=[UIImage imageWithContentsOfFile:fullPath];
    NSLog(@"current_img %@",current_img);
    return current_img;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}
- (IBAction)changePage{
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.scrollViewLibrary.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollViewLibrary.frame.size;
    [self.scrollViewLibrary scrollRectToVisible:frame animated:YES];
    int page=self.pageControl.currentPage;
    
    txtDescription.text=[[arrayImages objectAtIndex:page]valueForKey:@"description"];
    pageControlBeingUsed = YES;
}

-(IBAction)doneViewImages:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)removeAddImageView
{
    txvDescription.text=@"";
    imgViewAdd.image=nil;
    [self.imageAddSubView removeFromSuperview];
}


#pragma mark -
#pragma mark Alert Delegates
#pragma mark -
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==200)
    {
        switch (buttonIndex) {
            case 0:  //Cancel
                break;
            case 1:
                [self openLibrary];
                
                break;
            case 2:  //Cancel
                [self openCamera];
                break;
            default:
                break;
        }
    }
    
    
}

-(IBAction)camera:(id)sender
{
    [self openCamera];
}

-(IBAction)library:(id)sender
{
    [self openLibrary];
}

-(void)openCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])  {
        [self.imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:self.imagePicker animated:YES completion:nil];
        self.imagePicker.delegate=self;
    }
}

-(void)openLibrary
{
    [self.imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    if([popoverController isPopoverVisible])
	{
        [popoverController dismissPopoverAnimated:YES];
    }
    if([popoverController isPopoverVisible])
    {
        [popoverController dismissPopoverAnimated:YES];
    }
    popoverController = [[UIPopoverController alloc] initWithContentViewController: imagePicker];
    popoverController.delegate = self;
    
    [popoverController
     presentPopoverFromRect:CGRectMake(120.0,  500.0, 300.0, 300.0)  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    self.imagePicker.delegate=self;
}

-(void)deleteAllFiles
{
    NSFileManager *fileMgr = [[NSFileManager alloc] init];
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *directoryContents = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error];
    if (error == nil) {
        for (NSString *path in directoryContents) {
            NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:path];
            BOOL removeSuccess = [fileMgr removeItemAtPath:fullPath error:&error];
            if (!removeSuccess) {
                // Error handling
                
            }
        }
    } else {
        // Error handling
    }
}


@end
