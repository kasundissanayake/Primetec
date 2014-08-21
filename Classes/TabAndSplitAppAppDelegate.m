
#import "TabAndSplitAppAppDelegate.h"
#import "RootVC.h"
#import "DetailedVC.h"
#import "MySplitViewController.h"
#import "SecondViewController.h"
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


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
   	//create split view controller
    
     [toolbar setHidden:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideToolbar" object:nil];

    
    
    //[mvc getAllProjects];
    
 //   [self.myViewController hideToolbar];
    
  //  [self.navigationController setToolbarHidden:YES animated:NO];

    
    sketchesArray=[[NSMutableArray alloc]init];
    projectsArray=[[NSMutableArray alloc]init];
    
    
    RootVC *rvc=[[RootVC alloc] init];
	rvc.title=@"";
	DetailedVC *dvc=[[DetailedVC alloc] init];
	MySplitViewController *msc = [[MySplitViewController alloc] initWithLeftVC:rvc rightVC:dvc];
    
	rvc.detailedNavigationController=msc.rightController;
    
    
    
   // NSArray *viewControllers = [NSArray arrayWithObjects:msc,nil];

    
    
    
   // UISplitViewController* splitVC = [[UISplitViewController alloc] init];
   // splitVC.viewControllers = [NSArray arrayWithObjects:rvc, dvc, nil];
    
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.rootViewController = msc;
    [window makeKeyAndVisible];

    
    
	

   // NSArray *viewControllers = [NSArray arrayWithObjects:msc,nil];
    
    
    
    
   // [tabBarController setViewControllers:viewControllers];
    
//	UIImage* tabBarBackground = [UIImage imageNamed:@"Bar1.png"];
//    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
	
  	
	//the views are retained their new owners, so we can release
	//[vc2 release];
//	tabBarController.tabBar.barStyle=UIBarStyleBlackOpaque;
    // Add the tab bar controller's current view as a subview of the window
//    self.window.rootViewController=tabBarController;
//     [self.window addSubview:tabBarController.view];
//    [self.window makeKeyAndVisible];
    
   // [self.tabBarController.tabBar setHidden:YES];
    

    
 //---------------------------------------------------------------------------------------
    
    
    
    
    
    
    
    /***********************************method one****************************/
    
    
 /*  NSManagedObjectContext *context = [self managedObjectContext];
    userdetails *failedBankInfo = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"Users"
                                      inManagedObjectContext:context];
    

    
    failedBankInfo.username = @"brinthusha";
    failedBankInfo.password = @"12345";

    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    // Test listing all FailedBankInfos from the store
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init]; */
    
    
    
    
 /*   NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username == %@", failedBankInfo.username];
    [fetchRequest setPredicate:predicate];
    YourObject *obj = [ctx executeRequest:fetch];
    
    if(!obj) {
        //not there so create it and save
        obj = [ctx insertNewManagedObjectForEntity:@"Favorite"]; //typed inline, dont know actual method
        obj.stationIdentifier = stID;
        [ctx save];
    }*/
    
    
    

 /*   NSEntityDescription *entity = [NSEntityDescription entityForName:@"Users"
                                              inManagedObjectContext:context];

    
    [fetchRequest setEntity:entity];

    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (userdetails *info in fetchedObjects) {
        NSLog(@"Name: %@", info.username);
        NSLog(@"pass: %@", info.password);
       // [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"timestamp in %@", fetchedObjects]];

        
    } */
    
    
    
    /*******************************************/
    
    
    
    
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
    // [userData release];  only if you don't compile with ARC
    
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

    
    
    
    
    
    
    
//--------------------------------------------------------------------------------------------------------
    
    
    
    
    
    return YES;
}



//- (void)applicationDidEnterBackground:(UIApplication *)application
//{
//    [self.myViewController hidesBottomBarWhenPushed];
//}
//


/*
-(NSURLSessionConfiguration *)sessionConfiguration {
    NSURLSessionConfiguration *config =
    [NSURLSessionConfiguration defaultSessionConfiguration];
    
    config.URLCache = [[NSURLCache alloc] initWithMemoryCapacity:0
                                                    diskCapacity:0
                                                        diskPath:nil];
    
    return config;
}*/


/*
-(void)checkForDuplicates
{
    
    DetailedVC *controller = [[DetailedVC alloc]initWithNibName:@"detailVC" bundle:Nil];
    
   // controller.TUserName;
    
    
    
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Users"
                                              inManagedObjectContext:managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"username"
                                                                   ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    [request setSortDescriptors:sortDescriptors];
    
    NSError *Fetcherror;
    NSMutableArray *mutableFetchResults = [[managedObjectContext
                                            executeFetchRequest:request error:&Fetcherror] mutableCopy];
    
    if (!mutableFetchResults) {
        // error handling code.
    }
    
    if ([[mutableFetchResults valueForKey:@"username"]
         containsObject:controller.TUserName.text]) {
        NSLog(@"value duplicates");
        return;
    }
    else
    {

    
    
        NSManagedObjectContext *context = [self managedObjectContext];
        userdetails *failedBankInfo = [NSEntityDescription
                                       insertNewObjectForEntityForName:@"Users"
                                       inManagedObjectContext:context];
        failedBankInfo.username = @"usha";
        failedBankInfo.password = @"12345";
        
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        
        // Test listing all FailedBankInfos from the store
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Users"
                                                  inManagedObjectContext:context];
        
        
        [fetchRequest setEntity:entity];
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        for (userdetails *info in fetchedObjects) {
            NSLog(@"Name: %@", info.username);
            NSLog(@"pass: %@", info.password);
            // [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"timestamp in %@", fetchedObjects]];
            
            
        }
    
    
    
    
    
    }
}*/


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

