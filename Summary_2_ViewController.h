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



@property(nonatomic,strong) NSString *smSheetNumber;
@property(nonatomic,strong)IBOutlet UIScrollView *scrollView;


@property(nonatomic,weak) NSString *sm2description1;
@property(nonatomic,weak) NSString *sm2description2;
@property(nonatomic,weak) NSString *sm2description3;
@property(nonatomic,weak) NSString *sm2description4;
@property(nonatomic,weak) NSString *sm2description5;

@property(nonatomic,weak) NSString *sm2Qty1;
@property(nonatomic,weak) NSString *sm2Qty2;
@property(nonatomic,weak) NSString *sm2Qty3;
@property(nonatomic,weak) NSString *sm2Qty4;
@property(nonatomic,weak) NSString *sm2Qty5;

@property(nonatomic,weak) NSString *sm2price1;
@property(nonatomic,weak) NSString *sm2price2;
@property(nonatomic,weak) NSString *sm2price3;
@property(nonatomic,weak) NSString *sm2price4;
@property(nonatomic,weak) NSString *sm2price5
;
@property(nonatomic,weak) NSString *sm2amt1;
@property(nonatomic,weak) NSString *sm2amt2;
@property(nonatomic,weak) NSString *sm2amt3;
@property(nonatomic,weak) NSString *sm2amt4;
@property(nonatomic,weak) NSString *sm2amt5;

@property(nonatomic,weak) NSString *sm2total1;
@property(nonatomic,weak) NSString *sm2lessdiscount;
@property(nonatomic,weak) NSString *sm2total2;
@property(nonatomic,weak) NSString *sm2additional;
@property(nonatomic,weak) NSString *sm2total3;




@property (weak, nonatomic) IBOutlet UITextField *additionalDiscount;
@property (weak, nonatomic) IBOutlet UITextField *lessDiscount;
@property (weak, nonatomic) IBOutlet UITextField *mEAmount1;
@property (weak, nonatomic) IBOutlet UITextField *mEAmount2;
@property (weak, nonatomic) IBOutlet UITextField *mEAmount3;



@property (weak, nonatomic) IBOutlet UITextField *mEAmount4;
@property (weak, nonatomic) IBOutlet UITextField *mEAmount5;
@property (weak, nonatomic) IBOutlet UITextField *mEDescription1;
@property (weak, nonatomic) IBOutlet UITextField *mEDescription2;
@property (weak, nonatomic) IBOutlet UITextField *mEDescription3;



@property (weak, nonatomic) IBOutlet UITextField *mEDescription4;
@property (weak, nonatomic) IBOutlet UITextField *mEDescription5;
@property (weak, nonatomic) IBOutlet UITextField *mEQuantity1;
@property (weak, nonatomic) IBOutlet UITextField *mEQuantity2;
@property (weak, nonatomic) IBOutlet UITextField *mEQuantity3;



@property (weak, nonatomic) IBOutlet UITextField *mEQuantity4;
@property (weak, nonatomic) IBOutlet UITextField *mEQuantity5;
@property (weak, nonatomic) IBOutlet UITextField *mEUnitPrice1;
@property (weak, nonatomic) IBOutlet UITextField *mEUnitPrice2;
@property (weak, nonatomic) IBOutlet UITextField *mEUnitPrice3;



@property (weak, nonatomic) IBOutlet UITextField *mEUnitPrice4;
@property (weak, nonatomic) IBOutlet UITextField *mEUnitPrice5;
@property (weak, nonatomic) IBOutlet UITextField *sMSSheetNo;
@property (weak, nonatomic) IBOutlet UITextField *total1;
@property (weak, nonatomic) IBOutlet UITextField *total2;
@property (weak, nonatomic) IBOutlet UITextField *total3;




-(IBAction)shownext;
@end