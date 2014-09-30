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

- (id)initWithData:(NSDictionary *)sourceDictionary1;




@property (weak, nonatomic) IBOutlet UILabel *lblCom;


@property(nonatomic,strong)IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextView *projectDesc;
@property (strong, nonatomic) IBOutlet UITextView *contractorResp;
@property (strong, nonatomic) IBOutlet UITextView *correctiveAction;
@property(nonatomic,strong)IBOutlet UITextField *NtxtDateIssued;
@property(nonatomic,strong)IBOutlet UITextField *NtxtDateContractorStarted;
@property(nonatomic,strong)IBOutlet UITextField *NtxtDateContractorCompleted;
@property(nonatomic,strong)IBOutlet UITextField *NtxtDateofRawReprote;
@property(nonatomic,strong)IBOutlet UITextField *NtxtDate;
@property(nonatomic,strong)IBOutlet UITextField *DCRC;
@property(nonatomic,strong)IBOutlet UIImageView *imgSignature;
@property(nonatomic,strong)IBOutlet UITextField *nonCOtextTitle;
@property(nonatomic,strong)IBOutlet UITextField *nonCOtextProject;
@property(nonatomic,strong)IBOutlet UITextField *txtTitle;
@property(nonatomic,strong)IBOutlet UIView *imageAddSubView;
@property(nonatomic,strong)IBOutlet UIImageView *imgViewAdd;
@property(nonatomic,strong)IBOutlet UITextView *txvDescription;
@property (weak, nonatomic) IBOutlet UITextField *txtContactNo;
@property (weak, nonatomic) IBOutlet UITextField *txtTo;
@property (weak, nonatomic) IBOutlet UITextField *txtUserId;
@property (weak, nonatomic) IBOutlet UITextField *txtPrintedName;
@property (weak, nonatomic) IBOutlet UITextField *EditNonNoticeNo;


@end