//
//  SummarySheet1.m
//  PRIMECMAPP
//
//  Created by Kasun Dissanayake on 8/16/14.
//
//

#import "SummarySheet1.h"


@implementation SummarySheet1

@dynamic city;
@dynamic conPeWork;
@dynamic constructionOrder;
@dynamic contractor;
@dynamic date;
@dynamic descr;
@dynamic federalAidNumber;
@dynamic healWelAndPension;
@dynamic insAndTaxesOnItem1;
@dynamic itemDescount20per;
@dynamic lAAmount1;
@dynamic lAAmount2;
@dynamic lAAmount3;
@dynamic lAAmount4;
@dynamic lAAmount5;
@dynamic lAClass1;
@dynamic lAClass2;
@dynamic lAClass3;
@dynamic lAClass4;
@dynamic lAClass5;
@dynamic lANo1;
@dynamic lANo2;
@dynamic lANo3;
@dynamic lANo4;
@dynamic lANo5;
@dynamic lARate1;
@dynamic lARate2;
@dynamic lARate3;
@dynamic lARate4;
@dynamic lARate5;
@dynamic lATotalHours1;
@dynamic lATotalHours2;
@dynamic lATotalHours3;
@dynamic lATotalHours4;
@dynamic lATotalHours5;
@dynamic pOBox;
@dynamic project_id;
@dynamic projectNo;
@dynamic reportNo;
@dynamic sMSheetNo;
@dynamic sSHeader;
@dynamic state;
@dynamic telephoneNo;
@dynamic total;
@dynamic totalLabor;
@dynamic zip;
@dynamic printedName;
@dynamic syncStatus;


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
