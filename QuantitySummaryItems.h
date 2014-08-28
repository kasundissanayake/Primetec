//
//  QuantitySummaryItems.h
//  PRIMECMAPP
//
//  Created by Kasun Dissanayake on 8/16/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ExtendedManagedObject.h"

@interface QuantitySummaryItems : ExtendedManagedObject

@property (nonatomic, retain) NSString * item_no;
@property (nonatomic, retain) NSNumber * quantity_sum_details_no;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * location_station;
@property (nonatomic, retain) NSString * daily;
@property (nonatomic, retain) NSString * accum;

@end
