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

// item array
NSMutableArray *itemArray;

+(void) initialize {
    [self initItemArray];
}

+(NSString *)getAPISyncPullEndpoint {
    NSString *endpoint = @"http://192.168.167.1/ConstructionAPI/api/v1.0/sync/pull/";
    
    
    //NSString *endpoint = @"http://54.255.121.169/ConstructionAPI/api/v1.0/sync/pull/";
    
    //NSString *endpoint = @"http://www.privytext.us/ConstructionAPI/api/v1.0/sync/pull/";
    
    return endpoint;
}

+(NSString *)getAPISyncPushEndpoint {
    NSString *endpoint = @"http://192.168.167.1/ConstructionAPI/api/v1.0/sync/push/";
    
    //NSString *endpoint = @"http://54.255.121.169/ConstructionAPI/api/v1.0/sync/push/";
    
    //NSString *endpoint = @"http://www.privytext.us/ConstructionAPI/api/v1.0/sync/push/";
    
    return endpoint;
}

+(NSString *)getAPISyncImgPushEndpoint {
    NSString *endpoint = @"http://192.168.167.1/ConstructionAPI/api/v1.0/sync/images/push/";
    
    //NSString *endpoint = @"http://54.255.121.169/ConstructionAPI/api/v1.0/sync/images/push/";
    
    //NSString *endpoint = @"http://www.privytext.us/ConstructionAPI/api/v1.0/sync/images/push/";
    
    return endpoint;
}


+(NSString *)getAPISyncImgPullEndpoint {
    NSString *endpoint = @"http://192.168.167.1/ConstructionAPI/api/v1.0/sync/images/pull/";
    
    
    //NSString *endpoint = @"http://54.255.121.169/ConstructionAPI/api/v1.0/sync/images/pull/";
    
    //NSString *endpoint = @"http://www.privytext.us/ConstructionAPI/api/v1.0/sync/images/pull/";
    
    return endpoint;
}

+(NSString *)getSyncImgBaseURL {
    NSString *endpoint = @"http://192.168.167.1/ConstructionAPI/images/";
    
    
    //NSString *endpoint = @"http://54.255.121.169/ConstructionAPI/images/";
    
    //NSString *endpoint = @"http://www.privytext.us/ConstructionAPI/images/";
    
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
                      @"Projects",
                      // @"Assign_project",
                      
                      @"ComplianceForm",
                      @"ExpenseReportModel",
                      @"NonComplianceForm",
                      @"quantityEstimateForm",
                      
                      @"DailyInspectionForm",
                      // @"DailyInspectionItem",
                      
                      @"SummarySheet1",
                      @"SummarySheet2",
                      @"SummarySheet3"
                      ];
    });
    return _entities;
}

