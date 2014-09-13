//  DailyInspectionViewController.m
//  TabAndSplitApp
//
//  Created by Lingeswaran Kandasamy on 4/2/14.
//
//

#import "DailyInspectionViewController.h"
#import "SignatureViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CMShowImagesViewController.h"
#import "TabAndSplitAppAppDelegate.h"
#import "SDDrawingFileNames.h"
#import "SDDrawingsViewController.h"
#import "PRIMECMAPPUtils.h"
#import "PRIMECMController.h"

@interface DailyInspectionViewController ()
{
    NSMutableArray *hotelAnnotations;
    UIPopoverController *popoverController;
    UITableView *tblView;
    NSArray *tableData;
    NSInteger pickerTag;
    UIPickerView *pickerView1;
    NSMutableArray *pickerDataArray;
    SignatureViewController *signatureViewController;
    NSString *isSignature;
    UIButton *btnCloseSignView;
    UIPickerView *pickerViewCities;
    NSString *ifImage;
    TabAndSplitAppAppDelegate *appDelegate;
    NSString *imgName;
    NSInteger count;
    MBProgressHUD *HUD;
    NSMutableData *_receivedData;
    NSURLResponse *_receivedResponse;
    NSError *_connectionError;
    NSArray *resPonse;
    BOOL *uploading;
    int count1;
    NSString *comNoticeNo;
    BOOL *uploadingsketch;
    int count2;
    NSUserDefaults *defaults;
     NSDictionary *sourceDictionary;
    MBProgressHUD *hud;
    

    
}
@end

