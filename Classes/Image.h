//
//  Image.h
//  PRIMECMAPP
//
//  Created by Kasun Dissanayake on 8/23/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Image : NSManagedObject

@property (nonatomic, retain) NSString * imgName;
@property (nonatomic, retain) NSData * img;

@end
