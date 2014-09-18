//
//  TabAndSplitAppAppDelegate.h
//  TabAndSplitApp
//
//  Created by jey on 11/3/11.
//  Copyright 2011 CSS CORP. All rights reserved.
//



/*
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class RootVC;

@interface TabAndSplitAppAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate,UISplitViewControllerDelegate,UIToolbarDelegate,UINavigationControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
    UISplitViewController *splitviewcontroller;
    NSString *str1;
    NSString *str2;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    UIToolbar *toolbar;
    RootVC *mvc;
}

@property (nonatomic, retain) IBOutlet RootVC *mvc;
@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UITabBarController *tabBarController;
@property (weak, nonatomic) IBOutlet UIView *newt;
@property (nonatomic, assign) NSInteger Tag;
@property(nonatomic,retain)NSMutableArray *sketchesArray;
@property(nonatomic,retain)NSMutableArray *imageArray;
@property(nonatomic,retain)NSMutableArray *projectsArray;
@property (nonatomic, retain) NSString *userType;
@property (nonatomic, retain) NSString *userTypeOffline;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *projId;
@property (nonatomic, retain) NSString *projName;
@property (nonatomic, retain) NSString *projDescription;
@property (nonatomic, retain) NSString *projContractNo;
@property (nonatomic, retain) NSString *projTitle;
@property (nonatomic, retain) NSString *projPrintedName;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *tel;
@property (nonatomic, retain) NSString *pm;
@property (nonatomic, retain) NSString *zip;
@property (nonatomic, retain) NSString *saveVal;
@property (nonatomic, retain) NSString *str1;
@property (nonatomic, retain) NSString *str2;
@property (nonatomic, retain) NSString *reImp;


@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) NSString *client;
@property (nonatomic, retain) NSString *address_client;
@property (nonatomic, retain) NSString *coloumn1;
@property (nonatomic, retain) NSString *coloumn2;
@property (nonatomic, retain) NSString *coloumn3;
@property (nonatomic, retain) NSString *coloumn4;
@property (nonatomic, retain) NSString *coloumn5;
@property (nonatomic, retain) NSString *iddd;




//edit start

@property (nonatomic, retain) NSString *edit1;
@property (nonatomic, retain) NSString *edit2;


//edit end

- (NSURL *)applicationDocumentsDirectory;

@end */





//
//  TabAndSplitAppAppDelegate.h
//  TabAndSplitApp
//
//  Created by jey on 11/3/11.
//  Copyright 2011 CSS CORP. All rights reserved.
//


/********************************************Radha*****************************************************/
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
//#import "RootVC.h"


@class RootVC;

@interface TabAndSplitAppAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate,UISplitViewControllerDelegate,UIToolbarDelegate,UINavigationControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
    UISplitViewController *splitviewcontroller;
    NSString *str1;
    NSString *str2;
    //  NSString *reImp;
    
    //Codata
    
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    
    
    UIToolbar *toolbar;
    
    RootVC *mvc;
    
}




@property (nonatomic, retain) IBOutlet RootVC *mvc;
@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UITabBarController *tabBarController;
@property (weak, nonatomic) IBOutlet UIView *newt;
@property (nonatomic, assign) NSInteger Tag;
@property(nonatomic,retain)NSMutableArray *sketchesArray;
@property(nonatomic,retain)NSMutableArray *imageArray;
@property(nonatomic,retain)NSMutableArray *projectsArray;
@property (nonatomic, retain) NSString *userType;
@property (nonatomic, retain) NSString *userTypeOffline;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *projId;
@property (nonatomic, retain) NSString *projName;
@property (nonatomic, retain) NSString *projDescription;
@property (nonatomic, retain) NSString *projContractNo;
@property (nonatomic, retain) NSString *projTitle;
@property (nonatomic, retain) NSString *projPrintedName;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *tel;
@property (nonatomic, retain) NSString *pm;
@property (nonatomic, retain) NSString *zip;
@property (nonatomic, retain) NSString *saveVal;
@property (nonatomic, retain) NSString *str1;
@property (nonatomic, retain) NSString *str2;
@property (nonatomic, retain) NSString *reImp;



//Editing Compliance And Non Compliance//


