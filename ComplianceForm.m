//
//  ComplianceForm.m
//  PRIMECMAPP
//
//  Created by Kasun Dissanayake on 8/18/14.
//
//

#import "ComplianceForm.h"


@implementation ComplianceForm

@dynamic comHeader;
@dynamic complianceNoticeNo;
@dynamic contractNo;
@dynamic contractorResponsible;
@dynamic correctiveActionCompliance;
@dynamic date;
@dynamic dateContractorCompleted;
@dynamic dateContractorStarted;
@dynamic dateIssued;
@dynamic dateOfDWRReported;
@dynamic images_1;
@dynamic images_1_desc;
@dynamic images_2;
@dynamic images_2_desc;
@dynamic images_3;
@dynamic images_3_desc;
@dynamic images_uploaded;
@dynamic printedName;
@dynamic project_id;
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
    
    NSString *strDateIssued = [dateFormatter stringFromDate:self.dateIssued];
    [dict setValue:strDateIssued forKey:@"dateIssued"];
    
    NSString *strDateOfDWRReported = [dateFormatter stringFromDate:self.dateOfDWRReported];
    [dict setValue:strDateOfDWRReported forKey:@"dateOfDWRReported"];

    return dict;
}


@end
