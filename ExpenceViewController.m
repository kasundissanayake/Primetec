//
//  ExpenceViewController.m
//  TabAndSplitApp
//
//  Created by Lingeswaran Kandasamy on 4/2/14.
//
//

#import "ExpenceViewController.h"
#import "SignatureViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CMShowImagesViewController.h"
#import "TabAndSplitAppAppDelegate.h"
#import "SDDrawingFileNames.h"
#import "SDDrawingsViewController.h"
#import "PopUpViewController.h"
#import "PRIMECMAPPUtils.h"
#import "PRIMECMController.h"

@interface ExpenceViewController ()
{
    UIPopoverController *popoverController;
    UIPickerView *pickerViewCities;
    NSMutableArray *pickerDataArray;
    NSMutableArray *hotelAnnotations;
    UITableView *tblView;
    NSArray *tableData;
    UIDatePicker *datePicker;
    NSInteger pickerTag;
    UIPickerView *pickerView;
    NSString *isSignature;
    UIButton *btnCloseSignView;
    SignatureViewController *signatureViewController;
    NSString *ifImage;
    TabAndSplitAppAppDelegate *appDelegate;
    NSInteger count;
    NSInteger count1;
    NSInteger count2;
    BOOL uploading;
    BOOL uploadingsketch;
    NSString *comNoticeNo;
    BOOL isUploadingSignature;
    MBProgressHUD *HUD;
    NSMutableData *_receivedData;
    NSURLResponse *_receivedResponse;
    NSError *_connectionError;
    NSArray *resPonse;
    NSString *ExpID;
    NSString *RecID;
    BOOL first;
    BOOL Second;
    BOOL third;
}

@end

@implementation ExpenceViewController
@synthesize  scrollView,ERtextDate6,txtMil1,txtRate1,txtTotal1,cashAdvance,reimburs,imgSignatureEx,imagePicker,isFromSketches,isFromReport,arrayImages,imageAddSubView,imgViewAdd,txvDescription,header,ERtxtEmpName,ERtxtApprovedBy,ERtxtWeek,ERtxtCheckNum,ERdate6,ERtxtEmpNum,ERDescription,ERJobNo,ERType;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self deleteAllFiles];
    count=0;
    comNoticeNo=@"";
    count1=0;
    
    [[self ERdate6] setTintColor:[UIColor clearColor]];
    appDelegate=(TabAndSplitAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.sketchesArray removeAllObjects];
    
    self.imagePicker=[[UIImagePickerController alloc]init];
    arrayImages=[[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getImageReviewer) name:@"DoneSignatureReviewer" object:nil];
    tblView=[[UITableView alloc] initWithFrame:CGRectMake(265, 680, 0, 0) style:UITableViewStylePlain];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMapData:) name:@"ViewControllerAReloadData" object:nil];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back.jpg"]];
    // Do any additional setup after loading the view from its nib.
    scrollView.frame = CGRectMake(0,0, 720, 1988);
    [scrollView setContentSize:CGSizeMake(500, 2300)];
    
    UITapGestureRecognizer *singleTapInspec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetectedInspector)];
    imgSignatureEx.userInteractionEnabled = YES;
    [imgSignatureEx addGestureRecognizer:singleTapInspec];
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormat stringFromDate:today];
    
    ERtxtEmpNum.text=appDelegate.userId;
    ERtxtEmpName.text=appDelegate.projPrintedName;
    ERtextDate6.text=dateString;
    ERtxtApprovedBy.text=appDelegate.pm;
    
    NSString *expID = [PRIMECMController getExpenceIdByProjID:appDelegate.projId];
    
    if(expID != nil)
    {
        ExpID=expID;
        NSLog(@"Inthe");
    }
    else{
        ExpID=@"0";
    }
    
    
    NSString *strURL = [NSString stringWithFormat:@"http://data.privytext.us/contructionapi.php/api/expense/get/id/%@",appDelegate.projId];
     
     NSURL *apiURL =
     [NSURL URLWithString:strURL];
     NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:apiURL];
     
     
     [urlRequest setHTTPMethod:@"GET"];
     first=YES;
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


