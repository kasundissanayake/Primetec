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
    NSDictionary *sourceDictionary;
}

@end

@implementation ExpenceViewController
@synthesize scrollView;
@synthesize ERtextDate6;
@synthesize txtMil1;
@synthesize txtRate1;
@synthesize txtTotal1;
@synthesize cashAdvance;
@synthesize reimburs;
@synthesize imgSignatureEx;
@synthesize imagePicker;
@synthesize isFromSketches;
@synthesize isFromReport;
@synthesize arrayImages;
@synthesize imageAddSubView;
@synthesize imgViewAdd;
@synthesize txvDescription;
@synthesize header;
@synthesize ERtxtEmpName;
@synthesize ERtxtApprovedBy;
@synthesize ERtxtWeek;
@synthesize ERtxtCheckNum;
@synthesize ERdate6;
@synthesize ERDescription;
@synthesize ERJobNo;
@synthesize ERType;
@synthesize exNUmber;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)initWithData:(NSDictionary *)sourceDictionaryParam
{
    self = [super init];
    sourceDictionary = sourceDictionaryParam;
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    // ERtxtEmpNum.text=appDelegate.userId;
    ERtxtEmpName.text=appDelegate.projPrintedName;
    ERtextDate6.text=dateString;
    ERtxtApprovedBy.text=appDelegate.pm;
    
    if(!exNUmber)
        ExpID =  [NSString stringWithFormat:@"EX_%@",[self getCurrentDateTimeAsNSString]];
    else
        ExpID = exNUmber;
    
    if (sourceDictionary != nil && [sourceDictionary valueForKey:@"userInfo"] != nil){
        
        
        ERtxtApprovedBy.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"approvedBy"];
        cashAdvance.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eRCashAdvance"] ;
        ERtxtCheckNum.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"checkNo"];
        txtRate1.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"date"];
        ERtxtEmpName.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eMPName"];
        reimburs.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eRReimbursement"];
        ERtxtWeek.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"weekEnding"];
        
        txtMil1.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eRPAMilage1"];
        txtRate1.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eRPARate1"];
        txtTotal1.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eRTotal1"] ;
        header.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eRFHeader"];
        ERdate6.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eRDate1"];
        
        ERDescription.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eRDescription1"];
        ERJobNo.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eRJobNo1"];
        ERType.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eRType1"];
        exNUmber = [[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"eXReportNo"];
        
        appDelegate.sketchesArray = [[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"sketch_images"] mutableCopy];
        arrayImages = [[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"images_uploaded"] mutableCopy];
    }
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
    [self.navigationController.view addSubview:signatureViewController.view];
    [self createSignatureCloseBtn];
    [self.navigationController.view addSubview:btnCloseSignView];
    
}
-(void)tapDetectedReviewer
{
    isSignature=@"1";
    signatureViewController=[[SignatureViewController alloc]initWithNibName:@"SignatureViewController" bundle:nil];
    signatureViewController.imageViewTag=@"2";
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
    if(textField==txtMil1 || textField==txtRate1 || textField==cashAdvance || textField== reimburs || textField== ERtxtCheckNum  )
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
    
    //Radha
    if(appDelegate.reImp)
    {
        double cash  = [self.cashAdvance.text doubleValue];
        double sum = [appDelegate.reImp doubleValue];
        if (sum > 0)
        {
            double result = sum - cash;
            reimburs.text =  [NSString stringWithFormat:@"%.2f", result];
            if (sum < cash)
            {
                reimburs.text = @"00.00";
            }
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
    
    NSData *imagData = UIImageJPEGRepresentation(image,1.0);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fullPath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", imgNam]];
    BOOL status =  [fileManager createFileAtPath:fullPath contents:imagData attributes:nil];
    if(status)
    {
        if(!imgPath)
        {
            imgPath = [[NSMutableString alloc] init];
            [imgPath appendString:fullPath];
        }
        else
        {
            [imgPath appendString:@","];
            [imgPath appendString:fullPath];
        }
    }
}


- (IBAction)CancelImage:(id)sender {
    
    [self removeAddImageView];
    
}



-(IBAction)saveImage:(id)sender
{
    //Radha
    NSString *imgName=[NSString stringWithFormat:@"EX_%d_%i",arc4random()%100000, count];
    
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
    if(cashAdvance.text==NULL || cashAdvance.text.length==0 || reimburs.text==NULL || reimburs.text.length==0 || ERtxtEmpName.text==NULL || ERtxtEmpName.text.length==0 || imgSignatureEx.image==NULL || ERtextDate6.text==NULL ||  ERtextDate6.text.length==0 || ERtxtApprovedBy.text.length==0 || ERtxtApprovedBy.text==NULL || ERtxtWeek.text==NULL || ERtxtWeek.text.length==0 || ERtxtCheckNum.text==NULL || ERtxtCheckNum.text.length==0)
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
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.navigationController.view addSubview:HUD];
        HUD.labelText=@"";
        HUD.dimBackground = YES;
        HUD.delegate = self;
        [HUD show:YES];
        
        NSString *sigName=[NSString stringWithFormat:@"Signature_R%@",[self getCurrentDateTimeAsNSString]];
        
        NSLog(@" sketch_array - save: %@", appDelegate.sketchesArray);
        NSLog(@" image_array - save: %@", arrayImages);
        
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
        
        NSLog(@"sketches names %@", sketchesNameArray);
        NSLog(@"images names %@", imgNameArray);
        
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
        
        BOOL saveStatus = [PRIMECMController
                           saveExpenseForm:appDelegate.username
                           approvedBy:ERtxtApprovedBy.text
                           eRDate1:ERtextDate6.text
                           checkNo:ERtxtCheckNum.text
                           date:ERdate6.text
                           eRDescription1:ERDescription.text
                           eMPName:ERtxtEmpName.text
                           eRCashAdvance:cashAdvance.text
                           eRFHeader:header.text
                           eRReimbursement:reimburs.text
                           eXReportNo:exNUmber
                           images_uploaded:[imgNameArray componentsJoinedByString:@","]
                           project_id:appDelegate.projId
                           signature:sigName
                           weekEnding:ERtxtWeek.text
                           eRJobNo1:ERJobNo.text
                           eRPAMilage1:txtMil1.text
                           eRPARate1:txtRate1.text
                           eRTotal1:txtTotal1.text
                           eRType1:ERType.text];
        
        ERtxtApprovedBy.text=@" ";
        ERtextDate6.text=@" ";
        ERtxtCheckNum.text=@" ";
        ERdate6.text=@" ";
        txvDescription.text=@" ";
        ERtxtEmpName.text=@" ";
        cashAdvance.text=@" ";
        eRFHeader:header.text=@" ";
        eRReimbursement:reimburs.text=@" ";
        
        ERtxtWeek.text=@" ";
        ERJobNo.text=@" ";
        txtMil1.text=@" ";
        txtRate1.text=@" ";
        txtTotal1.text=@" ";
        ERType.text=@" ";
        
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
        
        if(arrayImages.count>0)
        {
            for (int i = 0; i < arrayImages.count;i++) {
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString* imggName = [[arrayImages objectAtIndex:i] valueForKey:@"name"];
                NSString *folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Images"];
                
                UIImage *image=[self getImageFromFileName:[NSString stringWithFormat:@"%@.jpg", imggName] folderPath:folderPath];
                
                if (image == nil) {
                    image = [PRIMECMController getTheImage:imggName];
                }

                
                NSData *imgData = UIImageJPEGRepresentation(image,0.3);
                
                imageSaveState = [PRIMECMController saveAllImages:imggName img:imgData syncStatus:SYNC_STATUS_PENDING];
                
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
                
                if (image == nil) {
                    image = [PRIMECMController getTheImage:imggName];
                }

                
                NSData *imgData = UIImageJPEGRepresentation(image,1.0);
                sketchSaveState = [PRIMECMController saveAllImages:imggName img:imgData syncStatus:SYNC_STATUS_PENDING];
                
            }
            
        }
        
        [HUD setHidden:YES];
        
        if (saveStatus && singSaveState){
            UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Successfully saved expense report." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [exportAlert show];
            [appDelegate.sketchesArray removeAllObjects];
            [arrayImages removeAllObjects];
            //[self deleteImageFiles];
        }else{
            UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to save expense report." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [exportAlert show];
        }
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

@end