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
    UIPageControl *pageControl;
    BOOL pageControlBeingUsed;
}

@property(nonatomic,retain) UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UILabel *CNo;
@property(nonatomic,strong)UIImagePickerController *imagePicker;
@property(nonatomic,assign)BOOL isFromSketches;
@property(nonatomic,assign)BOOL isFromReport;
@property(nonatomic,strong)NSMutableArray *arrayImages;



@property (weak, nonatomic) IBOutlet UILabel *lblComNotNum;


@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic,strong)IBOutlet UITextField *txtDateIssued;
@property(nonatomic,strong)IBOutlet UITextField *txtDateContractorStarted;
@property(nonatomic,strong)IBOutlet UITextField *txtDateContractorCompleted;
@property(nonatomic,strong)IBOutlet UITextField *txtDateofRawReprote;
@property(nonatomic,strong)IBOutlet UITextField *txtDate;
@property(nonatomic,strong)IBOutlet UIImageView *txtSignature;
@property (strong, nonatomic) IBOutlet UITextView *conRes;
@property (strong, nonatomic) IBOutlet UITextView *correctAction;
@property(nonatomic,strong)IBOutlet UITextField *EditComNumber;
@property(nonatomic,strong)IBOutlet UITextField *COtextTitle;
@property(nonatomic,strong)IBOutlet UITextField *COtextProject;
@property(nonatomic,strong)IBOutlet UIView *imageAddSubView;
@property(nonatomic,strong)IBOutlet UIImageView *imgViewAdd;
@property(nonatomic,strong)IBOutlet UITextView *txvDescription;
@property(nonatomic,strong) IBOutlet UIView *viewGallery;
@property(nonatomic,strong)IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtContactNo;
@property (weak, nonatomic) IBOutlet UITextView *txtProDesc;
@property (weak, nonatomic) IBOutlet UITextField *txtTo;
@property (weak, nonatomic) IBOutlet UITextField *txtUserId;
@property (weak, nonatomic) IBOutlet UITextField *txtPrintedName;
- (id)initWithData:(NSDictionary *)sourceDictionary;

@end