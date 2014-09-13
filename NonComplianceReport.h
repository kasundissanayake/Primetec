//
//  NonComplianceReport.h
//  ComSMART
//
//  Created by Lingeswaran Kandasamy on 5/2/14.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"

@interface NonComplianceReport : UIViewController<MFMailComposeViewControllerDelegate,MBProgressHUDDelegate,UIPrintInteractionControllerDelegate>
{
     UIPrintInteractionController *printController;
}
@property (strong, nonatomic) IBOutlet UITextView *lblProjDec;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic,strong)IBOutlet UITableView *tblView;
@property(nonatomic,strong)IBOutlet UIView *headerView;

@property(nonatomic,strong)IBOutlet UILabel *lblImageAttachmentTitle;
@property(nonatomic,strong)IBOutlet UIView *viewImageAttachmentTitle;
@property(nonatomic,retain)NSString *CNo;
@property (weak, nonatomic) IBOutlet UITextField *txtContactNo;

@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtProject;
@property (weak, nonatomic) IBOutlet UITextField *txtDateIssued;
@property (strong, nonatomic) IBOutlet UITextView *lblCorrectiveActionComp;
@property (weak, nonatomic) IBOutlet UITextField *txtTo;
@property (weak, nonatomic) IBOutlet UITextField *txtDateContractorStarted;
@property (weak, nonatomic) IBOutlet UITextField *txtDateOfRawReport;
@property (weak, nonatomic) IBOutlet UITextField *txtDateContractCompleted;

@property (weak, nonatomic) IBOutlet UITextField *txtPrintedName;
@property (weak, nonatomic) IBOutlet UITextField *txtDate;
@property (weak, nonatomic) IBOutlet UIImageView *imgSignature;

@property (strong, nonatomic) IBOutlet UITextView *lblContractorRes;

@property (strong, nonatomic) IBOutlet UITextField *nonComNotNo;

@property (strong, nonatomic) IBOutlet UITextField *dateCRC;

-(void)populateNonComplianceForm;
@end
