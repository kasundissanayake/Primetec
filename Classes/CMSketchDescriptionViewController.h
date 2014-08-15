//
//  CMSketchDescriptionViewController.h
//  TabAndSplitApp
//
//  Created by Prime on 6/6/14.
//
//

#import <UIKit/UIKit.h>

@interface CMSketchDescriptionViewController : UIViewController
@property(nonatomic,retain)NSString *imageName;
@property(nonatomic,retain)NSString *tag;
@property(nonatomic,retain)IBOutlet UITextView *txvDescription;
@property(nonatomic,retain)IBOutlet UIView *addCommentView;
@property(nonatomic,retain)IBOutlet UIButton *btnSave;

@end
