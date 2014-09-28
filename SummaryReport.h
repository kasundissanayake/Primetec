//
//  SummaryReport.h
//  ComSMART
//
//  Created by Lingeswaran Kandasamy on 5/2/14.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"

@interface SummaryReport : UIViewController<MFMailComposeViewControllerDelegate,UIPrintInteractionControllerDelegate,MBProgressHUDDelegate>
{
     UIPrintInteractionController *printController;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic,strong)IBOutlet UILabel *lblImageAttachmentTitle;
@property(nonatomic,strong)IBOutlet UIView *viewImageAttachmentTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtContractor;
@property (weak, nonatomic) IBOutlet UITextField *txtPOBox;
@property (weak, nonatomic) IBOutlet UITextField *txtCity;
@property (weak, nonatomic) IBOutlet UITextField *txtState;
@property (weak, nonatomic) IBOutlet UITextField *txtTpNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtCheckedBy;
@property (weak, nonatomic) IBOutlet UITextField *txtDate;
@property (weak, nonatomic) IBOutlet UITextField *txtDateOfWork;
@property (weak, nonatomic) IBOutlet UITextField *txtReportNum;
@property (weak, nonatomic) IBOutlet UITextField *txtContactorPerform;
@property (weak, nonatomic) IBOutlet UITextField *txtFederalAid;
@property (weak, nonatomic) IBOutlet UITextField *txtProjectNo;
@property (weak, nonatomic) IBOutlet UITextView *txvDesWork;
@property (weak, nonatomic) IBOutlet UITextView *txvConsOrder;
@property (weak, nonatomic) IBOutlet UITextField *txtClass1;
@property (weak, nonatomic) IBOutlet UITextField *txtClass2;
@property (weak, nonatomic) IBOutlet UITextField *txtClass3;
@property (weak, nonatomic) IBOutlet UITextField *txtClass4;
@property (weak, nonatomic) IBOutlet UITextField *txtClass5;
@property (weak, nonatomic) IBOutlet UITextField *txtNo1;
@property (weak, nonatomic) IBOutlet UITextField *txtNo2;
@property (weak, nonatomic) IBOutlet UITextField *txtNo3;
@property (weak, nonatomic) IBOutlet UITextField *txtNo4;
@property (weak, nonatomic) IBOutlet UITextField *txtNo5;
@property (weak, nonatomic) IBOutlet UITextField *txtTotal1;
@property (weak, nonatomic) IBOutlet UITextField *txtTotal2;
@property (weak, nonatomic) IBOutlet UITextField *txtTotal3;
@property (weak, nonatomic) IBOutlet UITextField *txtTotal4;
@property (weak, nonatomic) IBOutlet UITextField *txtTotal5;
@property (weak, nonatomic) IBOutlet UITextField *txtRate1;
@property (weak, nonatomic) IBOutlet UITextField *txtRate2;
@property (weak, nonatomic) IBOutlet UITextField *txtRate3;
@property (weak, nonatomic) IBOutlet UITextField *txtRate4;
@property (weak, nonatomic) IBOutlet UITextField *txtRate5;
@property (weak, nonatomic) IBOutlet UITextField *txtAmt1;
@property (weak, nonatomic) IBOutlet UITextField *txtAmt2;
@property (weak, nonatomic) IBOutlet UITextField *txtAmt3;
@property (weak, nonatomic) IBOutlet UITextField *txtAmt4;
@property (weak, nonatomic) IBOutlet UITextField *txtAmt5;
@property (weak, nonatomic) IBOutlet UITextField *txtTotalLabor;
@property (weak, nonatomic) IBOutlet UITextField *txtHealth;
@property (weak, nonatomic) IBOutlet UITextField *txtInsTax;
@property (weak, nonatomic) IBOutlet UITextField *txt20Items;
@property (weak, nonatomic) IBOutlet UITextField *txtTotalItems;
@property (weak, nonatomic) IBOutlet UITextField *txtDes1;
@property (weak, nonatomic) IBOutlet UITextField *txtDes2;
@property (weak, nonatomic) IBOutlet UITextField *txtDes3;
@property (weak, nonatomic) IBOutlet UITextField *txtDes4;
@property (weak, nonatomic) IBOutlet UITextField *txtDES5;
@property (weak, nonatomic) IBOutlet UITextField *txtQuantity3;
@property (weak, nonatomic) IBOutlet UITextField *txtQuantity1;
@property (weak, nonatomic) IBOutlet UITextField *txtQuantity4;
@property (weak, nonatomic) IBOutlet UITextField *txtQuantity5;
@property (weak, nonatomic) IBOutlet UITextField *txtQuantity2;
@property (weak, nonatomic) IBOutlet UITextField *txtUnitPrice1;
@property (weak, nonatomic) IBOutlet UITextField *txtUnitPrice2;
@property (weak, nonatomic) IBOutlet UITextField *txtUnitPrice3;
@property (weak, nonatomic) IBOutlet UITextField *txtUnitPrice4;
@property (weak, nonatomic) IBOutlet UITextField *txtUnitPrice5;

