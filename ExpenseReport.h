//
//  ExpenseReport.h

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"

@interface ExpenseReport : UIViewController<MFMailComposeViewControllerDelegate,MBProgressHUDDelegate,UIPrintInteractionControllerDelegate>
{
    UIPrintInteractionController *printController;
}

@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) IBOutlet UIView *headerView;



@property(nonatomic,retain)IBOutlet UITableView *tblSubView;
@property (weak, nonatomic) IBOutlet UITextField *txtCashAdvance;
@property (weak, nonatomic) IBOutlet UITextField *txtReimbursement;
@property (weak, nonatomic) IBOutlet UITextField *txtEmpName;
@property (weak, nonatomic) IBOutlet UIImageView *imgSignature;
@property (weak, nonatomic) IBOutlet UITextField *txtDate;
@property (weak, nonatomic) IBOutlet UITextField *txtApprovedBy;
@property (weak, nonatomic) IBOutlet UITextField *txtWeakEnding;
@property (weak, nonatomic) IBOutlet UITextField *txtCheckNumber;
@property(nonatomic,retain)NSString *ExNo;


@property (strong, nonatomic) IBOutlet UITextField *txtMil1;
@property (strong, nonatomic) IBOutlet UITextField *txtRate1;
@property (strong, nonatomic) IBOutlet UITextField *txtTotal1;

@property (weak, nonatomic) IBOutlet UILabel *header;
@property (weak, nonatomic) IBOutlet UITextField *ERdate6;
@property (weak, nonatomic) IBOutlet UITextField *ERDescription;
@property (weak, nonatomic) IBOutlet UITextField *ERJobNo;
@property (weak, nonatomic) IBOutlet UITextField *ERType;
@property(nonatomic,retain)NSString *sigImgName;

@end