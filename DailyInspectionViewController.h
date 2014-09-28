#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SuggestiveTextField.h"


@interface DailyInspectionViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate,MBProgressHUDDelegate,UITextFieldDelegate>


@property(nonatomic,strong)UIImagePickerController *imagePicker;
@property(nonatomic,assign)BOOL isFromSketches;
@property(nonatomic,assign)BOOL isFromReport;
@property(nonatomic,strong)NSMutableArray *arrayImages;
@property(nonatomic,strong)NSMutableArray *sketchesArray;

@property(nonatomic,strong)IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain) UIDatePicker *datePicker;
@property(nonatomic,strong)IBOutlet UITextField *txtDateIN;
@property(nonatomic,strong)IBOutlet UIImageView *imgSignatureDaily;
@property(nonatomic,strong)IBOutlet UIView *imageAddSubView;
@property(nonatomic,strong)IBOutlet UIImageView *imgViewAdd;
@property(nonatomic,strong)IBOutlet UITextView *txvDescription;
@property (weak, nonatomic) IBOutlet UITextField *txtName1;
@property (weak, nonatomic) IBOutlet UITextField *txtTitle1;
@property (weak, nonatomic) IBOutlet UITextField *txtName2;
@property (weak, nonatomic) IBOutlet UITextField *txtTitle2;
@property (weak, nonatomic) IBOutlet UITextField *txtName3;
@property (weak, nonatomic) IBOutlet UITextField *txtTitle3;
@property (weak, nonatomic) IBOutlet UITextField *txtName4;
@property (weak, nonatomic) IBOutlet UITextField *txtTitle4;
@property (weak, nonatomic) IBOutlet UITextField *txtName5;
@property (weak, nonatomic) IBOutlet UITextField *txtTitle5;
@property (weak, nonatomic) IBOutlet UITextField *txtname6;
@property (weak, nonatomic) IBOutlet UITextField *txtTitle6;
@property (weak, nonatomic) IBOutlet UITextField *txtName7;
@property (weak, nonatomic) IBOutlet UITextField *txtTitle7;
@property (weak, nonatomic) IBOutlet UITextField *txtName8;
@property (weak, nonatomic) IBOutlet UITextField *txtTitle8;
@property (weak, nonatomic) IBOutlet UITextField *txtCompany1;
@property (weak, nonatomic) IBOutlet UITextField *txtDescription1;
@property (weak, nonatomic) IBOutlet UITextField *txtCompany2;
@property (weak, nonatomic) IBOutlet UITextField *txtDescription2;
@property (weak, nonatomic) IBOutlet UITextField *txtCompany3;
@property (weak, nonatomic) IBOutlet UITextField *txtDescription3;
@property (weak, nonatomic) IBOutlet UITextField *txtCompany4;
@property (weak, nonatomic) IBOutlet UITextField *txtDescription4;
@property (weak, nonatomic) IBOutlet UITextField *txtHours;
@property (weak, nonatomic) IBOutlet UITextField *contractor;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtCity;
@property (weak, nonatomic) IBOutlet UITextField *txtState;
@property (weak, nonatomic) IBOutlet UITextField *txtTel;
@property (weak, nonatomic) IBOutlet UITextField *txtCompetent;
@property (weak, nonatomic) IBOutlet UITextField *txtProject;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextView *txtWrkDone;
@property (weak, nonatomic) IBOutlet UILabel *txtHeader;
@property (weak, nonatomic) IBOutlet UITextField *zip;
@property (weak, nonatomic) IBOutlet UITextField *repNo;
@property (weak, nonatomic) IBOutlet UITextField *ConName;
@property (weak, nonatomic) IBOutlet UITextField *Town;
@property (weak, nonatomic) IBOutlet UITextField *weather;
@property (weak, nonatomic) IBOutlet UITextField *time;
@property (weak, nonatomic) IBOutlet UITextField *q_itemNo1;
@property (weak, nonatomic) IBOutlet UITextField *q_itemNo2;
@property (weak, nonatomic) IBOutlet UITextField *q_itemNo3;
@property (weak, nonatomic) IBOutlet UITextField *q_itemNo4;
@property (weak, nonatomic) IBOutlet UITextField *q_itemNo5;
@property (weak, nonatomic) IBOutlet UITextField *des1;
@property (weak, nonatomic) IBOutlet UITextField *des2;
@property (weak, nonatomic) IBOutlet UITextField *des3;
@property (weak, nonatomic) IBOutlet UITextField *des4;
@property (weak, nonatomic) IBOutlet UITextField *des5;
@property (weak, nonatomic) IBOutlet UITextField *qua1;
@property (weak, nonatomic) IBOutlet UITextField *qua2;
@property (weak, nonatomic) IBOutlet UITextField *qua3;
@property (weak, nonatomic) IBOutlet UITextField *qua4;
@property (weak, nonatomic) IBOutlet UITextField *qua5;
@property(assign) IBOutlet SuggestiveTextField *textField0;
@property(assign) IBOutlet SuggestiveTextField *textField1;
@property(assign) IBOutlet SuggestiveTextField *textField2;
@property(assign) IBOutlet SuggestiveTextField *textField3;
@property(assign) IBOutlet SuggestiveTextField *textFiel4;
@property (weak, nonatomic) IBOutlet UITextField *oriCalDays;
@property (weak, nonatomic) IBOutlet UITextField *usedCalDays;



- (id)initWithData:(NSDictionary *)sourceDictionary;





@end