+(void) initItemArray {
    itemArray = [[NSMutableArray alloc] init];
    
    [itemArray addObject:@[@"INO-01", @"EARTH EXCAVATION AND GRADINGACCESS ROADPER CUBIC YARD"]];
    [itemArray addObject:@[@"INO-02", @"EARTH EXCAVATION AND SCREENED GRAVEL BELOW NORMAL GRADE PER CUBIC RD"]];
    [itemArray addObject:@[@"INO-03", @"TRENCH ROCK EXCAVATION DISPOSAL AND BACKFILL PER CUBIC YARD"]];
    [itemArray addObject:@[@"INO-04", @"CLEARING AND GRUBBING PER LUMP SUM"]];
    [itemArray addObject:@[@"INO-05", @"BANK RUN GRAVEL PER CUBIC YARD"]];
    [itemArray addObject:@[@"INO-06", @"TEST PITS PER CUBIC YARD"]];
    [itemArray addObject:@[@"INO-07", @"WATER FOR DUST CONTROL 1,000 GAL."]];
    [itemArray addObject:@[@"INO-08", @"SEDIMENTATION CONTROL SYSTEM PER LUMP SUM"]];
    [itemArray addObject:@[@"INO-09", @"MAINTENANCE AND PROTECTION OF TRAFFIC PER LUMP SUM"]];
    [itemArray addObject:@[@"INO-10", @"RAILROAD INSPECTOR ALLOWANCE"]];
    [itemArray addObject:@[@"INO-11", @"TRAFFICMEN(CITY POLICE)ALLOWAWCE"]];
    [itemArray addObject:@[@"INO-12", @"TRAFFICMEN	(STATE POLICE)ALLOWANCE"]];
    [itemArray addObject:@[@"INO-13", @"TRAFFICMEN(UNIFORMED FLAGMEN) ALLOWANCE"]];
    [itemArray addObject:@[@"INO-14", @"TEMPORARY WASTE STOCKPILE AREA RENTAL ALLOWANCE"]];
    [itemArray addObject:@[@"INO-15", @"UTILITY POLE RELOCATION ALLOWANCE"]];
    [itemArray addObject:@[@"INO-16", @"TEMPORARY PAVEMENT REPLACEMENT(CITY ROADS)PER SQ. YD."]];
    [itemArray addObject:@[@"INO-17", @"PERMANENT PAVEMENT REPLACEMENT( CITY ROADS )PER  SO ."]];
    [itemArray addObject:@[@"INO-18", @"MISCELLANEOUS CONCRETE PER CUBIC YARD"]];
    [itemArray addObject:@[@"INO-19", @"TURF ESTABLISHMENT PER SQ. YD."]];
    [itemArray addObject:@[@"INO-20", @"ENVIRONMENTAL HEALTH AND SAFETY PER LUMP SUM"]];
    [itemArray addObject:@[@"INO-21", @"TESTING LABORATORY SERVICES ALLOWANCE"]];
    [itemArray addObject:@[@"INO-22", @"FIELD OFFICE FOR ENGINEER PER MONTH"]];
    [itemArray addObject:@[@"INO-23", @"TEMPORARY WASTE STOCKPILE AREA PER LUMP SUM"]];
    [itemArray addObject:@[@"INO-24", @"DEWATERING, CONTROL AND DIVERSION OF WATER PER LUMP SUN"]];
    [itemArray addObject:@[@"INO-25", @"DISPOSAL OF CONTROLLED MATERIALS PER TON"]];
    [itemArray addObject:@[@"INO-26", @"CONTROLLED MATERIALS EXCAVATION PER CUBIC YARD"]];
    [itemArray addObject:@[@"INO-27", @"MANAGEMENT OF REUSABLE CONTROLLED MATERIAL PER CUBIC YARD"]];
    [itemArray addObject:@[@"INO-28", @"STONE CROSSING PER CUBIC YARD"]];
    [itemArray addObject:@[@"INO-29", @"HANDLING CONTAMINATED GROUNDWATER PER LUMP SUM"]];
    [itemArray addObject:@[@"INO-30", @"PIPE CROSSING UNDER RAILROAD PER LINEAR FOOT"]];
    [itemArray addObject:@[@"INO-31", @"CEMENT CONCRETE SIDEWALK AND DRIVEWAY PER 3Q. FT."]];
    [itemArray addObject:@[@"INO-32", @"30 REINFORCED CONCRETE PIPE LINER FOOT"]];
    [itemArray addObject:@[@"INO-33", @"30 REINFORCED  CONCRETE CULVERT END EACH"]];
    [itemArray addObject:@[@"INO-34", @"CONCRETE CURBING PER  LINEAR  FOOT"]];
    [itemArray addObject:@[@"INO-35", @"24 PVC  FORCE  MAIN  PIPING  AND APPURTENANCES PER  LINEAR  FOOT"]];
    [itemArray addObject:@[@"INO-36", @"30 PVC  FORCE  MAIN  PIPING AND APPURTENANCES PER LINEAR  FOOT"]];
    [itemArray addObject:@[@"INO-37", @"HYDROSTATIC TESTING  OF  FORCE MAIN PER  LUMP  SUM"]];
    [itemArray addObject:@[@"INO-38", @"DIRECTIONAL DRILLED FORCE MAIN PIPE #1 PER LINEAR FOOT PVC"]];
    [itemArray addObject:@[@"INO-39", @"DIRECTIONAL DRILLED FORCE MAIN PIPE #2 PER LINEAR FOOT PVC"]];
    [itemArray addObject:@[@"INO-40", @"DISPOSAL OF HDD BORE CUTTINGS PER TON"]];
    [itemArray addObject:@[@"INO-41", @"DISPOSAL OF HDD DRILLING MUD PER 1000 GAL"]];
    [itemArray addObject:@[@"INO-42", @"HDD  ADDITIONAL  REDIRECT  ROCK EACH"]];
    [itemArray addObject:@[@"INO-43", @"HDD  ADDITIONAL  REDIRECT  IN SOIL EACH"]];
    [itemArray addObject:@[@"INO-44", @"HDD  ADDITIONAL  CONDUCTOR CASING PER  LINEAR  FOOT"]];
    [itemArray addObject:@[@"INO-45", @"PERMANENT  ACCESS  ROAD PER  LINEAR  FOOT"]];
    [itemArray addObject:@[@"INO-46", @"WETLAND  MITIGATION  AND ENHANCEMENT PER  SQ.   YD."]];
    [itemArray addObject:@[@"INO-47", @"CONTROL  AND  REMOVAL  OF INVASIVE  VEGETATION PER ACRE"]];
    [itemArray addObject:@[@"INO-48", @"AIR  VALVE  MANHOLE EACH"]];
    [itemArray addObject:@[@"INO-49", @"JUNCTION  VAULT EACH"]];
    [itemArray addObject:@[@"INO-50", @"FORCE  MAIN  DRAIN  MANHOLE	EACH"]];
    [itemArray addObject:@[@"INO-51", @"RAILROAD  TRACK  REMOVAL AND RE PLACEMENT ALLOWANCE"]];
    [itemArray addObject:@[@"INO-52", @"RAILROAD  STONE  BALLAST PER  CUBIC  YARD"]];
    [itemArray addObject:@[@"INO-53", @"WATER  FOR  FORCE  MAIN  TESTING	ALLOWANCE"]];
    [itemArray addObject:@[@"INO-54", @"ADDITIONAL ALTERNATE NO. 1-EXTENDED WARRANTY(MAINTENANCE BOND) PER LUM SUM"]];
    [itemArray addObject:@[@"INO-55", @"ADD ALTERNATE NO. 2- CITY OF MIDDLETOWN PERMITS ALLOWANCE"]];
}

+(NSArray*) getItemFromDesc: (NSString*) desc {
    for (id item in itemArray){
        
        if ([[item objectAtIndex:1] isEqualToString:desc]){
            return item;
        }
    }
    return nil;
}

+(NSArray*) getItemFromNo: (NSString*) no {
    for (id item in itemArray){
        
        if ([[item objectAtIndex:0] isEqualToString:no]){
            return item;
        }
    }
    return nil;
}

+(NSArray*) getSuggestionArray {
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (id item in itemArray){
        [arr addObject:[item objectAtIndex:1]];
    }
    return arr;
}

+(NSArray*) getItemArray {
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (id item in itemArray){
        [arr addObject:[item objectAtIndex:0]];
    }
    return arr;
}

@end
