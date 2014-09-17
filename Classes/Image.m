//
//  Image.m
//  PRIMECMAPP
//
//  Created by Kasun Dissanayake on 8/23/14.
//
//

#import "Image.h"


@implementation Image

@dynamic imgName;
@dynamic img;
@dynamic syncStatus;

-(NSDictionary*) toDictionary
{
    NSArray *attributes = [[self.entity attributesByName] allKeys];
    NSMutableDictionary *dict = [[self dictionaryWithValuesForKeys:attributes] mutableCopy];
    
    [dict setValue:nil forKey:@"img"];
    
    return dict;
}

@end
