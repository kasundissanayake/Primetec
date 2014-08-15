//
//  ExpenseReport.h
//  ComSMART
//
//  Created by Lingeswaran Kandasamy on 5/2/14.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"


@interface ExpenseReport : UIViewController<MFMailComposeViewControllerDelegate,MBProgressHUDDelegate,UIPrintInteractionControllerDelegate>
{
     UIPrintInteractionController *printController;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) IBOutlet UIView *headerView;


@property(nonatomic,strong)IBOutlet UILabel *lblImageAttachmentTitle;
@property(nonatomic,strong)IBOutlet UIView *viewImageAttachmentTitle;
@property(nonatomic,retain)IBOutlet UITableView *tblSubView;
@property (weak, nonatomic) IBOutlet UITextField *txtCashAdvance;
@property (weak, nonatomic) IBOutlet UITextField *txtReimbursement;
@property (weak, nonatomic) IBOutlet UITextField *txtEmpName;
@property (weak, nonatomic) IBOutlet UIImageView *imgSignature;
@property (weak, nonatomic) IBOutlet UITextField *txtDate;
@property (weak, nonatomic) IBOutlet UITextField *txtApprovedBy;
@property (weak, nonatomic) IBOutlet UITextField *txtWeakEnding;
@property (weak, nonatomic) IBOutlet UITextField *txtEmpNo;
@property (weak, nonatomic) IBOutlet UITextField *txtCheckNumber;


@property(nonatomic,retain)NSString *ExNo;
@end
