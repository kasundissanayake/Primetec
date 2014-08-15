//
//  Dashboard.h
//  ComSMART
//
//  Created by Lingeswaran Kandasamy on 5/2/14.
//
//

#import <UIKit/UIKit.h>


@class RootVC;


@interface Dashboard : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{

    UINavigationController *__weak detailedNavigationController;
    UITableView *table;

@private
	NSArray *__weak directions;

    
}

@property (nonatomic, retain) RootVC *rootvc;


@property(nonatomic,weak) UINavigationController *detailedNavigationController;
//@property (strong, nonatomic) IBOutlet UIImageView *Frontimage;
@property (nonatomic, strong) IBOutlet UITableView *table;
//@property (strong, nonatomic) IBOutlet UIImageView *dashboardImage;

@end
