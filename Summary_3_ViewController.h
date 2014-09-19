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




/*


@property(nonatomic,strong)IBOutlet UITextField *StxtDateINS;
@property(nonatomic,strong)IBOutlet UITextField *StxtDateCR;
 
 
 

 
 
 
@property (strong, nonatomic) IBOutlet UITextField *txtHours1;
@property (strong, nonatomic) IBOutlet UITextField *txtHours2;
@property (strong, nonatomic) IBOutlet UITextField *txtHours3;
@property (strong, nonatomic) IBOutlet UITextField *txtHours4;
@property (strong, nonatomic) IBOutlet UITextField *txtHours5;
@property (strong, nonatomic) IBOutlet UITextField *txtRate1;
@property (strong, nonatomic) IBOutlet UITextField *txtRate2;
@property (strong, nonatomic) IBOutlet UITextField *txtRate3;
@property (strong, nonatomic) IBOutlet UITextField *txtRate4;
@property (strong, nonatomic) IBOutlet UITextField *txtRate5;
@property (strong, nonatomic) IBOutlet UITextField *txtTotal1;
@property (strong, nonatomic) IBOutlet UITextField *txtTotal2;
@property (strong, nonatomic) IBOutlet UITextField *txtTotal3;
@property (strong, nonatomic) IBOutlet UITextField *txtTotal4;
@property (strong, nonatomic) IBOutlet UITextField *txtTotal5;
@property (strong, nonatomic) IBOutlet UITextField *txtDailyTotal5;
@property (strong, nonatomic) IBOutlet UITextField *txtTotaToDatel5;
@property (weak, nonatomic) IBOutlet UITextField *class1;
@property (weak, nonatomic) IBOutlet UITextField *class2;
@property (weak, nonatomic) IBOutlet UITextField *class3;
@property (weak, nonatomic) IBOutlet UITextField *class4;
@property (weak, nonatomic) IBOutlet UITextField *class5;

@property (weak, nonatomic) IBOutlet UITextField *active1;
@property (weak, nonatomic) IBOutlet UITextField *active2;
@property (weak, nonatomic) IBOutlet UITextField *active3;
@property (weak, nonatomic) IBOutlet UITextField *active4;
@property (weak, nonatomic) IBOutlet UITextField *active5;
@property (weak, nonatomic) IBOutlet UITextField *no1;
@property (weak, nonatomic) IBOutlet UITextField *no2;
@property (weak, nonatomic) IBOutlet UITextField *no3;
@property (weak, nonatomic) IBOutlet UITextField *no4;
@property (weak, nonatomic) IBOutlet UITextField *no5;
@property (weak, nonatomic) IBOutlet UITextField *inspecter;
@property (weak, nonatomic) IBOutlet UITextField *pm;


*/

@end
