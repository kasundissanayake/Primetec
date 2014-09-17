//
//  PRIMECMAPPUtils.m
//  PRIMECMAPP
//
//  Created by Kasun Dissanayake on 8/16/14.
//
//

#import "PRIMECMAPPUtils.h"
#import "TabAndSplitAppAppDelegate.h"

@implementation PRIMECMAPPUtils

NSString * const API_ENDPOINT_KEY = @"SERVER_API_ENDPOINT";
NSString * const ROOT_RELOAD_NOTIFICATION = @"ROOT_RELOAD_NOTIFICATION";
NSString * const CACHE_CREDENTIALS = @"cache_credentials";
NSString * const USERNAME = @"USERNAME";
NSString * const PASSWORD = @"PASSWORD";

// sync status codes
int * const SYNC_STATUS_OK = 1;
int * const SYNC_STATUS_PENDING = 2;
int * const SYNC_STATUS_DELETED = 3;

+(NSString *)getAPISyncPullEndpoint {
    //NSString *endpoint = @"http://192.168.167.1/ConstructionAPI/api/v1.0/sync/pull/";
    
    
    //NSString *endpoint = @"http://54.255.121.169/ConstructionAPI/api/v1.0/sync/pull/";
    
    NSString *endpoint = @"http://www.privytext.us/ConstructionAPI/api/v1.0/sync/pull/";
    
    return endpoint;
}

+(NSString *)getAPISyncPushEndpoint {
    //NSString *endpoint = @"http://192.168.167.1/ConstructionAPI/api/v1.0/sync/push/";
    
    //NSString *endpoint = @"http://54.255.121.169/ConstructionAPI/api/v1.0/sync/push/";
    
    NSString *endpoint = @"http://www.privytext.us/ConstructionAPI/api/v1.0/sync/push/";
    
    return endpoint;
}

+(NSString *)getAPISyncImgPushEndpoint {
    //NSString *endpoint = @"http://192.168.167.1/ConstructionAPI/api/v1.0/sync/images/push/";
    
    //NSString *endpoint = @"http://54.255.121.169/ConstructionAPI/api/v1.0/sync/images/push/";
    
    NSString *endpoint = @"http://www.privytext.us/ConstructionAPI/api/v1.0/sync/images/push/";
    
    return endpoint;
}


+(NSString *)getAPISyncImgPullEndpoint {
    //NSString *endpoint = @"http://192.168.167.1/ConstructionAPI/api/v1.0/sync/images/pull/";
    
    
    //NSString *endpoint = @"http://54.255.121.169/ConstructionAPI/api/v1.0/sync/images/pull/";
    
    NSString *endpoint = @"http://www.privytext.us/ConstructionAPI/api/v1.0/sync/images/pull/";
    
    return endpoint;
}

+(NSString *)getSyncImgBaseURL {
    //NSString *endpoint = @"http://192.168.167.1/ConstructionAPI/images/";
    
    
    //NSString *endpoint = @"http://54.255.121.169/ConstructionAPI/images/";
    
    NSString *endpoint = @"http://www.privytext.us/ConstructionAPI/images/";
    
    return endpoint;
}

+ (NSString *)getAPIEndpoint {
    //NSString *path = [[NSBundle mainBundle] bundlePath];
    //NSString *finalPath = [path stringByAppendingPathComponent:@"PRIMECMAPP-Info.plist"];
    //NSLog(@"final path: %@", finalPath);
    //NSDictionary *plistData = [NSDictionary dictionaryWithContentsOfFile:finalPath];
    
    NSString *endpoint = @"http://construction.ravihansa3000.com/contructionapi.php";
    return endpoint;
}


+ (NSManagedObjectContext *)getManagedObjectContext {
    TabAndSplitAppAppDelegate *appDelegate = (TabAndSplitAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    return [appDelegate managedObjectContext];
    
}

+ (NSString *)filterValue:(NSString *)param {
    
    if (!param || (id)param == [NSNull null]) {
        return @"";
    }
    
    return param;
}

+ (NSNumber *)filterNumber:(NSNumber *)param {
    
    if (!param || (id)param == [NSNull null]) {
        return [NSNumber numberWithInt:-1];
    }
    
    if ([param isKindOfClass:[NSNumber class]]) {
        return param;
    }
    
    return [NSNumber numberWithInt:-1];
}

+ (NSArray *)getEntities
{
    static NSArray *_entities;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _entities = @[
                      @"Assign_project",
                      @"ComplianceForm",
                      @"DailyInspectionForm",
                      @"DailyInspectionItem",
                      @"Expensedata",
                      @"ExpenseReportModel",
                      @"NonComplianceForm",
                      @"Projects",
                      @"QuantitySummaryDetails",
                      @"QuantitySummaryItems",
                      @"SummarySheet1",
                      @"SummarySheet2",
                      @"SummarySheet3"
                      ];
    });
    return _entities;
}

@end
