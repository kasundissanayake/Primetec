#import <UIKit/UIKit.h>
@interface MySplitViewController : UIViewController
{
	UINavigationController *leftController;
	UINavigationController *rightController;
}

@property (nonatomic, strong) UINavigationController *leftController;
@property (nonatomic, strong) UINavigationController *rightController;

- (void)layoutViews:(UIInterfaceOrientation)orientation initialVerticalOffset:(float)offset;

- (MySplitViewController*) initWithLeftVC:(UIViewController*)leftvc rightVC:(UIViewController*)rightvc;
@end
