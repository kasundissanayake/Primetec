//
//  nonComplianceViewController.m
//  PRIMECMAPP
//
//  Created by Lingeswaran Kandasamy on 9/27/14.
//
//

#import "nonComplianceViewController.h"
#import "SignatureViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CMShowImagesViewController.h"
#import "TabAndSplitAppAppDelegate.h"
#import "SDDrawingFileNames.h"
#import "SDDrawingsViewController.h"
#import "PRIMECMAPPUtils.h"
#import "PRIMECMController.h"

@interface nonComplianceViewController ()
{
    UIDatePicker *datePicker;
    NSMutableArray *hotelAnnotations;
    UIPopoverController *popoverController;
    UITableView *tblView;
    NSArray *tableData;
    NSInteger pickerTag;
    
    NSMutableArray *pickerDataArray;
    SignatureViewController *signatureViewController;
    NSString *isSignature;
    UIButton *btnCloseSignView;
    UIPickerView *pickerViewCities;
    NSString *ifImage;
    TabAndSplitAppAppDelegate *appDelegate;
    
    NSInteger count;
    MBProgressHUD *hud;
    NSMutableData *_receivedData;
    NSURLResponse *_receivedResponse;
    NSError *_connectionError;
    NSArray *resPonse;
    BOOL *uploading;
    int count1;
    NSString *comNoticeNo;
    int count2;
    BOOL *uploadingsketch;
    BOOL isUploadingSignature;
    NSUserDefaults *defaults;
    NSDictionary *sourceDictionary1;
}

@end
@implementation nonComplianceViewController
@synthesize scrollView;
@synthesize projectDesc, contractorResp, correctiveAction;
@synthesize NtxtDateIssued, NtxtDateContractorStarted, NtxtDateContractorCompleted, NtxtDate,NtxtDateofRawReprote, DCRC;
@synthesize imgSignature;
@synthesize nonCOtextProject, nonCOtextTitle;
@synthesize imagePicker;
@synthesize isFromReport,isFromSketches;
@synthesize arrayImages,txtTitle;
@synthesize imageAddSubView;
@synthesize imgViewAdd,txvDescription;
@synthesize txtContactNo,txtUserId,txtPrintedName,txtTo,EditNonNoticeNo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithData:(NSDictionary *)sourceDictionaryParam{
    self = [super init];
    sourceDictionary1 = sourceDictionaryParam;
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getImageReviewer) name:@"DoneSignatureReviewer" object:nil];
    
    count=0;
    pickerTag=0;
    appDelegate=(TabAndSplitAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.sketchesArray removeAllObjects];
    
    self.imagePicker=[[UIImagePickerController alloc]init];
    arrayImages=[[NSMutableArray alloc]init];
    
    [projectDesc.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [projectDesc.layer setBorderWidth: 1.0];
    [projectDesc.layer setCornerRadius:8.0f];
    
    [correctiveAction.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [correctiveAction.layer setBorderWidth: 1.0];
    [correctiveAction.layer setCornerRadius:8.0f];
    
    [contractorResp.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [contractorResp.layer setBorderWidth: 1.0];
    [contractorResp.layer setCornerRadius:8.0f];
    
    tblView=[[UITableView alloc] initWithFrame:CGRectMake(265, 680, 0, 0) style:UITableViewStylePlain];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMapData:) name:@"ViewControllerAReloadData" object:nil];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back.jpg"]];
    
    // Do any additional setup after loading the view from its nib.
    scrollView.frame = CGRectMake(0,0, 720, 1988);
    [scrollView setContentSize:CGSizeMake(500, 2300)];
    UITapGestureRecognizer *singleTapInspec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetectedInspector)];
    imgSignature.userInteractionEnabled = YES;
    [imgSignature addGestureRecognizer:singleTapInspec];
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:today];
    
    txtContactNo.text=appDelegate.projId;
    projectDesc.text=appDelegate.projDescription;
    nonCOtextTitle.text=appDelegate.projTitle;
    nonCOtextProject.text=appDelegate.projName;
    txtPrintedName.text=appDelegate.projPrintedName;
    NtxtDate.text=dateString;
    txtUserId.text=appDelegate.userId;
    
    if (sourceDictionary1 != nil && [sourceDictionary1 valueForKey:@"userInfo"] != nil){
        NSLog(@"NonCompliance Form - populating update for non_complianceNoticeNo: %@", [[sourceDictionary1 valueForKey:@"userInfo"] valueForKey:@"non_ComplianceNoticeNo"]);
        projectDesc.text = [[sourceDictionary1 valueForKey:@"userInfo"] valueForKey:@"projectDescription"];
        contractorResp.text = [[sourceDictionary1 valueForKey:@"userInfo"] valueForKey:@"contractorResponsible"];
        correctiveAction.text = [[sourceDictionary1 valueForKey:@"userInfo"] valueForKey:@"descriptionOfNonCompliance"];
        NtxtDateIssued.text = [[sourceDictionary1 valueForKey:@"userInfo"] valueForKey:@"dateIssued"];
        NtxtDateContractorStarted.text = [[sourceDictionary1 valueForKey:@"userInfo"] valueForKey:@"dateContractorStarted"];
        NtxtDateContractorCompleted.text = [[sourceDictionary1 valueForKey:@"userInfo"] valueForKey:@"dateContractorCompleted"];
        NtxtDate.text = [[sourceDictionary1 valueForKey:@"userInfo"] valueForKey:@"date"];
        NtxtDateofRawReprote.text = [[sourceDictionary1 valueForKey:@"userInfo"] valueForKey:@"dateOfDWRReported"];
        DCRC.text = [[sourceDictionary1 valueForKey:@"userInfo"] valueForKey:@"dateCRTCB"];
        txtTo.text = [[sourceDictionary1 valueForKey:@"userInfo"] valueForKey:@"to"];
        EditNonNoticeNo.text = [[sourceDictionary1 valueForKey:@"userInfo"] valueForKey:@"non_ComplianceNoticeNo"];
        
        appDelegate.sketchesArray = [[[sourceDictionary1 valueForKey:@"userInfo"] valueForKey:@"sketch_images"] mutableCopy];
        arrayImages = [[[sourceDictionary1 valueForKey:@"userInfo"] valueForKey:@"images_uploaded"] mutableCopy];
    }
}

