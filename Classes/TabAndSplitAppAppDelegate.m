
/*
#import "TabAndSplitAppAppDelegate.h"
#import "RootVC.h"
#import "DetailedVC.h"
#import "MySplitViewController.h"
#import "ComplianceForm.h"
#import "ComplianceForm.h"
#import "GIKAnnotation.h"
#import "GIKAnnotationView.h"
#import "GIKCalloutAnnotation.h"
#import "GIKCalloutContentView.h"
#import "GIKCalloutView.h"
#import "DetailedVC.h"

@implementation TabAndSplitAppAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize sketchesArray;
@synthesize userType;
@synthesize userTypeOffline;
@synthesize projectsArray;
@synthesize username;
@synthesize projId;
@synthesize projContractNo,projDescription,projName,projPrintedName,projTitle;
@synthesize userId;
@synthesize address,city,state,tel,pm,zip;
@synthesize saveVal;
@synthesize str1, str2, reImp;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize  mvc;
@synthesize imageArray;
@synthesize address_client;
@synthesize client;
@synthesize coloumn1,coloumn2,coloumn3,coloumn4,iddd;
@synthesize edit1,edit2;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   	//create split view controller
    [toolbar setHidden:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideToolbar" object:nil];
    sketchesArray=[[NSMutableArray alloc]init];
    imageArray=[[NSMutableArray alloc]init];
    projectsArray=[[NSMutableArray alloc]init];
    RootVC *rvc=[[RootVC alloc] init];
	rvc.title=@"";
	DetailedVC *dvc=[[DetailedVC alloc] init];
	MySplitViewController *msc = [[MySplitViewController alloc] initWithLeftVC:rvc rightVC:dvc];
	rvc.detailedNavigationController=msc.rightController;
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.rootViewController = msc;
    [window makeKeyAndVisible];
    
    NSError *error;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entitydesc = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:context];
    NSManagedObject *userData;
    
    // Create first object:
    userData = [[NSManagedObject alloc]initWithEntity:entitydesc insertIntoManagedObjectContext:context];
    [userData setValue:@"Lin" forKey:@"username"];
    [userData setValue:@"12345" forKey:@"password"];
    [userData setValue:@"I" forKey:@"user_type"];
    [context save:&error];
    
    // Create second object:
    userData = [[NSManagedObject alloc]initWithEntity:entitydesc insertIntoManagedObjectContext:context];
    [userData setValue:@"Roy" forKey:@"username"];
    [userData setValue:@"12345" forKey:@"password"];
    [userData setValue:@"I" forKey:@"user_type"];
    
    [context save:&error];
    userData = [[NSManagedObject alloc]initWithEntity:entitydesc insertIntoManagedObjectContext:context];
    [userData setValue:@"Art" forKey:@"username"];
    [userData setValue:@"12345" forKey:@"password"];
    [userData setValue:@"R" forKey:@"user_type"];
    [context save:&error];
    
    return YES;
}


#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreData" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreData.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
}


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    
}

@end*/



/****************************************************Radha*********************************************/




#import "TabAndSplitAppAppDelegate.h"
#import "RootVC.h"
#import "DetailedVC.h"
#import "MySplitViewController.h"
#import "ComplianceForm.h"
#import "ComplianceForm.h"
#import "GIKAnnotation.h"
#import "GIKAnnotationView.h"
#import "GIKCalloutAnnotation.h"
#import "GIKCalloutContentView.h"
#import "GIKCalloutView.h"
#import "DetailedVC.h"

@implementation TabAndSplitAppAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize sketchesArray;
@synthesize userType;
@synthesize userTypeOffline;
@synthesize projectsArray;
@synthesize username;
@synthesize projId;
@synthesize projContractNo,projDescription,projName,projPrintedName,projTitle;
@synthesize userId;
@synthesize address,city,state,tel,pm,zip;
@synthesize saveVal;
@synthesize str1, str2, reImp;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize  mvc;
@synthesize imageArray;


//editing Compliance AND Non Compliance
@synthesize EprojectDescription;
@synthesize Eproject_id;
@synthesize Etitle;
@synthesize EProject;
@synthesize EcomplianceNoticeNo;
@synthesize EdateIssued;
@synthesize EContractorResponsible;
@synthesize Eto;
@synthesize EdateContractorStarted;
@synthesize EdateContractorCompleted;
@synthesize EprojPrintedName;
@synthesize EdateOfDWRReported;
@synthesize EcorrectiveActionCompliance;
@synthesize EprintedName;
@synthesize Edate;
@synthesize Eimages_uploaded;
@synthesize Esketch_images;
@synthesize signature;
@synthesize EdateCompletedBy;