-(void)getImageReviewer
{
    [self removeSignatureView];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    
    NSString *folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Signature"];
    imgSignatureEx.image=[self getImageFromFileName:[NSString stringWithFormat:@"%@.jpg",@"Signature_R"] folderPath:folderPath];
    
}


-(void)getImageInspector
{
    [self removeSignatureView];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    
    NSString *folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Signature"];
    imgSignatureEx.image=[self getImageFromFileName:[NSString stringWithFormat:@"%@.jpg",@"Signature_R"] folderPath:folderPath];
    
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
    signatureViewController.imageViewTag=@"2";
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
    
    if (cell == nil) {
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
    [popoverController presentPopoverFromBarButtonItem:(UIBarButtonItem *)sender
                              permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

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
    
    popoverContent.contentSizeForViewInPopover = CGSizeMake(320, 244);
    
    //create a popover controller
    popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    CGRect popoverRect = [self.view convertRect:[txtField frame]
                                       fromView:[txtField superview]];
    
    popoverRect.size.width = MIN(popoverRect.size.width, 100) ;
    popoverRect.origin.x  = popoverRect.origin.x;
    [popoverController presentPopoverFromRect:popoverRect inView:self.view  permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField==ERType)
    {
        [ERType resignFirstResponder];
        pickerDataArray=[[NSMutableArray alloc]initWithObjects:@"Office",@"Auto",@"EMPL",@"ENT",@"Travel",@"MISC",@"Personal/Auto",nil];
        [self createPicker:ERType];
        pickerTag=1;
    }
    
    
    if(textField==ERtxtWeek)
    {
        [ERtxtWeek resignFirstResponder];
        [self createDatePicker:ERtxtWeek];
        pickerTag=18;
    }
    
    
    if(textField==ERdate6)
    {
        [ERdate6 resignFirstResponder];
        [self createDatePicker:ERdate6];
        pickerTag=25;
    }
}


-(void)selectionDone
{
    [popoverController dismissPopoverAnimated:YES];
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
    //in the current view to the view's siz
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


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField==txtMil1 || textField==txtRate1 || textField==cashAdvance )
    {
        
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
        for (int i = 0; i < [string length]; i++)
        {
            unichar c = [string characterAtIndex:i];
            if (![myCharSet characterIsMember:c])
            {
                txtMil1.enabled=YES;
                txtRate1.enabled=YES;
                cashAdvance.enabled=YES;
                return NO;
            }
            else{
                
            }
        }
        return YES;
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField==txtTotal1)
    {
        double dist1 = [self.txtMil1.text doubleValue];
        double mileage1 = [self.txtRate1.text doubleValue];
        txtTotal1.text =  [NSString stringWithFormat:@"%.2f",dist1 * mileage1];
        [txtTotal1 resignFirstResponder];
    }
    
    double cash  = [self.cashAdvance.text doubleValue];
    double sum = [appDelegate.reImp doubleValue];
    if (sum > 0)
    {
        
        double totdate = sum;
        double result = totdate - cash;
        reimburs.text =  [NSString stringWithFormat:@"%.2f", result];
        if (totdate < cash)
        {
            reimburs.text = @"00.00";
        }
    }
    
    
    if(textField.text.length==0)
    {
        textField.text=@" ";
    }
}


- (void)TextChange:(id)sender{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    if(pickerTag==18)
    {
        ERtxtWeek.text=[df stringFromDate:datePicker.date];
    }
    if(pickerTag==25)
    {
        ERdate6.text=[df stringFromDate:datePicker.date];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-
#pragma UIPickerView Delegate Methods
#pragma mark-

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return pickerDataArray.count;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerTag==1)
    {
        ERType.text=[pickerDataArray objectAtIndex:[pickerView selectedRowInComponent:0]];
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


-(void)showAddImageView
{
    imageAddSubView.layer.cornerRadius=5;
    imageAddSubView.layer.masksToBounds=YES;
    imageAddSubView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    imageAddSubView.layer.borderWidth = 3.0f;
    [self.view addSubview:imageAddSubView];
    [self.view bringSubviewToFront:imageAddSubView];
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
        if( !( [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error]))
            NSLog(@"[%@] ERROR: attempting to write create Images directory", [self class]);
    }
    
    NSData *imagData = UIImageJPEGRepresentation(image,0.75f);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fullPath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", imgNam]];
    [fileManager createFileAtPath:fullPath contents:imagData attributes:nil];
}


-(IBAction)saveImage:(id)sender
{
    NSString *imgName=[NSString stringWithFormat:@"CM_%i",count];
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
        [arrayImages addObject:imageDictionary];
        [self saveImageTaken:imgViewAdd.image imgName:imgName];
        [self removeAddImageView];
    }
}


-(void)removeAddImageView
{
    txvDescription.text=@"";
    imgViewAdd.image=nil;
    [self.imageAddSubView removeFromSuperview];
    
}
-(IBAction)gotoImageLibrary:(id)sender
{
    if(arrayImages.count!=0)
    {
        CMShowImagesViewController *nextView= [[CMShowImagesViewController alloc]initWithNibName:@"CMShowImagesViewController" bundle:nil];
        nextView.arrayImages=arrayImages;
        nextView.isFromSketches=NO;
        nextView.isFromReport=NO;
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

-(IBAction)doneViewImages:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (IBAction)butSave:(id)sender {
    
    
    if(cashAdvance.text==NULL || cashAdvance.text.length==0 || reimburs.text==NULL || reimburs.text.length==0 || ERtxtEmpName.text==NULL || ERtxtEmpName.text.length==0 || imgSignatureEx.image==NULL || ERtextDate6.text==NULL ||  ERtextDate6.text.length==0 || ERtxtApprovedBy.text.length==0 || ERtxtApprovedBy.text==NULL || ERtxtWeek.text==NULL || ERtxtWeek.text.length==0 || ERtxtEmpNum.text==NULL || ERtxtEmpNum.text.length==0|| ERtxtCheckNum.text==NULL || ERtxtCheckNum.text.length==0)
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
        NSString *sigName=[NSString stringWithFormat:@"Signature_R%@",[self getCurrentDateTimeAsNSString]];
        third=YES;
        first=NO;
        Second=NO;
        NSString *strURL = [NSString stringWithFormat:@"%@/api/expense/update/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@", [PRIMECMAPPUtils getAPIEndpoint],
                            ExpID,header.text,cashAdvance.text,reimburs.text,ERtxtEmpName.text,ERtxtWeek.text,sigName,ERtxtEmpNum.text,ERtxtApprovedBy.text,ERtextDate6.text,@"hi",ERtxtCheckNum.text];
        
        NSLog(@"URL---- %@",strURL);
        
        NSString *uencodedUrl = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *apiURL =
        [NSURL URLWithString:uencodedUrl];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:apiURL];
        [urlRequest setHTTPMethod:@"POST"];
        
        //signature
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Signature"];
        UIImage *image=[self getSignatureFromFileName:[NSString stringWithFormat:@"%@.jpg",@"Signature_R"] folderPath:folderPath];
        NSData *imaData = UIImageJPEGRepresentation(image,0.3);
        NSMutableData *postbody = [NSMutableData data];
        
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [urlRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@.jpg\"\r\n",sigName] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[NSData dataWithData:imaData]];
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSLog(@"^^^^^^^^^^^^^%@",postbody);
        
        [urlRequest setHTTPBody:postbody];
        // uploading=YES;
        
        NSLog(@"sent");
        
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
        cashAdvance.text=NULL;
        cashAdvance.text=NULL;
        reimburs.text=NULL ;
        reimburs.text=NULL;
        ERtxtEmpName.text=NULL;
        ERtxtEmpName.text=NULL;
        imgSignatureEx.image=NULL;
        ERtextDate6.text=NULL;
        ERtextDate6.text=NULL;
        ERtxtApprovedBy.text=NULL;
        ERtxtApprovedBy.text=NULL;
        ERtxtWeek.text=NULL;
        ERtxtWeek.text=NULL;
        ERtxtEmpNum.text=NULL;
        ERtxtEmpNum.text=NULL;
        ERtxtCheckNum.text=NULL;
        ERtxtCheckNum.text=NULL;
    }
}