-(void)getImageReviewer{
    [self removeSignatureView];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    
    NSString *folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Signature"];
    imgSignature.image=[self getImageFromFileName:[NSString stringWithFormat:@"%@.jpg",@"Signature_R"] folderPath:folderPath];
}

-(UIImage *)getImageFromFileName:(NSString *)fileName folderPath:(NSString *)folderPath{
    //get images from document directory
    NSLog(@"image name......%@",fileName);
    UIImage *current_img;
    NSString *fullPath = [folderPath stringByAppendingPathComponent:fileName];
    current_img=[UIImage imageWithContentsOfFile:fullPath];
    NSLog(@"current_img %@",current_img);
    return current_img;
}

-(IBAction)saveNonCompliance:(id)sender{
    if(txtTitle.text==NULL || txtTitle.text.length==0|| txtContactNo.text==NULL || txtContactNo.text.length==0 || projectDesc.text==NULL || projectDesc.text.length==0 || nonCOtextTitle.text==NULL || nonCOtextTitle.text.length==0||nonCOtextProject.text==NULL || nonCOtextProject.text.length==0||NtxtDateIssued.text==NULL || NtxtDateIssued.text.length==0||contractorResp.text==NULL || contractorResp.text.length==0|| txtTo.text==NULL || txtTo.text.length==0|| NtxtDateContractorStarted.text==NULL || NtxtDateContractorStarted.text.length==0|| NtxtDateContractorCompleted.text==NULL || NtxtDateContractorCompleted.text.length==0||NtxtDateofRawReprote.text==NULL || NtxtDateofRawReprote.text.length==0 || correctiveAction.text==NULL || correctiveAction.text.length==0 ||imgSignature.image==NULL||txtPrintedName.text==NULL || txtPrintedName.text.length==0 || txtUserId.text==NULL || txtUserId.text.length==0 || DCRC.text == NULL || DCRC.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty"
                                                        message:@"Please fill all the fields"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else{
        
        NSString *sigName=[NSString stringWithFormat:@"Signature_R%@",[self getCurrentDateTimeAsNSString]];
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.navigationController.view addSubview:hud];
        hud.labelText=@"";
        hud.dimBackground = YES;
        hud.delegate = self;
        [hud show:YES];
        NSMutableArray *sketchesNameArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < appDelegate.sketchesArray.count; i++){
            NSString* imggName = [[appDelegate.sketchesArray objectAtIndex:i] valueForKey:@"name"];
            [sketchesNameArray addObject:imggName];
        }
        NSMutableArray *imgNameArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < arrayImages.count; i++){
            NSString* imggName = [[arrayImages objectAtIndex:i] valueForKey:@"name"];
            [imgNameArray addObject:imggName];
        }
        BOOL saveStatus = [PRIMECMController
                           saveNonComplianceForm:appDelegate.username
                           non_ComplianceNoticeNo:EditNonNoticeNo.text
                           title:txtTitle.text
                           contractNo:txtContactNo.text
                           comTitle:txtTitle.text
                           dateIssued:NtxtDateIssued.text
                           conRespon:contractorResp.text
                           to:txtTo.text
                           dateDCRC:DCRC.text
                           dateConStarted:NtxtDateContractorStarted.text
                           dateConComplteted:NtxtDateContractorCompleted.text
                           dateRawReport:NtxtDateofRawReprote.text
                           userId:txtUserId.text
                           correctiveAction:correctiveAction.text
                           signature:sigName
                           printedName:txtPrintedName.text
                           projId:appDelegate.projId
                           sketchImg:[sketchesNameArray componentsJoinedByString:@","]
                           images_uploaded:[imgNameArray componentsJoinedByString:@","]
                           ];
        txtContactNo.text = @"";
        projectDesc.text=@"";
        nonCOtextTitle.text=@"";
        NtxtDateIssued.text=@"";
        nonCOtextTitle.text=@"";
        nonCOtextProject.text=@"";
        contractorResp.text=@"";
        txtTo.text=@"";
        txtTo.text=@"";
        DCRC.text=@"";
        NtxtDateContractorStarted.text=@"";
        NtxtDateContractorCompleted.text=@"";
        NtxtDateofRawReprote.text=@"";
        txtUserId.text=@"";
        correctiveAction.text=@"";
        imgSignature.image=NULL;
        txtPrintedName.text=@"";
        NtxtDate.text=@"";
        
        [hud setHidden:YES];
        BOOL imageSaveState;
        BOOL sketchSaveState;
        BOOL singSaveState;
        
        //Signature to coredata
        
        NSArray *pathsSign = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectorySign = [pathsSign objectAtIndex:0];
        NSString *folderPathSign= [documentsDirectorySign stringByAppendingPathComponent:@"/Signature"];
        UIImage *imageSign=[self getSignatureFromFileName:[NSString stringWithFormat:@"%@.jpg",@"Signature_R"] folderPath:folderPathSign];
        NSData *imaDataSign = UIImageJPEGRepresentation(imageSign,1.0);
        singSaveState = [PRIMECMController saveAllImages:sigName img:imaDataSign syncStatus:SYNC_STATUS_PENDING];
        
        if(arrayImages.count>0){
            for (int i = 0; i < arrayImages.count;i++) {
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString* imggName = [[arrayImages objectAtIndex:i] valueForKey:@"name"];
                NSString *folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Images"];
                
                UIImage *image=[self getImageFromFileName:[NSString stringWithFormat:@"%@.jpg", imggName] folderPath:folderPath];
                if (image == nil) {
                    image = [PRIMECMController getTheImage:imggName];
                }
                NSData *imgData = UIImageJPEGRepresentation(image,1.0);
                imageSaveState = [PRIMECMController saveAllImages:imggName img:imgData syncStatus:SYNC_STATUS_PENDING];
            }
        }
        if(appDelegate.sketchesArray.count>0){
            for (int i=0;i < appDelegate.sketchesArray.count;i++) {
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *folderPath= [documentsDirectory stringByAppendingPathComponent:@"/DESK"];
                NSString *imggName = [[appDelegate.sketchesArray objectAtIndex:i] valueForKey:@"name"];
                UIImage *image=[self getImageFromFileName:[NSString stringWithFormat:@"%@.jpg", imggName] folderPath:folderPath];
                if (image == nil) {
                    image = [PRIMECMController getTheImage:imggName];
                }
                NSData *imgData = UIImageJPEGRepresentation(image,1.0);
                sketchSaveState = [PRIMECMController saveAllImages:imggName img:imgData syncStatus:SYNC_STATUS_PENDING];
            }
        }
        [hud setHidden:YES];
        if (saveStatus && singSaveState){
            UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Successfully saved Non-Compliance report." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [exportAlert show];
            [appDelegate.sketchesArray removeAllObjects];
            [arrayImages removeAllObjects];
            [self deleteImageFiles];
        }else{
            UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to save Non-Compliance report." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [exportAlert show];
        }
    }
}

