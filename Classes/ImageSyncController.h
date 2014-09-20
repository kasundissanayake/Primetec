//
//  ImageSyncController.h
//  PRIMECMAPP
//
//  Created by Akila Perera on 9/21/14.
//
//

#import <Foundation/Foundation.h>

@interface ImageSyncController : NSObject


+ (BOOL) pullImagesFromServer;

+ (BOOL) downloadImageFromServer: (id) imageList;

+ (BOOL) pushPendingImagesToServer;

+ (BOOL) pushImageToServer:(NSString*) imageItem data:(NSData*)imageData;


@end
