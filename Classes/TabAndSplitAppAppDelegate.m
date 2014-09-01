
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