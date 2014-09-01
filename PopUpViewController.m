//
//  PopUpViewController.m
//  TabAndSplitApp
//
//  Created by Prime on 5/13/14.
//
//

#import "PopUpViewController.h"

@interface PopUpViewController ()
{
    NSArray *tableData;
    NSUserDefaults *defaults;
   
}

@end

@implementation PopUpViewController
@synthesize tblView;
@synthesize viewProjectName;
@synthesize txtViewProjectName;
@synthesize viewHeader;
@synthesize viewAttachImage;
@synthesize button;


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
    
    

    button.enabled=NO;
    

    // Do any additional setup after loading the view from its nib.
}
-(IBAction)saveAnnotationData:(id)sender
{
     [self dismissViewControllerAnimated:YES completion:nil];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"changeMapToolBar" object:nil];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"addMapGesture" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    tableData = [NSArray arrayWithObjects:@"Project Id", @"Project Name",@"Address",@"Option 4", nil];

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
    //cell.imageView.image=[UIImage imageNamed:@"map_pin.png"];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//
//{
//    return @"                                              Project Details:";
//}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return viewHeader;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:1.0];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
//                           forView:viewProjectName
//                             cache:YES];
//    
    
   [self.view addSubview:viewProjectName];
  //  [UIView commitAnimations];
    [txtViewProjectName becomeFirstResponder];
    
    
    
        
}
-(IBAction)doneAddProject:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)doneProjectNameView:(id)sender
{
    [txtViewProjectName resignFirstResponder];
    [self.viewProjectName removeFromSuperview];
    [defaults setObject:txtViewProjectName.text forKey:@"ProjectName"];
    button.enabled=YES;
    
    
    
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
    [self.viewAttachImage removeFromSuperview];
}


- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}


@end
