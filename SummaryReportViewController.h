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



//Radha
@property BOOL isEdit;




@property(nonatomic,strong)IBOutlet UIScrollView *scrollView;
@property(nonatomic,strong)NSMutableArray *arrayImages;

@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *conPeWork;
@property (weak, nonatomic) IBOutlet UITextView *constructionOrder;
@property (weak, nonatomic) IBOutlet UITextField *contractor;
@property (weak, nonatomic) IBOutlet UITextField *date;
@property (weak, nonatomic) IBOutlet UITextView *descr;
@property (weak, nonatomic) IBOutlet UITextField *federalAidNumber;
@property (weak, nonatomic) IBOutlet UITextField *healWelAndPension;
@property (weak, nonatomic) IBOutlet UITextField *insAndTaxesOnItem1;
@property (weak, nonatomic) IBOutlet UITextField *itemDescount20per;
@property (weak, nonatomic) IBOutlet UITextField *lAAmount1;
@property (weak, nonatomic) IBOutlet UITextField *lAAmount2;
@property (weak, nonatomic) IBOutlet UITextField *lAAmount3;
@property (weak, nonatomic) IBOutlet UITextField *lAAmount4;
@property (weak, nonatomic) IBOutlet UITextField *lAAmount5;
@property (weak, nonatomic) IBOutlet UITextField *lAClass1;
@property (weak, nonatomic) IBOutlet UITextField *lAClass2;
@property (weak, nonatomic) IBOutlet UITextField *lAClass3;
@property (weak, nonatomic) IBOutlet UITextField *lAClass4;
@property (weak, nonatomic) IBOutlet UITextField *lAClass5;
@property (weak, nonatomic) IBOutlet UITextField *lANo1;
@property (weak, nonatomic) IBOutlet UITextField *lANo2;
@property (weak, nonatomic) IBOutlet UITextField *lANo3;
@property (weak, nonatomic) IBOutlet UITextField *lANo4;
@property (weak, nonatomic) IBOutlet UITextField *lANo5;
@property (weak, nonatomic) IBOutlet UITextField *lARate1;
@property (weak, nonatomic) IBOutlet UITextField *lARate2;
@property (weak, nonatomic) IBOutlet UITextField *lARate3;
@property (weak, nonatomic) IBOutlet UITextField *lARate4;
@property (weak, nonatomic) IBOutlet UITextField *lARate5;
@property (weak, nonatomic) IBOutlet UITextField *lATotalHours1;
@property (weak, nonatomic) IBOutlet UITextField *lATotalHours2;
@property (weak, nonatomic) IBOutlet UITextField *lATotalHours3;
@property (weak, nonatomic) IBOutlet UITextField *lATotalHours4;
@property (weak, nonatomic) IBOutlet UITextField *lATotalHours5;
@property (weak, nonatomic) IBOutlet UITextField *pOBox;
@property (weak, nonatomic) IBOutlet UITextField *projectNo;
@property (weak, nonatomic) IBOutlet UILabel *sSHeader;
@property (weak, nonatomic) IBOutlet UITextField *state;
@property (weak, nonatomic) IBOutlet UITextField *telephoneNo;
@property (weak, nonatomic) IBOutlet UITextField *total;
@property (weak, nonatomic) IBOutlet UITextField *totalLabor;
@property (weak, nonatomic) IBOutlet UITextField *zip;


@property (weak, nonatomic) IBOutlet UITextField *printedName;
@property (weak, nonatomic) IBOutlet UITextField *project_id;
@property (weak, nonatomic) IBOutlet UITextField *reportNo;
@property (weak, nonatomic) IBOutlet UITextField *sMSheetNo;
@property (weak, nonatomic) IBOutlet UITextField *id;

@end
