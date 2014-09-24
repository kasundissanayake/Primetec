//
//  Summary_3_ViewController.h
//  TabAndSplitApp
//
//  Created by Lingeswaran Kandasamy on 4/2/14.
//
//

#import <UIKit/UIKit.h>
#import "SummaryReportViewController.h"
#import "Summary_2_ViewController.h"
#import "MBProgressHUD.h"

@interface Summary_3_ViewController : UIViewController <MBProgressHUDDelegate>

@property BOOL isEdit;

@property(nonatomic,strong) NSString *smSheetNumber;


@property(nonatomic,strong) NSString *sm3class1;
@property(nonatomic,strong) NSString *sm3class2;
@property(nonatomic,strong) NSString *sm3class3;
@property(nonatomic,strong) NSString *sm3class4;
@property(nonatomic,strong) NSString *sm3class5;

@property(nonatomic,strong) NSString *sm3act1;
@property(nonatomic,strong) NSString *sm3act2;
@property(nonatomic,strong) NSString *sm3act3;
@property(nonatomic,strong) NSString *sm3act4;
@property(nonatomic,strong) NSString *sm3act5;

@property(nonatomic,strong) NSString *sm3no1;
@property(nonatomic,strong) NSString *sm3no2;
@property(nonatomic,strong) NSString *sm3no3;
@property(nonatomic,strong) NSString *sm3no4;
@property(nonatomic,strong) NSString *sm3no5
;
@property(nonatomic,strong) NSString *sm3hr1;
@property(nonatomic,strong) NSString *sm3hr2;
@property(nonatomic,strong) NSString *sm3hr3;
@property(nonatomic,strong) NSString *sm3hr4;
@property(nonatomic,strong) NSString *sm3hr5;

@property(nonatomic,strong) NSString *sm3rate1;
@property(nonatomic,strong) NSString *sm3rate2;
@property(nonatomic,strong) NSString *sm3rate3;
@property(nonatomic,strong) NSString *sm3rate4;
@property(nonatomic,strong) NSString *sm3rate5;

@property(nonatomic,strong) NSString *sm3amt1;
@property(nonatomic,strong) NSString *sm3amt2;
@property(nonatomic,strong) NSString *sm3amt3;
@property(nonatomic,strong) NSString *sm3amt4;
@property(nonatomic,strong) NSString *sm3amt5;

@property(nonatomic,strong) NSString *sm3dtotal;
@property(nonatomic,strong) NSString *sm3dtotaldate;





@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property(nonatomic,strong)IBOutlet UITextField *contractorRepresentative;
@property(nonatomic,strong)IBOutlet UITextField *dailyTotal;

@property(nonatomic,strong)IBOutlet UITextField *date1;
@property(nonatomic,strong)IBOutlet UITextField *date2;

@property (strong, nonatomic) IBOutlet UITextField *eQAmount1;
@property (strong, nonatomic) IBOutlet UITextField *eQAmount2;
@property (strong, nonatomic) IBOutlet UITextField *eQAmount3;
@property (strong, nonatomic) IBOutlet UITextField *eQAmount4;
@property (strong, nonatomic) IBOutlet UITextField *eQAmount5;
@property (strong, nonatomic) IBOutlet UITextField *eQIdleActive1;
@property (strong, nonatomic) IBOutlet UITextField *eQIdleActive2;
@property (strong, nonatomic) IBOutlet UITextField *eQIdleActive3;
@property (strong, nonatomic) IBOutlet UITextField *eQIdleActive4;
@property (strong, nonatomic) IBOutlet UITextField *eQIdleActive5;
@property (strong, nonatomic) IBOutlet UITextField *eQNo1;
@property (strong, nonatomic) IBOutlet UITextField *eQNo2;
@property (strong, nonatomic) IBOutlet UITextField *eQNo3;
@property (strong, nonatomic) IBOutlet UITextField *eQNo4;
@property (strong, nonatomic) IBOutlet UITextField *eQNo5;
@property (strong, nonatomic) IBOutlet UITextField *eQRAte1;
@property (strong, nonatomic) IBOutlet UITextField *eQRAte2;
@property (weak, nonatomic) IBOutlet UITextField *eQRAte3;
@property (weak, nonatomic) IBOutlet UITextField *eQRAte4;
@property (weak, nonatomic) IBOutlet UITextField *eQRAte5;
@property (weak, nonatomic) IBOutlet UITextField *eQSizeandClass1;
@property (weak, nonatomic) IBOutlet UITextField *eQSizeandClass2;
@property(nonatomic,strong)NSMutableArray *arrayImages;
@property (weak, nonatomic) IBOutlet UITextField *eQSizeandClass3;
@property (weak, nonatomic) IBOutlet UITextField *eQSizeandClass4;
@property (weak, nonatomic) IBOutlet UITextField *eQSizeandClass5;
@property (weak, nonatomic) IBOutlet UITextField *eQTotalHours1;
@property (weak, nonatomic) IBOutlet UITextField *eQTotalHours2;
@property (weak, nonatomic) IBOutlet UITextField *eQTotalHours3;
@property (weak, nonatomic) IBOutlet UITextField *eQTotalHours4;
@property (weak, nonatomic) IBOutlet UITextField *eQTotalHours5;
@property (weak, nonatomic) IBOutlet UITextField *inspector;
@property (weak, nonatomic) IBOutlet UITextField *project_id;
@property(nonatomic,strong)IBOutlet UIImageView *signature1;
@property(nonatomic,strong)IBOutlet UIImageView *signature2;
@property (weak, nonatomic) IBOutlet UITextField *sMSheetNo;
@property (weak, nonatomic) IBOutlet UITextField *total_to_date;



@end