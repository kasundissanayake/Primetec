//
//  quantitySummarySheet.m
//  PRIMECMAPP
//
//  Created by Lingeswaran Kandasamy on 8/10/14.
//
//

#import "quantitySummarySheet.h"
#import "quantityCellTableViewCell.h"
#import "TabAndSplitAppAppDelegate.h"
#import "PRIMECMAPPUtils.h"
#import "PRIMECMController.h"
@interface quantitySummarySheet (){
    UIPopoverController *popoverController;
    BOOL isSubTableView;
    NSMutableArray *arrayItems;
    NSMutableArray *itemDetails;
    MBProgressHUD *HUD;
    TabAndSplitAppAppDelegate *appDelegate;
    NSMutableData *_receivedData;
    NSURLResponse *_receivedResponse;
    NSError *_connectionError;
    NSArray *resPonse;
    UIBarButtonItem  *btnPrint;
    NSString *itemNo;
    NSString *itemDes;
    NSString *value;
    NSArray *pickerDataArray;
    NSInteger pickerTag;
    UIPickerView *pickerView1;
    UIPickerView *pickerViewCities;
    BOOL isSaved;
    NSDictionary *sourceDictionary;
    NSString *qtyEstID;
}

@end

@implementation quantitySummarySheet
@synthesize qtyTable,isEdit;
@synthesize scrollView;
@synthesize i_number,item,est_quantity,project,unit,unit_price;

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
    
    UIBarButtonItem *Button = [[UIBarButtonItem alloc]
                               initWithTitle:NSLocalizedString(@"Exit", @"")
                               style:UIBarButtonItemStyleDone
                               target:self
                               action:@selector(exit)];
    
    self.navigationItem.rightBarButtonItem = Button;
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
    // Do any additional setup after loading the view from its nib.
    scrollView.frame = CGRectMake(0,0, 720, 1800);
    [scrollView setContentSize:CGSizeMake(700, 2300)];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back.jpg"]];
    
    appDelegate=(TabAndSplitAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    project.text=appDelegate.projName;
    
    if (sourceDictionary != nil && [sourceDictionary valueForKey:@"userInfo"] != nil){
        NSLog(@"QuantityEstimateForm - populating update for qtyEstID: %@", [[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"qtyEstID"]);
        
        qtyEstID = [[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"qtyEstID"];
        project.text= [[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"project"];
        i_number.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"item_no"];
        
        NSArray *arr = [PRIMECMAPPUtils getItemFromNo:i_number.text];
        if (arr && [arr count] > 0){
            item.text=[arr objectAtIndex:1];
        }
        
        est_quantity.text= [[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"est_qty"];;
        unit_price.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"unit_price"];
        unit.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"unit"];
        
        itemDetails  =  [NSMutableArray arrayWithArray:[PRIMECMController
                                                        getInspectionSummaryForItemID:i_number.text]];
        
        [qtyTable reloadData];
    }
}


-(void)exit{
    UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Data Cached." delegate:self cancelButtonTitle:@"EXIT" otherButtonTitles: nil];
    [exportAlert show];
}



-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if(textField==i_number)
    {
        [i_number resignFirstResponder];
        pickerDataArray=[PRIMECMAPPUtils getItemArray];
        [self createPicker:i_number];
        pickerTag=1;
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


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return pickerDataArray.count;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [pickerDataArray objectAtIndex:row];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerTag==1)
    {
        i_number.text=[pickerDataArray objectAtIndex:[pickerView selectedRowInComponent:0]];
    }
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}


// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    CGFloat componentWidth = 0.0;
    componentWidth = 320.0;
    
    return componentWidth;
}


-(void)selectionDone
{
    [popoverController dismissPopoverAnimated:YES];
    
    value=i_number.text;
    
    NSArray *arr = [PRIMECMAPPUtils getItemFromNo:i_number.text];
    if ([arr count] > 0){
        item.text = [arr objectAtIndex:1];
    }
    
    itemDetails  =  [NSMutableArray arrayWithArray:[PRIMECMController
                                                    getInspectionSummaryForItemID:i_number.text]];
    
    [qtyTable reloadData];
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
    for (int i = 0; i <= count; i++) {
        if ([itemDetails valueForKey:@"qty"] && [[itemDetails valueForKey:@"qty"] count] > i){
            accum += [[[itemDetails valueForKey:@"qty"] objectAtIndex:i] intValue];
        }
    }
    return accum;
}

- (IBAction)saveQuantitySumSheet:(id)sender {
    
    if(project.text==NULL || project.text.length==0|| i_number.text==NULL || i_number.text.length==0 || item.text==NULL || item.text.length==0 || est_quantity.text==NULL || est_quantity.text.length==0||unit.text==NULL || unit.text.length==0||unit_price.text==NULL || unit_price.text.length==0)
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
        
        isSaved=YES;
        
        BOOL saveStatus = [PRIMECMController
                           
                           saveQuantityEstimateForm:appDelegate.username
                           est_qty:est_quantity.text
                           item_no:i_number.text
                           project_id:appDelegate.projId
                           unit:unit.text
                           unit_price: unit_price.text
                           qtyEstID:qtyEstID];
        
        
        
        project.text = @"";
        i_number.text=@"";
        est_quantity.text=@"";
        unit.text=@"";
        unit_price.text=@"";
        
        
        [HUD setHidden:YES];
        
        if (saveStatus ){
            UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Successfully saved QuantitySummaryDetails report." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [exportAlert show];
        }else{
            UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to save QuantitySummaryDetails report." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [exportAlert show];
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end