@implementation DailyInspectionViewController
@synthesize scrollView;
@synthesize txtDateIN;
@synthesize imgSignatureDaily;
@synthesize imagePicker;
@synthesize isFromReport,isFromSketches;
@synthesize arrayImages;
@synthesize imageAddSubView;
@synthesize imgViewAdd,txvDescription,datePicker;
@synthesize txtName1,txtName2,txtName3,txtName4,txtName5,txtname6,txtDescription1,txtDescription2,txtDescription3,txtDescription4,txtTitle1,txtTitle2,txtTitle3,txtTitle4,txtTitle5,txtTitle6,txtTitle7,txtTitle8,txtCompany1,txtCompany2,txtCompany3,txtCompany4,txtName7,txtName8,txtHours,contractor,txtAddress,txtState,txtCity,txtTel,txtCompetent,txtProject,txtTwn,txtEmail,txtWrkDone,txtHeader,zip;
@synthesize oriCalDays,usedCalDays,ConName,repNo,time,Town,weather,des1,des2,des3,des4,des5,qua1,qua2,qua3,qua4,qua5;
@synthesize textField,textField1,textField2,textField3,textFiel4;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithData:(NSDictionary *)sourceDictionaryParam
{
    self = [super init];
    sourceDictionary = sourceDictionaryParam;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self deleteAllFiles];
    
    count=0;
    appDelegate=(TabAndSplitAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.sketchesArray removeAllObjects];
    [arrayImages removeAllObjects];
    
    self.imagePicker=[[UIImagePickerController alloc]init];
    arrayImages=[[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getImageReviewer) name:@"DoneSignatureReviewer" object:nil];
    [txtWrkDone.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [txtWrkDone.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [txtWrkDone.layer setBorderWidth: 1.0];
    [txtWrkDone.layer setCornerRadius:8.0f];
    [txtWrkDone.layer setMasksToBounds:YES];
    tblView=[[UITableView alloc] initWithFrame:CGRectMake(265, 680, 0, 0) style:UITableViewStylePlain];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMapData:) name:@"ViewControllerAReloadData" object:nil];
    
    // Do any additional setup after loading the view from its nib.
    
    scrollView.frame = CGRectMake(0,0, 720, 2900);
    [scrollView setContentSize:CGSizeMake(700, 3250)];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back.jpg"]];
    UITapGestureRecognizer *singleTapInspec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetectedInspector)];
    imgSignatureDaily.userInteractionEnabled = YES;
    [imgSignatureDaily addGestureRecognizer:singleTapInspec];
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormat stringFromDate:today];
    
    
    NSDate *today1 = [NSDate date];
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    
    
    [dateFormat1 setDateFormat:@"hh:mm"];
    NSString *dateString1 = [dateFormat1 stringFromDate:today1];
    
    time.text=dateString1;
    ConName.text=appDelegate.client;
    Town.text=appDelegate.city;
    
    contractor.text=appDelegate.projId;
    txtAddress.text=appDelegate.address;
    txtCity.text=appDelegate.city;
    txtState.text=appDelegate.state;
    txtTel.text=appDelegate.tel;
    txtDateIN.text=dateString;
    txtProject.text=appDelegate.projName;
    zip.text=appDelegate.zip;
    
    
    
    if (sourceDictionary != NULL){
        NSLog(@"Compliance Form Data: %@", sourceDictionary);
        
        NSLog(@"Compliance Form complianceNoticeNo: %@", [[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"complianceNoticeNo"]);
        imgSignatureDaily.image=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"signature"];
        txtName1.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"oVJName1"];
        txtName2.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"oVJName1"];
        txtName3.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"oVJName1"];
        txtName4.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"oVJName1"];
        txtName7.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"iFName1"];
        txtName5.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"iFName1"];
        txtname6.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"iFName1"];
        txtName8.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"iFName1"];
        
        txtDescription1.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"wDODescriptionOfWork1"];
        txtDescription2.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"wDODescriptionOfWork1"];
        txtDescription3.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"wDODescriptionOfWork1"];
        txtDescription4.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"wDODescriptionOfWork1"];
        
        txtTitle1.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"oVJTitle1"];
        txtTitle2.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"oVJTitle1"];
        txtTitle3.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"oVJTitle1"];
        txtTitle4.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"oVJTitle1"];
        txtTitle5.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"iFTitle1"];
        txtTitle6.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"iFTitle1"];
        txtTitle7.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"iFTitle1"];
        txtTitle8.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"iFTitle1"];
        
        
        txtCompany1.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"wDODepartmentOrCompany1"];
        txtCompany2.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"wDODepartmentOrCompany1"];
        txtCompany3.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"wDODepartmentOrCompany1"];
        txtCompany4.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"wDODepartmentOrCompany1"];
        
        txtHours.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"contractorsHoursOfWork"];
        contractor.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"con_Name"];
        txtAddress.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"p_o_Box"];
        txtState.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"state"];
        txtCity.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"city"];
        txtTel.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"telephone_No"];
        txtCompetent.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"competentPerson"];
        txtProject.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"project"];
        txtEmail.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"e_Mail"];
        txtWrkDone.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"workDoneBy"];
        zip.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"zip_Code"];
        oriCalDays.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"original_Calendar_Days"];
        usedCalDays.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"calendar_Days_Used"];
        ConName.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"con_Name"];
        repNo.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"report_No"];
        time.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"time"];
        Town.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"town_city"];
        weather.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"weather"];
        
        
        des1.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"desc"];
        des2.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"desc"];
        des3.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"desc"];
        des4.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"desc"];
        des5.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"desc"];
        qua1.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"qty"];
        qua2.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"qty"];
        qua3.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"qty"];
        qua4.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"qty"];
        qua5.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"qty"];
        textField.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"no"];
        textField1.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"no"];
        textField2.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"no"];
        textField3.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"no"];
        textFiel4.text=[[sourceDictionary valueForKey:@"userInfo"] valueForKey:@"no"];
        
        
    }
    
    NSArray *array = @[@"EARTH EXCAVATION AND GRADINGACCESS ROADPER CUBIC YARD--,INO-01",@"EARTH EXCAVATION AND SCREENED GRAVEL BELOW NORMAL GRADE PER CUBIC RD--,INO-02",@"TRENCH ROCK EXCAVATION DISPOSAL AND BACKFILL PER CUBIC YARD--,INO-03",@"CLEARING AND GRUBBING PER LUMP SUM--,INO-04",@"BANK RUN GRAVEL PER CUBIC YARD--,INO-05",@"TEST PITS PER CUBIC YARD--,INO-06",@"WATER FOR DUST CONTROL 1,000 GAL.--,INO-07",@"SEDIMENTATION CONTROL SYSTEM PER LUMP SUM--,INO-08",@"MAINTENANCE AND PROTECTION OF TRAFFIC PER LUMP SUM--,INO-09",@"RAILROAD INSPECTOR ALLOWANCE--,INO-10",@"TRAFFICMEN(CITY POLICE)ALLOWAWCE,INO-11",@"TRAFFICMEN	(STATE POLICE)ALLOWANCE--,INO-12",@"TRAFFICMEN(UNIFORMED FLAGMEN) ALLOWANCE--,INO-13",@"TEMPORARY WA6TE STOCKPILE AREA RENTAL ALLOWANCE--,INO-14",@"UTILITY POLE RELOCATION ALLOWANCE--,INO-15",@"TEMPORARY PAVEMENT REPLACEMENT(CITY ROADS)PER SQ. YD.--,INO-16",@"PERMANENT PAVEMENT REPLACEMENT( CITY ROADS )PER  SO . YD .--,INO-17",@"MI8CELLANEOUS CONCRETE PER CUBIC YARD--,INO-18",@"TURF ESTABLISHMENT PER SQ. YD.--,INO-19",@"ENVIRONMENTAL HEALTH AND SAFETY PER LUMP SUM--,INO-20,TESTING LABORATORY SERVICES ALLOWANCE--,INO-21",@"FIELD OFFICE FOR ENGIWEER PER MONTH--,INO-22",@"TEMPORARY WASTE STOCKPILE AREA PER LUMP SUM--,INO-23",@"DEWATERING, CONTROL AND DIVERSION OF WATER PER LUMP SUN--,INO-24",@"DISPOSAL OF CONTROLLED MATERIALS PER TON--,INO-25",@"MANAGEMENT OF REUSABLE CONTROLLED MATERIAL PER CUBIC YARD--,INO-26",@"STONE CROSSING PER CUBIC YARD--,INO-27",@"STONE CROSSING PER CUBIC YARD--,INO-28",@"HANDLING CONTAMINATED GROUNDWATER PER LUMP SUM--,INO-29",@"PIPE CROSSING UNDER RAILROAD PER LINEAR FOOT--,INO-30",@"CEMENT CONCRETE SIDEWALK AND DRIVEWAY PER 3Q. FT.--,INO-31",@"30'REINFORCED CONCRETE PIPE LINER FOOT--,INO-32",@"30 REINFORCED  CONCRETE CULVERT END EACH--,INO-33",@"CONCRETE CURBING PER  LINEAR  FOOT--,INO-34",@"24 PVC  FORCE  MAIN  PIPING  AND APPURTENANCES PER  LINEAR  FOOT--,INO-35",@"HYDROSTATIC TESTING  OF  FORCE MAIN PER  LUMP  SUM--,INO-36",@"DIRECTIONAL DRILLED FORCE MAIN PIPE #1 PER LINEAR FOOT PVC--,INO-37",@"DIRECTIONAL DRILLED FORCE MAIN PIPE #2 PER LINEAR FOOT PVC--,INO-38",@"DISPOSAL OF HDD BORE CUTTINGS PER TON--,INO-39",@"DISPOSAL OF HDD DRILLING MUD PER 1000 GAL--,INO-40",@"HDD  ADDITIONAL  REDIRECT  ROCK EACH--,INO-41",@"HDD  ADDITIONAL  REDIRECT  IN SOIL EACH--,INO-42",@"HDD  ADDITIONAL  REDIRECT  IN SOIL EACH --,INO-43",@"HDD  ADDITIONAL  CONDUCTOR CASING PER  LINEAR  FOOT--,INO-44",@"PERMANENT  ACCESS  ROAD PER  LINEAR  FOOT --,INO-45",@"WETLAND  MITIGATION  AND ENHANCEMENT PER  SQ.   YD.--,INO-46",@"CONTROL  AND  REMOVAL  OF INVASIVE  VEGETATION PER ACRE --,INO-47",@"AIR  VALVE  MANHOLE EACH --,INO-48",@"JUNCTION  VAULT EACH --,INI-49",@"FORCE  MAIN  DRAIN  MANHOLE	EACH --,INO-50",@"RAILROAD  TRACK  REMOVAL AND RE PLACEMENT ALLOWANCE --,INO-51",@"RAILROAD  STONE  BALLAST PER  CUBIC  YARD --,INO-52",@"WATER  FOR  FORCE  MAIN  TESTING	ALLOWANCE --,INO-53",@"ADDITIONAL ALTERNATE NO. 1-EXTENDED WARRANTY(MAINTENANCE BOND) PER LUM SUM--,INO-54",@"ADD ALTERNATE NO. 2- CITY OF MIDDLETOWN PERMITS ALLOWANCE--,INO55"];
    
    
    
    //Assigning to searchfield
    [textField setSuggestions:array];
    [textField1 setSuggestions:array];
    [textField2 setSuggestions:array];
    [textField3 setSuggestions:array];
    [textFiel4 setSuggestions:array];
    
    
    defaults= [NSUserDefaults standardUserDefaults];
    

    
    UIBarButtonItem *Button = [[UIBarButtonItem alloc]
                               initWithTitle:NSLocalizedString(@"Exit", @"")
                               style:UIBarButtonItemStyleDone
                               target:self
                               action:@selector(exit)];
    
    self.navigationItem.rightBarButtonItem = Button;
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
    defaults= [NSUserDefaults standardUserDefaults];
    
    NSString* temp1 = [defaults objectForKey:@"textField1Text"];
    NSString* temp2 = [defaults objectForKey:@"textField2Text"];
    NSString* temp3 = [defaults objectForKey:@"textField3Text"];
    NSString* temp4 = [defaults objectForKey:@"textField4Text"];
    NSString* temp5 = [defaults objectForKey:@"textField5Text"];
    NSString* temp6 = [defaults objectForKey:@"textField6Text"];
    NSString* temp7 = [defaults objectForKey:@"textField7Text"];
    NSString* temp8 = [defaults objectForKey:@"textField8Text"];
    NSString* temp9 = [defaults objectForKey:@"textField9Text"];
    NSString* temp10 = [defaults objectForKey:@"textField10Text"];
    NSString* temp11= [defaults objectForKey:@"textField11Text"];
    NSString* temp12= [defaults objectForKey:@"textField12Text"];
    NSString* temp13= [defaults objectForKey:@"textField13Text"];
    NSString* temp14= [defaults objectForKey:@"textField14Text"];
    NSString* temp15= [defaults objectForKey:@"textField15Text"];
    NSString* temp16= [defaults objectForKey:@"textField16Text"];
    NSString* temp17= [defaults objectForKey:@"textField17Text"];
    NSString* temp18= [defaults objectForKey:@"textField18Text"];
    NSString* temp19= [defaults objectForKey:@"textField19Text"];
    NSString* temp20= [defaults objectForKey:@"textField20Text"];
    NSString* temp21= [defaults objectForKey:@"textField21Text"];
    NSString* temp22= [defaults objectForKey:@"textField22Text"];
    NSString* temp23= [defaults objectForKey:@"textField23Text"];
    NSString* temp24= [defaults objectForKey:@"textField24Text"];
    NSString* temp25= [defaults objectForKey:@"textField25Text"];
    NSString* temp26= [defaults objectForKey:@"textField26Text"];
    NSString* temp27= [defaults objectForKey:@"textField27Text"];
    NSString* temp28= [defaults objectForKey:@"textField28Text"];
    NSString* temp29= [defaults objectForKey:@"textField29Text"];
    NSString* temp30= [defaults objectForKey:@"textField30Text"];
    NSString* temp31= [defaults objectForKey:@"textField31Text"];
    NSString* temp32= [defaults objectForKey:@"textField32Text"];
    NSString* temp33= [defaults objectForKey:@"textField33Text"];
    NSString* temp34= [defaults objectForKey:@"textField34Text"];
    NSString* temp35= [defaults objectForKey:@"textField35Text"];
    NSString* temp36= [defaults objectForKey:@"textField36Text"];
    NSString* temp37= [defaults objectForKey:@"textField37Text"];
    NSString* temp38= [defaults objectForKey:@"textField38Text"];
    NSString* temp39= [defaults objectForKey:@"textField39Text"];
    NSString* temp40= [defaults objectForKey:@"textField40Text"];
    NSString* temp41= [defaults objectForKey:@"textField41Text"];
    NSString* temp42= [defaults objectForKey:@"textField42Text"];
    
    repNo.text=temp1;
    txtCompetent.text=temp2;
    weather.text=temp3;
    txtEmail.text=temp4;
    txtWrkDone.text=temp5;
    des1.text=temp6;
    des2.text=temp7;
    des3.text=temp8;
    des4.text=temp9;
    des5.text=temp10;
    qua1.text=temp11;
    qua2.text=temp12;
    qua3.text=temp13;
    qua4.text=temp14;
    qua5.text=temp15;
    txtName1.text=temp16;
    txtName2.text=temp17;
    txtName3.text=temp18;
    txtName4.text=temp19;
    txtName5.text=temp20;
    txtname6.text=temp21;
    txtName7.text=temp22;
    txtName8.text=temp23;
    txtTitle1.text=temp24;
    txtTitle2.text=temp25;
    txtTitle3.text=temp26;
    txtTitle4.text=temp27;
    txtTitle5.text=temp28;
    txtTitle6.text=temp29;
    txtTitle7.text=temp30;
    txtTitle8.text=temp31;
    oriCalDays.text=temp32;
    usedCalDays.text=temp33;
    txtCompany1.text=temp34;
    txtCompany2.text=temp35;
    txtCompany3.text=temp36;
    txtCompany4.text=temp37;
    txtDescription1.text=temp38;
    txtDescription2.text=temp39;
    txtDescription3.text=temp40;
    txtDescription4.text=temp41;
    txtHours.text=temp42;
}

