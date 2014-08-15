

#import <UIKit/UIKit.h>

@interface SignatureViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *ColorButton;
@property (strong, nonatomic) IBOutlet UIButton *btnDone;
@property (strong, nonatomic) IBOutlet UIButton *btnClear;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UIButton *btnUndo;
@property (strong, nonatomic) IBOutlet UIButton *btnRedo;
@property(nonatomic,strong)NSString *imageViewTag;
@property(nonatomic,strong)UIImage *image;
@property(nonatomic,strong)IBOutlet UIView *signatureSubview;

-(IBAction)remove:(id)sender;
-(IBAction)back:(id)sender;
-(IBAction)clear:(id)sender;
-(IBAction)changeColors:(id)sender;
- (IBAction)colorSet:(id)sender;

- (IBAction)saveScreen:(id)sender;

@end
