//  DailyInspectionViewController.m
//  TabAndSplitApp
//
//  Created by Lingeswaran Kandasamy on 4/2/14.
//
//

#import "DailyInspectionViewController.h"
#import "SignatureViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CMShowImagesViewController.h"
#import "TabAndSplitAppAppDelegate.h"
#import "SDDrawingFileNames.h"
#import "SDDrawingsViewController.h"
#import "PRIMECMAPPUtils.h"
#import "PRIMECMController.h"

@interface DailyInspectionViewController ()
{
    NSMutableArray *hotelAnnotations;
    UIPopoverController *popoverController;
    UITableView *tblView;
    NSArray *tableData;
    NSInteger pickerTag;
    UIPickerView *pickerView1;
    NSMutableArray *pickerDataArray;
    SignatureViewController *signatureViewController;
    NSString *isSignature;
    UIButton *btnCloseSignView;
    UIPickerView *pickerViewCities;
    NSString *ifImage;
    TabAndSplitAppAppDelegate *appDelegate;
    NSString *imgName;
    NSInteger count;
    MBProgressHUD *HUD;
    NSMutableData *_receivedData;
    NSURLResponse *_receivedResponse;
    NSError *_connectionError;
    NSArray *resPonse;
    BOOL *uploading;
    int count1;
    NSString *comNoticeNo;
    BOOL *uploadingsketch;
    int count2;
    NSUserDefaults *defaults;
    NSDictionary *sourceDictionary;
    MBProgressHUD *hud;
}
@end

@implementation DailyInspectionViewController
@synthesize scrollView;
@synthesize txtDateIN;
@synthesize imgSignatureDaily;
@synthesize imagePicker;
@synthesize isFromReport,isFromSketches;
@synthesize arrayImages;
@synthesize imageAddSubView;
@synthesize imgViewAdd,txvDescription,datePicker;

@synthesize txtName1,txtName2,txtName3,txtName4,txtName5,txtname6,txtDescription1,txtDescription2,txtDescription3,txtDescription4,txtTitle1,txtTitle2,txtTitle3,txtTitle4,txtTitle5,txtTitle6,txtTitle7,txtTitle8,txtCompany1,txtCompany2,txtCompany3,txtCompany4,txtName7,txtName8,txtHours,contractor,txtAddress,txtState,txtCity,txtTel,txtCompetent,txtProject,txtEmail,txtWrkDone,txtHeader,zip;

@synthesize oriCalDays,usedCalDays,ConName,repNo,time,Town,weather,des1,des2,des3,des4,des5,qua1,qua2,qua3,qua4,qua5;