-(void)exit{
    NSString* textField1Text = repNo.text;
    [defaults setObject:textField1Text forKey:@"textField1Text"];
    
    NSString* textField2Text = txtCompetent.text;
    [defaults setObject:textField2Text forKey:@"textField2Text"];
    
    
    NSString* textField3Text = weather.text;
    [defaults setObject:textField3Text forKey:@"textField3Text"];
    
    NSString* textField4Text = txtEmail.text;
    [defaults setObject:textField4Text forKey:@"textField4Text"];
    
    
    NSString* textField5Text = txtWrkDone.text;
    [defaults setObject:textField5Text forKey:@"textField5Text"];
    
    NSString* textField6Text = des1.text;
    [defaults setObject:textField6Text forKey:@"textField6Text"];
    
    NSString* textField7Text = des2.text;
    [defaults setObject:textField7Text forKey:@"textField7Text"];
    
    NSString* textField8Text = des3.text;
    [defaults setObject:textField8Text forKey:@"textField8Text"];
    
    NSString* textField9Text = des4.text;
    [defaults setObject:textField9Text forKey:@"textField9Text"];
    
    NSString* textField10Text = des5.text;
    [defaults setObject:textField10Text forKey:@"textField10Text"];
    
    NSString* textField11Text = qua1.text;
    [defaults setObject:textField11Text forKey:@"textField11Text"];
    
    NSString* textField12Text = qua2.text;
    [defaults setObject:textField12Text forKey:@"textField12Text"];
    
    NSString* textField13Text = qua3.text;
    [defaults setObject:textField13Text forKey:@"textField13Text"];
    
    NSString* textField14Text = qua4.text;
    [defaults setObject:textField14Text forKey:@"textField14Text"];
    
    NSString* textField15Text = qua5.text;
    [defaults setObject:textField15Text forKey:@"textField15Text"];
    
    NSString* textField16Text = txtName1.text;
    [defaults setObject:textField16Text forKey:@"textField16Text"];
    
    
    NSString* textField17Text = txtName2.text;
    [defaults setObject:textField17Text forKey:@"textField17Text"];
    
    NSString* textField18Text = txtName3.text;
    [defaults setObject:textField18Text forKey:@"textField18Text"];
    
    NSString* textField19Text = txtName4.text;
    [defaults setObject:textField19Text forKey:@"textField19Text"];
    
    NSString* textField20Text = txtName5.text;
    [defaults setObject:textField20Text forKey:@"textField20Text"];
    
    NSString* textField21Text = txtname6.text;
    [defaults setObject:textField21Text forKey:@"textField21Text"];
    
    NSString* textField22Text = txtName7.text;
    [defaults setObject:textField22Text forKey:@"textField22Text"];
    
    NSString* textField23Text = txtName8.text;
    [defaults setObject:textField23Text forKey:@"textField23Text"];
    
    NSString* textField24Text = txtTitle1.text;
    [defaults setObject:textField24Text forKey:@"textField24Text"];
    
    NSString* textField25Text = txtTitle2.text;
    [defaults setObject:textField25Text forKey:@"textField25Text"];
    
    NSString* textField26Text = txtTitle3.text;
    [defaults setObject:textField26Text forKey:@"textField26Text"];
    
    NSString* textField27Text = txtTitle4.text;
    [defaults setObject:textField27Text forKey:@"textField27Text"];
    
    NSString* textField28Text = txtTitle5.text;
    [defaults setObject:textField28Text forKey:@"textField28Text"];
    
    NSString* textField29Text = txtTitle6.text;
    [defaults setObject:textField29Text forKey:@"textField29Text"];
    
    NSString* textField30Text = txtTitle7.text;
    [defaults setObject:textField30Text forKey:@"textField30Text"];
    
    NSString* textField31Text = txtTitle8.text;
    [defaults setObject:textField31Text forKey:@"textField31Text"];
    
    NSString* textField32Text = oriCalDays.text;
    [defaults setObject:textField32Text forKey:@"textField32Text"];
    
    NSString* textField33Text = usedCalDays.text;
    [defaults setObject:textField33Text forKey:@"textField33Text"];
    
    NSString* textField34Text = txtCompany1.text;
    [defaults setObject:textField34Text forKey:@"textField34Text"];
    
    NSString* textField35Text = txtCompany2.text;
    [defaults setObject:textField35Text forKey:@"textField35Text"];
    
    NSString* textField36Text = txtCompany3.text;
    [defaults setObject:textField36Text forKey:@"textField36Text"];
    
    NSString* textField37Text = txtCompany4.text;
    [defaults setObject:textField37Text forKey:@"textField37Text"];
    
    NSString* textField38Text = txtDescription1.text;
    [defaults setObject:textField38Text forKey:@"textField38Text"];
    
    NSString* textField39Text = txtDescription2.text;
    [defaults setObject:textField39Text forKey:@"textField39Text"];
    
    NSString* textField40Text = txtDescription3.text;
    [defaults setObject:textField40Text forKey:@"textField40Text"];
    
    NSString* textField41Text = txtDescription4.text;
    [defaults setObject:textField41Text forKey:@"textField41Text"];
    
    NSString* textField42Text = txtHours.text;
    [defaults setObject:textField42Text forKey:@"textField42Text"];
    
    UIImage* textField43Text = imgSignatureDaily.image;
    [defaults setObject:UIImagePNGRepresentation(textField43Text)   forKey:@"textField43Text"];
    [defaults synchronize];
    UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Data Cached." delegate:self cancelButtonTitle:@"EXIT" otherButtonTitles: nil];
    [exportAlert show];
}

