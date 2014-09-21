//
//  NonComplianceForm.h
//  PRIMECMAPP
//
//  Created by Kasun Dissanayake on 8/16/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ExtendedManagedObject.h"

@interface NonComplianceForm : ExtendedManagedObject

@property (nonatomic, retain) NSString * contractNo;
@property (nonatomic, retain) NSString * contractorResponsible;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSDate * dateContractorCompleted;
@property (nonatomic, retain) NSDate * dateContractorStarted;
@property (nonatomic, retain) NSDate * dateCRTCB;
@property (nonatomic, retain) NSDate * dateIssued;
@property (nonatomic, retain) NSDate * dateOfDWRReported;
@property (nonatomic, retain) NSString * descriptionOfNonCompliance;
@property (nonatomic, retain) NSString * images_uploaded;
@property (nonatomic, retain) NSString * non_ComHeader;
@property (nonatomic, retain) NSString * non_ComplianceNoticeNo;
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
