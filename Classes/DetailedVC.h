
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface DetailedVC : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
 {

     	UINavigationController *detailedNavigationController;
}


@property (nonatomic, strong) IBOutlet UITextField *usernameField;
@property (nonatomic, strong) IBOutlet UITextField *passwordField;



- (IBAction)LoginUser:(id)sender;


@property (strong, nonatomic) IBOutlet UILabel *DHLabel;

@property (strong, nonatomic) IBOutlet UILabel *DHLabel1;

@property (strong, nonatomic) IBOutlet UITextField *TUserName;
@property (strong, nonatomic) IBOutlet UITextField *TPassword;

@end


