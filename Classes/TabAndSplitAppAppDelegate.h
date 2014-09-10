//
//  TabAndSplitAppAppDelegate.h
//  TabAndSplitApp
//
//  Created by jey on 11/3/11.
//  Copyright 2011 CSS CORP. All rights reserved.
//

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

/*
 
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
 
 */


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

- (NSURL *)applicationDocumentsDirectory;

@end