//Edit Daily Inspection============//

@synthesize DIlblProject;
@synthesize DItxtWorkDone;
@synthesize DItxtContractor;
@synthesize DItxtAdressPOBox;
@synthesize DItxtCity;
@synthesize DItxtState;
@synthesize DItxtTelephone;
@synthesize DItxtCometentPerson;
@synthesize DItxtTown;
@synthesize DItxtEmail;
@synthesize DItxtOfficeName1;
@synthesize DItxtOfficeTitle1;
@synthesize DItxtOfficeName2;
@synthesize DItxtOfficeName3;
@synthesize DItxtOfficeName4;
@synthesize DItxtOfficeTitle2;
@synthesize DItxtOfficeTitle3;
@synthesize DItxtOfficeTitle4;
@synthesize DItxtInspecName1;
@synthesize DItxtInspecName2;
@synthesize DItxtInspecName3;
@synthesize DItxtInspecTitle1;
@synthesize DItxtInspecTitle2;
@synthesize DItxtInspecTitle3;
@synthesize DItxtWorkDoneDepart1;
@synthesize DItxtWorkDoneDepart2;
@synthesize DItxtWorkDoneDepart3;
@synthesize DItxtWorkDec1;
@synthesize DItxtWorkDec3;
@synthesize DItxtWorkDec2;
@synthesize DItxtHowToWork;
@synthesize DIimgInspectorSignature;
@synthesize DItxtInspecName4;
@synthesize DItxtInspecTitle;
@synthesize DItxtWorkDoneDepart4;
@synthesize DItxtWorkDec4;
@synthesize DItxtHoursOfWork;
@synthesize DItxtZip;
@synthesize DIrepNo;
@synthesize DIconName;
@synthesize DItown;
@synthesize DIweather;
@synthesize DItime;
@synthesize DIdes1;
@synthesize DIdes2;
@synthesize DIdes3;
@synthesize DIdes4;
@synthesize DIdes5;
@synthesize DIqua1;
@synthesize DIqua2;
@synthesize DIqua3;
@synthesize DIqua4;
@synthesize DIqua5;
@synthesize DIitemno1;
@synthesize DIitemno2;
@synthesize DIitemno3;
@synthesize DIitemno4;
@synthesize DIitemno5;
@synthesize DIcaldays;
@synthesize DIuseddays;



//========================//

//=======EDIT Summary Sheet============//

