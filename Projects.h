//
//  Projects.h
//  PRIMECMAPP
//
//  Created by Kasun Dissanayake on 8/16/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Projects : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * client_name;
@property (nonatomic, retain) NSString * contract_no;
@property (nonatomic, retain) NSDate * created_date;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * inspecter;
@property (nonatomic, retain) NSDate * p_date;
@property (nonatomic, retain) NSString * p_description;
@property (nonatomic, retain) NSString * p_latitude;
@property (nonatomic, retain) NSString * p_longitude;
@property (nonatomic, retain) NSString * p_name;
@property (nonatomic, retain) NSString * p_title;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * projecct_id;
@property (nonatomic, retain) NSString * project_manager;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * street;
@property (nonatomic, retain) NSString * zip;

@end
