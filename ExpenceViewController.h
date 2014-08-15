//
//  ExpenceViewController.h
//  TabAndSplitApp
//
//  Created by Lingeswaran Kandasamy on 4/2/14.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface ExpenceViewController : UIViewController<UIPickerViewDelegate,UIPopoverControllerDelegate,UIPickerViewDataSource,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, MBProgressHUDDelegate >


@property(nonatomic,strong)IBOutlet UIScrollView *scrollView;
@property(nonatomic,strong)IBOutlet UITextField *ERtextDate6;
@property (strong, nonatomic) IBOutlet UITextField *txtMil1;
@property (strong, nonatomic) IBOutlet UITextField *txtRate1;
@property (strong, nonatomic) IBOutlet UITextField *txtTotal1;
@property (strong, nonatomic) IBOutlet UITextField *cashAdvance;
@property (strong, nonatomic) IBOutlet UITextField *reimburs;
@property(nonatomic,strong)IBOutlet UIImageView *imgSignatureEx;

@property(nonatomic,strong)UIImagePickerController *imagePicker;
@property(nonatomic,assign)BOOL isFromSketches;
@property(nonatomic,assign)BOOL isFromReport;
@property(nonatomic,strong)NSMutableArray *arrayImages;
@property(nonatomic,strong)IBOutlet UIView *imageAddSubView;
@property(nonatomic,strong)IBOutlet UIImageView *imgViewAdd;
@property(nonatomic,strong)IBOutlet UITextView *txvDescription;

- (IBAction)butExp:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *header;
@property (weak, nonatomic) IBOutlet UITextField *ERtxtEmpName;
@property (weak, nonatomic) IBOutlet UITextField *ERtxtApprovedBy;
@property (weak, nonatomic) IBOutlet UITextField *ERtxtWeek;
@property (weak, nonatomic) IBOutlet UITextField *ERtxtCheckNum;
@property (weak, nonatomic) IBOutlet UITextField *ERdate6;

@property (weak, nonatomic) IBOutlet UITextField *ERtxtEmpNum;
@property (weak, nonatomic) IBOutlet UITextField *ERDescription;
@property (weak, nonatomic) IBOutlet UITextField *ERJobNo;
@property (weak, nonatomic) IBOutlet UITextField *ERType;


@end
