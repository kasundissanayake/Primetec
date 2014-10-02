//
//  ComplianceViewController.h
//  PRIMECMAPP
//
//  Created by Lingeswaran Kandasamy on 9/27/14.
//
//


#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "PRIMECMController.h"

@interface ComplianceViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDataSource,UITableViewDelegate,UIPopoverControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,MBProgressHUDDelegate>{
    UIScrollView *scrollView;
    
}

@property(nonatomic,retain) UIDatePicker *datePicker;

@property(nonatomic,strong)UIImagePickerController *imagePicker;
@property(nonatomic,assign)BOOL isFromSketches;
@property(nonatomic,assign)BOOL isFromReport;
@property(nonatomic,strong)NSMutableArray *arrayImages;


@property (weak, nonatomic) IBOutlet UILabel *lblnoNum;



@property(nonatomic,strong)IBOutlet UIView *imageAddSubView;
@property(nonatomic,strong)IBOutlet UIImageView *imgViewAdd;
@property (strong, nonatomic) IBOutlet UILabel *CNo;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property(nonatomic,weak)IBOutlet UITextField *txtDateIssued;
@property(nonatomic,weak)IBOutlet UITextField *txtDateContractorStarted;
@property(nonatomic,weak)IBOutlet UITextField *txtDateContractorCompleted;
@property(nonatomic,weak)IBOutlet UITextField *txtDateofRawReprote;
@property(nonatomic,weak)IBOutlet UITextField *txtDate;
@property(nonatomic,weak)IBOutlet UIImageView *txtSignature;
@property (weak, nonatomic) IBOutlet UITextView *conRes;
@property (weak, nonatomic) IBOutlet UITextView *correctAction;
@property(nonatomic,weak)IBOutlet UITextField *EditComNumber;
@property(nonatomic,weak)IBOutlet UITextField *COtextTitle;
@property(nonatomic,weak)IBOutlet UITextField *COtextProject;

@property(nonatomic,weak)IBOutlet UITextView *txvDescription;
@property(nonatomic,weak) IBOutlet UIView *viewGallery;
@property(nonatomic,weak)IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtContactNo;
@property (weak, nonatomic) IBOutlet UITextView *txtProDesc;
@property (weak, nonatomic) IBOutlet UITextField *txtTo;
@property (weak, nonatomic) IBOutlet UITextField *txtUserId;
@property (weak, nonatomic) IBOutlet UITextField *txtPrintedName;
- (id)initWithData:(NSDictionary *)sourceDictionary;

@end