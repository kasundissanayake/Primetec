//
//  Projects.m
//  PRIMECMAPP
//
//  Created by Akila Perera on 9/6/14.
//
//

#import "Projects.h"


@implementation Projects

@dynamic address;
@dynamic city;
@dynamic client_name;
@dynamic contract_no;
@dynamic created_date;
@dynamic id;
@dynamic inspecter;
@dynamic p_date;
@dynamic p_description;
@dynamic p_latitude;
@dynamic p_longitude;
@dynamic p_name;
@dynamic p_title;
@dynamic phone;
@dynamic projecct_id;
@dynamic project_manager;
@dynamic state;
@dynamic status;
@dynamic street;
@dynamic zip;

-(NSDictionary*) toDictionary
{
    NSArray *attributes = [[self.entity attributesByName] allKeys];
    NSMutableDictionary *dict = [[self dictionaryWithValuesForKeys:attributes] mutableCopy];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *strCreated_date = [dateFormatter stringFromDate:self.created_date];
    [dict setValue:strCreated_date forKey:@"created_date"];
    
    NSString *strPDate = [dateFormatter stringFromDate:self.p_date];
    [dict setValue:strPDate forKey:@"p_date"];
    
    return dict;
}

@end