-(void)deleteImageFiles{
    NSFileManager *fileMgr = [[NSFileManager alloc] init];
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *folderPath= [documentsDirectory stringByAppendingPathComponent:@"/DESK"];
    NSArray *directoryContents = [fileMgr contentsOfDirectoryAtPath:folderPath error:&error];
    if (error == nil) {
        for (NSString *path in directoryContents) {
            NSString *fullPath = [folderPath stringByAppendingPathComponent:path];
            BOOL removeSuccess = [fileMgr removeItemAtPath:fullPath error:&error];
            if (!removeSuccess) {
                // Error handling
            }
        }
    } else {
        // Error handling
    }
    
    folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Images"];
    directoryContents = [fileMgr contentsOfDirectoryAtPath:folderPath error:&error];
    if (error == nil) {
        for (NSString *path in directoryContents) {
            NSString *fullPath = [folderPath stringByAppendingPathComponent:path];
            BOOL removeSuccess = [fileMgr removeItemAtPath:fullPath error:&error];
            if (!removeSuccess) {
                // Error handling
            }
        }
    } else {
        // Error handling
        
    }
}

-(void)tapDetectedInspector{
    isSignature=@"1";
    signatureViewController=[[SignatureViewController alloc]initWithNibName:@"SignatureViewController" bundle:nil];
    [self.navigationController.view addSubview:signatureViewController.view];
    [self createSignatureCloseBtn];
    [self.navigationController.view addSubview:btnCloseSignView];
}

