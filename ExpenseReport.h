//
//  ExpenseReport.h
//  PRIMECMAPP
//
//  Created by Kasun Dissanayake on 8/16/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ExpenseReport : NSManagedObject

@property (nonatomic, retain) NSString * approvedBy;
@property (nonatomic, retain) NSString * attachment;
@property (nonatomic, retain) NSString * checkNo;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * employeeNo;
@property (nonatomic, retain) NSString * eMPName;
@property (nonatomic, retain) NSNumber * eRCashAdvance;
@property (nonatomic, retain) NSString * eRFHeader;
@property (nonatomic, retain) NSNumber * eRReimbursement;
@property (nonatomic, retain) NSString * eXReportNo;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * images_uploaded;
@property (nonatomic, retain) NSString * project_id;
@property (nonatomic, retain) NSString * signature;
@property (nonatomic, retain) NSDate * weekEnding;

@end
