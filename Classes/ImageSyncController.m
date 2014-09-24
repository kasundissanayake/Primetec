//
//  ImageSyncController.m
//  PRIMECMAPP
//
//  Created by Akila Perera on 9/21/14.
//
//

#import "ImageSyncController.h"
#import "PRIMECMAPPUtils.h"
#import "ExtendedManagedObject.h"
#import "Reachability.h"
#import "PRIMECMController.h"

@implementation ImageSyncController

+ (BOOL) pullImagesFromServer {
    
    NSError *error = [[NSError alloc] init];
    NSManagedObjectContext *context = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Image" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setPropertiesToFetch:@[@"imgName"]];
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *entityObjArray =[[NSMutableArray alloc] init];
    for (ExtendedManagedObject *managedObj in objects) {
        NSDictionary *itemDict =  [managedObj toDictionary];
        [entityObjArray addObject:itemDict];
        
    }
    [data setObject:entityObjArray forKey:@"Image"];
    
    
    // create a JSON string from your NSDictionary
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] init];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    
    NSURL *endpoint = [NSURL URLWithString:[PRIMECMAPPUtils getAPISyncImgPullEndpoint]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL: endpoint];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"Sync image pull request body json data: %@", data);
    
    
    NSHTTPURLResponse* urlResponse = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSLog(@"Sync Image Pull HTTP Response Code: %d", [urlResponse statusCode]);
    NSString *responsestr = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    NSLog(@"Sync Image Pull Response: %@", responsestr);
    NSLog(@"NSHTTPURLResponse: %@", urlResponse);
    
    if ( ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300))
    {
        
        NSString *responsestr = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        NSLog(@"Successfully downloaded sync image pull json");
        NSError *jsonError;
        id jsonResponse = [NSJSONSerialization JSONObjectWithData:[responsestr dataUsingEncoding:NSUTF8StringEncoding]
                                                          options:NSJSONReadingMutableContainers
                                                            error:&jsonError];
        
        NSDictionary *responseDictionary = (NSDictionary *)jsonResponse;
        if (!jsonError && responseDictionary){
            id msgStatus = [[responseDictionary objectForKey:@"message"] objectForKey:@"status"];
            
            if ([msgStatus isEqualToString:@"success"]){
                return [self downloadImageFromServer:[responseDictionary objectForKey:@"Image"]];
            }else{
                NSLog(@"Error in response status: %@", msgStatus);
                return FALSE;
            }
        }else{
            return FALSE;
        }
        
        return TRUE;
    }
    else
    {
        NSLog(@"Server is not responding. Failed to download sync pull json. Response code: %ld", (long)[urlResponse statusCode]);
        return FALSE;
    }
    return FALSE;
}

+ (BOOL) downloadImageFromServer: (id) imageList {
    
    BOOL downloadSatus = TRUE;
    
    for (id imgName in imageList){
        NSLog(@"Pull image name: %@", imgName);
        NSURL *endpoint = [NSURL URLWithString:[[PRIMECMAPPUtils getSyncImgBaseURL] stringByAppendingString:imgName]];
        NSData* imgData = [NSData dataWithContentsOfURL:endpoint];
        
        if (![PRIMECMController saveAllImages:imgName img:imgData syncStatus:SYNC_STATUS_OK]){
            downloadSatus = FALSE;
        }
    }
    
    return downloadSatus;
}

+ (BOOL) pushPendingImagesToServer {
    NSError *error = [[NSError alloc] init];
    
    NSManagedObjectContext *context = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Image" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(syncStatus = %d)", SYNC_STATUS_PENDING];
    [fetchRequest setPredicate:predicate];
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    
    NSLog(@"Img sync objs: %@", objects);
    
    BOOL imgSyncStatus = TRUE;
    
    for (NSManagedObject* imageObj in objects){
        
        UIImage* img = [UIImage imageWithData:[imageObj valueForKey:@"img"]];
        NSData *imageData = UIImageJPEGRepresentation(img, 1.0);
        
        if (imageData == nil){
            continue;
        }
        
        if ([self pushImageToServer:[imageObj valueForKey:@"imgName"] data:imageData ]){
            
            NSNumber *imgSyncStatus = [NSNumber numberWithInt:SYNC_STATUS_OK];
            [imageObj setValue:imgSyncStatus forKey:@"syncStatus"];
            if (![context save:&error]){
                NSLog(@"Failed to update SYNC STATUS of image: %@", [imageObj valueForKey:@"imgName"]);
            }
            
        } else {
            NSLog(@"Failed to push image with name: %@", [objects valueForKey:@"imgName"]);
            imgSyncStatus = FALSE;
        }
    }
    
    return imgSyncStatus;
}

+ (BOOL) pushImageToServer:(NSString*) imageItem data:(NSData*)imageData {
    
    
    if (![self connected]) {
        return FALSE;
    }
    if (!imageData){
        return FALSE;
    }
    
    NSString *urlString = [ PRIMECMAPPUtils getAPISyncImgPushEndpoint];
    NSHTTPURLResponse* urlResponse = [[NSHTTPURLResponse alloc] init];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n", imageItem] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:nil];
    
    
    if ( ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300))
    {
        NSLog(@"Pushed image: %@", imageItem);
        return TRUE;
    }
    return FALSE;
}

+ (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

@end
