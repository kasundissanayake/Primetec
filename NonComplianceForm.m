//
//  NonComplianceForm.m
//  PRIMECMAPP
//
//  Created by Kasun Dissanayake on 8/16/14.
//
//

#import "NonComplianceForm.h"


@implementation NonComplianceForm

@dynamic contractNo;
@dynamic contractorResponsible;
@dynamic date;
@dynamic dateContractorCompleted;
@dynamic dateContractorStarted;
@dynamic dateCRTCB;
@dynamic dateIssued;
@dynamic dateOfDWRReported;
@dynamic descriptionOfNonCompliance;
@dynamic images_uploaded;
@dynamic non_ComHeader;
@dynamic non_ComplianceNoticeNo;
@dynamic printedName;
@dynamic project;
@dynamic project_id;
@dynamic projectDescription;
@dynamic signature;
@dynamic sketch_images;
@dynamic title;
@dynamic to;
@dynamic userID;
@dynamic syncStatus;

-(NSDictionary*) toDictionary
{
    NSArray *attributes = [[self.entity attributesByName] allKeys];
    NSMutableDictionary *dict = [[self dictionaryWithValuesForKeys:attributes] mutableCopy];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *strDate = [dateFormatter stringFromDate:self.date];
    [dict setValue:strDate forKey:@"date"];
    
    NSString *strDateContractorCompleted = [dateFormatter stringFromDate:self.dateContractorCompleted];
    [dict setValue:strDateContractorCompleted forKey:@"dateContractorCompleted"];
    
    NSString *strDateContractorStarted = [dateFormatter stringFromDate:self.dateContractorStarted];
    [dict setValue:strDateContractorStarted forKey:@"dateContractorStarted"];
    
    NSString *strDateCRTCB = [dateFormatter stringFromDate:self.dateCRTCB];
    [dict setValue:strDateCRTCB forKey:@"dateCRTCB"];
    
    NSString *strDateIssued = [dateFormatter stringFromDate:self.dateIssued];
    [dict setValue:strDateIssued forKey:@"dateIssued"];
    
    NSString *strDateOfDWRReported = [dateFormatter stringFromDate:self.dateOfDWRReported];
    [dict setValue:strDateOfDWRReported forKey:@"dateOfDWRReported"];
    
    return dict;
}

@end
