//
//  Expensedata.m
//  PRIMECMAPP
//
//  Created by Kasun Dissanayake on 8/16/14.
//
//

#import "Expensedata.h"


@implementation Expensedata

@dynamic eRDate1;
@dynamic eRDescription1;
@dynamic eRJobNo1;
@dynamic eRPAMilage1;
@dynamic eRPARate1;
@dynamic eRTotal1;
@dynamic eRType1;
@dynamic eXReportNo;
@dynamic id;
@dynamic images_uploaded;


-(NSDictionary*) toDictionary
{
    NSArray *attributes = [[self.entity attributesByName] allKeys];
    NSMutableDictionary *dict = [[self dictionaryWithValuesForKeys:attributes] mutableCopy];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:self.eRDate1];
    [dict setValue:strDate forKey:@"eRDate1"];
    
    return dict;
}

@end
