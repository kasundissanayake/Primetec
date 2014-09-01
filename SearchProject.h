//
//  SearchProject.h
//  ComSMART
//
//  Created by Lingeswaran Kandasamy on 5/5/14.
//
//

#import <UIKit/UIKit.h>

@interface SearchProject : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UISearchBarDelegate>
{
   @private
	NSArray *directions;
    
    
}
@property(nonatomic,weak) UINavigationController *detailedNavigationController;
//@property (strong, nonatomic) IBOutlet UIImageView *Frontimage;
@property (nonatomic, strong) IBOutlet UITableView *table;

//@property (strong, nonatomic) IBOutlet UIImageView *searchProject;
@property(nonatomic,strong)IBOutlet UISearchBar *searchBar;


@end