- (IBAction)butExp:(id)sender {
    uploading = NO;
    uploadingsketch=NO;
    if(ERdate6.text==NULL || ERdate6.text.length==0 || ERDescription.text==NULL || ERDescription.text.length==0 || ERJobNo.text==NULL || ERJobNo.text.length==0 || ERType.text==NULL ||  ERType.text.length==0 || txtMil1.text.length==0 || txtMil1.text==NULL || txtRate1.text==NULL || txtRate1.text.length==0 || txtTotal1.text==NULL || txtTotal1.text.length==0)
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
        Second=YES;
        uploading = NO;
        uploadingsketch=NO;
        first=NO;
        NSString *sigName=[NSString stringWithFormat:@"Signature_%@",[self getCurrentDateTimeAsNSString]];
        
        NSString *strURL = [NSString stringWithFormat:@"%@/api/expense/create/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@", [PRIMECMAPPUtils getAPIEndpoint],
                            ExpID,appDelegate.projId,header.text,ERdate6.text,ERDescription.text,ERJobNo.text,ERType.text,txtMil1.text,txtRate1.text,txtTotal1.text];
        
        NSLog(@"URL---- %@",strURL);
        
        NSString *uencodedUrl = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *apiURL =
        [NSURL URLWithString:uencodedUrl];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:apiURL];
        [urlRequest setHTTPMethod:@"POST"];
        
        //signature
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Signature"];
        UIImage *image=[self getSignatureFromFileName:[NSString stringWithFormat:@"%@.jpg",@"Signature_R"] folderPath:folderPath];
        NSData *imaData = UIImageJPEGRepresentation(image,0.3);
        NSMutableData *postbody = [NSMutableData data];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [urlRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@.jpg\"\r\n",sigName] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[NSData dataWithData:imaData]];
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [urlRequest setHTTPBody:postbody];
        
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
        
        ERdate6.text=NULL;
        ERDescription.text=NULL;
        ERJobNo.text=NULL;
        ERType.text=NULL;
        txtMil1.text=NULL ;
        txtRate1.text=NULL;
        txtTotal1.text=NULL;
    }
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

