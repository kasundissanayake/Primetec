//
//  PRIMECMAPPUtils.h
//  PRIMECMAPP
//
//  Created by Kasun Dissanayake on 8/16/14.
//
//

#import <Foundation/Foundation.h>

@interface PRIMECMAPPUtils : NSObject

extern NSString * const SERVER_PATH;
extern NSString * const ROOT_RELOAD_NOTIFICATION;
extern NSString * const REGISTER_URL;
extern NSString * const LOGIN_URL;
extern NSString * const CACHE_CREDENTIALS;
extern NSString * const USERNAME;
extern NSString * const PASSWORD;
extern NSString * const TOKEN_URL;
extern NSString * const ACCESS_TOKEN;
extern NSString * const REFRESH_TOKEN;

+ (NSString *)getAPIEndpoint;

+ (NSManagedObjectContext *)getManagedObjectContext;

+ (NSString *)filterValue:(NSString *)param;

+ (NSNumber *)filterNumber:(NSString *)param;

@end