@property (weak, nonatomic) IBOutlet UITextField *txtMAmt1;
@property (weak, nonatomic) IBOutlet UITextField *txtMAmt2;
@property (weak, nonatomic) IBOutlet UITextField *txtMAmt3;
@property (weak, nonatomic) IBOutlet UITextField *txtMAmt4;
@property (weak, nonatomic) IBOutlet UITextField *txtMAmt5;
@property (weak, nonatomic) IBOutlet UITextField *txtTotalMeterial;
@property (weak, nonatomic) IBOutlet UITextField *txtLessDiscount;
@property (weak, nonatomic) IBOutlet UITextField *txtLessDisTotal;
@property (weak, nonatomic) IBOutlet UITextField *txtAdditional;
@property (weak, nonatomic) IBOutlet UITextField *txtAddTotal;
@property (weak, nonatomic) IBOutlet UITextField *txtSize1;
@property (weak, nonatomic) IBOutlet UITextField *txtSize2;
@property (weak, nonatomic) IBOutlet UITextField *txtSize3;
@property (weak, nonatomic) IBOutlet UITextField *txtSize4;
@property (weak, nonatomic) IBOutlet UITextField *txtSize5;
@property (weak, nonatomic) IBOutlet UITextField *txtActive1;
@property (weak, nonatomic) IBOutlet UITextField *txtActive2;
@property (weak, nonatomic) IBOutlet UITextField *txtActive3;
@property (weak, nonatomic) IBOutlet UITextField *txtActive4;
@property (weak, nonatomic) IBOutlet UITextField *txtActive5;
@property (weak, nonatomic) IBOutlet UITextField *txtENo1;
@property (weak, nonatomic) IBOutlet UITextField *txtENo2;
@property (weak, nonatomic) IBOutlet UITextField *txtENo3;
@property (weak, nonatomic) IBOutlet UITextField *txtENo4;
@property (weak, nonatomic) IBOutlet UITextField *txtENo5;
@property (weak, nonatomic) IBOutlet UITextField *txtETotal1;
@property (weak, nonatomic) IBOutlet UITextField *txtETotal2;
@property (weak, nonatomic) IBOutlet UITextField *txtEtotal3;
@property (weak, nonatomic) IBOutlet UITextField *txtETotal4;
@property (weak, nonatomic) IBOutlet UITextField *txtETotal5;
@property (weak, nonatomic) IBOutlet UITextField *txtInspector;

@property (weak, nonatomic) IBOutlet UITextField *txtContractorRepresentative;
@property (weak, nonatomic) IBOutlet UIImageView *imgSignature;
@property (weak, nonatomic) IBOutlet UIImageView *imgSignature2;
@property (weak, nonatomic) IBOutlet UITextField *txtConReDate;
@property (weak, nonatomic) IBOutlet UITextField *txtDailyTotal;
@property (weak, nonatomic) IBOutlet UITextField *txtTotalDate;
@property (weak, nonatomic) IBOutlet UITextField *txtERate1;
@property (weak, nonatomic) IBOutlet UITextField *txtERate2;
@property (weak, nonatomic) IBOutlet UITextField *txtERate3;
@property (weak, nonatomic) IBOutlet UITextField *txtERate4;
@property (weak, nonatomic) IBOutlet UITextField *txtERate5;
@property (weak, nonatomic) IBOutlet UITextField *txtEAmt1;
@property (weak, nonatomic) IBOutlet UITextField *txtEAmt2;
@property (weak, nonatomic) IBOutlet UITextField *txtEAmt3;
@property (weak, nonatomic) IBOutlet UITextField *txtEAmt4;
@property (weak, nonatomic) IBOutlet UITextField *txtEAmt5;
@property(nonatomic,retain)NSString *SMNo;
@property (weak, nonatomic) IBOutlet UITextField *reportNoForEdit;

@end