-(void)tapDetectedReviewer{
    isSignature=@"1";
    signatureViewController=[[SignatureViewController alloc]initWithNibName:@"SignatureViewController" bundle:nil];
    [self.navigationController.view addSubview:signatureViewController.view];
    [self createSignatureCloseBtn];
    [self.navigationController.view addSubview:btnCloseSignView];
}


-(void)createSignatureCloseBtn{
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

-(void)removeSignatureView{
    [btnCloseSignView removeFromSuperview];
    [signatureViewController.view removeFromSuperview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [tableData count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.text =[tableData objectAtIndex:indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0){
    }
    if(indexPath.section==0 && indexPath.row==1){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeDashboard" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showSProject" object:nil];
    }
    if(indexPath.section==0 && indexPath.row==2){
    }
    [popoverController dismissPopoverAnimated:YES];
}


-(IBAction)selectType:(id)sender{
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
    [popoverController presentPopoverFromBarButtonItem:(UIBarButtonItem *)sender
                              permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(void)createPicker:(UITextField *)txtField{
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
    popoverContent = [[UIViewController alloc] init];
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
    [datePicker addTarget:self
                   action:@selector(TextChange:)
         forControlEvents:UIControlEventValueChanged];
    UIViewController* popoverContent = [[UIViewController alloc] init];
    UIView* popoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 344)];
    popoverView.backgroundColor = [UIColor whiteColor];
    [popoverView addSubview:pickerToolbar];
    [popoverView addSubview:datePicker];
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
    [popoverController
     presentPopoverFromRect:popoverRect
     inView:self.view
     permittedArrowDirections:UIPopoverArrowDirectionAny
     animated:YES];
}


-(void)selectionDone{
    [popoverController dismissPopoverAnimated:YES];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField==nonCOtextTitle){
        [nonCOtextTitle resignFirstResponder];
        pickerDataArray=[[NSMutableArray alloc]initWithObjects:@"Middletown Construction",@"Hartford Construction",@"Rockyhill Construction",nil];
        [self createPicker:nonCOtextTitle];
        pickerTag=6;
    }
    if(textField==nonCOtextProject){
        [nonCOtextProject resignFirstResponder];
        pickerDataArray=[[NSMutableArray alloc]initWithObjects:@"Middletown Project",@"Hartford Project",@"Rockyhill project",nil];
        [self createPicker:nonCOtextProject];
        pickerTag=7;
    }
    if(textField==NtxtDateIssued){
        [NtxtDateIssued resignFirstResponder];
        [self createDatePicker:NtxtDateIssued];
        pickerTag=1;
    }
    if(textField==NtxtDateContractorStarted){
        [NtxtDateContractorStarted resignFirstResponder];
        [self createDatePicker:NtxtDateContractorStarted];
        pickerTag=2;
    }
    if(textField==NtxtDateContractorCompleted){
        [NtxtDateContractorCompleted resignFirstResponder];
        [self createDatePicker:NtxtDateContractorCompleted];
        pickerTag=3;
    }
    if(textField==NtxtDate){
        [NtxtDate resignFirstResponder];
        [self createDatePicker:NtxtDate];
        pickerTag=4;
    }
    if(textField==NtxtDateofRawReprote){
        [NtxtDateofRawReprote resignFirstResponder];
        [self createDatePicker:NtxtDateofRawReprote];
        pickerTag=5;
    }
    if(textField==DCRC){
        [DCRC resignFirstResponder];
        [self createDatePicker:DCRC];
        pickerTag=6;
    }
    
    if(textField==txtTitle){
        txtTitle.borderStyle=UITextBorderStyleLine;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField==txtTitle){
        txtTitle.borderStyle=UITextBorderStyleNone;
    }
}
- (void)TextChange:(id)sender{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    if(pickerTag==1){
        NtxtDateIssued.text=[df stringFromDate:datePicker.date];
    }
    else if(pickerTag==2){
        NtxtDateContractorStarted.text=[df stringFromDate:datePicker.date];
    }
    else if(pickerTag==3){
        NtxtDateContractorCompleted.text=[df stringFromDate:datePicker.date];
    }
    else if(pickerTag==4){
        NtxtDate.text=[df stringFromDate:datePicker.date];
    }
    else if(pickerTag==5){
        NtxtDateofRawReprote.text=[df stringFromDate:datePicker.date];
    }
    else if(pickerTag==6){
        DCRC.text=[df stringFromDate:datePicker.date];
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return pickerDataArray.count;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(pickerTag==6){
        nonCOtextTitle.text=[pickerDataArray objectAtIndex:[pickerView selectedRowInComponent:0]];
    }
    else if(pickerTag==7){
        nonCOtextProject.text=[pickerDataArray objectAtIndex:[pickerView selectedRowInComponent:0]];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [pickerDataArray objectAtIndex:row];
}


// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    CGFloat componentWidth = 0.0;
	componentWidth = 320.0;
	return componentWidth;
}

-(void)showAddImageView{
    imageAddSubView.layer.cornerRadius=5;
    imageAddSubView.layer.masksToBounds=YES;
    imageAddSubView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    imageAddSubView.layer.borderWidth = 3.0f;
    [self.navigationController.view addSubview:imageAddSubView];
    [self.navigationController.view bringSubviewToFront:imageAddSubView];
}

-(IBAction)attachImage:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attach an image"
                                                    message:@""
                                                   delegate:nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Library",@"Camera", nil];
    alert.delegate=self;
    alert.tag=200;
    [alert show];
}

- (IBAction)handwritingButtonClicked:(id)sender{
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

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    count++;
    UIImage *newImage=[info objectForKey:UIImagePickerControllerOriginalImage];
    [popoverController dismissPopoverAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    imgViewAdd.image=newImage;
    [self showAddImageView];
}

-(NSString*)getCurrentDateTimeAsNSString{
    //get current datetime as image name
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-ddHH:mm:ss"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [format setLocale:locale];
    NSDate *now = [NSDate date];
    NSString *retStr = [format stringFromDate:now];
    return retStr;
}

-(void)saveImageTaken:(UIImage *)image imgName:(NSString *)imgNam{
    //store image in ducument directory.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *folderPath;
    folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Images"];
    NSLog(@"folderPath--- %@",folderPath);
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath]){
        NSError *error;
        if( ! ([[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error]))
            NSLog(@"[%@] ERROR: attempting to write create Images directory", [self class]);
    }
    
    NSData *imagData = UIImageJPEGRepresentation(image,1.0);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fullPath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", imgNam]];
    [fileManager createFileAtPath:fullPath contents:imagData attributes:nil];
}



- (IBAction)CancelImage:(id)sender {
    
    [self removeAddImageView];
    
}




-(IBAction)saveImage:(id)sender{
    NSString *imgName=[NSString stringWithFormat:@"non_compliance_%@_%@_%d",appDelegate.projId, appDelegate.username, arc4random()%10000];
    if(txvDescription.text.length==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty"
                                                        message:@"Please add photo Description."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
    else{
        NSLog(@"Add Image----------------%@",imgName);
        NSMutableDictionary *imageDictionary = [[NSMutableDictionary alloc] init];
        imageDictionary=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                         [NSString stringWithFormat:@"%i",count], @"tag",
                         txvDescription.text, @"description",
                         imgName, @"name",
                         nil];
        [arrayImages addObject:imageDictionary];
        [self saveImageTaken:imgViewAdd.image imgName:imgName];
        [self removeAddImageView];
    }
}

-(void)removeAddImageView{
    txvDescription.text=@"";
    imgViewAdd.image=nil;
    [self.imageAddSubView removeFromSuperview];
}

-(IBAction)gotoImageLibrary:(id)sender{
    if(arrayImages.count!=0){
        CMShowImagesViewController *nextView= [[CMShowImagesViewController alloc]initWithNibName:@"CMShowImagesViewController" bundle:nil];
        
        NSLog(@"Arrayyy--------- %i",arrayImages.count);
        nextView.arrayImages=arrayImages;
        nextView.isFromSketches=NO;
        nextView.isFromReport=NO;
        [nextView setModalPresentationStyle:UIModalPresentationFormSheet];
        [self presentViewController:nextView animated:true completion:nil];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty"
                                                        message:@"No images to display"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        
    }
}
-(IBAction)gotoSketches:(id)sender{
    if(appDelegate.sketchesArray.count!=0){
        CMShowImagesViewController *nextView= [[CMShowImagesViewController alloc]initWithNibName:@"CMShowImagesViewController" bundle:nil];
        NSLog(@"Arrayyy--------- %i",appDelegate.sketchesArray.count);
        nextView.arrayImages=appDelegate.sketchesArray;
        nextView.isFromSketches=YES;
        nextView.isFromReport=NO;
        [nextView setModalPresentationStyle:UIModalPresentationFormSheet];
        [self presentViewController:nextView animated:true completion:nil];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty"
                                                        message:@"No sketches to display"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        
    }
}

-(UIImage *)getImageFromFileName:(NSString *)fileName{
    //get images from document directory
    NSLog(@"image name......%@",fileName);
    UIImage *current_img;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *folderPath;
    if(isFromSketches){
        folderPath= [documentsDirectory stringByAppendingPathComponent:@"/DESK"];
    }
    else{
        folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Images"];
    }
    NSString *fullPath = [folderPath stringByAppendingPathComponent:fileName];
    current_img=[UIImage imageWithContentsOfFile:fullPath];
    NSLog(@"current_img %@",current_img);
    return current_img;
}

-(UIImage *)getSignatureFromFileName:(NSString *)fileName{
    //get images from document directory
    NSLog(@"image name......%@",fileName);
    UIImage *current_img;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *folderPath;
    if(isFromSketches){
        folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Signature"];
    }
    else{
        folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Signature_R"];
    }
    
    NSString *fullPath = [folderPath stringByAppendingPathComponent:fileName];
    current_img=[UIImage imageWithContentsOfFile:fullPath];
    NSLog(@"current_img %@",current_img);
    return current_img;
}

-(UIImage *)getSignatureFromFileName:(NSString *)fileName folderPath:(NSString *)folderPath{
    //get images from document directory
    NSLog(@"image name......%@",fileName);
    UIImage *current_img;
    NSString *fullPath = [folderPath stringByAppendingPathComponent:fileName];
    current_img=[UIImage imageWithContentsOfFile:fullPath];
    NSLog(@"current_img %@",current_img);
    return current_img;
    
}


-(IBAction)doneViewImages:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark -
#pragma mark Alert Delegates
#pragma mark -
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==200){
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

-(IBAction)camera:(id)sender{
    [self openCamera];
}

-(IBAction)library:(id)sender{
    [self openLibrary];
}

-(void)openCamera{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [self.imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:self.imagePicker animated:YES completion:nil];
        self.imagePicker.delegate=self;
    }
}

-(void)openLibrary{
    [self.imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    if([popoverController isPopoverVisible]){
        [popoverController dismissPopoverAnimated:YES];
    }
    if([popoverController isPopoverVisible]){
        [popoverController dismissPopoverAnimated:YES];
    }
    popoverController = [[UIPopoverController alloc] initWithContentViewController: imagePicker];
    popoverController.delegate = self;
    [popoverController
     presentPopoverFromRect:CGRectMake(120.0,  500.0, 300.0, 300.0)  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    self.imagePicker.delegate=self;
}

-(void)deleteAllFiles{
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
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
