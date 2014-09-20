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
@property(nonatomic,retain)  NSString *sMSheetNo;
@property(nonatomic,retain)  NSString *inspectionID;

//edit end

- (NSURL *)applicationDocumentsDirectory;

@end