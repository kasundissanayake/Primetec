//
//  Assign_project.m
//  PRIMECMAPP
//
//  Created by Kasun Dissanayake on 8/16/14.
//
//

#import "Assign_project.h"


@implementation Assign_project

@dynamic assign_date;
@dynamic id;
@dynamic projectid;
@dynamic username;

-(NSDictionary*) toDictionary
{
    NSArray *attributes = [[self.entity attributesByName] allKeys];
    NSMutableDictionary *dict = [[self dictionaryWithValuesForKeys:attributes] mutableCopy];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:self.assign_date];
    [dict setValue:strDate forKey:@"assign_date"];  
    
    return dict;
}

@end
