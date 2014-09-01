//
//  QuantitySummaryDetails.m
//  PRIMECMAPP
//
//  Created by Kasun Dissanayake on 8/16/14.
//
//

#import "QuantitySummaryDetails.h"


@implementation QuantitySummaryDetails

@dynamic id;
@dynamic project_id;
@dynamic project;
@dynamic item_no;
@dynamic est_qty;
@dynamic unit;
@dynamic unit_price;
@dynamic user;


-(NSDictionary*) toDictionary
{
    NSArray *attributes = [[self.entity attributesByName] allKeys];
    NSMutableDictionary *dict = [[self dictionaryWithValuesForKeys:attributes] mutableCopy];
    
    return dict;
}

@end
