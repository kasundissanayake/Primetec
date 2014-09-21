//
//  QuantitySummaryDetails.h
//  PRIMECMAPP
//
//  Created by Akila Perera on 9/21/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ExtendedManagedObject.h"

@interface QuantityEstimateForm : ExtendedManagedObject

@property (nonatomic, retain) NSNumber * est_qty;
@property (nonatomic, retain) NSString * item_no;
@property (nonatomic, retain) NSString * project_id;
@property (nonatomic, retain) NSString * unit;
@property (nonatomic, retain) NSNumber * unit_price;
@property (nonatomic, retain) NSString * user;
@property (nonatomic, retain) NSNumber * syncStatus;
@property (nonatomic, retain) NSString * qtyEstID;
@property (nonatomic, retain) NSDate * date;

@end
