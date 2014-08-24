//
//  DailyInspectionReport.h
//  ComSMART
//
//  Created by Lingeswaran Kandasamy on 5/2/14.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"


@interface DailyInspectionReport : UIViewController<MFMailComposeViewControllerDelegate,MBProgressHUDDelegate,UIPrintInteractionControllerDelegate>
{
    UIPrintInteractionController *printController;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;



@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UITableView *tblView;

@property (strong, nonatomic) IBOutlet UITextView *lblProject;
@property (strong, nonatomic) IBOutlet UITextView *txtWorkDone;

@property(nonatomic,strong)IBOutlet UILabel *lblImageAttachmentTitle;
@property(nonatomic,strong)IBOutlet UIView *viewImageAttachmentTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtContractor;
@property (weak, nonatomic) IBOutlet UITextField *txtAdressPOBox;
@property (weak, nonatomic) IBOutlet UITextField *txtCity;
@property (weak, nonatomic) IBOutlet UITextField *txtState;
@property (weak, nonatomic) IBOutlet UITextField *txtTelephone;
@property (weak, nonatomic) IBOutlet UITextField *txtCometentPerson;

@property (weak, nonatomic) IBOutlet UITextField *txtTown;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;

@property (weak, nonatomic) IBOutlet UITextField *txtOfficeName1;
@property (weak, nonatomic) IBOutlet UITextField *txtOfficeTitle1;
@property (weak, nonatomic) IBOutlet UITextField *txtOfficeName2;
@property (weak, nonatomic) IBOutlet UITextField *txtOfficeName3;
@property (weak, nonatomic) IBOutlet UITextField *txtOfficeName4;
@property (weak, nonatomic) IBOutlet UITextField *txtOfficeTitle2;
@property (weak, nonatomic) IBOutlet UITextField *txtOfficeTitle3;
@property (weak, nonatomic) IBOutlet UITextField *txtOfficeTitle4;
@property (weak, nonatomic) IBOutlet UITextField *txtInspecName1;
@property (weak, nonatomic) IBOutlet UITextField *txtInspecName2;
@property (weak, nonatomic) IBOutlet UITextField *txtInspecName3;
@property (weak, nonatomic) IBOutlet UITextField *txtInspecTitle1;
@property (weak, nonatomic) IBOutlet UITextField *txtInspecTitle2;
@property (weak, nonatomic) IBOutlet UITextField *txtInspecTitle3;
@property (weak, nonatomic) IBOutlet UITextField *txtWorkDoneDepart1;
@property (weak, nonatomic) IBOutlet UITextField *txtWorkDoneDepart2;
@property (weak, nonatomic) IBOutlet UITextField *txtWorkDoneDepart3;
@property (weak, nonatomic) IBOutlet UITextField *txtWorkDec1;
@property (weak, nonatomic) IBOutlet UITextField *txtWorkDec3;
@property (weak, nonatomic) IBOutlet UITextField *txtWorkDec2;
@property (weak, nonatomic) IBOutlet UITextField *txtHowToWork;
@property (weak, nonatomic) IBOutlet UIImageView *imgInspectorSignature;
@property(nonatomic,retain)NSString *CNo;
@property (weak, nonatomic) IBOutlet UITextField *txtInspecName4;
@property (weak, nonatomic) IBOutlet UITextField *txtInspecTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtWorkDoneDepart4;
@property (weak, nonatomic) IBOutlet UITextField *txtWorkDec4;
@property (weak, nonatomic) IBOutlet UITextField *txtHoursOfWork;

@property (weak, nonatomic) IBOutlet UITextField *txtZip;




@property (weak, nonatomic) IBOutlet UITextField *repNo;
@property (weak, nonatomic) IBOutlet UITextField *conName;

@property (weak, nonatomic) IBOutlet UITextField *town;

@property (weak, nonatomic) IBOutlet UITextField *weather;
@property (weak, nonatomic) IBOutlet UITextField *time;
//@property (weak, nonatomic) IBOutlet UITextField *des1;
@property (weak, nonatomic) IBOutlet UITextView *des1;


@property (weak, nonatomic) IBOutlet UITextView *des2;

@property (weak, nonatomic) IBOutlet UITextView *des3;

@property (weak, nonatomic) IBOutlet UITextView *des4;

@property (weak, nonatomic) IBOutlet UITextView *des5;


@property (weak, nonatomic) IBOutlet UITextField *qua1;
@property (weak, nonatomic) IBOutlet UITextField *qua2;
@property (weak, nonatomic) IBOutlet UITextField *qua3;
@property (weak, nonatomic) IBOutlet UITextField *qua4;
@property (weak, nonatomic) IBOutlet UITextField *qua5;



@property (weak, nonatomic) IBOutlet UITextField *itemno1;

@property (weak, nonatomic) IBOutlet UITextField *itemno2;

@property (weak, nonatomic) IBOutlet UITextField *itemno3;

@property (weak, nonatomic) IBOutlet UITextField *itemno4;

@property (weak, nonatomic) IBOutlet UITextField *itemno5;

@property (weak, nonatomic) IBOutlet UITextField *caldays;

@property (weak, nonatomic) IBOutlet UITextField *useddays;


@end
