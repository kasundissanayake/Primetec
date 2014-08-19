//
//  reportDashboard.h
//  ComSMART
//
//  Created by Lingeswaran Kandasamy on 5/7/14.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface reportDashboard : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,MBProgressHUDDelegate>
{
    
    UINavigationController *__weak detailedNavigationController;
    UITableView *table;
    
@private
	NSArray *directions;
    
    
}

@property(nonatomic,weak) UINavigationController *detailedNavigationController;
//@property (strong, nonatomic) IBOutlet UIImageView *Frontimage;
@property (nonatomic, strong) IBOutlet UITableView *table;
//@property (strong, nonatomic) IBOutlet UIImageView *dashboardImage;
@property(nonatomic,assign) NSInteger proType;

@end
