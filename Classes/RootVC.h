

#import <UIKit/UIKit.h>
#include "MySplitViewController.h"
#import "MBProgressHUD.h"

@interface RootVC : UIViewController <UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UISearchBarDelegate,MBProgressHUDDelegate,UIToolbarDelegate>
{
	UINavigationController *__weak detailedNavigationController;
    UITableView *table;
    @private
	NSArray *__weak directions;
    UIToolbar *toolbar;
}


@property(nonatomic,weak) UINavigationController *detailedNavigationController;
@property (strong, nonatomic) IBOutlet UIImageView *Frontimage;
@property (nonatomic, strong) IBOutlet UITableView *table;
@property(nonatomic,strong)IBOutlet UISegmentedControl *proStatusSeg;
@property(nonatomic,strong)IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) MBProgressHUD *hud;

@end



