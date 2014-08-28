//
//  QuantitySummaryItems.m
//  PRIMECMAPP
//
//  Created by Kasun Dissanayake on 8/16/14.
//
//

#import "QuantitySummaryItems.h"


@implementation QuantitySummaryItems

@dynamic item_no;
@dynamic quantity_sum_details_no;
@dynamic date;
@dynamic location_station;
@dynamic daily;
@dynamic accum;


-(NSDictionary*) toDictionary
{
    NSArray *attributes = [[self.entity attributesByName] allKeys];
    NSMutableDictionary *dict = [[self dictionaryWithValuesForKeys:attributes] mutableCopy];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:self.date];
    [dict setValue:strDate forKey:@"date"];
    
    return dict;
}

@end
