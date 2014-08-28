//
//  Image.h
//  PRIMECMAPP
//
//  Created by Kasun Dissanayake on 8/23/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ExtendedManagedObject.h"

@interface Image : ExtendedManagedObject

@property (nonatomic, retain) NSString * imgName;
@property (nonatomic, retain) NSData * img;

@end
