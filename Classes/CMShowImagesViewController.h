//
//  CMShowImagesViewController.h
//  TabAndSplitApp
//
//  Created by Prime on 6/5/14.
//
//

#import <UIKit/UIKit.h>

@interface CMShowImagesViewController : UIViewController<UIScrollViewDelegate>
{
    
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    BOOL pageControlBeingUsed;
    
}
@property(nonatomic,strong)NSMutableArray *arrayImages;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) IBOutlet UITextView *txtDescription;
@property(nonatomic,strong) IBOutlet UIView *viewGallery;
//@property(nonatomic,strong)IBOutlet UILabel *lblTitle;
@property(nonatomic,assign)BOOL isFromSketches;
@property(nonatomic,assign)BOOL isFromReport;
@end
