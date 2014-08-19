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


+ (NSString *)getAPIEndpoint {
    //NSString *path = [[NSBundle mainBundle] bundlePath];
    //NSString *finalPath = [path stringByAppendingPathComponent:@"PRIMECMAPP-Info.plist"];
    //NSLog(@"final path: %@", finalPath);
    //NSDictionary *plistData = [NSDictionary dictionaryWithContentsOfFile:finalPath];
    
    NSString *endpoint = @"http://construction.ravihansa3000.com/contructionapi.php";
    return endpoint;
}


+ (NSString *)getServerImagePath {
    NSString *endpoint = @"http://construction.ravihansa3000.com/images";
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

@end
