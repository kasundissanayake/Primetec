//
//  DailyInspectionViewController.h
//  TabAndSplitApp
//
//  Created by Lingeswaran Kandasamy on 4/2/14.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface DailyInspectionViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate,MBProgressHUDDelegate>

@property(nonatomic,strong)IBOutlet UIScrollView *scrollView;

@property(nonatomic,retain) UIDatePicker *datePicker;


@property(nonatomic,strong)IBOutlet UITextField *txtDateIN;
@property(nonatomic,strong)IBOutlet UIImageView *imgSignatureDaily;

@property (strong, nonatomic) IBOutlet UITextField *printedname;


@property(nonatomic,strong)UIImagePickerController *imagePicker;
@property(nonatomic,assign)BOOL isFromSketches;
@property(nonatomic,assign)BOOL isFromReport;


@property(nonatomic,strong)NSMutableArray *arrayImages;
@property(nonatomic,strong)NSMutableArray *sketchesArray;






@property(nonatomic,strong)IBOutlet UIView *imageAddSubView;
@property(nonatomic,strong)IBOutlet UIImageView *imgViewAdd;
@property(nonatomic,strong)IBOutlet UITextView *txvDescription;




@property (weak, nonatomic) IBOutlet UITextField *txtName1;

@property (weak, nonatomic) IBOutlet UITextField *txtTitle1;

@property (weak, nonatomic) IBOutlet UITextField *txtName2;

@property (weak, nonatomic) IBOutlet UITextField *txtTitle2;

@property (weak, nonatomic) IBOutlet UITextField *txtName3;

@property (weak, nonatomic) IBOutlet UITextField *txtTitle3;

@property (weak, nonatomic) IBOutlet UITextField *txtName4;

@property (weak, nonatomic) IBOutlet UITextField *txtTitle4;

@property (weak, nonatomic) IBOutlet UITextField *txtName5;

@property (weak, nonatomic) IBOutlet UITextField *txtTitle5;

@property (weak, nonatomic) IBOutlet UITextField *txtname6;

@property (weak, nonatomic) IBOutlet UITextField *txtTitle6;

@property (weak, nonatomic) IBOutlet UITextField *txtName7;

@property (weak, nonatomic) IBOutlet UITextField *txtTitle7;

@property (weak, nonatomic) IBOutlet UITextField *txtName8;

@property (weak, nonatomic) IBOutlet UITextField *txtTitle8;


@property (weak, nonatomic) IBOutlet UITextField *txtCompany1;

@property (weak, nonatomic) IBOutlet UITextField *txtDescription1;

@property (weak, nonatomic) IBOutlet UITextField *txtCompany2;

@property (weak, nonatomic) IBOutlet UITextField *txtDescription2;

@property (weak, nonatomic) IBOutlet UITextField *txtCompany3;

@property (weak, nonatomic) IBOutlet UITextField *txtDescription3;


@property (weak, nonatomic) IBOutlet UITextField *txtCompany4;

@property (weak, nonatomic) IBOutlet UITextField *txtDescription4;

@property (weak, nonatomic) IBOutlet UITextField *txtHours;


@property (weak, nonatomic) IBOutlet UITextField *contractor;

@property (weak, nonatomic) IBOutlet UITextField *txtAddress;

@property (weak, nonatomic) IBOutlet UITextField *txtCity;

@property (weak, nonatomic) IBOutlet UITextField *txtState;

@property (weak, nonatomic) IBOutlet UITextField *txtTel;

@property (weak, nonatomic) IBOutlet UITextField *txtDate;

@property (weak, nonatomic) IBOutlet UITextField *txtCompetent;

@property (weak, nonatomic) IBOutlet UITextField *txtProject;

@property (weak, nonatomic) IBOutlet UITextField *txtTwn;

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;

@property (weak, nonatomic) IBOutlet UITextView *txtWrkDone;

@property (weak, nonatomic) IBOutlet UILabel *txtHeader;
@property (weak, nonatomic) IBOutlet UITextField *zip;

@end