-(void)showAddImageView
{
    imageAddSubView.layer.cornerRadius=5;
    imageAddSubView.layer.masksToBounds=YES;
    imageAddSubView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    imageAddSubView.layer.borderWidth = 3.0f;
    [self.navigationController.view addSubview:imageAddSubView];
    [self.navigationController.view bringSubviewToFront:imageAddSubView];
}

-(IBAction)attachImage:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attach an image"
                                                    message:@""
                                                   delegate:nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Library",@"Camera", nil];
    alert.delegate=self;
    alert.tag=200;
    [alert show];
}

- (IBAction)handwritingButtonClicked:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"NAVIGATE_TO_DRAW"];
    //instantiate the view controller
    NSBundle *bundle = [NSBundle bundleForClass:[SDDrawingsViewController class]];
    UIStoryboard *storyboard;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        storyboard = [UIStoryboard storyboardWithName:@"SDSimpleDrawing_iPad" bundle:bundle];
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"SDSimpleDrawing_iPhone" bundle:bundle];
    }
    SDDrawingsViewController *viewController = [storyboard instantiateInitialViewController];
    [self presentViewController:viewController animated:YES completion:nil];
}

#pragma mark -
#pragma mark imagePicker delegates
#pragma mark -

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    count++;
    UIImage *newImage=[info objectForKey:UIImagePickerControllerOriginalImage];
    [popoverController dismissPopoverAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    imgViewAdd.image=newImage;
    [self showAddImageView];
}

-(NSString*)getCurrentDateTimeAsNSString
{
    //get current datetime as image name
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-ddHH:mm:ss"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [format setLocale:locale];
    NSDate *now = [NSDate date];
    NSString *retStr = [format stringFromDate:now];
    return retStr;
}

-(void)saveImageTaken:(UIImage *)image imgName:(NSString *)imgNam
{
    //store image in ducument directory.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *folderPath;
    folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Images"];
    
    NSLog(@"folderPath--- %@",folderPath);
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath]){
        
        NSError *error;
        if(  !([[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error]))
            NSLog(@"[%@] ERROR: attempting to write create Images directory", [self class]);
    }
    
    NSData *imagData = UIImageJPEGRepresentation(image,0.75f);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fullPath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", imgNam]];
    [fileManager createFileAtPath:fullPath contents:imagData attributes:nil];
}


-(IBAction)saveImage:(id)sender
{
    imgName=[NSString stringWithFormat:@"CM_%i",count];
    if(txvDescription.text.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty"
                                                        message:@"Please add photo Description."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        NSLog(@"Add Image----------------%@",imgName);
        NSMutableDictionary *imageDictionary = [[NSMutableDictionary alloc] init];
        imageDictionary=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                         [NSString stringWithFormat:@"%i",count], @"tag",
                         txvDescription.text, @"description",
                         imgName, @"name",
                         nil];
        
        NSLog(@"Add Image objjjjjjj-------");
        [arrayImages addObject:imageDictionary];
        [self saveImageTaken:imgViewAdd.image imgName:imgName];
        [self removeAddImageView];
    }
}

-(void)removeAddImageView
{
    txvDescription.text=@"";
    imgViewAdd.image=nil;
    [self.imageAddSubView removeFromSuperview];
}


-(IBAction)gotoImageLibrary:(id)sender
{
    if(arrayImages.count!=0)
    {
        CMShowImagesViewController *nextView= [[CMShowImagesViewController alloc]initWithNibName:@"CMShowImagesViewController" bundle:nil];
        //nextView.tag=[NSString stringWithFormat:@"%i",btn.tag];
        NSLog(@"Arrayyy--------- %i",arrayImages.count);
        nextView.arrayImages=arrayImages;
        nextView.isFromSketches=NO;
        nextView.isFromReport=NO;
        
        [nextView setModalPresentationStyle:UIModalPresentationFormSheet];
        [self presentViewController:nextView animated:true completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty"
                                                        message:@"No images to display"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}

-(IBAction)gotoSketches:(id)sender
{
    if(appDelegate.sketchesArray.count!=0)
    {
        CMShowImagesViewController *nextView= [[CMShowImagesViewController alloc]initWithNibName:@"CMShowImagesViewController" bundle:nil];
        //nextView.tag=@"0";
        NSLog(@"Arrayyy--------- %i",appDelegate.sketchesArray.count);
        nextView.arrayImages=appDelegate.sketchesArray;
        nextView.isFromSketches=YES;
        nextView.isFromReport=NO;
        //nextView.view.frame=CGRectMake(100, 150, 600, 800);
        [nextView setModalPresentationStyle:UIModalPresentationFormSheet];
        [self presentViewController:nextView animated:true completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty"
                                                        message:@"No sketches to display"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}


-(UIImage *)getImageFromFileName:(NSString *)fileName
{
    //get images from document directory
    NSLog(@"image name......%@",fileName);
    UIImage *current_img;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *folderPath;
    
    if(isFromSketches)
    {
        folderPath= [documentsDirectory stringByAppendingPathComponent:@"/DESK"];
    }
    else
    {
        
        folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Images"];
    }
    
    NSString *fullPath = [folderPath stringByAppendingPathComponent:fileName];
    current_img=[UIImage imageWithContentsOfFile:fullPath];
    NSLog(@"current_img %@",current_img);
    return current_img;
}

-(IBAction)doneViewImages:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark Alert Delegates
#pragma mark -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==200)
    {
        switch (buttonIndex) {
            case 0:  //Cancel
                break;
            case 1:
                [self openLibrary];
                
                break;
            case 2:  //Cancel
                [self openCamera];
                break;
            default:
                break;
        }
    }
}

-(IBAction)camera:(id)sender
{
    [self openCamera];
}

-(IBAction)library:(id)sender
{
    [self openLibrary];
}

-(void)openCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])  {
        [self.imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:self.imagePicker animated:YES completion:nil];
        self.imagePicker.delegate=self;
    }
}

