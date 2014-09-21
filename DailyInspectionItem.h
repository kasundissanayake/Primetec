//
//  DailyInspectionItem.h
//  PRIMECMAPP
//
//  Created by Kasun Dissanayake on 8/16/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ExtendedManagedObject.h"

@interface DailyInspectionItem : ExtendedManagedObject

@property (nonatomic, retain) NSString * inspectionID;
@property (nonatomic, retain) NSString * no;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * qty;
@property (nonatomic, retain) NSDate * date;

@end
