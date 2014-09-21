//
//  ComplianceForm.h
//  PRIMECMAPP
//
//  Created by Kasun Dissanayake on 8/18/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ExtendedManagedObject.h"

@interface ComplianceForm : ExtendedManagedObject

@property (nonatomic, retain) NSString * comHeader;
@property (nonatomic, retain) NSString * complianceNoticeNo;
@property (nonatomic, retain) NSNumber * contractNo;
@property (nonatomic, retain) NSString * contractorResponsible;
@property (nonatomic, retain) NSString * correctiveActionCompliance;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSDate * dateContractorCompleted;
@property (nonatomic, retain) NSDate * dateContractorStarted;
@property (nonatomic, retain) NSDate * dateIssued;
@property (nonatomic, retain) NSDate * dateOfDWRReported;
@property (nonatomic, retain) NSString * images_1;
@property (nonatomic, retain) NSString * images_1_desc;
@property (nonatomic, retain) NSString * images_2;
@property (nonatomic, retain) NSString * images_2_desc;
@property (nonatomic, retain) NSString * images_3;
@property (nonatomic, retain) NSString * images_3_desc;
@property (nonatomic, retain) NSString * images_uploaded;
@property (nonatomic, retain) NSString * printedName;
@property (nonatomic, retain) NSString * project;
@property (nonatomic, retain) NSString * project_id;
@property (nonatomic, retain) NSString * projectDescription;
@property (nonatomic, retain) NSString * signature;
@property (nonatomic, retain) NSString * sketch_images;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * to;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSNumber * syncStatus;

@end
