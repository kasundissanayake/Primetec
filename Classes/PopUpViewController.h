

#import <UIKit/UIKit.h>


@interface PopUpViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{


NSArray *entries;
NSMutableDictionary *selectionStates;
}

@property(nonatomic,strong)IBOutlet UITableView *tblView;
@property(nonatomic,strong)IBOutlet UIView *viewProjectName;
@property(nonatomic,strong)IBOutlet UITextView *txtViewProjectName;
@property(nonatomic,strong)IBOutlet UIView *viewHeader;
@property(nonatomic,strong)IBOutlet UIView *viewAttachImage;
@property(nonatomic,strong)IBOutlet UIBarButtonItem *button;
@property(nonatomic,strong)IBOutlet UILabel *lblTitle;
@property(nonatomic,strong)IBOutlet UIImageView *imgViewAttach;
@property(nonatomic,strong)IBOutlet UIImageView *imgViewAttach1;
@property(nonatomic,strong)IBOutlet UIImageView *imgViewAttach2;
@property(nonatomic,strong)IBOutlet UIImageView *imgViewAttach3;
@property(nonatomic,strong)IBOutlet UIImageView *imgViewAttach4;
@property(nonatomic,strong)IBOutlet UIImageView *imgViewAttach5;
@property(nonatomic,strong)IBOutlet UIImageView *imgViewAttach6;
@property(nonatomic,strong)IBOutlet UIImageView *imgViewAttach7;
@property(nonatomic,strong)IBOutlet UIImageView *imgViewAttach8;
@property(nonatomic,strong)IBOutlet UIImageView *imgViewAttach9;
@property(nonatomic,strong)IBOutlet UIImageView *imgViewAttach10;
@property(nonatomic,strong)IBOutlet UIImageView *imgViewAttach11;
@property(nonatomic,strong)IBOutlet UIImageView *imgViewAttach12;
@property(nonatomic,strong)IBOutlet UIImageView *imgViewAttach13;
@property(nonatomic,strong)IBOutlet UIImageView *imgViewAttach14;
@property(nonatomic,strong)IBOutlet UIImageView *imgViewAttach15;
@property(nonatomic,strong)UIImagePickerController *imagePicker;
@property(nonatomic,strong)IBOutlet UIView *imageAddSubView;
@property(nonatomic,strong)IBOutlet UIImageView *imgViewAdd;
@property(nonatomic,strong)NSMutableArray *arrayImages;
@property(nonatomic,assign)BOOL isFromSketches;
@property(nonatomic,assign)BOOL isFromReport;
@property(nonatomic,strong)IBOutlet UITextView *txvDescription;
@property(nonatomic,retain) UIDatePicker *datePicker;

@end
