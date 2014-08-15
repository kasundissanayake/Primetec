//
//  projectCodata.h
//  PRIMECMAPP
//
//  Created by 3SG Corporation on 7/30/14.
//
//

#import <CoreData/CoreData.h>

@interface projectCodata : NSManagedObject

@property (nonatomic, strong) NSString *projecct_id;
@property (nonatomic, strong) NSString *p_title;
@property (nonatomic, strong) NSString *p_name;
@property (nonatomic, strong) NSString *p_description;
@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *zip;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSDate *p_date;
@property (nonatomic, strong) NSString *client_name;
@property (nonatomic, strong) NSString *project_manager;
@property (nonatomic, strong) NSString *inspecter;










@end