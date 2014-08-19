//
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

@synthesize txtName1,txtName2,txtName3,txtName4,txtName5,txtname6,txtDescription1,txtDescription2,txtDescription3,txtDescription4,txtTitle1,txtTitle2,txtTitle3,txtTitle4,txtTitle5,txtTitle6,txtTitle7,txtTitle8,txtCompany1,txtCompany2,txtCompany3,txtCompany4,txtName7,txtName8,txtHours,contractor,txtAddress,txtState,txtCity,txtTel,txtCompetent,txtProject,txtTwn,txtEmail,txtWrkDone,txtHeader,zip;



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
    [self deleteAllFiles];
    
       count=0;
    appDelegate=(TabAndSplitAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate.sketchesArray removeAllObjects];
    
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
    scrollView.frame = CGRectMake(0,0, 720, 1988);
    [scrollView setContentSize:CGSizeMake(500, 2300)];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back.jpg"]];
    
    
    UITapGestureRecognizer *singleTapInspec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetectedInspector)];
    
    imgSignatureDaily.userInteractionEnabled = YES;
    [imgSignatureDaily addGestureRecognizer:singleTapInspec];
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormat stringFromDate:today];
    
    
    contractor.text=appDelegate.projId;
    txtAddress.text=appDelegate.address;
    txtCity.text=appDelegate.city;
    txtState.text=appDelegate.state;
    txtTel.text=appDelegate.tel;
    txtDateIN.text=dateString;
    txtProject.text=appDelegate.projName;
    zip.text=appDelegate.zip;
    
    
    
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
    //    }
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
        if(  [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error])
            ;// success
        
        
        else
        {
            NSLog(@"[%@] ERROR: attempting to write create Images directory", [self class]);
        }
    }
    
    NSData *imagData = UIImageJPEGRepresentation(image,0.75f);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fullPath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", imgNam]];
    [fileManager createFileAtPath:fullPath contents:imagData attributes:nil];
}
-(IBAction)saveImage:(id)sender
{
    imgName=[NSString stringWithFormat:@"CM_%i",count];
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
        //nextView.tag=[NSString stringWithFormat:@"%i",btn.tag];
        NSLog(@"Arrayyy--------- %i",arrayImages.count);
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





//brin



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
    
    
    uploading = NO;
    
    uploadingsketch=NO;
    
    
    if(txtHours.text==NULL || txtHours.text.length==0 || contractor.text==NULL || contractor.text.length==0 ||txtAddress.text==NULL || txtAddress.text.length==0 ||txtCity.text==NULL || txtCity.text.length==0 || txtState.text==NULL || txtState.text.length==0 ||txtTel.text==NULL|| txtTel.text.length==0||txtDateIN.text==NULL|| txtDateIN.text.length==0 ||txtCompetent.text==NULL || txtCompetent.text.length==0 ||txtProject.text==NULL || txtProject.text.length==0 ||txtWrkDone.text==NULL || txtWrkDone.text.length==0 || imgSignatureDaily.image==NULL)
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
        uploading = NO;
        uploadingsketch=NO;
        
        NSString *sigName=[NSString stringWithFormat:@"Signature_%@",[self getCurrentDateTimeAsNSString]];
        
        NSString *name1=@" ";
        NSString *name2=@" ";
        NSString *name3=@" ";
        NSString *name4=@" ";
        NSString *name5=@" ";
        NSString *name6=@" ";
        NSString *name7=@" ";
        NSString *name8=@" ";
        
        NSString *title1=@" ";
         NSString *title2=@" ";
         NSString *title3=@" ";
         NSString *title4=@" ";
        NSString *title5=@" ";
        NSString *title6=@" ";
        NSString *title7=@" ";
        NSString *title8=@" ";
        
        NSString *depart1=@" ";
        NSString *depart2=@" ";
        NSString *depart3=@" ";
        NSString *depart4=@" ";
        NSString *dec1=@" ";
        NSString *dec2=@" ";
        NSString *dec3=@" ";
        NSString *dec4=@" ";
        if(txtName1.text!=NULL && txtName1.text.length!=0)
        {
            name1=txtName1.text;
        }
        if(txtName2.text!=NULL && txtName2.text.length!=0)
        {
            name2=txtName2.text;
        }
        if(txtName3.text!=NULL && txtName3.text.length!=0)
        {
            name3=txtName3.text;
        }
        if(txtName4.text!=NULL && txtName4.text.length!=0)
        {
            name4=txtName4.text;
        }
        if(txtName5.text!=NULL && txtName5.text.length!=0)
        {
            name5=txtName5.text;
        }
        if(txtname6.text!=NULL && txtname6.text.length!=0)
        {
            name6=txtname6.text;
        }
        if(txtName7.text!=NULL && txtName7.text.length!=0)
        {
            name7=txtName7.text;
        }
        if(txtName8.text!=NULL && txtName8.text.length!=0)
        {
            name8=txtName8.text;
        }
      
        if(txtTitle1.text!=NULL && txtTitle1.text.length!=0)
        {
            title1=txtTitle1.text;
        }
        if(txtTitle2.text!=NULL && txtTitle2.text.length!=0)
        {
            title2=txtTitle2.text;
        }
        if(txtTitle3.text!=NULL && txtTitle3.text.length!=0)
        {
            title3=txtTitle3.text;
        }
        if(txtTitle4.text!=NULL && txtTitle4.text.length!=0)
        {
            title4=txtTitle4.text;
        }
        if(txtTitle5.text!=NULL && txtTitle5.text.length!=0)
        {
            title5=txtTitle5.text;
        }
        if(txtTitle6.text!=NULL && txtTitle6.text.length!=0)
        {
            title6=txtTitle6.text;
        }
        if(txtTitle7.text!=NULL && txtTitle7.text.length!=0)
        {
            title7=txtTitle7.text;
        }
        if(txtTitle8.text!=NULL && txtTitle8.text.length!=0)
        {
            title8=txtTitle8.text;
        }
        if(txtName1.text!=NULL && txtName1.text.length!=0)
        {
            name1=txtName1.text;
        }
        if(txtCompany1.text!=NULL && txtCompany1.text.length!=0)
        {
            depart1=txtCompany1.text;
        }
        if(txtCompany2.text!=NULL && txtCompany2.text.length!=0)
        {
            depart2=txtCompany2.text;
        }
        if(txtCompany3.text!=NULL && txtCompany3.text.length!=0)
        {
            depart3=txtCompany3.text;
        }
        if(txtCompany4.text!=NULL && txtCompany4.text.length!=0)
        {
            depart4=txtCompany4.text;
        }
        if(txtDescription1.text!=NULL && txtDescription1.text.length!=0)
        {
            dec1=txtDescription1.text;
        }
        if(txtDescription2.text!=NULL && txtDescription2.text.length!=0)
        {
            dec2=txtDescription2.text;
        }
        if(txtDescription3.text!=NULL && txtDescription3.text.length!=0)
        {
            dec3=txtDescription3.text;
        }
        if(txtDescription4.text!=NULL && txtDescription4.text.length!=0)
        {
            dec4=txtDescription4.text;
        }
        
        
        
        NSString *strURL = [NSString stringWithFormat:@"%@/api/dailyinspection/create/%@/%@/%@/00/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@", [PRIMECMAPPUtils getAPIEndpoint],
                            appDelegate.username,txtHeader.text,contractor.text,txtAddress.text,txtCity.text,txtState.text,zip.text,txtTel.text,txtDateIN.text,txtCompetent.text,txtProject.text,appDelegate.projId,@"town",txtEmail.text,txtWrkDone.text,name1,title1,name2,title2,name3,title3,name4,title4,name5,title5,name6,title6,name7,title7,name8,title8,depart1,dec1,depart2,dec2,depart3,dec3,depart4,dec4,txtHours.text,sigName,appDelegate.projPrintedName];
        
        NSString *uencodedUrl = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        
          NSLog(@"URL---- %@",uencodedUrl);
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
        
        //signature
        

        
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
        
        _receivedData = [[NSMutableData alloc] init];
        
        [connection start];
               
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.navigationController.view addSubview:HUD];
        HUD.labelText=@"";
        HUD.dimBackground = YES;
        HUD.delegate = self;
        [HUD show:YES];
        
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