@synthesize textField0,textField1,textField2,textField3,textFiel4;
@synthesize q_itemNo1;
@synthesize q_itemNo2;
@synthesize q_itemNo3;
@synthesize q_itemNo4;
@synthesize q_itemNo5;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    //[self deleteAllFiles];
    
    count=0;
    appDelegate=(TabAndSplitAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.sketchesArray removeAllObjects];
    [arrayImages removeAllObjects];
    
    self.imagePicker=[[UIImagePickerController alloc]init];
    arrayImages=[[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getImageReviewer) name:@"DoneSignatureReviewer" object:nil];
    [txtWrkDone.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [txtWrkDone.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [txtWrkDone.layer setBorderWidth: 1.0];
    [txtWrkDone.layer setCornerRadius:8.0f];
    [txtWrkDone.layer setMasksToBounds:YES];
    tblView=[[UITableView alloc] initWithFrame:CGRectMake(265, 680, 0, 0) style:UITableViewStylePlain];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMapData:) name:@"ViewControllerAReloadData" object:nil];
    
    // Do any additional setup after loading the view from its nib.
    
    scrollView.frame = CGRectMake(0,0, 720, 2900);
    [scrollView setContentSize:CGSizeMake(700, 3250)];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back.jpg"]];
    UITapGestureRecognizer *singleTapInspec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetectedInspector)];
    imgSignatureDaily.userInteractionEnabled = YES;
    [imgSignatureDaily addGestureRecognizer:singleTapInspec];
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormat stringFromDate:today];
    
    
    NSDate *today1 = [NSDate date];
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    
    
    [dateFormat1 setDateFormat:@"hh:mm"];
    NSString *dateString1 = [dateFormat1 stringFromDate:today1];
    
    time.text=dateString1;
    ConName.text=appDelegate.client;
    Town.text=appDelegate.city;
    
    contractor.text=appDelegate.projId;
    txtAddress.text=appDelegate.address;
    txtCity.text=appDelegate.city;
    txtState.text=appDelegate.state;
    txtTel.text=appDelegate.tel;
    txtDateIN.text=dateString;
    txtProject.text=appDelegate.projName;
    zip.text=appDelegate.zip;
    
    
    if (sourceDictionary != nil && [sourceDictionary valueForKey:@"userInfo"] != nil){
        NSLog(@"Daily Inspection Form - populating update for inspectionID: %@", [[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"inspectionID"]);
        
        txtName1.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"oVJName1"];
        txtName2.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"oVJName2"];
        txtName3.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"oVJName3"];
        txtName4.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"oVJName4"];
        txtName7.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"iFName1"];
        txtName5.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"iFName2"];
        txtname6.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"iFName3"];
        txtName8.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"iFName4"];
        
        txtDescription1.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"wDODescriptionOfWork1"];
        txtDescription2.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"wDODescriptionOfWork2"];
        txtDescription3.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"wDODescriptionOfWork3"];
        txtDescription4.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"wDODescriptionOfWork4"];
        
        txtTitle1.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"oVJTitle1"];
        txtTitle2.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"oVJTitle2"];
        txtTitle3.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"oVJTitle3"];
        txtTitle4.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"oVJTitle4"];
        txtTitle5.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"iFTitle1"];
        txtTitle6.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"iFTitle2"];
        txtTitle7.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"iFTitle3"];
        txtTitle8.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"iFTitle4"];
        
        txtCompany1.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"wDODepartmentOrCompany1"];
        txtCompany2.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"wDODepartmentOrCompany2"];
        txtCompany3.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"wDODepartmentOrCompany3"];
        txtCompany4.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"wDODepartmentOrCompany4"];
        
        txtHours.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"contractorsHoursOfWork"];
        contractor.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"con_Name"];
        txtAddress.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"p_o_Box"];
        txtState.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"state"];
        txtCity.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"city"];
        txtTel.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"telephone_No"];
        txtCompetent.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"competentPerson"];
        txtProject.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"project"];
        txtEmail.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"e_Mail"];
        txtWrkDone.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"workDoneBy"];
        zip.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"zip_Code"];
        oriCalDays.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"original_Calendar_Days"];
        usedCalDays.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"calendar_Days_Used"];
        ConName.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"con_Name"];
        repNo.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"report_No"];
        time.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"time"];
        Town.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"town_city"];
        weather.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"weather"];
        
        des1.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"i_Desc1"];
        des2.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"i_Desc2"];
        des3.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"i_Desc3"];
        des4.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"i_Desc4"];
        des5.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"i_Desc5"];
        
        qua1.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"i_QTY1"];
        qua2.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"i_QTY2"];
        qua3.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"i_QTY3"];
        qua4.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"i_QTY4"];
        qua5.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"i_QTY5"];
        
        q_itemNo1.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"i_No1"];
        q_itemNo2.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"i_No2"];
        q_itemNo3.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"i_No3"];
        q_itemNo4.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"i_No4"];
        q_itemNo5.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"i_No5"];
        
        appDelegate.sketchesArray = [[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"sketch_images"] mutableCopy];
        arrayImages = [[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"images_uploaded"] mutableCopy];
    }
    
    NSArray *array = [PRIMECMAPPUtils getSuggestionArray];
    //Assigning to searchfield
    [textField0 setSuggestions:array];
    [textField1 setSuggestions:array];
    [textField2 setSuggestions:array];
    [textField3 setSuggestions:array];
    [textFiel4 setSuggestions:array];
    
    textField0.tag = 1;
    textField1.tag = 2;
    textField2.tag = 3;
    textField3.tag = 4;
    textFiel4.tag = 5;
    
    
    defaults= [NSUserDefaults standardUserDefaults];
    
    
    
}


