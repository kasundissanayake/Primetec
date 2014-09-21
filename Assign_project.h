//
//  Assign_project.h
//  PRIMECMAPP
//
//  Created by Kasun Dissanayake on 8/16/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ExtendedManagedObject.h"

@interface Assign_project : ExtendedManagedObject

@property (nonatomic, retain) NSDate * assign_date;
@property (nonatomic, retain) NSString * projectid;
@property (nonatomic, retain) NSString * username;

-(NSDictionary*) toDictionary;
@end