-(void)openLibrary
{
    [self.imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    if([popoverController isPopoverVisible])
	{
        [popoverController dismissPopoverAnimated:YES];
    }
    if([popoverController isPopoverVisible])
    {
        [popoverController dismissPopoverAnimated:YES];
    }
    popoverController = [[UIPopoverController alloc] initWithContentViewController: imagePicker];
    popoverController.delegate = self;
    [popoverController
     presentPopoverFromRect:CGRectMake(120.0,  500.0, 300.0, 300.0)  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    self.imagePicker.delegate=self;
}

-(void)deleteAllFiles
{
    NSFileManager *fileMgr = [[NSFileManager alloc] init];
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *directoryContents = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error];
    if (error == nil) {
        for (NSString *path in directoryContents) {
            NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:path];
            BOOL removeSuccess = [fileMgr removeItemAtPath:fullPath error:&error];
            if (!removeSuccess) {
                // Error handling
            }
        }
    } else {
        // Error handling
    }
}


-(void)getImageReviewer
{
    [self removeSignatureView];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Signature"];
    imgSignatureDaily.image=[self getImageFromFileName:[NSString stringWithFormat:@"%@.jpg",@"Signature_R"] folderPath:folderPath];
}


-(void)getImageInspector
{
    [self removeSignatureView];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Signature"];
    imgSignatureDaily.image=[self getImageFromFileName:[NSString stringWithFormat:@"%@.jpg",@"Signature_R"] folderPath:folderPath];
}



-(UIImage *)getImageFromFileName:(NSString *)fileName folderPath:(NSString *)folderPath
{
    //get images from document directory
    NSLog(@"image name......%@",fileName);
    UIImage *current_img;
    NSString *fullPath = [folderPath stringByAppendingPathComponent:fileName];
    current_img=[UIImage imageWithContentsOfFile:fullPath];
    NSLog(@"current_img %@",current_img);
    return current_img;
}



-(void)tapDetectedInspector
{
    isSignature=@"1";
    signatureViewController=[[SignatureViewController alloc]initWithNibName:@"SignatureViewController" bundle:nil];
    NSLog(@"get URL image");
    [self.navigationController.view addSubview:signatureViewController.view];
    [self createSignatureCloseBtn];
    [self.navigationController.view addSubview:btnCloseSignView];
    
}

-(void)tapDetectedReviewer
{
    isSignature=@"1";
    signatureViewController=[[SignatureViewController alloc]initWithNibName:@"SignatureViewController" bundle:nil];
    NSLog(@"get URL image");
    [self.navigationController.view addSubview:signatureViewController.view];
    [self createSignatureCloseBtn];
    [self.navigationController.view addSubview:btnCloseSignView];
}


-(void)createSignatureCloseBtn
{
    UIImage* imageNormal = [UIImage imageNamed:@"closeBtn.png"];
    UIImage* imageHighLighted = [UIImage imageNamed:@"closeBtn.png"];
    CGRect frame;
    frame = CGRectMake(617,115,40,40);
    btnCloseSignView = [[UIButton alloc]initWithFrame:frame];
    [btnCloseSignView setBackgroundImage:imageNormal forState:UIControlStateNormal];
    [btnCloseSignView setBackgroundImage:imageHighLighted forState:UIControlStateHighlighted];
    [btnCloseSignView setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnCloseSignView setTitle:@"" forState:UIControlStateNormal];
    [btnCloseSignView setShowsTouchWhenHighlighted:YES];
    [btnCloseSignView addTarget:self action:@selector(removeSignatureView) forControlEvents:UIControlEventTouchUpInside];
}


-(void)removeSignatureView
{
    [btnCloseSignView removeFromSuperview];
    [signatureViewController.view removeFromSuperview];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.text =[tableData objectAtIndex:indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        
    }
    if(indexPath.section==0 && indexPath.row==1)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeDashboard" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showSProject" object:nil];
    }
    if(indexPath.section==0 && indexPath.row==2)
    {
    }
    [popoverController dismissPopoverAnimated:YES];
}


-(IBAction)selectType:(id)sender
{
    tableData = [NSArray arrayWithObjects:@"",@"Dashboard", @"Help",nil];
    UIViewController *popoverContent=[[UIViewController alloc] init];
    [tblView reloadData];
    UIView *popoverView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 300)];
    popoverView.backgroundColor=[UIColor whiteColor];
    popoverContent.view=popoverView;
    popoverContent.preferredContentSize=CGSizeMake(250, 150);
    popoverContent.view=tblView; //Adding tableView to popover
    tblView.delegate=self;
    tblView.dataSource=self;
    popoverController=[[UIPopoverController alloc]initWithContentViewController:popoverContent];
    [popoverController presentPopoverFromBarButtonItem:(UIBarButtonItem *)sender
                              permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}


