//
//  Expensedata.h
//  PRIMECMAPP
//
//  Created by Kasun Dissanayake on 8/16/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ExtendedManagedObject.h"

@interface Expensedata : ExtendedManagedObject

@property (nonatomic, retain) NSDate * eRDate1;
@property (nonatomic, retain) NSString * eRDescription1;
@property (nonatomic, retain) NSString * eRJobNo1;
@property (nonatomic, retain) NSNumber * eRPAMilage1;
@property (nonatomic, retain) NSNumber * eRPARate1;
@property (nonatomic, retain) NSNumber * eRTotal1;
@property (nonatomic, retain) NSString * eRType1;
@property (nonatomic, retain) NSString * eXReportNo;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * images_uploaded;

@end
