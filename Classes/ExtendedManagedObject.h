//
//  ExtendedManagedObject.h
//  PRIMECMAPP
//
//  Created by Akila Perera on 8/26/14.
//
//

#import <CoreData/CoreData.h>

@interface ExtendedManagedObject : NSManagedObject

//@property (nonatomic, assign) BOOL traversed;

- (NSDictionary*) toDictionary;
//- (void) populateFromDictionary:(NSDictionary*)dict;
//+ (ExtendedManagedObject*) createManagedObjectFromDictionary:(NSDictionary*)dict
//                                                   inContext:(NSManagedObjectContext*)context;

@end