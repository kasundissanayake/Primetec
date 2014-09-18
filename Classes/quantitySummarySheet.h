//
//  quantitySummarySheet.h
//  PRIMECMAPP
//
//  Created by 3SG Corporation on 8/24/14.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"



@interface quantitySummarySheet : UIViewController<MFMailComposeViewControllerDelegate,MBProgressHUDDelegate,UIPrintInteractionControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIPopoverControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property BOOL isEdit;
@property (strong, nonatomic) NSDictionary *selectedDict;



@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *qtyTable;

@property (weak, nonatomic) IBOutlet UITextField *project;

@property (weak, nonatomic) IBOutlet UITextField *i_number;

@property (weak, nonatomic) IBOutlet UITextField *item;

@property (weak, nonatomic) IBOutlet UITextField *est_quantity;

@property (weak, nonatomic) IBOutlet UITextField *unit;

@property (weak, nonatomic) IBOutlet UITextField *unit_price;

@end