-(void)showAddImageView
{
    imageAddSubView.layer.cornerRadius=5;
    imageAddSubView.layer.masksToBounds=YES;
    imageAddSubView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    imageAddSubView.layer.borderWidth = 3.0f;
    [self.navigationController.view addSubview:imageAddSubView];
    [self.navigationController.view bringSubviewToFront:imageAddSubView];
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
        if(  !([[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error]))
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





-(IBAction)saveImage:(id)sender
{
    NSString *imgName=[NSString stringWithFormat:@"daily_inspection_%@_%@_%d",appDelegate.projId, appDelegate.username, arc4random()%10000];
    
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


-(void)getImageReviewer
{
    [self removeSignatureView];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Signature"];
    imgSignatureDaily.image=[self getImageFromFileName:[NSString stringWithFormat:@"%@.jpg",@"Signature_R"] folderPath:folderPath];
}


-(void)getImageInspector
{
    [self removeSignatureView];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Signature"];
    imgSignatureDaily.image=[self getImageFromFileName:[NSString stringWithFormat:@"%@.jpg",@"Signature_R"] folderPath:folderPath];
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

      if ([tableData count] > indexPath.row){
               cell.textLabel.text =[tableData objectAtIndex:indexPath.row];
          }
    if ([tableData count] > indexPath.row){
        cell.textLabel.text =[tableData objectAtIndex:indexPath.row];
    }

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


-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
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





-(IBAction)saveDailyInspection:(id)sender{
    
    
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    uploading = NO;
    uploadingsketch=NO;
    if(txtHours.text==NULL || txtHours.text.length==0 || contractor.text==NULL || contractor.text.length==0 ||txtAddress.text==NULL || txtAddress.text.length==0 ||txtCity.text==NULL || txtCity.text.length==0 || txtState.text==NULL || txtState.text.length==0 ||txtTel.text==NULL|| txtTel.text.length==0||txtDateIN.text==NULL|| txtDateIN.text.length==0 ||txtCompetent.text==NULL || txtCompetent.text.length==0 ||txtProject.text==NULL || txtProject.text.length==0 ||txtWrkDone.text==NULL || txtWrkDone.text.length==0 || imgSignatureDaily.image==NULL || repNo.text==NULL || repNo.text.length==0)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty"
                                                        message:@"Please fill all the fields"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    
    else if ([emailTest evaluateWithObject:txtEmail.text] == NO){
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"Email not in proper format"
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
        
        appDelegate=(TabAndSplitAppAppDelegate *)[[UIApplication sharedApplication] delegate];
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
        
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        
        BOOL saveStatus = [PRIMECMController
                           saveDailyInspectionForm:appDelegate.username
                           calendar_Days_Used:usedCalDays.text
                           city:txtCity.text
                           competentPerson:txtCompetent.text
                           con_Name:ConName.text
                           contractor:contractor.text
                           contractorsHoursOfWork:txtHours.text
                           date:txtDateIN.text
                           dIFHeader:txtHeader.text
                           e_Mail:txtEmail.text
                           
                           i_Desc1:des1.text
                           i_Desc2:des2.text
                           i_Desc3:des3.text
                           i_Desc4:des4.text
                           i_Desc5:des5.text
                           
                           i_No1:q_itemNo1.text
                           i_No2:q_itemNo2.text
                           i_No3:q_itemNo3.text
                           i_No4:q_itemNo4.text
                           i_No5:q_itemNo5.text
                           
                           i_QTY1:qua1.text
                           i_QTY2:qua2.text
                           i_QTY3:qua3.text
                           i_QTY4:qua4.text
                           i_QTY5:qua5.text
                           
                           iFName1:txtName5.text
                           iFName2:txtname6.text
                           iFName3:txtName7.text
                           iFName4:txtName8.text
                           
                           iFTitle1:txtTitle5.text
                           iFTitle2:txtTitle6.text
                           iFTitle3:txtTitle7.text
                           iFTitle4:txtTitle8.text
                           
                           images_uploaded:[imgNameArray componentsJoinedByString:@","]
                           inspectionID:repNo.text
                           inspectorSign:sigName
                           signature:sigName
                           original_Calendar_Days:oriCalDays.text
                           
                           oVJName1:txtName1.text
                           oVJName2:txtName2.text
                           oVJName3:txtName3.text
                           oVJName4:txtName4.text
                           
                           oVJTitle1:txtTitle1.text
                           oVJTitle2:txtTitle2.text
                           oVJTitle3:txtTitle3.text
                           oVJTitle4:txtTitle4.text
                           
                           p_o_Box:txtAddress.text
                           printedName:appDelegate.projPrintedName
                           project_id:appDelegate.projId
                           report_No:repNo.text
                           sketch_images:[sketchesNameArray componentsJoinedByString:@","]
                           state:txtState.text
                           telephone_No:txtTel.text
                           time:time.text
                           town_city:Town.text
                           
                           wDODepartmentOrCompany1:txtCompany1.text
                           wDODepartmentOrCompany2:txtCompany2.text
                           wDODepartmentOrCompany3:txtCompany3.text
                           wDODepartmentOrCompany4:txtCompany4.text
                           wDODescriptionOfWork1:txtDescription1.text
                           wDODescriptionOfWork2:txtDescription2.text
                           wDODescriptionOfWork3:txtDescription3.text
                           wDODescriptionOfWork4:txtDescription4.text
                           weather:weather.text
                           workDoneBy:txtWrkDone.text
                           zip_Code:zip.text
                           ];
        
        
        NSLog(@"Save status DailyInspectionForm: %hhd", saveStatus);
        
        BOOL imageSaveState = TRUE;
        BOOL singSaveState = TRUE;
        
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
                
                NSData *imgData = UIImageJPEGRepresentation(image,1.0);
                
                if (! [PRIMECMController saveAllImages:imggName img:imgData syncStatus:SYNC_STATUS_PENDING]){
                    imageSaveState = FALSE;
                }
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
                
                if (! [PRIMECMController saveAllImages:imggName img:imgData syncStatus:SYNC_STATUS_PENDING]){
                    singSaveState = FALSE;
                }
            }
            
        }
        
        [hud setHidden:YES];
        
        if (saveStatus && singSaveState){
            UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Successfully saved Daily Inspection report." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [exportAlert show];
            [appDelegate.sketchesArray removeAllObjects];
            [arrayImages removeAllObjects];
            [self clearFieldsInForm];
            //[self deleteImageFiles];
        }else{
            UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to save Daily Inspection report." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [exportAlert show];
        }
    }
}

-(void)clearFieldsInForm
{
    contractor.text=@"";
    txtAddress.text=@"";
    txtCity.text=@"";
    txtState.text=@"";
    zip.text=@"";
    txtTel.text=@"";
    txtDateIN.text=@"";
    txtCompetent.text=@"";
    txtProject.text=@"";
    txtEmail.text=@"";
    txtWrkDone.text=@"";
    txtName1.text=@"";
    txtName2.text=@"";
    txtName3.text=@"";
    txtName4.text=@"";
    txtName5.text=@"";
    txtname6.text=@"";
    txtName7.text=@"";
    txtName8.text=@"";
    txtTitle1.text=@"";
    txtTitle2.text=@"";
    txtTitle3.text=@"";
    txtTitle4.text=@"";
    txtTitle5.text=@"";
    txtTitle6.text=@"";
    txtTitle7.text=@"";
    txtTitle8.text=@"";
    txtCompany1.text=@"";
    txtCompany2.text=@"";
    txtCompany3.text=@"";
    txtCompany4.text=@"";
    txtDescription1.text=@"";
    txtDescription2.text=@"";
    txtDescription3.text=@"";
    txtDescription4.text=@"";
    txtHours.text=@"";
    imgSignatureDaily.image=NULL;
    repNo.text=@"";
    ConName.text=@"";
    Town.text=@"";
    weather.text=@"";
    time.text=@"";
    des1.text=@"";
    des2.text=@"";
    des3.text=@"";
    des4.text=@"";
    des5.text=@"";
    qua1.text=@"";
    qua2.text=@"";
    qua3.text=@"";
    qua4.text=@"";
    qua5.text=@"";
    oriCalDays.text=@"";
    usedCalDays.text=@"";
    
    q_itemNo1.text=@"";
    q_itemNo2.text=@"";
    q_itemNo3.text=@"";
    q_itemNo4.text=@"";
    q_itemNo5.text=@"";

   
}


-(void)deleteImageFiles
{
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
        folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Signature"];
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
    
    //distancePickerView.dataSource = self;
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


-(void)selectionDone
{
    [popoverController dismissPopoverAnimated:YES];
}



- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
    //brin
    // scrollView.scrollEnabled = NO;
    
    
    
    if(textField==txtCompetent)
    {
        [txtCompetent resignFirstResponder];
        pickerDataArray=[[NSMutableArray alloc]initWithObjects:@"Bill Clayton",@"Art",nil];
        [self createPicker:txtCompetent];
        pickerTag=1;
    }
    if(textField==txtProject)
    {
        [txtProject resignFirstResponder];
        pickerDataArray=[[NSMutableArray alloc]initWithObjects:@"Middletown Project",@"Hartford Project",@"Rockyhill project",nil];
        [self createPicker:txtProject];
        pickerTag=2;
    }
    if(textField==txtDateIN)
    {
        [txtDateIN resignFirstResponder];
        [self createDatePicker:txtDateIN];
        pickerTag=3;
    }
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField==txtHours || textField==qua1 || textField==qua2 || textField==qua3 || textField==qua4 || textField==qua5 || textField==oriCalDays || textField==usedCalDays)
    {
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
        for (int i = 0; i < [string length]; i++)
        {
            unichar c = [string characterAtIndex:i];
            if (![myCharSet characterIsMember:c])
            {
                txtHours.enabled=YES;
                return NO;
            }
            else{
                
            }
        }
        return YES;
    }
    return YES;
}


-(IBAction)itemDescChange:(id)sender
{
    if (sender == textField0){
        NSArray *arr = [PRIMECMAPPUtils getItemFromDesc:textField0.text];
        if (arr && [arr count] >0){
            q_itemNo1.text = [arr objectAtIndex:0];
        }
    }
    else if (sender == textField1){
        NSArray *arr = [PRIMECMAPPUtils getItemFromDesc:textField1.text];
        if (arr && [arr count] >0){
            q_itemNo2.text = [arr objectAtIndex:0];
        }
    }
    else if (sender == textField2){
        NSArray *arr = [PRIMECMAPPUtils getItemFromDesc:textField2.text];
        if (arr && [arr count] >0){
            q_itemNo3.text = [arr objectAtIndex:0];
        }
    }
    else if (sender == textField3){
        NSArray *arr = [PRIMECMAPPUtils getItemFromDesc:textField3.text];
        if (arr && [arr count] >0){
            q_itemNo4.text = [arr objectAtIndex:0];
        }
    }
    else if (sender == textFiel4){
        NSArray *arr = [PRIMECMAPPUtils getItemFromDesc:textFiel4.text];
        if (arr && [arr count] >0){
            q_itemNo5.text = [arr objectAtIndex:0];
        }
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    //brin
    scrollView.scrollEnabled = YES;
    
    
}

/*
 -(BOOL)textFieldShouldReturn:(UITextField *)textField
 {
 //  clearField = NO;
 }
 */

- (void)TextChange:(id)sender{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    if(pickerTag==3)
    {
        txtDateIN.text=[df stringFromDate:datePicker.date];
    }
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
    if(pickerTag==1)
    {
        txtCompetent.text=[pickerDataArray objectAtIndex:[pickerView selectedRowInComponent:0]];
    }
    else if(pickerTag==2)
    {
        txtProject.text=[pickerDataArray objectAtIndex:[pickerView selectedRowInComponent:0]];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end