-(void)uploadImage
{
    NSString *urlLink = [NSString stringWithFormat:@"%@/api/expense/uploadimages/%@/%@/%@/", [PRIMECMAPPUtils getAPIEndpoint],
                         appDelegate.username,RecID,[[arrayImages objectAtIndex:count1] valueForKey:@"name"]];
    
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
    [urlRequest setHTTPBody:postbody];
    uploading=YES;
    first=NO;
    Second=NO;
    third=NO;
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    _receivedData = [[NSMutableData alloc] init];
    [connection start];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _receivedResponse = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData  *)data
{
    [_receivedData appendData:data];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"eeeeee");
    [HUD setHidden:YES];
    _connectionError = error;
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [HUD setHidden:YES];
    NSError *parseError = nil;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:_receivedData options:kNilOptions error:&parseError];
    
    NSLog(@"response---%@",responseObject);
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    if (first) {
        if(![[responseObject valueForKey:@"status"]isEqualToString:@"not found"])
        {
            ExpID=[responseObject valueForKey:@"id"];
            NSLog(@"exp id---------%@",ExpID);
        }
        else{
            ExpID=@"0";
            NSLog(@"exp id---------%@",ExpID);
        }
    }
    else if(Second){
        NSLog(@"rec id---------second secon sec");
        
        if([[responseObject valueForKey:@"status"]isEqualToString:@"sucess"])
        {
            RecID=[responseObject valueForKey:@"record_id"];
            NSLog(@"rec id---------%@",RecID);
            // Second=NO;
            if(arrayImages.count>0)
            {
                count1=0;
                [self uploadImage];
            }
            else
            {
                UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Successfully added." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [exportAlert show];
            }
        }
    }
    else if (uploading) {
        
        uploading=NO;
        count1 ++;
        if(count1< arrayImages.count)
        {
            [self uploadImage];
        }
        else
        {
            UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Successfully added." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [exportAlert show];
        }
    }
    else if(third){
        UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Successfully added." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [exportAlert show];
    }
}
@end
