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


@property (strong, nonatomic) IBOutlet UITextField *txtQTY1;
@property (strong, nonatomic) IBOutlet UITextField *txtQTY2;
@property (strong, nonatomic) IBOutlet UITextField *txtQTY3;
@property (strong, nonatomic) IBOutlet UITextField *txtQTY4;
@property (strong, nonatomic) IBOutlet UITextField *txtQTY5;



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



@property (strong, nonatomic) IBOutlet UITextField *tTotal;

@property (strong, nonatomic) IBOutlet UITextField *txtLTotal;
@property (strong, nonatomic) IBOutlet UITextField *txtInsu;
@property (strong, nonatomic) IBOutlet UITextField *txt20;
@property (strong, nonatomic) IBOutlet UITextField *txtGRTotal;



@property (weak, nonatomic) IBOutlet UITextField *txtDescription1;
@property (weak, nonatomic) IBOutlet UITextField *txtDescription2;
@property (weak, nonatomic) IBOutlet UITextField *txtDescription3;
@property (weak, nonatomic) IBOutlet UITextField *txtDescription4;
@property (weak, nonatomic) IBOutlet UITextField *txtDescription5;


-(IBAction)shownext;
@end
