//
//  QuantitySummaryDetails.h
//  PRIMECMAPP
//
//  Created by Kasun Dissanayake on 8/16/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ExtendedManagedObject.h"

@interface QuantitySummaryDetails : ExtendedManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * project_id;
@property (nonatomic, retain) NSString * project;
@property (nonatomic, retain) NSString * item_no;
@property (nonatomic, retain) NSNumber * est_qty;
@property (nonatomic, retain) NSNumber * unit;
@property (nonatomic, retain) NSString * unit_price;
@property (nonatomic, retain) NSString * user;

@end
