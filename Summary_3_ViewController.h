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


@property(nonatomic,strong)IBOutlet UITextField *StxtDateINS;
@property(nonatomic,strong)IBOutlet UITextField *StxtDateCR;
@property(nonatomic,strong)IBOutlet UIImageView *imgSignatureINS;
@property(nonatomic,strong)IBOutlet UIImageView *imgSignatureCR;


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
@property(nonatomic,strong)NSMutableArray *arrayImages;


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


@end
