//
//  QuantitySummaryDetails.m
//  PRIMECMAPP
//
//  Created by Akila Perera on 9/21/14.
//
//

#import "QuantityEstimateForm.h"


@implementation QuantityEstimateForm

@dynamic est_qty;
@dynamic item_no;
@dynamic project_id;
@dynamic unit;
@dynamic unit_price;
@dynamic user;
@dynamic syncStatus;
@dynamic qtyEstID;
@dynamic date;

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
