//
//  PopUpViewController.m
//  TabAndSplitApp
//
//  Created by Prime on 5/13/14.
//
//

#import "PopUpViewController.h"
#import "popupcell.h"
#import "CMShowImagesViewController.h"



@interface PopUpViewController ()
{
    NSArray *tableData;
    NSUserDefaults *defaults;
    UIPopoverController *popoverController;
    int imgTag;
    UIActionSheet *sheet;
    
    
    NSInteger count;
    UIPickerView *pickerViewInspectors;
    int pickerTag;
    NSArray *pickerDataArray;
    NSIndexPath *index;
    
    
}

@end

@implementation PopUpViewController
@synthesize tblView;
@synthesize viewProjectName;
@synthesize txtViewProjectName;
@synthesize viewHeader;
@synthesize viewAttachImage;
@synthesize button;
@synthesize lblTitle;
@synthesize imgViewAdd;
@synthesize arrayImages;
@synthesize isFromReport,isFromSketches;
@synthesize imageAddSubView;
@synthesize datePicker;



@synthesize imgViewAttach,imgViewAttach1,imgViewAttach3,imgViewAttach2,imgViewAttach4,imgViewAttach5,imgViewAttach6,
imgViewAttach7,imgViewAttach8,imgViewAttach9,imgViewAttach10,imgViewAttach11,imgViewAttach12,imgViewAttach13,imgViewAttach14,imgViewAttach15;
@synthesize imagePicker;
@synthesize txvDescription;


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
    
    defaults=[NSUserDefaults standardUserDefaults];
    imgTag=0;
    
    
    
    
    self.imagePicker=[[UIImagePickerController alloc]init];
    
    
    arrayImages=[[NSMutableArray alloc]init];
    
    UITapGestureRecognizer* gestureImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageAttachOptions:)];
    // if labelView is not set userInteractionEnabled, you must do so
    gestureImageTap.numberOfTapsRequired=1;
    [imgViewAttach setUserInteractionEnabled:YES];
    [imgViewAttach addGestureRecognizer:gestureImageTap];
    
    UITapGestureRecognizer* gestureImageTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageAttachOptions:)];
    // if labelView is not set userInteractionEnabled, you must do so
    [imgViewAttach1 setUserInteractionEnabled:YES];
    [imgViewAttach1 addGestureRecognizer:gestureImageTap1];
    
    UITapGestureRecognizer* gestureImageTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageAttachOptions:)];
    // if labelView is not set userInteractionEnabled, you must do so
    [imgViewAttach2 setUserInteractionEnabled:YES];
    [imgViewAttach2 addGestureRecognizer:gestureImageTap2];
    UITapGestureRecognizer* gestureImageTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageAttachOptions:)];
    // if labelView is not set userInteractionEnabled, you must do so
    [imgViewAttach3 setUserInteractionEnabled:YES];
    [imgViewAttach3 addGestureRecognizer:gestureImageTap3];
    UITapGestureRecognizer* gestureImageTap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageAttachOptions:)];
    // if labelView is not set userInteractionEnabled, you must do so
    [imgViewAttach4 setUserInteractionEnabled:YES];
    [imgViewAttach4 addGestureRecognizer:gestureImageTap4];
    UITapGestureRecognizer* gestureImageTap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageAttachOptions:)];
    // if labelView is not set userInteractionEnabled, you must do so
    [imgViewAttach5 setUserInteractionEnabled:YES];
    [imgViewAttach5 addGestureRecognizer:gestureImageTap5];
    UITapGestureRecognizer* gestureImageTap6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageAttachOptions:)];
    // if labelView is not set userInteractionEnabled, you must do so
    [imgViewAttach6 setUserInteractionEnabled:YES];
    [imgViewAttach6 addGestureRecognizer:gestureImageTap6];
    UITapGestureRecognizer* gestureImageTap7 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageAttachOptions:)];
    // if labelView is not set userInteractionEnabled, you must do so
    [imgViewAttach7 setUserInteractionEnabled:YES];
    [imgViewAttach7 addGestureRecognizer:gestureImageTap7];
    UITapGestureRecognizer* gestureImageTap8 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageAttachOptions:)];
    // if labelView is not set userInteractionEnabled, you must do so
    [imgViewAttach8 setUserInteractionEnabled:YES];
    [imgViewAttach8 addGestureRecognizer:gestureImageTap8];
    UITapGestureRecognizer* gestureImageTap9 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageAttachOptions:)];
    // if labelView is not set userInteractionEnabled, you must do so
    [imgViewAttach9 setUserInteractionEnabled:YES];
    [imgViewAttach9 addGestureRecognizer:gestureImageTap9];
    UITapGestureRecognizer* gestureImageTap10 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageAttachOptions:)];
    // if labelView is not set userInteractionEnabled, you must do so
    [imgViewAttach10 setUserInteractionEnabled:YES];
    [imgViewAttach10 addGestureRecognizer:gestureImageTap10];
    UITapGestureRecognizer* gestureImageTap11 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageAttachOptions:)];
    // if labelView is not set userInteractionEnabled, you must do so
    [imgViewAttach11 setUserInteractionEnabled:YES];
    [imgViewAttach11 addGestureRecognizer:gestureImageTap11];
    UITapGestureRecognizer* gestureImageTap12 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageAttachOptions:)];
    // if labelView is not set userInteractionEnabled, you must do so
    [imgViewAttach12 setUserInteractionEnabled:YES];
    [imgViewAttach12 addGestureRecognizer:gestureImageTap12];
    UITapGestureRecognizer* gestureImageTap13 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageAttachOptions:)];
    // if labelView is not set userInteractionEnabled, you must do so
    [imgViewAttach13 setUserInteractionEnabled:YES];
    [imgViewAttach13 addGestureRecognizer:gestureImageTap13];
    UITapGestureRecognizer* gestureImageTap14 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageAttachOptions:)];
    // if labelView is not set userInteractionEnabled, you must do so
    [imgViewAttach14 setUserInteractionEnabled:YES];
    [imgViewAttach14 addGestureRecognizer:gestureImageTap14];
    UITapGestureRecognizer* gestureImageTap15 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageAttachOptions:)];
    // if labelView is not set userInteractionEnabled, you must do so
    [imgViewAttach15 setUserInteractionEnabled:YES];
    [imgViewAttach15 addGestureRecognizer:gestureImageTap15];
    
    
    tableData = [NSArray arrayWithObjects:@"Project Id",@"Project Title",@"Project Name",@"Project Description",@"Street",@"City",@"State",@"Zip",@"Phone No",@"Date",@"Client Name",@"Project Manager",@"Inspector",nil];
    
    
    
    button.enabled=NO;
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    defaults=[NSUserDefaults standardUserDefaults];
    
    // Do any additional setup after loading the view from its nib.
}




