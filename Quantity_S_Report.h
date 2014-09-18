//
//  Quantity_S_Report.h
//  PRIMECMAPP
//
//  Created by 3SG Corporation on 8/24/14.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>
#import "PRIMECMController.h"



@interface Quantity_S_Report : UIViewController<UIPrintInteractionControllerDelegate,MFMailComposeViewControllerDelegate,MBProgressHUDDelegate>{
    
    
    UIPrintInteractionController *printController;
    
    
    
}
@property (strong, nonatomic) NSDictionary *selectedDict;


@property(nonatomic,retain)NSString *QNo;
@property (weak, nonatomic) IBOutlet UITextField *project;
@property (weak, nonatomic) IBOutlet UITextField *itemNo;
@property (weak, nonatomic) IBOutlet UITextField *estQty;
@property (weak, nonatomic) IBOutlet UITextField *unit;
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet UITableView *quantityTable;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextView *item;

@property (weak, nonatomic) IBOutlet UITableView *tblView;



@end