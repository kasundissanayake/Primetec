//
//  PRIMECMController.h
//  PRIMECMAPP
//
//  Created by Kasun Dissanayake on 8/16/14.
//
//

#import <Foundation/Foundation.h>

@interface PRIMECMController : NSObject
- (void)synchronizeWithServer:(NSString *)url;
- (void)parseResponse:(id)responseObject;

@end
