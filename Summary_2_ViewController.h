//
//  Summary_2_ViewController.h
//  TabAndSplitApp
//
//  Created by Lingeswaran Kandasamy on 4/2/14.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface Summary_2_ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>

@property(nonatomic,strong)IBOutlet UIScrollView *scrollView;


//Radha
@property BOOL isEdit;
@property(nonatomic,strong) NSString *smSheetNumber;




@property (strong, nonatomic) IBOutlet UITextField *additionalDiscount;
@property (strong, nonatomic) IBOutlet UITextField *lessDiscount;
@property (strong, nonatomic) IBOutlet UITextField *mEAmount1;
@property (strong, nonatomic) IBOutlet UITextField *mEAmount2;
@property (strong, nonatomic) IBOutlet UITextField *mEAmount3;



@property (strong, nonatomic) IBOutlet UITextField *mEAmount4;
@property (strong, nonatomic) IBOutlet UITextField *mEAmount5;
@property (strong, nonatomic) IBOutlet UITextField *mEDescription1;
@property (strong, nonatomic) IBOutlet UITextField *mEDescription2;
@property (strong, nonatomic) IBOutlet UITextField *mEDescription3;



@property (strong, nonatomic) IBOutlet UITextField *mEDescription4;
@property (strong, nonatomic) IBOutlet UITextField *mEDescription5;
@property (strong, nonatomic) IBOutlet UITextField *mEQuantity1;
@property (strong, nonatomic) IBOutlet UITextField *mEQuantity2;
@property (strong, nonatomic) IBOutlet UITextField *mEQuantity3;



@property (strong, nonatomic) IBOutlet UITextField *mEQuantity4;

@property (strong, nonatomic) IBOutlet UITextField *mEQuantity5;
@property (strong, nonatomic) IBOutlet UITextField *mEUnitPrice1;
@property (strong, nonatomic) IBOutlet UITextField *mEUnitPrice2;
@property (strong, nonatomic) IBOutlet UITextField *mEUnitPrice3;



@property (weak, nonatomic) IBOutlet UITextField *mEUnitPrice4;
@property (weak, nonatomic) IBOutlet UITextField *mEUnitPrice5;
@property (weak, nonatomic) IBOutlet UITextField *sMSSheetNo;
@property (weak, nonatomic) IBOutlet UITextField *total1;
@property (weak, nonatomic) IBOutlet UITextField *total2;
@property (weak, nonatomic) IBOutlet UITextField *total3;




-(IBAction)shownext;
@end
