
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface DetailedVC : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
 {

     	UINavigationController *detailedNavigationController;
}

@property (nonatomic, strong) IBOutlet UIButton *registerBtn;
@property (nonatomic, strong) IBOutlet UIButton *loginBtn;
@property (nonatomic, strong) IBOutlet UITextField *usernameField;
@property (nonatomic, strong) IBOutlet UITextField *passwordField;



//@property(nonatomic,assign) UINavigationController *detailedNavigationController;
- (IBAction)LoginUser:(id)sender;


@property (strong, nonatomic) IBOutlet UIImageView *DVImage;

@property (strong, nonatomic) IBOutlet UILabel *DHLabel;

@property (strong, nonatomic) IBOutlet UILabel *DHLabel1;

@property (strong, nonatomic) IBOutlet UILabel *LUserName;

@property (strong, nonatomic) IBOutlet UILabel *LPassword;

@property (strong, nonatomic) IBOutlet UILabel *LForgetPassword;

@property (strong, nonatomic) IBOutlet UITextField *TUserName;
@property (strong, nonatomic) IBOutlet UITextField *TPassword;

@end


