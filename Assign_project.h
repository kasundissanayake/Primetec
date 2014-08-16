//
//  Assign_project.h
//  PRIMECMAPP
//
//  Created by Kasun Dissanayake on 8/16/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Assign_project : NSManagedObject

@property (nonatomic, retain) NSDate * assign_date;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * projectid;
@property (nonatomic, retain) NSString * username;

@end