@property (nonatomic, retain) NSString *EprojectDescription;
@property (nonatomic, retain) NSString *Eproject_id;
@property (nonatomic, retain) NSString *Etitle;
@property (nonatomic, retain) NSString *EProject;
@property (nonatomic, retain) NSString *EcomplianceNoticeNo;
@property (nonatomic, retain) NSString *EdateIssued;
@property (nonatomic, retain) NSString *EContractorResponsible;
@property (nonatomic, retain) NSString *Eto;
@property (nonatomic, retain) NSString *EdateContractorStarted;
@property (nonatomic, retain) NSString *EdateContractorCompleted;
@property (nonatomic, retain) NSString *EprojPrintedName;
@property (nonatomic, retain) NSString *EdateOfDWRReported;
@property (nonatomic, retain) NSString *EcorrectiveActionCompliance;
@property (nonatomic, retain) NSString *EprintedName;
@property (nonatomic, retain) NSString *Edate;
@property (nonatomic, retain) NSString *Eimages_uploaded;
@property (nonatomic, retain) NSString *Esketch_images;
@property (nonatomic, retain) UIImage *signature;
@property (nonatomic, retain) NSString *EdateCompletedBy;



//=============//

//EDIT Daily Inspection==========//

@property (nonatomic, retain) NSString *DIlblProject;
@property (nonatomic, retain) NSString *DItxtWorkDone;
@property (nonatomic, retain) NSString *DItxtContractor;
@property (nonatomic, retain) NSString *DItxtAdressPOBox;
@property (nonatomic, retain) NSString *DItxtCity;
@property (nonatomic, retain) NSString *DItxtState;
@property (nonatomic, retain) NSString *DItxtTelephone;
@property (nonatomic, retain) NSString *DItxtCometentPerson;
@property (nonatomic, retain) NSString *DItxtTown;
@property (nonatomic, retain) NSString *DItxtEmail;
@property (nonatomic, retain) NSString *DItxtOfficeName1;
@property (nonatomic, retain) NSString *DItxtOfficeTitle1;
@property (nonatomic, retain) NSString *DItxtOfficeName2;
@property (nonatomic, retain) NSString *DItxtOfficeName3;
@property (nonatomic, retain) NSString *DItxtOfficeName4;
@property (nonatomic, retain) NSString *DItxtOfficeTitle2;
@property (nonatomic, retain) NSString *DItxtOfficeTitle3;
@property (nonatomic, retain) NSString *DItxtOfficeTitle4;
@property (nonatomic, retain) NSString *DItxtInspecName1;
@property (nonatomic, retain) NSString *DItxtInspecName2;
@property (nonatomic, retain) NSString *DItxtInspecName3;
@property (nonatomic, retain) NSString *DItxtInspecTitle1;
@property (nonatomic, retain) NSString *DItxtInspecTitle2;
@property (nonatomic, retain) NSString *DItxtInspecTitle3;
@property (nonatomic, retain) NSString *DItxtWorkDoneDepart1;
@property (nonatomic, retain) NSString *DItxtWorkDoneDepart2;
@property (nonatomic, retain) NSString *DItxtWorkDoneDepart3;
@property (nonatomic, retain) NSString *DItxtWorkDec1;
@property (nonatomic, retain) NSString *DItxtWorkDec3;
@property (nonatomic, retain) NSString *DItxtWorkDec2;
@property (nonatomic, retain) NSString *DItxtHowToWork;
@property (nonatomic, retain) UIImage *DIimgInspectorSignature;
@property (nonatomic, retain) NSString *DItxtInspecName4;
@property (nonatomic, retain) NSString *DItxtInspecTitle;
@property (nonatomic, retain) NSString *DItxtWorkDoneDepart4;
@property (nonatomic, retain) NSString *DItxtWorkDec4;
@property (nonatomic, retain) NSString *DItxtHoursOfWork;
@property (nonatomic, retain) NSString *DItxtZip;
@property (nonatomic, retain) NSString *DIrepNo;
@property (nonatomic, retain) NSString *DIconName;
@property (nonatomic, retain) NSString *DItown;
@property (nonatomic, retain) NSString *DIweather;
@property (nonatomic, retain) NSString *DItime;
@property (nonatomic, retain) NSString *DIdes1;
@property (nonatomic, retain) NSString *DIdes2;
@property (nonatomic, retain) NSString *DIdes3;
@property (nonatomic, retain) NSString *DIdes4;
@property (nonatomic, retain) NSString *DIdes5;
@property (nonatomic, retain) NSString *DIqua1;
@property (nonatomic, retain) NSString *DIqua2;
@property (nonatomic, retain) NSString *DIqua3;
@property (nonatomic, retain) NSString *DIqua4;
@property (nonatomic, retain) NSString *DIqua5;
@property (nonatomic, retain) NSString *DIitemno1;
@property (nonatomic, retain) NSString *DIitemno2;
@property (nonatomic, retain) NSString *DIitemno3;
@property (nonatomic, retain) NSString *DIitemno4;
@property (nonatomic, retain) NSString *DIitemno5;
@property (nonatomic, retain) NSString *DIcaldays;
@property (nonatomic, retain) NSString *DIuseddays;