//start brin attach and view image




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


-(void)createDatePicker:(UILabel *)txtField{
    
    
    
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
                   action:@selector(TextChangee:)
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
    
    
    
    
    [popoverController
     presentPopoverFromRect:popoverRect
     inView:self.view
     permittedArrowDirections:UIPopoverArrowDirectionAny
     animated:YES];
    
    
    
    
}



- (void)TextChangee:(id)sender{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    
    [df setDateFormat:@"yyyy-MM-dd"];
    if(pickerTag==3)
    {
        popupcell *cell =(popupcell *) [tblView cellForRowAtIndexPath:index];
        cell.lblpopupvalue.text=[df stringFromDate:datePicker.date];
       [defaults setObject: [df stringFromDate:datePicker.date] forKey:@"Date"];
        
        
    }
    [tblView reloadData];
    
}


-(void)lablelDidBeginEditing:(UITableViewCell *)label

{
    
    if(label==[defaults objectForKey:@"Date"])
    {
        [[defaults objectForKey:@"Date"] resignFirstResponder];
        [self createDatePicker:[defaults objectForKey:@"Date"]];
        pickerTag=3;
    }
}





-(void)selectionDone
{
    [popoverController dismissPopoverAnimated:YES];
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
     presentPopoverFromRect:CGRectMake(10.0,  100.0, 300.0, 300.0)  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    
    
    
    self.imagePicker.delegate=self;
    
    
}

