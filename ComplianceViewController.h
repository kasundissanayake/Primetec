//
//  ComplianceViewController.h
//  TabAndSplitApp
//
//  Created by Lingeswaran Kandasamy on 4/1/14.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface ComplianceViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDataSource,UITableViewDelegate,UIPopoverControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,MBProgressHUDDelegate>
{
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    BOOL pageControlBeingUsed;
}

@property (strong, nonatomic) IBOutlet UILabel *CNo;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property(nonatomic,strong)IBOutlet UIView *imageSubView;

@property(nonatomic,retain) UIDatePicker *datePicker;


@property(nonatomic,strong)IBOutlet UITextField *txtDateIssued;
@property(nonatomic,strong)IBOutlet UITextField *txtDateContractorStarted;
@property(nonatomic,strong)IBOutlet UITextField *txtDateContractorCompleted;
@property(nonatomic,strong)IBOutlet UITextField *txtDateofRawReprote;
@property(nonatomic,strong)IBOutlet UITextField *txtDate;



@property(nonatomic,strong)IBOutlet UIImageView *txtSignature;



@property (strong, nonatomic) IBOutlet UITextView *conRes;
@property (strong, nonatomic) IBOutlet UITextView *correctAction;



@property(nonatomic,strong)IBOutlet UITextField *COtextTitle;
@property(nonatomic,strong)IBOutlet UITextField *COtextProject;

@property(nonatomic,strong)UIImagePickerController *imagePicker;
@property(nonatomic,strong)IBOutlet UIButton *btnAttachImage;


@property(nonatomic,strong)IBOutlet UIView *imageAddSubView;
@property(nonatomic,strong)IBOutlet UIImageView *imgViewAdd;
@property(nonatomic,strong)IBOutlet UITextView *txvDescription;

//@property(nonatomic,retain)NSMutableArray *arrayImages;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollViewLibrary;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) IBOutlet UITextView *txtDescription;
@property(nonatomic,strong) IBOutlet UIView *viewGallery;
@property(nonatomic,strong)IBOutlet UILabel *lblTitle;
@property(nonatomic,assign)BOOL isFromSketches;
@property(nonatomic,assign)BOOL isFromReport;
@property(nonatomic,strong)IBOutlet UIView *librarySubView;
@property(nonatomic,strong)NSMutableArray *arrayImages;
@property(nonatomic,strong)IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtContactNo;
@property (weak, nonatomic) IBOutlet UITextField *txtComNoticeNo;
@property (weak, nonatomic) IBOutlet UITextView *txtProDesc;
@property (weak, nonatomic) IBOutlet UITextField *txtTo;
@property (weak, nonatomic) IBOutlet UITextField *txtUserId;
@property (weak, nonatomic) IBOutlet UITextField *txtPrintedName;




@end