-(void)uploadImage
{
    
    
    NSString *urlLink = [NSString stringWithFormat:@"%@/api/dailyinspection/uploadimages/%@/%@/%@/", [PRIMECMAPPUtils getAPIEndpoint],
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



-(void)uploadSignature
{
    
    
    NSString *urlLink = [NSString stringWithFormat:@"%@/api/dailyinspection/uploadimages/%@/%@/%@/", [PRIMECMAPPUtils getAPIEndpoint],
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
    NSString *urlLink = [NSString stringWithFormat:@"%@/api/dailyinspection/uploadsketches/%@/%@/%@/", [PRIMECMAPPUtils getAPIEndpoint],
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



- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"daily-----");
    
    _receivedResponse = response;
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData
                                                                 *)data
{
    NSLog(@"ddddd");
    [_receivedData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError
                                                                   *)error
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
    
    if (uploading) {
        
        uploading=NO;
        count1 ++;
        
        if(count1< arrayImages.count)
            
        {
            
            [self uploadImage];
        }
        else
        {
            
            
            if(appDelegate.sketchesArray.count>0)
            {
                [self uploadSketch];
            }
            else
            {
                
                
                UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Successfully added." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];            [exportAlert show];
            }
        }
        
    }
    
    
    else if(uploadingsketch){
        
        uploadingsketch=NO;
        
        count2++;
        
        
        
        if(count2< appDelegate.sketchesArray.count)
            
        {
            
            [self uploadSketch];
        }
        else
        {
            
            UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Successfully added." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [exportAlert show];
            
        }
        
        
        
        
    }
    
    else{
        NSLog(@"Upload Images------ %i",arrayImages.count);
        if([[responseObject valueForKey:@"status"]isEqualToString:@"sucess"])
            
        {
            
            comNoticeNo=[responseObject valueForKey:@"id"];
            NSLog(@"Upload Images------ %i",arrayImages.count);
            
            if(arrayImages.count >0)
            {
                
                [self uploadImage];
            }
            
            
            else{
                
                if(appDelegate.sketchesArray.count >0)
                {
                    
                    [self uploadSketch];
                }
            }
            
            
        }
        else
        {
            UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [exportAlert show];
        }
        
        
        
    }
    
    
    
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
    if(textField==txtHours )
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






-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.text.length==0)
    {
        textField.text=@" ";
    }
    //clearField = NO;
}

-(void)textFieldShouldReturn:(UITextField *)textField
{
    //  clearField = NO;
}

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
