//
//  ExpenseReport.m
//  PRIMECMAPP
//
//  Created by Kasun Dissanayake on 8/16/14.
//
//

#import "ExpenseReportModel.h"


@implementation ExpenseReportModel

@dynamic approvedBy;
@dynamic eRDate1;
@dynamic checkNo;
@dynamic date;
@dynamic eRDescription1;
@dynamic eMPName;
@dynamic eRCashAdvance;
@dynamic eRFHeader;
@dynamic eRReimbursement;
@dynamic eXReportNo;
@dynamic images_uploaded;
@dynamic project_id;
@dynamic signature;
@dynamic weekEnding;
@dynamic eRJobNo1;
@dynamic eRPAMilage1;
@dynamic eRPARate1;
@dynamic eRTotal1;
@dynamic eRType1;



-(NSDictionary*) toDictionary
{
    NSArray *attributes = [[self.entity attributesByName] allKeys];
    NSMutableDictionary *dict = [[self dictionaryWithValuesForKeys:attributes] mutableCopy];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *strDate = [dateFormatter stringFromDate:self.date];
    [dict setValue:strDate forKey:@"date"];
    
    NSString *eRDate1 = [dateFormatter stringFromDate:self.date];
    [dict setValue:eRDate1 forKey:@"eRDate1"];
    
    NSString *strWeekEndingDate = [dateFormatter stringFromDate:self.weekEnding];
    [dict setValue:strWeekEndingDate forKey:@"weekEnding"];
    
    return dict;
}

@end
