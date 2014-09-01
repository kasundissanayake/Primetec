//
//  ExtendedManagedObject.m
//  PRIMECMAPP
//
//  Created by Akila Perera on 8/26/14.
//
//

#import "ExtendedManagedObject.h"

@implementation ExtendedManagedObject


-(NSDictionary*) toDictionary
{
    NSArray *attributes = [[self.entity attributesByName] allKeys];
    NSMutableDictionary *dict = [[self dictionaryWithValuesForKeys:attributes] mutableCopy];
    
    return dict;
}

@end
