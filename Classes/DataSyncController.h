//
//  DataSyncController.h
//  PRIMECMAPP
//
//  Created by Akila Perera on 9/21/14.
//
//

#import <Foundation/Foundation.h>

@interface DataSyncController : NSObject

+ (void)parseResponse:(id)responseObject;

+(BOOL) pushPendingDataToServer;

+(BOOL) pullDataFromServer;

@end
