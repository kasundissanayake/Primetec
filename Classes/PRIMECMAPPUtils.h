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


extern int * const SYNC_STATUS_OK;
extern int * const SYNC_STATUS_PENDING;
extern int * const SYNC_STATUS_DELETED;

+ (NSString *)getAPISyncPullEndpoint;

+ (NSString *)getAPISyncPushEndpoint;

+ (NSString *)getAPIEndpoint;

+ (NSManagedObjectContext *)getManagedObjectContext;

+ (NSString *)filterValue:(NSString *)param;

+ (NSNumber *)filterNumber:(NSString *)param;

+ (NSArray *)getEntities;

+(NSString *)getAPISyncImgPushEndpoint;

+(NSString *)getAPISyncImgPullEndpoint;

+(NSString *)getSyncImgBaseURL;

+(NSArray*) getItemFromDesc: (NSString*) desc;

+(NSArray*) getItemFromNo: (NSString*) no;

+(NSArray*) getSuggestionArray;

@end