-(IBAction)saveDailyInspection:(id)sender{
    uploading = NO;
    uploadingsketch=NO;
    if(txtHours.text==NULL || txtHours.text.length==0 || contractor.text==NULL || contractor.text.length==0 ||txtAddress.text==NULL || txtAddress.text.length==0 ||txtCity.text==NULL || txtCity.text.length==0 || txtState.text==NULL || txtState.text.length==0 ||txtTel.text==NULL|| txtTel.text.length==0||txtDateIN.text==NULL|| txtDateIN.text.length==0 ||txtCompetent.text==NULL || txtCompetent.text.length==0 ||txtProject.text==NULL || txtProject.text.length==0 ||txtWrkDone.text==NULL || txtWrkDone.text.length==0 || imgSignatureDaily.image==NULL)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty"
                                                        message:@"Please fill all the fields"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.navigationController.view addSubview:hud];
        hud.labelText=@"";
        hud.dimBackground = YES;
        hud.delegate = self;
        [hud show:YES];
        
        appDelegate=(TabAndSplitAppAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *sigName=[NSString stringWithFormat:@"Signature_R%@",[self getCurrentDateTimeAsNSString]];
        NSLog(@" sketch_array - save: %@", appDelegate.sketchesArray);
        NSLog(@" image_array - save: %@", arrayImages);
        
        NSMutableArray *sketchesNameArray = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < appDelegate.sketchesArray.count; i++){
            NSString* imggName = [[appDelegate.sketchesArray objectAtIndex:i] valueForKey:@"name"];
            [sketchesNameArray addObject:imggName];
        }
        
        NSMutableArray *imgNameArray = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < arrayImages.count; i++){
            NSString* imggName = [[arrayImages objectAtIndex:i] valueForKey:@"name"];
            [imgNameArray addObject:imggName];
        }
        
        NSLog(@"sketches names %@", sketchesNameArray);
        NSLog(@"images names %@", imgNameArray);
        
        
        NSArray *item1Arr = [des1.text componentsSeparatedByString:@"--,"];
        NSArray *item2Arr = [des2.text componentsSeparatedByString:@"--,"];
        NSArray *item3Arr = [des3.text componentsSeparatedByString:@"--,"];
        NSArray *item4Arr = [des4.text componentsSeparatedByString:@"--,"];
        NSArray *item5Arr = [des5.text componentsSeparatedByString:@"--,"];
        
        NSString *i_no1= @"", *i_no2= @"", *i_no3= @"", *i_no4= @"", *i_no5= @"", *i_desc1= @"", *i_desc2= @"", *i_desc3= @"", *i_desc4= @"", *i_desc5 = @"";
        
        if ([item1Arr count] > 1){
            i_no1 = [item1Arr objectAtIndex:1];
            i_desc1 = [item1Arr objectAtIndex:0];
        }
        
        if ([item2Arr count] > 1){
            i_no2 = [item2Arr objectAtIndex:1];
            i_desc2 = [item2Arr objectAtIndex:0];
        }
        
        if ([item3Arr count] > 1){
            i_no3 = [item3Arr objectAtIndex:1];
            i_desc3 = [item3Arr objectAtIndex:0];
        }
        
        if ([item4Arr count] > 1){
            i_no4 = [item4Arr objectAtIndex:1];
            i_desc4 = [item4Arr objectAtIndex:0];
        }
        
        if ([item5Arr count] > 1){
            i_no5 = [item5Arr objectAtIndex:1];
            i_desc5 = [item5Arr objectAtIndex:0];
        }
        
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        
        BOOL saveStatus = [PRIMECMController
                           saveDailyInspectionForm:appDelegate.username
                           calendar_Days_Used:usedCalDays.text
                           city:txtCity.text
                           competentPerson:txtCompetent.text
                           con_Name:ConName.text
                           contractor:contractor.text
                           contractorsHoursOfWork:txtHours.text
                           date:txtDateIN.text
                           dIFHeader:txtHeader.text
                           e_Mail:txtEmail.text
                           
                           i_Desc1:i_desc1
                           i_Desc2:i_desc2
                           i_Desc3:i_desc3
                           i_Desc4:i_desc4
                           i_Desc5:i_desc5
                           
                           i_No1:i_no1
                           i_No2:i_no2
                           i_No3:i_no3
                           i_No4:i_no4
                           i_No5:i_no5
                           
                           i_QTY1:qua1.text
                           i_QTY2:qua2.text
                           i_QTY3:qua3.text
                           i_QTY4:qua4.text
                           i_QTY5:qua5.text
                           
                           iFName1:txtName5.text
                           iFName2:txtname6.text
                           iFName3:txtName7.text
                           iFName4:txtName8.text
                           
                           iFTitle1:txtTitle5.text
                           iFTitle2:txtTitle6.text
                           iFTitle3:txtTitle7.text
                           iFTitle4:txtTitle8.text
                           
                           images_uploaded:[imgNameArray componentsJoinedByString:@","]
                           inspectionID:repNo.text
                           inspectorSign:sigName
                           signature:sigName
                           original_Calendar_Days:oriCalDays.text
                           
                           oVJName1:txtName1.text
                           oVJName2:txtName2.text
                           oVJName3:txtName3.text
                           oVJName4:txtName4.text
                           
                           oVJTitle1:txtTitle1.text
                           oVJTitle2:txtTitle2.text
                           oVJTitle3:txtTitle3.text
                           oVJTitle4:txtTitle4.text
                           
                           p_o_Box:txtAddress.text
                           printedName:appDelegate.projPrintedName
                           project:txtProject.text
                           project_id:appDelegate.projId
                           report_No:repNo.text
                           sketch_images:[sketchesNameArray componentsJoinedByString:@","]
                           state:txtState.text
                           telephone_No:txtTel.text
                           time:time.text
                           town_city:Town.text
                           
                           wDODepartmentOrCompany1:txtCompany1.text
                           wDODepartmentOrCompany2:txtCompany2.text
                           wDODepartmentOrCompany3:txtCompany3.text
                           wDODepartmentOrCompany4:txtCompany4.text
                           wDODescriptionOfWork1:txtDescription1.text
                           wDODescriptionOfWork2:txtDescription2.text
                           wDODescriptionOfWork3:txtDescription3.text
                           wDODescriptionOfWork4:txtDescription4.text
                           weather:weather.text
                           workDoneBy:txtWrkDone.text
                           zip_Code:zip.text
                           ];
        
        
        NSLog(@"Save status DailyInspectionForm: %hhd", saveStatus);
        
        BOOL imageSaveState = TRUE;
        BOOL singSaveState = TRUE;
        
        //Signature to coredata
        
        NSArray *pathsSign = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectorySign = [pathsSign objectAtIndex:0];
        
        NSString *folderPathSign= [documentsDirectorySign stringByAppendingPathComponent:@"/Signature"];
        
        
        UIImage *imageSign=[self getSignatureFromFileName:[NSString stringWithFormat:@"%@.jpg",@"Signature_R"] folderPath:folderPathSign];
        NSData *imaDataSign = UIImageJPEGRepresentation(imageSign,0.3);
        singSaveState = [PRIMECMController saveAllImages:sigName img:imaDataSign];
        
        if(arrayImages.count>0)
        {
            for (int i = 0; i < arrayImages.count;i++) {
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString* imggName = [[arrayImages objectAtIndex:count1] valueForKey:@"name"];
                NSString *folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Images"];
                
                UIImage *image=[self getImageFromFileName:[NSString stringWithFormat:@"%@.jpg", imggName] folderPath:folderPath];
                NSData *imgData = UIImageJPEGRepresentation(image,0.3);
                
                if (! [PRIMECMController saveAllImages:imggName img:imgData]){
                    imageSaveState = FALSE;
                }
            }
            
        }
        
        if(appDelegate.sketchesArray.count>0)
        {
            for (int i=0;i < appDelegate.sketchesArray.count;i++) {
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                
                NSString *folderPath= [documentsDirectory stringByAppendingPathComponent:@"/DESK"];
                NSString *imggName = [[appDelegate.sketchesArray objectAtIndex:i] valueForKey:@"name"];
                UIImage *image=[self getImageFromFileName:[NSString stringWithFormat:@"%@.jpg", imggName] folderPath:folderPath];
                NSData *imgData = UIImageJPEGRepresentation(image,0.3);
                
                if (! [PRIMECMController saveAllImages:imggName img:imgData]){
                    singSaveState = FALSE;
                }
            }
            
        }
        
        [hud setHidden:YES];
        
        if (saveStatus && singSaveState){
            UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Successfully saved Daily Inspection report." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [exportAlert show];
            [appDelegate.sketchesArray removeAllObjects];
            [arrayImages removeAllObjects];
            [self clearFieldsInForm];
            //[self deleteImageFiles];
        }else{
            UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to save Daily Inspection report." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [exportAlert show];
        }
    }
}

