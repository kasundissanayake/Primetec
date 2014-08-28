//
//  Users.m
//  PRIMECMAPP
//
//  Created by Kasun Dissanayake on 8/16/14.
//
//

#import "Users.h"


@implementation Users

@dynamic active;
@dynamic created;
@dynamic email;
@dynamic firstname;
@dynamic id;
@dynamic id_no;
@dynamic lastname;
@dynamic password;
@dynamic user_type;
@dynamic username;


-(NSDictionary*) toDictionary
{
    NSArray *attributes = [[self.entity attributesByName] allKeys];
    NSMutableDictionary *dict = [[self dictionaryWithValuesForKeys:attributes] mutableCopy];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:self.created];
    [dict setValue:strDate forKey:@"created"];
    
    return dict;
}

@end