-(void)createPicker:(UILabel *)lable
{
    
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolbar sizeToFit];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(selectionDone)];
    [barItems addObject:doneBtn];
    [pickerToolbar setItems:barItems animated:YES];
    
    
    pickerViewInspectors = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 320, 300)];
    pickerViewInspectors.delegate = self;
    pickerViewInspectors.showsSelectionIndicator = YES;
    
    
    UIViewController* popoverContent = [[UIViewController alloc] init];
    UIView* popoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 344)];
    popoverView.backgroundColor = [UIColor whiteColor];
    
    
    [popoverView addSubview:pickerToolbar];
    [popoverView addSubview:pickerViewInspectors];
    popoverContent.view = popoverView;
    
    
    //resize the popover view shown
    //in the current view to the view's size
    popoverContent.preferredContentSize = CGSizeMake(320, 244);
    
    //create a popover controller
    popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    CGRect popoverRect = [self.view convertRect:[lable frame]
                                       fromView:[lable superview]];
    
    popoverRect.size.width = MIN(popoverRect.size.width, 100) ;
    popoverRect.origin.x  = popoverRect.origin.x;
    // popoverRect.size.height  = ;
    
    [popoverController
     presentPopoverFromRect:popoverRect
     inView:self.view
     permittedArrowDirections:UIPopoverArrowDirectionUp
     animated:YES];
    
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




-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    count++;
    UIImage *newImage=[info objectForKey:UIImagePickerControllerOriginalImage];
    
    [popoverController dismissPopoverAnimated:YES];
    
    [self showAddImageView];
    imgViewAdd.image=newImage;
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}


-(void)showAddImageView
{
    imageAddSubView.layer.cornerRadius=5;
    imageAddSubView.layer.masksToBounds=YES;
    imageAddSubView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    imageAddSubView.layer.borderWidth = 3.0f;
    
    [self.view addSubview:imageAddSubView];
    [self.view bringSubviewToFront:imageAddSubView];
    
    
    
    NSLog(@"hello");
    }


-(IBAction)attachImage:(id)sender
{
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Attachments"
                                                    message:@""
                                                   delegate:nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Library",@"Camera", nil];
    alert.delegate=self;
    alert.tag=200;
    [alert show];
    //    }
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


-(IBAction)saveAnnotationData:(id)sender
{
    NSLog(@"Project ID--- %@",[defaults objectForKey:@"Project Id"]);
    
    
    
    if([[defaults objectForKey:@"Project Id"] isEqualToString:@""] || [[defaults objectForKey:@"Project Title"] isEqualToString:@""] || [[defaults objectForKey:@"Project Name"] isEqualToString:@""]  || [[defaults objectForKey:@"Project Description"] isEqualToString:@""] || [[defaults objectForKey:@"Street"] isEqualToString:@""] ||  [[defaults objectForKey:@"City"] isEqualToString:@""] ||  [[defaults objectForKey:@"State"] isEqualToString:@""] ||  [[defaults objectForKey:@"Zip"] isEqualToString:@""] ||  [[defaults objectForKey:@"Phone No"] isEqualToString:@""] ||  [[defaults objectForKey:@"Date"] isEqualToString:@""] ||  [[defaults objectForKey:@"Client Name"] isEqualToString:@""] ||  [[defaults objectForKey:@"Project Manager"] isEqualToString:@""] ||  [[defaults objectForKey:@"Inspector"] isEqualToString:@""] || [defaults objectForKey:@"Project Id"]==NULL || [defaults objectForKey:@"Project Title"]==NULL || [defaults objectForKey:@"Project Description"]==NULL || [defaults objectForKey:@"Street"]==NULL|| [defaults objectForKey:@"City"]==NULL || [defaults objectForKey:@"Zip"]==NULL ||  [defaults objectForKey:@"Phone No"] ==NULL || [defaults objectForKey:@"Date"]==NULL|| [defaults objectForKey:@"Client Name"]==NULL || [defaults objectForKey:@"Project Manager"]==NULL || [defaults objectForKey:@"Inspector"]==NULL)
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
        
        
        [self dismissViewControllerAnimated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeMapToolBar" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addMapGesture" object:nil];
    }
    
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return 13;
}








- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"popupcell";
    popupcell *cell =(popupcell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    
    if (cell == nil) {
        //  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"popupcell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    
    
    if (indexPath.section==0 && indexPath.row==0) {
        
        cell.lblpopupvalue.text=[defaults objectForKey:@"Project Id"];
        NSLog(@"projectid %@",[defaults objectForKey:@"Project Id"]);
        cell.lblHeading.text =[tableData objectAtIndex:indexPath.row];
    }
    
    
    else if (indexPath.section==0 && indexPath.row==1) {
        
        cell.lblpopupvalue.text=[defaults objectForKey:@"Project Title"];
        NSLog(@"title %@",[defaults objectForKey:@"Project Title"]);
        cell.lblHeading.text =[tableData objectAtIndex:indexPath.row];
    }
    else  if (indexPath.section==0 && indexPath.row==2) {
        
        cell.lblpopupvalue.text=[defaults objectForKey:@"Project Name"];
        NSLog(@"pname %@",[defaults objectForKey:@"Project Name"]);
        cell.lblHeading.text =[tableData objectAtIndex:indexPath.row];
    }
    else if (indexPath.section==0 && indexPath.row==3) {
        
        cell.lblpopupvalue.text=[defaults objectForKey:@"Project Description"];
        NSLog(@"description %@",[defaults objectForKey:@"Project Description"]);
        cell.lblHeading.text =[tableData objectAtIndex:indexPath.row];
    }
    
    
    else if (indexPath.section==0 && indexPath.row==4) {
        
        cell.lblpopupvalue.text=[defaults objectForKey:@"Street"];
        NSLog(@"street %@",[defaults objectForKey:@"Street"]);
        cell.lblHeading.text =[tableData objectAtIndex:indexPath.row];
    }
    
    else if (indexPath.section==0 && indexPath.row==5) {
        
        cell.lblpopupvalue.text=[defaults objectForKey:@"City"];
        NSLog(@"title %@",[defaults objectForKey:@"Project Title"]);
        cell.lblHeading.text =[tableData objectAtIndex:indexPath.row];
    }
    
    else if (indexPath.section==0 && indexPath.row==6) {
        
        cell.lblpopupvalue.text=[defaults objectForKey:@"State"];
        NSLog(@"state %@",[defaults objectForKey:@"State"]);
        cell.lblHeading.text =[tableData objectAtIndex:indexPath.row];
    }
    
    else if (indexPath.section==0 && indexPath.row==7) {
        
        cell.lblpopupvalue.text=[defaults objectForKey:@"Zip"];
        NSLog(@"zip %@",[defaults objectForKey:@"Zip"]);
        cell.lblHeading.text =[tableData objectAtIndex:indexPath.row];
    }
    
    else if (indexPath.section==0 && indexPath.row==8) {
        
        cell.lblpopupvalue.text=[defaults objectForKey:@"Phone No"];
        NSLog(@"phone no %@",[defaults objectForKey:@"Phone No"]);
        cell.lblHeading.text =[tableData objectAtIndex:indexPath.row];
    }
    
    else if (indexPath.section==0 && indexPath.row==9) {
        
        cell.lblpopupvalue.text=[defaults objectForKey:@"Date"];
        NSLog(@"date %@",[defaults objectForKey:@"Date"]);
        cell.lblHeading.text =[tableData objectAtIndex:indexPath.row];
    }
    
    
    else if (indexPath.section==0 && indexPath.row==10) {
        
        cell.lblpopupvalue.text=[defaults objectForKey:@"Client Name"];
        NSLog(@"cname %@",[defaults objectForKey:@"Client Name"]);
        cell.lblHeading.text =[tableData objectAtIndex:indexPath.row];
    }
    
    else if (indexPath.section==0 && indexPath.row==11) {
        
        cell.lblpopupvalue.text=[defaults objectForKey:@"Project Manager"];
        NSLog(@"manager %@",[defaults objectForKey:@"Project Manager"]);
        cell.lblHeading.text =[tableData objectAtIndex:indexPath.row];
    }
    else if (indexPath.section==0 && indexPath.row==12) {
        
        cell.lblpopupvalue.text=[defaults objectForKey:@"Inspector"];
        NSLog(@"inspector %@",[defaults objectForKey:@"Inspector"]);
        cell.lblHeading.text =[tableData objectAtIndex:indexPath.row];
    }
    
    
  
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    
    return cell;
    
}




//brin start
-(void)saveImageTaken:(UIImage *)image imgName:(NSString *)imgNam
{
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



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    popupcell *cell =(popupcell *) [tableView cellForRowAtIndexPath:indexPath];
      if(indexPath.row==11)
    {
        pickerDataArray = [NSArray arrayWithObjects:@"Art",nil];
        pickerTag=2;
        [self createPicker:cell.lblpopupvalue];
        
    }
    
    
    else if (indexPath.row==9){
        
        
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        
        
        [df setDateFormat:@"yyyy-MM-dd"];
        pickerTag=3;
        
        [self createDatePicker:cell.lblpopupvalue];
        
    }
    else
    {
        
        
        NSLog(@"selected----%@",cell.lblHeading.text);
        lblTitle.text=cell.lblHeading.text;
        
        [self.view addSubview:viewProjectName];
        
        
        
        txtViewProjectName.text=[defaults objectForKey:lblTitle.text];
        [txtViewProjectName becomeFirstResponder];
    }
    
    
}

//-----------------------------------------------------------------------//


#pragma mark -
#pragma mark ALPickerView delegate methods


-(IBAction)doneAddProject:(id)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(IBAction)doneProjectNameView:(id)sender
{
    [defaults setObject:txtViewProjectName.text forKey:lblTitle.text];
    [txtViewProjectName resignFirstResponder];
    [self.viewProjectName removeFromSuperview];
    
    button.enabled=YES;
    [tblView reloadData];
    
    
    
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
    popupcell *cell =(popupcell *) [tblView cellForRowAtIndexPath:index];
    cell.lblpopupvalue.text=[pickerDataArray objectAtIndex:[pickerView selectedRowInComponent:0]];
    if(pickerTag==1)
    {
                [defaults setObject: [pickerDataArray objectAtIndex:[pickerView selectedRowInComponent:0]] forKey:@"Inspector"];
        NSLog(@"Inspector---------%@",[defaults objectForKey:@"Inspector"]);
        
    }
    if(pickerTag==2)
    {
        
        [defaults setObject: [pickerDataArray objectAtIndex:[pickerView selectedRowInComponent:0]] forKey:@"Project Manager"];
        NSLog(@"Project Manager---------%@",[defaults objectForKey:@"Project Manager"]);
    }
    
    
    [tblView reloadData];
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

- (void) showImageAttachOptions:(UITapGestureRecognizer *)sender
{
    NSLog(@"Craaaaaaa-------------------000000");
    //UIImageView *btn=(UIImageView*)sender;
    switch (sender.view.tag) {
        case 0:
            imgTag=0;
            
            break;
        case 1:
            imgTag=1;
            
            break;
        case 2:
            imgTag=2;
            
            break;
        case 3:
            imgTag=3;
            
            break;
        case 4:
            imgTag=4;
            
            break;
        case 5:
            imgTag=5;
            
            break;
        case 6:
            imgTag=6;
            
            break;
        case 7:
            imgTag=7;
            
            break;
        case 8:
            imgTag=8;
            
            break;
        case 9:
            imgTag=9;
            
            break;
        case 10:
            imgTag=10;
            
            break;
        case 11:
            imgTag=11;
            
            break;
        case 12:
            imgTag=12;
            
            break;
        case 13:
            imgTag=13;
            
            break;
        case 14:
            imgTag=14;
            
            break;
        case 15:
            imgTag=15;
            
            break;
        default:
            break;
    }
    
    
    
    sheet = [[UIActionSheet alloc] initWithTitle: nil
                                        delegate: self
                               cancelButtonTitle: nil
                          destructiveButtonTitle: nil
                               otherButtonTitles: @"Take Photo",
             @"Choose Existing Photo", nil];
    CGRect frame;
    switch (imgTag) {
        case 0:
            frame=self.imgViewAttach.frame;
            break;
        case 1:
            frame=self.imgViewAttach1.frame;
            break;
        case 2:
            frame=self.imgViewAttach2.frame;
            break;
        case 3:
            frame=self.imgViewAttach3.frame;
            break;
        case 4:
            frame=self.imgViewAttach4.frame;
            break;
        case 5:
            frame=self.imgViewAttach5.frame;
            break;
        case 6:
            frame=self.imgViewAttach6.frame;
            break;
        case 7:
            frame=self.imgViewAttach7.frame;
            break;
        case 8:
            frame=self.imgViewAttach8.frame;
            break;
        case 9:
            frame=self.imgViewAttach9.frame;
            break;
        case 10:
            frame=self.imgViewAttach10.frame;
            break;
        case 11:
            frame=self.imgViewAttach11.frame;
            break;
        case 12:
            frame=self.imgViewAttach12.frame;
            break;
        case 13:
            frame=self.imgViewAttach13.frame;
            break;
        case 14:
            frame=self.imgViewAttach14.frame;
            break;
        case 15:
            frame=self.imgViewAttach15.frame;
            break;
            
        default:
            break;
    }
    
    
    [sheet showFromRect:frame inView: self.view animated: YES];
}


-(IBAction)cancelProjectNameView:(id)sender
{
    
    [txtViewProjectName resignFirstResponder];
    [self.viewProjectName removeFromSuperview];
}
-(IBAction)displayAttachImageView:(id)sender
{
    [self.view addSubview:viewAttachImage];
    
}
-(IBAction)doneAttachmentsView:(id)sender
{
    
   
    switch (imgTag) {
        case 0:
            imgViewAdd.image=imgViewAttach.image;
            
            break;
        case 1:
            imgViewAdd.image=imgViewAttach1.image;
            
            break;
        case 2:
            imgViewAdd.image=imgViewAttach2.image;
            
            
            break;
        case 3:
            imgViewAdd.image=imgViewAttach3.image;
            
            
            break;
        case 4:
            imgViewAdd.image=imgViewAttach4.image;
            
            
            break;
        case 5:
            imgViewAdd.image=imgViewAttach5.image;
            
            break;
        case 6:
            imgViewAdd.image=imgViewAttach6.image;
            
            break;
        case 7:
            imgViewAdd.image=imgViewAttach7.image;
            
            
            break;
        case 8:
            imgViewAdd.image=imgViewAttach8.image;
            
            break;
        case 9:
            imgViewAdd.image=imgViewAttach9.image;
            
            break;
        case 10:
            imgViewAdd.image=imgViewAttach10.image;
            
            
            break;
        case 11:
            imgViewAdd.image=imgViewAttach11.image;
            
            
            break;
        case 12:
            imgViewAdd.image=imgViewAttach12.image;
            
            
            break;
        case 13:
            imgViewAdd.image=imgViewAttach13.image;
            
            
            break;
        case 14:
            imgViewAdd.image=imgViewAttach14.image;
            
            break;
        case 15:
            imgViewAdd.image=imgViewAttach15.image;
            
            
            break;
        default:
            break;
    }
    
    
    [self.viewAttachImage removeFromSuperview];
    
    
    
    
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


- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

#pragma mark -
#pragma mark UIActionSheetDelegate Methods

-(NSString*)getCurrentDateTimeAsNSString
{
    //get current datetime as image name
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [format setLocale:locale];
    NSDate *now = [NSDate date];
    NSString *retStr = [format stringFromDate:now];
    return retStr;
}


@end
