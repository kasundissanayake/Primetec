#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ExtendedManagedObject.h"

@interface ExpenseReportModel : ExtendedManagedObject

@property (nonatomic, retain) NSString * approvedBy;
@property (nonatomic, retain) NSDate * eRDate1;
@property (nonatomic, retain) NSString * checkNo;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * eRDescription1;
@property (nonatomic, retain) NSString * eMPName;
@property (nonatomic, retain) NSNumber * eRCashAdvance;
@property (nonatomic, retain) NSString * eRFHeader;
@property (nonatomic, retain) NSNumber * eRReimbursement;
@property (nonatomic, retain) NSString * eXReportNo;
@property (nonatomic, retain) NSString * images_uploaded;
@property (nonatomic, retain) NSString * project_id;
@property (nonatomic, retain) NSString * signature;
@property (nonatomic, retain) NSDate * weekEnding;
@property (nonatomic, retain) NSString * eRJobNo1;
@property (nonatomic, retain) NSString * eRPAMilage1;
@property (nonatomic, retain) NSNumber * eRPARate1;
@property (nonatomic, retain) NSString * eRTotal1;
@property (nonatomic, retain) NSString * eRType1;

@end



