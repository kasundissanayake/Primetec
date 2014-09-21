//
//  ExtendedManagedObject.h
//  PRIMECMAPP
//
//  Created by Akila Perera on 8/26/14.
//
//

#import <CoreData/CoreData.h>

@interface ExtendedManagedObject : NSManagedObject

- (NSDictionary*) toDictionary;

@end