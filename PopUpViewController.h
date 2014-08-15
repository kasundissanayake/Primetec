//
//  PopUpViewController.h
//  TabAndSplitApp
//
//  Created by Prime on 5/13/14.
//
//

#import <UIKit/UIKit.h>

@interface PopUpViewController : UIViewController
@property(nonatomic,retain)IBOutlet UITableView *tblView;
@property(nonatomic,retain)IBOutlet UIView *viewProjectName;
@property(nonatomic,retain)IBOutlet UITextView *txtViewProjectName;
@property(nonatomic,retain)IBOutlet UIView *viewHeader;
@property(nonatomic,retain)IBOutlet UIView *viewAttachImage;
@property(nonatomic,retain)IBOutlet UIBarButtonItem *button;

@end