@synthesize sMSheetNo;
@synthesize EdiSummarySheetNo;
@synthesize EditxtContractor;
@synthesize EditxtPOBox;
@synthesize EditxtCity;
@synthesize EditxtState;
@synthesize EditxtTpNumber;
@synthesize EditxtDate;
@synthesize EditxtDateOfWork;
@synthesize EditxtContactorPerform;
@synthesize EditxtFederalAid;
@synthesize EditxtProjectNo;
@synthesize EditxvDesWork;
@synthesize EditxvConsOrder;
@synthesize EditxtClass1;
@synthesize EditxtClass2;
@synthesize EditxtClass3;
@synthesize EditxtClass4;
@synthesize EditxtClass5;
@synthesize EditxtNo1;
@synthesize EditxtNo2;
@synthesize EditxtNo3;
@synthesize EditxtNo4;
@synthesize EditxtNo5;
@synthesize EditxtTotal1;
@synthesize EditxtTotal2;
@synthesize EditxtTotal3;
@synthesize EditxtTotal4;
@synthesize EditxtTotal5;
@synthesize EditxtRate1;
@synthesize EditxtRate2;
@synthesize EditxtRate3;
@synthesize EditxtRate4;
@synthesize EditxtRate5;
@synthesize EditxtAmt1;
@synthesize EditxtAmt2;
@synthesize EditxtAmt3;
@synthesize EditxtAmt4;
@synthesize EditxtAmt5;
@synthesize EditxtTotalLabor;
@synthesize EditxtHealth;
@synthesize EditxtInsTax;
@synthesize Editxt20Items;
@synthesize EditxtTotalItems;
@synthesize EditxtDes1;
@synthesize EditxtDes2;
@synthesize EditxtDes3;
@synthesize EditxtDes4;
@synthesize EditxtDES5;
@synthesize EditxtQuantity1;
@synthesize EditxtQuantity2;
@synthesize EditxtQuantity3;
@synthesize EditxtQuantity4;
@synthesize EditxtQuantity5;
@synthesize EditxtUnitPrice1;
@synthesize EditxtUnitPrice2;
@synthesize EditxtUnitPrice3;
@synthesize EditxtUnitPrice4;
@synthesize EditxtUnitPrice5;
@synthesize EditxtMAmt1;
@synthesize EditxtMAmt2;
@synthesize EditxtMAmt3;
@synthesize EditxtMAmt4;
@synthesize EditxtMAmt5;
@synthesize EditxtTotalMeterial;
@synthesize EditxtLessDiscount;
@synthesize EditxtLessDisTotal;
@synthesize EditxtAdditional;
@synthesize EditxtAddTotal;
@synthesize EditxtSize1;
@synthesize EditxtSize2;
@synthesize EditxtSize3;
@synthesize EditxtSize4;
@synthesize EditxtSize5;
@synthesize EditxtActive1;
@synthesize EditxtActive2;
@synthesize EditxtActive3;
@synthesize EditxtActive4;
@synthesize EditxtActive5;
@synthesize EditxtENo1;
@synthesize EditxtENo2;
@synthesize EditxtENo3;
@synthesize EditxtENo4;
@synthesize EditxtENo5;
@synthesize EditxtETotal1;
@synthesize EditxtETotal2;
@synthesize EditxtEtotal3;
@synthesize EditxtETotal4;
@synthesize EditxtETotal5;
@synthesize EditxtERate1;
@synthesize EditxtERate2;
@synthesize EditxtERate3;
@synthesize EditxtERate4;
@synthesize EditxtERate5;
@synthesize EditxtEAmt1;
@synthesize EditxtEAmt2;
@synthesize EditxtEAmt3;
@synthesize EditxtEAmt4;
@synthesize EditxtEAmt5;
@synthesize EditxtInspector;
@synthesize EditxtContractorRepresentative;
@synthesize EditxtConReDate;
@synthesize EditxtDailyTotal;
@synthesize EditxtTotalDate;
@synthesize EdisignName1;
@synthesize EdisignName2;


//=========END=============//


//======Start Expense Report===//


@synthesize EEApprovedBy;
@synthesize EECashAdvance;
@synthesize EEChequeNumber;
@synthesize EEdate;
@synthesize EEEmpName;
@synthesize EEEmpNo;
@synthesize EEweekEnding;
@synthesize EESign;


//=========End===Editing//

//start brin

@synthesize address_client;
@synthesize client;

@synthesize coloumn1,coloumn2,coloumn3,coloumn4,iddd;

//end brin

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   	//create split view controller
    [toolbar setHidden:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideToolbar" object:nil];
    sketchesArray=[[NSMutableArray alloc]init];
    
    //start brin
    
    imageArray=[[NSMutableArray alloc]init];
    
    
    //end brin
    
    projectsArray=[[NSMutableArray alloc]init];
    RootVC *rvc=[[RootVC alloc] init];
    rvc.title=@"";
    DetailedVC *dvc=[[DetailedVC alloc] init];
    MySplitViewController *msc = [[MySplitViewController alloc] initWithLeftVC:rvc rightVC:dvc];
    rvc.detailedNavigationController=msc.rightController;
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.rootViewController = msc;
    [window makeKeyAndVisible];
    
    NSError *error;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entitydesc = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:context];
    NSManagedObject *userData;
    
    // Create first object:
    userData = [[NSManagedObject alloc]initWithEntity:entitydesc insertIntoManagedObjectContext:context];
    [userData setValue:@"Lin" forKey:@"username"];
    [userData setValue:@"12345" forKey:@"password"];
    [userData setValue:@"I" forKey:@"user_type"];
    [context save:&error];
    
    // Create second object:
    userData = [[NSManagedObject alloc] initWithEntity:entitydesc insertIntoManagedObjectContext:context];
    [userData setValue:@"Roy" forKey:@"username"];
    [userData setValue:@"12345" forKey:@"password"];
    [userData setValue:@"I" forKey:@"user_type"];
    
    [context save:&error];
    userData = [[NSManagedObject alloc]initWithEntity:entitydesc insertIntoManagedObjectContext:context];
    [userData setValue:@"Art" forKey:@"username"];
    [userData setValue:@"12345" forKey:@"password"];
    [userData setValue:@"R" forKey:@"user_type"];
    [context save:&error];
    
    return YES;
}


#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreData" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreData.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
}


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    
}

@end






/*****************************************************************************************************/




