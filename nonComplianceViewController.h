//
//  nonComplianceViewController.h
//  PRIMECMAPP
//
//  Created by Lingeswaran Kandasamy on 9/27/14.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface nonComplianceViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,MBProgressHUDDelegate>

@property(nonatomic,assign)BOOL isFromSketches;
@property(nonatomic,assign)BOOL isFromReport;
@property(nonatomic,strong)NSMutableArray *arrayImages;
@property(nonatomic,strong)UIImagePickerController *imagePicker;


@property (weak, nonatomic) IBOutlet UILabel *lblCom;

@property(nonatomic,strong)IBOutlet UIView *imageAddSubView;
@property(nonatomic,strong)IBOutlet UIImageView *imgViewAdd;
@property(nonatomic,strong)IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextView *projectDesc;
@property (weak, nonatomic) IBOutlet UITextView *contractorResp;
@property (weak, nonatomic) IBOutlet UITextView *correctiveAction;
@property(nonatomic,weak)IBOutlet UITextField *NtxtDateIssued;
@property(nonatomic,weak)IBOutlet UITextField *NtxtDateContractorStarted;
@property(nonatomic,weak)IBOutlet UITextField *NtxtDateContractorCompleted;
@property(nonatomic,weak)IBOutlet UITextField *NtxtDateofRawReprote;
@property(nonatomic,weak)IBOutlet UITextField *NtxtDate;
@property(nonatomic,weak)IBOutlet UITextField *DCRC;
@property(nonatomic,weak)IBOutlet UIImageView *imgSignature;
@property(nonatomic,weak)IBOutlet UITextField *nonCOtextTitle;
@property(nonatomic,weak)IBOutlet UITextField *nonCOtextProject;
@property(nonatomic,weak)IBOutlet UITextField *txtTitle;

@property(nonatomic,weak)IBOutlet UITextView *txvDescription;
@property (weak, nonatomic) IBOutlet UITextField *txtContactNo;
@property (weak, nonatomic) IBOutlet UITextField *txtTo;
@property (weak, nonatomic) IBOutlet UITextField *txtUserId;
@property (weak, nonatomic) IBOutlet UITextField *txtPrintedName;
@property (weak, nonatomic) IBOutlet UITextField *EditNonNoticeNo;
- (id)initWithData:(NSDictionary *)sourceDictionary1;

@end