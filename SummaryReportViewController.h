//
//  SummaryReportViewController.h
//  TabAndSplitApp
//
//  Created by Lingeswaran Kandasamy on 4/2/14.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface SummaryReportViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, MBProgressHUDDelegate>

@property(nonatomic,strong)IBOutlet UIScrollView *scrollView;
@property(nonatomic,strong)NSMutableArray *arrayImages;
@property (weak, nonatomic) IBOutlet UITextField *sumContracter;
@property (weak, nonatomic) IBOutlet UITextField *sumAddress;
@property (weak, nonatomic) IBOutlet UITextField *sumCity;
@property (weak, nonatomic) IBOutlet UITextField *sumState;
@property (weak, nonatomic) IBOutlet UITextField *sumTel;
@property (weak, nonatomic) IBOutlet UITextField *sumDate;
@property (weak, nonatomic) IBOutlet UITextField *sumPW;
@property (weak, nonatomic) IBOutlet UITextField *sumFAN;
@property (weak, nonatomic) IBOutlet UITextField *sumProjectNum;
@property (weak, nonatomic) IBOutlet UITextView *sumDescription;
@property (weak, nonatomic) IBOutlet UITextView *sumConOrder;
@property (weak, nonatomic) IBOutlet UITextField *sumClass1;
@property (weak, nonatomic) IBOutlet UITextField *sumClass2;
@property (weak, nonatomic) IBOutlet UITextField *sumClass3;
@property (weak, nonatomic) IBOutlet UITextField *sumClass5;
@property (weak, nonatomic) IBOutlet UITextField *sumClass4;
@property (weak, nonatomic) IBOutlet UITextField *sumNo1;
@property (weak, nonatomic) IBOutlet UITextField *sumNo2;
@property (weak, nonatomic) IBOutlet UITextField *sumNo3;
@property (weak, nonatomic) IBOutlet UITextField *sumNo4;
@property (weak, nonatomic) IBOutlet UITextField *sumNo5;
@property (weak, nonatomic) IBOutlet UITextField *sumHr1;
@property (weak, nonatomic) IBOutlet UITextField *sumHr2;
@property (weak, nonatomic) IBOutlet UITextField *sumHr3;
@property (weak, nonatomic) IBOutlet UITextField *sumHr4;
@property (weak, nonatomic) IBOutlet UITextField *sumHr5;
@property (weak, nonatomic) IBOutlet UITextField *sumRate1;
@property (weak, nonatomic) IBOutlet UITextField *sumRate2;
@property (weak, nonatomic) IBOutlet UITextField *sumRate3;
@property (weak, nonatomic) IBOutlet UITextField *sumRate4;
@property (weak, nonatomic) IBOutlet UITextField *sumRate5;
@property (weak, nonatomic) IBOutlet UITextField *sumAmt1;
@property (weak, nonatomic) IBOutlet UITextField *sumAmt2;
@property (weak, nonatomic) IBOutlet UITextField *sumAmt3;
@property (weak, nonatomic) IBOutlet UITextField *sumAmt4;
@property (weak, nonatomic) IBOutlet UITextField *sumAmt5;
@property (weak, nonatomic) IBOutlet UITextField *sumTotLbr;
@property (weak, nonatomic) IBOutlet UITextField *sumHealth;
@property (weak, nonatomic) IBOutlet UITextField *sumIns;
@property (weak, nonatomic) IBOutlet UITextField *sum20;
@property (weak, nonatomic) IBOutlet UITextField *sumTotal;
@property (weak, nonatomic) IBOutlet UILabel *header;
@property (weak, nonatomic) IBOutlet UITextField *summeryZip;


@end
