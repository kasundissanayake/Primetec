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
@dynamic attachment;
@dynamic checkNo;
@dynamic date;
@dynamic employeeNo;
@dynamic eMPName;
@dynamic eRCashAdvance;
@dynamic eRFHeader;
@dynamic eRReimbursement;
@dynamic eXReportNo;
@dynamic id;
@dynamic images_uploaded;
@dynamic project_id;
@dynamic signature;
@dynamic weekEnding;

-(NSDictionary*) toDictionary
{
    NSArray *attributes = [[self.entity attributesByName] allKeys];
    NSMutableDictionary *dict = [[self dictionaryWithValuesForKeys:attributes] mutableCopy];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *strDate = [dateFormatter stringFromDate:self.date];
    [dict setValue:strDate forKey:@"date"];
    
    NSString *strWeekEndingDate = [dateFormatter stringFromDate:self.weekEnding];
    [dict setValue:strWeekEndingDate forKey:@"weekEnding"];
    
    return dict;
}

@end