//===========END============//

//=======Summary Sheet Editing ============//

@property(nonatomic,retain)  NSString *sMSheetNo;
@property (nonatomic, retain) NSString *EdiSummarySheetNo;
@property (nonatomic, retain) NSString *EditxtContractor;
@property (nonatomic, retain) NSString *EditxtPOBox;
@property (nonatomic, retain) NSString *EditxtCity;
@property (nonatomic, retain) NSString *EditxtState;
@property (nonatomic, retain) NSString *EditxtTpNumber;
@property (nonatomic, retain) NSString *EditxtDate;
@property (nonatomic, retain) NSString *EditxtDateOfWork;
@property (nonatomic, retain) NSString *EditxtContactorPerform;
@property (nonatomic, retain) NSString *EditxtFederalAid;
@property (nonatomic, retain) NSString *EditxtProjectNo;
@property (nonatomic, retain) NSString *EditxvDesWork;
@property (nonatomic, retain) NSString *EditxvConsOrder;
@property (nonatomic, retain) NSString *EditxtClass1;
@property (nonatomic, retain) NSString *EditxtClass2;
@property (nonatomic, retain) NSString *EditxtClass3;
@property (nonatomic, retain) NSString *EditxtClass4;
@property (nonatomic, retain) NSString *EditxtClass5;
@property (nonatomic, retain) NSString *EditxtNo1;
@property (nonatomic, retain) NSString *EditxtNo2;
@property (nonatomic, retain) NSString *EditxtNo3;
@property (nonatomic, retain) NSString *EditxtNo4;
@property (nonatomic, retain) NSString *EditxtNo5;
@property (nonatomic, retain) NSString *EditxtTotal1;
@property (nonatomic, retain) NSString *EditxtTotal2;
@property (nonatomic, retain) NSString *EditxtTotal3;
@property (nonatomic, retain) NSString *EditxtTotal4;
@property (nonatomic, retain) NSString *EditxtTotal5;
@property (nonatomic, retain) NSString *EditxtRate1;
@property (nonatomic, retain) NSString *EditxtRate2;
@property (nonatomic, retain) NSString *EditxtRate3;
@property (nonatomic, retain) NSString *EditxtRate4;
@property (nonatomic, retain) NSString *EditxtRate5;
@property (nonatomic, retain) NSString *EditxtAmt1;
@property (nonatomic, retain) NSString *EditxtAmt2;
@property (nonatomic, retain) NSString *EditxtAmt3;
@property (nonatomic, retain) NSString *EditxtAmt4;
@property (nonatomic, retain) NSString *EditxtAmt5;
@property (nonatomic, retain) NSString *EditxtTotalLabor;
@property (nonatomic, retain) NSString *EditxtHealth;
@property (nonatomic, retain) NSString *EditxtInsTax;
@property (nonatomic, retain) NSString *Editxt20Items;
@property (nonatomic, retain) NSString *EditxtTotalItems;
@property (nonatomic, retain) NSString *EditxtDes1;
@property (nonatomic, retain) NSString *EditxtDes2;
@property (nonatomic, retain) NSString *EditxtDes3;
@property (nonatomic, retain) NSString *EditxtDes4;
@property (nonatomic, retain) NSString *EditxtDES5;
@property (nonatomic, retain) NSString *EditxtQuantity1;
@property (nonatomic, retain) NSString *EditxtQuantity2;
@property (nonatomic, retain) NSString *EditxtQuantity3;
@property (nonatomic, retain) NSString *EditxtQuantity4;
@property (nonatomic, retain) NSString *EditxtQuantity5;
@property (nonatomic, retain) NSString *EditxtUnitPrice1;
@property (nonatomic, retain) NSString *EditxtUnitPrice2;
@property (nonatomic, retain) NSString *EditxtUnitPrice3;
@property (nonatomic, retain) NSString *EditxtUnitPrice4;
@property (nonatomic, retain) NSString *EditxtUnitPrice5;
@property (nonatomic, retain) NSString *EditxtMAmt1;
@property (nonatomic, retain) NSString *EditxtMAmt2;
@property (nonatomic, retain) NSString *EditxtMAmt3;
@property (nonatomic, retain) NSString *EditxtMAmt4;
@property (nonatomic, retain) NSString *EditxtMAmt5;
@property (nonatomic, retain) NSString *EditxtTotalMeterial;
@property (nonatomic, retain) NSString *EditxtLessDiscount;
@property (nonatomic, retain) NSString *EditxtLessDisTotal;
@property (nonatomic, retain) NSString *EditxtAdditional;
@property (nonatomic, retain) NSString *EditxtAddTotal;
@property (nonatomic, retain) NSString *EditxtSize1;
@property (nonatomic, retain) NSString *EditxtSize2;
@property (nonatomic, retain) NSString *EditxtSize3;
@property (nonatomic, retain) NSString *EditxtSize4;
@property (nonatomic, retain) NSString *EditxtSize5;
@property (nonatomic, retain) NSString *EditxtActive1;
@property (nonatomic, retain) NSString *EditxtActive2;
@property (nonatomic, retain) NSString *EditxtActive3;
@property (nonatomic, retain) NSString *EditxtActive4;
@property (nonatomic, retain) NSString *EditxtActive5;
@property (nonatomic, retain) NSString *EditxtENo1;
@property (nonatomic, retain) NSString *EditxtENo2;
@property (nonatomic, retain) NSString *EditxtENo3;
@property (nonatomic, retain) NSString *EditxtENo4;
@property (nonatomic, retain) NSString *EditxtENo5;
@property (nonatomic, retain) NSString *EditxtETotal1;
@property (nonatomic, retain) NSString *EditxtETotal2;
@property (nonatomic, retain) NSString *EditxtEtotal3;
@property (nonatomic, retain) NSString *EditxtETotal4;
@property (nonatomic, retain) NSString *EditxtETotal5;
@property (nonatomic, retain) NSString *EditxtERate1;
@property (nonatomic, retain) NSString *EditxtERate2;
@property (nonatomic, retain) NSString *EditxtERate3;
@property (nonatomic, retain) NSString *EditxtERate4;
@property (nonatomic, retain) NSString *EditxtERate5;
@property (nonatomic, retain) NSString *EditxtEAmt1;
@property (nonatomic, retain) NSString *EditxtEAmt2;
@property (nonatomic, retain) NSString *EditxtEAmt3;
@property (nonatomic, retain) NSString *EditxtEAmt4;
@property (nonatomic, retain) NSString *EditxtEAmt5;
@property (nonatomic, retain) NSString *EditxtInspector;
@property (nonatomic, retain) NSString *EditxtContractorRepresentative;
@property (nonatomic, retain) NSString *EditxtConReDate;
@property (nonatomic, retain) NSString *EditxtDailyTotal;
@property (nonatomic, retain) NSString *EditxtTotalDate;
@property (nonatomic, retain) UIImage *EdisignName1;
@property (nonatomic, retain) UIImage *EdisignName2;



//==================end==============//


//Edit Expense Report======================//

@property (nonatomic, retain) NSString *EEApprovedBy;
@property (nonatomic, retain) NSString *EECashAdvance;
@property (nonatomic, retain) NSString *EEChequeNumber;
@property (nonatomic, retain) NSString *EEdate;
@property (nonatomic, retain) NSString *EEEmpName;
@property (nonatomic, retain) NSString *EEEmpNo;
@property (nonatomic, retain) NSString *EEweekEnding;
@property (nonatomic, retain) UIImage *EESign;






//=====end========//





@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) NSString *client;
@property (nonatomic, retain) NSString *address_client;
@property (nonatomic, retain) NSString *coloumn1;
@property (nonatomic, retain) NSString *coloumn2;
@property (nonatomic, retain) NSString *coloumn3;
@property (nonatomic, retain) NSString *coloumn4;
@property (nonatomic, retain) NSString *coloumn5;
@property (nonatomic, retain) NSString *iddd;




//- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end



/*********************************************************************************************************************/
