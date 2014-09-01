//
//  SummarySheet2.m
//  PRIMECMAPP
//
//  Created by Kasun Dissanayake on 8/16/14.
//
//

#import "SummarySheet2.h"


@implementation SummarySheet2

@dynamic additionalDiscount;
@dynamic lessDiscount;
@dynamic mEAmount1;
@dynamic mEAmount2;
@dynamic mEAmount3;
@dynamic mEAmount4;
@dynamic mEAmount5;
@dynamic mEDescription1;
@dynamic mEDescription2;
@dynamic mEDescription3;
@dynamic mEDescription4;
@dynamic mEDescription5;
@dynamic mEQuantity1;
@dynamic mEQuantity2;
@dynamic mEQuantity3;
@dynamic mEQuantity4;
@dynamic mEQuantity5;
@dynamic mEUnitPrice1;
@dynamic mEUnitPrice2;
@dynamic mEUnitPrice3;
@dynamic mEUnitPrice4;
@dynamic mEUnitPrice5;
@dynamic project_id;
@dynamic sMSSheetNo;
@dynamic total1;
@dynamic total2;
@dynamic total3;

-(NSDictionary*) toDictionary
{
    NSArray *attributes = [[self.entity attributesByName] allKeys];
    NSMutableDictionary *dict = [[self dictionaryWithValuesForKeys:attributes] mutableCopy];
    
    return dict;
}

@end
