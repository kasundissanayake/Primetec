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

NSString * const SERVER_PATH = @"SERVER_PATH";
NSString * const ROOT_RELOAD_NOTIFICATION = @"ROOT_RELOAD_NOTIFICATION";
NSString * const CACHE_CREDENTIALS = @"cache_credentials";
NSString * const USERNAME = @"USERNAME";
NSString * const PASSWORD = @"PASSWORD";


+ (NSString *)getServerPath {
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:@"Resource.plist"];
    NSDictionary *plistData = [NSDictionary dictionaryWithContentsOfFile:finalPath];
    
    return [plistData objectForKey:SERVER_PATH];
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