-(void)clearFieldsInForm
{
    contractor.text=@"";
    txtAddress.text=@"";
    txtCity.text=@"";
    txtState.text=@"";
    zip.text=@"";
    txtTel.text=@"";
    txtDateIN.text=@"";
    txtCompetent.text=@"";
    txtProject.text=@"";
    txtEmail.text=@"";
    txtWrkDone.text=@"";
    txtName1.text=@"";
    txtName2.text=@"";
    txtName3.text=@"";
    txtName4.text=@"";
    txtName5.text=@"";
    txtname6.text=@"";
    txtName7.text=@"";
    txtName8.text=@"";
    txtTitle1.text=@"";
    txtTitle2.text=@"";
    txtTitle3.text=@"";
    txtTitle4.text=@"";
    txtTitle5.text=@"";
    txtTitle6.text=@"";
    txtTitle7.text=@"";
    txtTitle8.text=@"";
    txtCompany1.text=@"";
    txtCompany2.text=@"";
    txtCompany3.text=@"";
    txtCompany4.text=@"";
    txtDescription1.text=@"";
    txtDescription2.text=@"";
    txtDescription3.text=@"";
    txtDescription4.text=@"";
    txtHours.text=@"";
    imgSignatureDaily.image=NULL;
    repNo.text=@"";
    ConName.text=@"";
    Town.text=@"";
    weather.text=@"";
    time.text=@"";
    des1.text=@"";
    des2.text=@"";
    des3.text=@"";
    des4.text=@"";
    des5.text=@"";
    qua1.text=@"";
    qua2.text=@"";
    qua3.text=@"";
    qua4.text=@"";
    qua5.text=@"";
    oriCalDays.text=@"";
    usedCalDays.text=@"";
}


-(void)deleteImageFiles
{
    NSFileManager *fileMgr = [[NSFileManager alloc] init];
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *folderPath= [documentsDirectory stringByAppendingPathComponent:@"/DESK"];
    
    NSArray *directoryContents = [fileMgr contentsOfDirectoryAtPath:folderPath error:&error];
    if (error == nil) {
        for (NSString *path in directoryContents) {
            NSString *fullPath = [folderPath stringByAppendingPathComponent:path];
            BOOL removeSuccess = [fileMgr removeItemAtPath:fullPath error:&error];
            if (!removeSuccess) {
                // Error handling
                
            }
        }
    } else {
        // Error handling
        
    }
    
    folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Images"];
    
    directoryContents = [fileMgr contentsOfDirectoryAtPath:folderPath error:&error];
    if (error == nil) {
        for (NSString *path in directoryContents) {
            NSString *fullPath = [folderPath stringByAppendingPathComponent:path];
            BOOL removeSuccess = [fileMgr removeItemAtPath:fullPath error:&error];
            if (!removeSuccess) {
                // Error handling
                
            }
        }
    } else {
        // Error handling
        
    }
}


-(UIImage *)getSignatureFromFileName:(NSString *)fileName
{
    //get images from document directory
    NSLog(@"image name......%@",fileName);
    UIImage *current_img;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *folderPath;
    
    if(isFromSketches)
    {
        folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Signature"];
    }
    else
    {
        folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Signature"];
    }
    
    NSString *fullPath = [folderPath stringByAppendingPathComponent:fileName];
    current_img=[UIImage imageWithContentsOfFile:fullPath];
    NSLog(@"current_img %@",current_img);
    return current_img;
}



-(UIImage *)getSignatureFromFileName:(NSString *)fileName folderPath:(NSString *)folderPath
{
    //get images from document directory
    NSLog(@"image name......%@",fileName);
    UIImage *current_img;
    NSString *fullPath = [folderPath stringByAppendingPathComponent:fileName];
    current_img=[UIImage imageWithContentsOfFile:fullPath];
    NSLog(@"current_img %@",current_img);
    return current_img;
}

-(void)uploadImage
{
    NSString *urlLink = [NSString stringWithFormat:@"%@/api/dailyinspection/uploadimages/%@/%@/%@/", [PRIMECMAPPUtils getAPIEndpoint],
                         appDelegate.username,comNoticeNo,[[arrayImages objectAtIndex:count1] valueForKey:@"name"]];
    
    NSString *unicodeLink = [urlLink stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"URL---%@",unicodeLink);
    
    NSURL *apiURL =
    [NSURL URLWithString:unicodeLink];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:apiURL cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                          timeoutInterval:60.0];
    
    [urlRequest setHTTPMethod:@"POST"];
    NSLog(@"URL DESK----- %@",unicodeLink);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Images"];
    NSMutableData *postbody = [NSMutableData data];
    UIImage *image=[self getImageFromFileName:[NSString stringWithFormat:@"%@.jpg", [[arrayImages objectAtIndex:count1] valueForKey:@"name"]] folderPath:folderPath];
    NSData *imaData = UIImageJPEGRepresentation(image,0.3);
    // NSLog(@"********************* UPloadinggggg %i  %@",count1,[arrayImages objectAtIndex:count1]);
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [urlRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@.jpg\"\r\n",[[arrayImages objectAtIndex:count1] valueForKey:@"name"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[NSData dataWithData:imaData]];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [urlRequest setHTTPBody:postbody];
    uploading=YES;
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    _receivedData = [[NSMutableData alloc] init];
    [connection start];
    NSLog(@"sent");
}


-(void)uploadSignature
{
    NSString *urlLink = [NSString stringWithFormat:@"%@/api/dailyinspection/uploadimages/%@/%@/%@/", [PRIMECMAPPUtils getAPIEndpoint],
                         appDelegate.username,comNoticeNo,[[arrayImages objectAtIndex:count1] valueForKey:@"name"]];
    
    NSString *unicodeLink = [urlLink stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"URL---%@",unicodeLink);
    
    NSURL *apiURL =
    [NSURL URLWithString:unicodeLink];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:apiURL cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                          timeoutInterval:60.0];
    
    [urlRequest setHTTPMethod:@"POST"];
    NSLog(@"URL DESK----- %@",unicodeLink);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Images"];
    NSMutableData *postbody = [NSMutableData data];
    UIImage *image=[self getImageFromFileName:[NSString stringWithFormat:@"%@.jpg", [[arrayImages objectAtIndex:count1] valueForKey:@"name"]] folderPath:folderPath];
    NSData *imaData = UIImageJPEGRepresentation(image,0.3);
    // NSLog(@"********************* UPloadinggggg %i  %@",count1,[arrayImages objectAtIndex:count1]);
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [urlRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@.jpg\"\r\n",[[arrayImages objectAtIndex:count1] valueForKey:@"name"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[NSData dataWithData:imaData]];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"^^^^^^^^^^^^^%@",postbody);
    
    [urlRequest setHTTPBody:postbody];
    uploading=YES;
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    _receivedData = [[NSMutableData alloc] init];
    [connection start];
    NSLog(@"sent");
}



