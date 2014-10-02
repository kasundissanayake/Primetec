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
{
    //  Radha
    NSMutableString *imgPath;
}
//Radha  is used for Edit or New also
@property(nonatomic,strong) NSString *exNUmber;
@property(nonatomic,strong)NSMutableArray *arrayImages;
@property(nonatomic,strong)IBOutlet UIView *imageAddSubView;
@property(nonatomic,strong)IBOutlet UIImageView *imgViewAdd;
@property(nonatomic,strong)IBOutlet UIImageView *imgSignatureEx;

@property(nonatomic,weak)IBOutlet UIScrollView *scrollView;
@property(nonatomic,weak)IBOutlet UITextField *ERtextDate6;
@property (weak, nonatomic) IBOutlet UITextField *txtMil1;
@property (weak, nonatomic) IBOutlet UITextField *txtRate1;
@property (weak, nonatomic) IBOutlet UITextField *txtTotal1;
@property (weak, nonatomic) IBOutlet UITextField *cashAdvance;
@property (weak, nonatomic) IBOutlet UITextField *reimburs;


@property(nonatomic,strong)UIImagePickerController *imagePicker;
@property(nonatomic,assign)BOOL isFromSketches;
@property(nonatomic,assign)BOOL isFromReport;

@property(nonatomic,weak)IBOutlet UITextView *txvDescription;

@property (weak, nonatomic) IBOutlet UILabel *header;
@property (weak, nonatomic) IBOutlet UITextField *ERtxtEmpName;
@property (weak, nonatomic) IBOutlet UITextField *ERtxtApprovedBy;
@property (weak, nonatomic) IBOutlet UITextField *ERtxtWeek;
@property (weak, nonatomic) IBOutlet UITextField *ERtxtCheckNum;
@property (weak, nonatomic) IBOutlet UITextField *ERdate6;

@property (weak, nonatomic) IBOutlet UITextField *ERDescription;
@property (weak, nonatomic) IBOutlet UITextField *ERJobNo;
@property (weak, nonatomic) IBOutlet UITextField *ERType;

- (id)initWithData:(NSDictionary *)sourceDictionary;

@end