-(void)uploadSketch
{
    uploadingsketch=YES;
    NSString *urlLink = [NSString stringWithFormat:@"%@/api/dailyinspection/uploadsketches/%@/%@/%@/", [PRIMECMAPPUtils getAPIEndpoint],
                         appDelegate.username,comNoticeNo,[[appDelegate.sketchesArray objectAtIndex:count2] valueForKey:@"name"]];
    
    NSString *unicodeLink = [urlLink stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"URL---%@",unicodeLink);
    
    NSURL *apiURL =
    [NSURL URLWithString:unicodeLink];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:apiURL cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                          timeoutInterval:60.0];
    
    [urlRequest setHTTPMethod:@"POST"];
    NSLog(@"URL DESK----- %@",unicodeLink);
    //isSendingDecs=YES;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *folderPath= [documentsDirectory stringByAppendingPathComponent:@"/DESK"];
    NSMutableData *postbody = [NSMutableData data];
    UIImage *image=[self getImageFromFileName:[NSString stringWithFormat:@"%@.jpg", [[appDelegate.sketchesArray objectAtIndex:count2] valueForKey:@"name"]] folderPath:folderPath];
    NSData *imaData = UIImageJPEGRepresentation(image,0.3);
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [urlRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@.jpg\"\r\n",[[appDelegate.sketchesArray objectAtIndex:count2] valueForKey:@"name"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[NSData dataWithData:imaData]];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"^^^^^^^^^^^^^%@",postbody);
    [urlRequest setHTTPBody:postbody];
    uploadingsketch=YES;
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    _receivedData = [[NSMutableData alloc] init];
    [connection start];
    NSLog(@"sent");
}



-(void)createPicker:(UITextField *)txtField
{
    
    
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolbar sizeToFit];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(selectionDone)];
    [barItems addObject:doneBtn];
    
    [pickerToolbar setItems:barItems animated:YES];
    
    
    pickerViewCities = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 320, 300)];
    pickerViewCities.delegate = self;
    
    
    pickerViewCities.showsSelectionIndicator = YES;
    
    
    UIViewController* popoverContent = [[UIViewController alloc] init];
    UIView* popoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 344)];
    popoverView.backgroundColor = [UIColor whiteColor];
    
    
    [popoverView addSubview:pickerToolbar];
    [popoverView addSubview:pickerViewCities];
    popoverContent.view = popoverView;
    
    popoverContent.preferredContentSize = CGSizeMake(320, 244);
    
    //create a popover controller
    popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    CGRect popoverRect = [self.view convertRect:[txtField frame]
                                       fromView:[txtField superview]];
    
    popoverRect.size.width = MIN(popoverRect.size.width, 100) ;
    popoverRect.origin.x  = popoverRect.origin.x;
    // popoverRect.size.height  = ;
    
    [popoverController
     presentPopoverFromRect:popoverRect
     inView:self.view
     permittedArrowDirections:UIPopoverArrowDirectionUp
     animated:YES];
    
}


-(void)createDatePicker:(UITextField *)txtField{
    
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolbar sizeToFit];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(selectionDone)];
    [barItems addObject:doneBtn];
    
    [pickerToolbar setItems:barItems animated:YES];
    
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 320, 300)];
    
    //distancePickerView.dataSource = self;
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.hidden = NO;
    datePicker.date = [NSDate date];
    
    
    [datePicker addTarget:self
                   action:@selector(TextChange:)
         forControlEvents:UIControlEventValueChanged];
    
    UIViewController* popoverContent = [[UIViewController alloc] init];
    UIView* popoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 344)];
    popoverView.backgroundColor = [UIColor whiteColor];
    
    
    [popoverView addSubview:pickerToolbar];
    [popoverView addSubview:datePicker];
    popoverContent.view = popoverView;
    
    //resize the popover view shown
    //in the current view to the view's size
    popoverContent.preferredContentSize = CGSizeMake(320, 244);
    
    //create a popover controller
    popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    CGRect popoverRect = [self.view convertRect:[txtField frame]
                                       fromView:[txtField superview]];
    
    popoverRect.size.width = MIN(popoverRect.size.width, 100) ;
    popoverRect.origin.x  = popoverRect.origin.x;
    
    [popoverController
     presentPopoverFromRect:popoverRect
     inView:self.view
     permittedArrowDirections:UIPopoverArrowDirectionAny
     animated:YES];
}


-(void)selectionDone
{
    [popoverController dismissPopoverAnimated:YES];
}



- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField==txtCompetent)
    {
        [txtCompetent resignFirstResponder];
        pickerDataArray=[[NSMutableArray alloc]initWithObjects:@"Bill Clayton",@"Art",nil];
        [self createPicker:txtCompetent];
        pickerTag=1;
    }
    if(textField==txtProject)
    {
        [txtProject resignFirstResponder];
        pickerDataArray=[[NSMutableArray alloc]initWithObjects:@"Middletown Project",@"Hartford Project",@"Rockyhill project",nil];
        [self createPicker:txtProject];
        pickerTag=2;
    }
    if(textField==txtDateIN)
    {
        [txtDateIN resignFirstResponder];
        [self createDatePicker:txtDateIN];
        pickerTag=3;
    }
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField==txtHours )
    {
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
        for (int i = 0; i < [string length]; i++)
        {
            unichar c = [string characterAtIndex:i];
            if (![myCharSet characterIsMember:c])
            {
                txtHours.enabled=YES;
                return NO;
            }
            else{
                
            }
        }
        return YES;
    }
    return YES;
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.text.length==0)
    {
        textField.text=@" ";
    }
    //clearField = NO;
}

-(void)textFieldShouldReturn:(UITextField *)textField
{
    //  clearField = NO;
}

- (void)TextChange:(id)sender{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    if(pickerTag==3)
    {
        txtDateIN.text=[df stringFromDate:datePicker.date];
    }
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return pickerDataArray.count;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerTag==1)
    {
        txtCompetent.text=[pickerDataArray objectAtIndex:[pickerView selectedRowInComponent:0]];
    }
    else if(pickerTag==2)
    {
        txtProject.text=[pickerDataArray objectAtIndex:[pickerView selectedRowInComponent:0]];
    }
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [pickerDataArray objectAtIndex:row];
}


// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    CGFloat componentWidth = 0.0;
	componentWidth = 320.0;
	return componentWidth;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
