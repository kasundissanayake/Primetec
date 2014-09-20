//
//  PRIMECMController.m
//  PRIMECMAPP
//
//  Created by Kasun Dissanayake on 8/16/14.
//
//

#import "PRIMECMController.h"
#import "PRIMECMAPPUtils.h"
#import "Assign_project.h"
#import "ComplianceForm.h"
#import "DailyInspectionForm.h"
#import "DailyInspectionItem.h"
#import "Expensedata.h"
#import "ExpenseReportModel.h"
#import "NonComplianceForm.h"
#import "Projects.h"
#import "QuantitySummaryDetails.h"
#import "QuantitySummaryItems.h"
#import "SummarySheet1.h"
#import "SummarySheet2.h"
#import "SummarySheet3.h"
#import "Users.h"
#import "Reachability.h"
#import "Image.h"

@implementation PRIMECMController

+ (int)synchronizeWithServer {
    
    NSString *url = [NSString stringWithFormat:@"%@", [PRIMECMAPPUtils getAPISyncPullEndpoint]];
    
    if (![self connected]) {
        return 1;
    }
    
    BOOL pushStatus = [self pushAllToServer];
    if (!pushStatus){
        return 4;
    }
    
    NSURL *endpoint = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL: endpoint];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse* urlResponse = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSLog(@"Sync Pull HTTP Response Code: %d", [urlResponse statusCode]);
    
    if ( ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300))
    {
        NSString *responsestr = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        NSLog(@"Successfully downloaded complete json");
        NSError *jsonError;
        id jsonResponse = [NSJSONSerialization JSONObjectWithData:[responsestr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonError];
        
        NSDictionary *responseDictionary = (NSDictionary *)jsonResponse;
        if (!jsonError && responseDictionary){
            id msgStatus = [[responseDictionary objectForKey:@"message"] objectForKey:@"status"];
            if ([msgStatus isEqualToString:@"success"]){
                
                [self parseResponse:jsonResponse];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reload_table_data" object:self];
                NSLog(@"Successfully parsed complete json");
                
                return 0;
            }else{
                NSLog(@"%@", [jsonError description]);
                return 3;
            }
        }else{
            return 3;
        }
    }
    else
    {
        NSLog(@"Server is not responding. Failed to download complete json. Response code: %ld", (long)[urlResponse statusCode]);
        return 2;
    }
}

+(BOOL) pushAllToServer{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    NSArray *entities = [PRIMECMAPPUtils getEntities];
    NSError *error = [[NSError alloc] init];
    NSManagedObjectContext *context = [PRIMECMAPPUtils getManagedObjectContext];
    
    for (NSString *entityItem in entities){
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:entityItem inManagedObjectContext:context];
        
        [fetchRequest setEntity:entity];
        NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
        NSMutableArray *entityObjArray =[[NSMutableArray alloc] init];
        for (ExtendedManagedObject *managedObj in objects){
            NSDictionary *itemDict =  [managedObj toDictionary]; //[assp toDictionary];
            [entityObjArray addObject:itemDict];
            
        }
        [data setObject:entityObjArray forKey:entityItem];
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
    if (! jsonData) {
        NSLog(@"JSON error: %@", error.localizedDescription);
        return FALSE;
    }
    
    NSString *jsonReqStringData = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    if (![self connected]) {
        return FALSE;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@", [PRIMECMAPPUtils getAPISyncPushEndpoint]];
    NSData *bodyData = [jsonReqStringData dataUsingEncoding:NSUTF8StringEncoding];
    NSURL *endpoint = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    [request setURL: endpoint];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:bodyData];
    
    NSHTTPURLResponse* urlResponse = [[NSHTTPURLResponse alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSString *responsestr = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    
    NSLog(@"Sync Push HTTP Response Code: %d", [urlResponse statusCode]);
    NSLog(@"Sync Push HTTP Response  Data: %@", responsestr);
    NSLog(@"NSHTTPURLResponse: %@", urlResponse);
    
    if ( ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300))
    {
        NSLog(@"Successfully connected to server");
        NSError *jsonError;
        id jsonResponse = [NSJSONSerialization JSONObjectWithData:[responsestr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonError];
        NSLog(@"Sync Push JSON Data: %@", jsonResponse);
        NSDictionary *responseDictionary = (NSDictionary *)jsonResponse;
        if (responseDictionary){
            id msgStatus = [[responseDictionary objectForKey:@"message"] objectForKey:@"status"];
            if ([msgStatus isEqualToString:@"success"]){
                return TRUE;
            }else{
                return FALSE;
            }
        }else{
            return FALSE;
        }
        
        NSString *status = [jsonResponse valueForKey:@"message"] ;
        if (!jsonError && [status isEqualToString:@"success"]) {
            NSLog(@"Successfully pushed records to the server");
            return TRUE;
        } else {
            NSLog(@"%@", [jsonError description]);
            return FALSE;
        }
    }
    else
    {
        NSLog(@"Something went wrong at the server. Failed to push data. Response code: %ld", (long)[urlResponse statusCode]);
        return FALSE;
        
    }
    
    return FALSE;
    
}

+ (int)synchronizeImagesWithServer {
    
    BOOL syncPushStatus = [self pushPendingImagesToServer];
    
    BOOL syncPullStatus = [self pullImagesFromServer];
    
    if (syncPushStatus && syncPullStatus){
        NSLog(@"Successfully synchronized images");
        return 0;
    } else {
        NSLog(@"Failed to synchronize images");
    }
    return 1;
}

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
        NSDictionary *itemDict =  [managedObj toDictionary]; //[assp toDictionary];
        [entityObjArray addObject:itemDict];
        
    }
    [data setObject:entityObjArray forKey:@"Image"];
    
    
    // create a JSON string from your NSDictionary
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
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
    
    NSLog(@"Sync pull request body json data: %@", data);
    
    
    NSHTTPURLResponse* urlResponse = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSLog(@"Sync Image Pull HTTP Response Code: %d", [urlResponse statusCode]);
    NSString *responsestr = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    NSLog(@"Sync Image Pull Response: %@", responsestr);
    NSLog(@"NSHTTPURLResponse: %@", urlResponse);
    
    if ( ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300))
    {
        
        NSString *responsestr = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        NSLog(@"Successfully downloaded sync pull json");
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
                NSLog(@"%@", [jsonError description]);
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
        
        if (![self saveAllImages:imgName img:imgData syncStatus:SYNC_STATUS_OK]){
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

+ (void)parseResponse:(id)responseObject {
    //NSLog(@"Response object: %@", responseObject);
    NSDictionary *responseDictionary = (NSDictionary *)responseObject;
    if (responseDictionary) {
        
        NSArray *assignProjectArray = [responseDictionary objectForKey:@"assign_project"];
        if (assignProjectArray) {
            for (NSDictionary *assignProject in assignProjectArray) {
                [self parseAssignProject:assignProject];
            }
        }
        NSArray *complianceFormArray = [responseDictionary objectForKey:@"complianceForm"];
        if (complianceFormArray) {
            for (NSDictionary *complianceForm in complianceFormArray) {
                [self parseComplianceForm:complianceForm];
            }
        }
        NSArray *dailyInspectionFormArray = [responseDictionary objectForKey:@"dailyInspectionForm"];
        if (dailyInspectionFormArray) {
            for (NSDictionary *dailyInspectionForm in dailyInspectionFormArray) {
                [self parsedailyInspectionForm:dailyInspectionForm];
            }
        }
        
        NSArray *dailyInspection_itemArray = [responseDictionary objectForKey:@"dailyInspection_item"];
        
        if (dailyInspection_itemArray) {
            for (NSDictionary *dailyInspection_item in dailyInspection_itemArray) {
                [self parseDailyInspectionItem:dailyInspection_item];
            }
        }
        
        NSArray *expensedataArray = [responseDictionary objectForKey:@"expensedata"];
        
        if (expensedataArray) {
            
            for (NSDictionary *expensedata in expensedataArray) {
                [self parseexpensedata:expensedata];
            }
        }
        
        NSArray *expenseReportArray = [responseDictionary objectForKey:@"expenseReport"];
        
        if (expenseReportArray) {
            for (NSDictionary *expenseReport in expenseReportArray) {
                [self parseExpenseReport:expenseReport];
            }
        }
        
        NSArray *nonComplianceFormArray = [responseDictionary objectForKey:@"nonComplianceForm"];
        
        if (nonComplianceFormArray) {
            for (NSDictionary *nonComplianceForm in nonComplianceFormArray) {
                [self parsenonComplianceForm:nonComplianceForm];
            }
        }
        
        NSArray *projectsArray = [responseDictionary objectForKey:@"projects"];
        
        if (projectsArray) {
            for (NSDictionary *projects in projectsArray) {
                [self parseProjects:projects];
            }
        }
        
        NSArray *quantitySummaryDetailsTypeArray = [responseDictionary objectForKey:@"quantity_summary_details"];
        
        if (quantitySummaryDetailsTypeArray) {
            for (NSDictionary *quantitySummaryDetailsType in quantitySummaryDetailsTypeArray) {
                [self parseQuantitySummaryDetailsType:quantitySummaryDetailsType];
            }
        }
        
        NSArray *quantitySummaryItemsArray = [responseDictionary objectForKey:@"quantity_summary_items"];
        
        if (quantitySummaryItemsArray) {
            for (NSDictionary *quantitySummaryItems in quantitySummaryItemsArray) {
                [self parseQuantitySummaryItems:quantitySummaryItems];
            }
        }
        
        NSArray *summarySheet1Array = [responseDictionary objectForKey:@"summarySheet1"];
        
        if (summarySheet1Array) {
            for (NSDictionary *summarySheet1 in summarySheet1Array) {
                [self parseSummarySheet1:summarySheet1];
            }
        }
        
        NSArray *summarySheet2Array = [responseDictionary objectForKey:@"summarySheet2"];
        
        if (summarySheet2Array) {
            for (NSDictionary *summarySheet2 in summarySheet2Array) {
                [self parseSummarySheet2:summarySheet2];
            }
        }
        
        NSArray *summarySheet3Array = [responseDictionary objectForKey:@"summarySheet3"];
        
        if (summarySheet3Array) {
            for (NSDictionary *summarySheet3 in summarySheet3Array) {
                [self parseSummarySheet3:summarySheet3];
            }
        }
        
        NSArray *usersArray = [responseDictionary objectForKey:@"users"];
        
        if (usersArray) {
            for (NSDictionary *users in usersArray) {
                [self parseUsers:users];
            }
        }
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:ROOT_RELOAD_NOTIFICATION object:self];
}

+ (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

+ (void)parseAssignProject:(id)payload {
    
    if ([payload objectForKey:@"id"]) {
        
        Assign_project *assp;
        
        NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
        
        NSError *retrieveError;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Assign_project"
                                                  inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
        [fetchRequest setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(projectid = %@ AND username = %@)",
                                  [payload objectForKey:@"projectid"], [payload objectForKey:@"username"] ];
        [fetchRequest setPredicate:predicate];
        
        NSArray *fetchedObjects = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&retrieveError];
        
        if (fetchedObjects && [fetchedObjects count] > 0) {
            assp = [fetchedObjects objectAtIndex:0];
        }
        
        if (!assp) {
            assp = [NSEntityDescription
                    insertNewObjectForEntityForName:@"Assign_project"
                    inManagedObjectContext:managedContext];
        }
        
        [assp setId:[NSNumber numberWithInt:[[payload objectForKey:@"id"] intValue]]];
        [assp setUsername:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"username"]]];
        [assp setProjectid:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"projectid"]]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        if ([payload objectForKey:@"assign_date"]) {
            [assp setAssign_date:[dateFormatter dateFromString:[payload objectForKey:@"assign_date"]]];
        }
        
        NSError *saveError;
        if (![managedContext save:&saveError]) {
            NSLog(@"Whoops, couldn't save: %@", [saveError localizedDescription]);
        }
    }
}

+ (void)parseComplianceForm:(id)payload {
    
    if ([payload objectForKey:@"ComplianceNoticeNo"]) {
        
        ComplianceForm *assp;
        
        NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
        
        NSError *retrieveError;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"ComplianceForm"
                                                  inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
        [fetchRequest setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(complianceNoticeNo = %@)", [payload objectForKey:@"ComplianceNoticeNo"]];
        [fetchRequest setPredicate:predicate];
        
        NSArray *fetchedObjects = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&retrieveError];
        
        if (fetchedObjects && [fetchedObjects count] > 0) {
            assp = [fetchedObjects objectAtIndex:0];
        }
        
        if (!assp) {
            assp = [NSEntityDescription
                    insertNewObjectForEntityForName:@"ComplianceForm"
                    inManagedObjectContext:managedContext];
        }
        
        [assp setContractNo:[NSNumber numberWithInt:[[payload objectForKey:@"ContractNo"] intValue]]];
        [assp setComHeader:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"comHeader"]]];
        [assp setComplianceNoticeNo:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"ComplianceNoticeNo"]]];
        [assp setProjectDescription:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"ProjectDescription"]]];
        [assp setTitle:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Title"]]];
        [assp setProject:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Project"]]];
        [assp setProject_id:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Project_id"]]];
        [assp setContractorResponsible:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"ContractorResponsible"]]];
        [assp setTo:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"To"]]];
        [assp setUserID:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"UserID"]]];
        [assp setCorrectiveActionCompliance:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"CorrectiveActionCompliance"]]];
        [assp setSignature:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Signature"]]];
        [assp setPrintedName:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"PrintedName"]]];
        [assp setImages_uploaded:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"images_uploaded"]]];
        [assp setSketch_images:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"sketch_images"]]];
        [assp setImages_1:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"images_1"]]];
        [assp setImages_1_desc:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"images_1_desc"]]];
        [assp setImages_2:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"images_2"]]];
        [assp setImages_2_desc:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"images_2_desc"]]];
        [assp setImages_3:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"images_3"]]];
        [assp setImages_3_desc:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"images_3_desc"]]];
        
        NSNumber* syncStatusNum = [NSNumber numberWithInt:SYNC_STATUS_OK];
        [assp setValue:syncStatusNum forKey:@"syncStatus"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        if ([payload objectForKey:@"DateIssued"]) {
            [assp setDateIssued:[dateFormatter dateFromString:[payload objectForKey:@"DateIssued"]]];
        }
        
        if ([payload objectForKey:@"DateContractorStarted"]) {
            [assp setDateContractorStarted:[dateFormatter dateFromString:[payload objectForKey:@"DateContractorStarted"]]];
        }
        
        if ([payload objectForKey:@"DateContractorCompleted"]) {
            [assp setDateContractorCompleted:[dateFormatter dateFromString:[payload objectForKey:@"DateContractorCompleted"]]];
        }
        
        if ([payload objectForKey:@"DateOfDWRReported"]) {
            [assp setDateOfDWRReported:[dateFormatter dateFromString:[payload objectForKey:@"DateOfDWRReported"]]];
        }
        
        if ([payload objectForKey:@"Date"]) {
            [assp setDate:[dateFormatter dateFromString:[payload objectForKey:@"Date"]]];
        }
        
        NSError *saveError;
        if (![managedContext save:&saveError]) {
            NSLog(@"Whoops, couldn't save: %@", [saveError localizedDescription]);
        }
    }
}

+ (void)parsedailyInspectionForm:(id)payload {
    
    if ([payload objectForKey:@"id"]) {
        
        DailyInspectionForm *assp;
        
        NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
        
        NSError *retrieveError;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"DailyInspectionForm"
                                                  inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
        [fetchRequest setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(inspectionID = %@)", [payload objectForKey:@"inspectionID"]];
        [fetchRequest setPredicate:predicate];
        
        NSArray *fetchedObjects = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&retrieveError];
        
        if (fetchedObjects && [fetchedObjects count] > 0) {
            assp = [fetchedObjects objectAtIndex:0];
        }
        
        if (!assp) {
            assp = [NSEntityDescription
                    insertNewObjectForEntityForName:@"DailyInspectionForm"
                    inManagedObjectContext:managedContext];
        }
        
        [assp setId:[NSNumber numberWithInt:[[payload objectForKey:@"id"] intValue]]];
        [assp setReport_No:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"report_No"]]];
        [assp setDIFHeader:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"DIFHeader"]]];
        [assp setContractor:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Contractor"]]];
        [assp setCon_Name:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"con_Name"]]];
        [assp setProject:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Project"]]];
        [assp setProject_id:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Project_id"]]];
        [assp setWeather:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"weather"]]];
        [assp setTime:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"time"]]];
        [assp setInspectionID:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"inspectionID"]]];
        [assp setP_o_Box:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"P_O_Box"]]];
        [assp setCity:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"City"]]];
        [assp setState:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"State"]]];
        [assp setImages_uploaded:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"images_uploaded"]]];
        [assp setSketch_images:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"sketch_images"]]];
        [assp setZip_Code:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Zip_Code"]]];
        [assp setTelephone_No:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Telephone_No"]]];
        [assp setCompetentPerson:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"CompetentPerson"]]];
        [assp setTown_city:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Town_City"]]];
        [assp setE_Mail:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"E_Mail"]]];
        [assp setWorkDoneBy:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"WorkDoneBy"]]];
        [assp setOVJName1:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"OVJName1"]]];
        [assp setOVJName2:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"OVJName2"]]];
        [assp setOVJName3:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"OVJName3"]]];
        [assp setOVJName4:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"OVJName4"]]];
        [assp setOVJTitle1:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"OVJTitle1"]]];
        [assp setOVJTitle2:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"OVJTitle2"]]];
        [assp setOVJTitle3:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"OVJTitle3"]]];
        [assp setOVJTitle4:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"OVJTitle4"]]];
        [assp setIFName1:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"IFName1"]]];
        [assp setIFName2:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"IFName2"]]];
        [assp setIFName3:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"IFName3"]]];
        [assp setIFName4:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"IFName4"]]];
        [assp setIFTitle1:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"IFTitle1"]]];
        [assp setIFTitle2:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"IFTitle2"]]];
        [assp setIFTitle3:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"IFTitle3"]]];
        [assp setIFTitle4:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"IFTitle4"]]];
        [assp setWDODepartmentOrCompany1:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"WDODepartmentOrCompany1"]]];
        [assp setWDODepartmentOrCompany2:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"WDODepartmentOrCompany2"]]];
        [assp setWDODepartmentOrCompany3:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"WDODepartmentOrCompany3"]]];
        [assp setWDODepartmentOrCompany4:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"WDODepartmentOrCompany4"]]];
        [assp setWDODescriptionOfWork1:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"WDODescriptionOfWork1"]]];
        [assp setWDODescriptionOfWork2:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"WDODescriptionOfWork2"]]];
        [assp setWDODescriptionOfWork3:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"WDODescriptionOfWork3"]]];
        [assp setWDODescriptionOfWork4:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"WDODescriptionOfWork4"]]];
        //[assp setContractorsHoursOfWork:[NSNumber numberWithInt:[[payload objectForKey:@"ContractorsHoursOfWork"] intValue]]];
        [assp setContractorsHoursOfWork:[payload objectForKey:@"ContractorsHoursOfWork"]];
        
        [assp setInspectorSign:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"InspectorSign"]]];
        [assp setPrintedName:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"printedName"]]];
        [assp setOriginal_Calendar_Days:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"original_Calendar_Days"]]];
        [assp setCalendar_Days_Used:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"calendar_Days_Used"]]];
        [assp setI_No1:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"I_No1"]]];
        [assp setI_No2:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"I_No2"]]];
        [assp setI_No3:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"I_No3"]]];
        [assp setI_No4:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"I_No4"]]];
        [assp setI_No5:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"I_No5"]]];
        [assp setI_Desc1:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"I_Desc1"]]];
        [assp setI_Desc2:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"I_Desc2"]]];
        [assp setI_Desc3:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"I_Desc3"]]];
        [assp setI_Desc4:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"I_Desc4"]]];
        [assp setI_Desc5:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"I_Desc5"]]];
        [assp setI_QTY1:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"I_QTY1"]]];
        [assp setI_QTY2:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"I_QTY2"]]];
        [assp setI_QTY3:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"I_QTY3"]]];
        [assp setI_QTY4:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"I_QTY4"]]];
        [assp setI_QTY5:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"I_QTY5"]]];
        
        NSNumber* syncStatusNum = [NSNumber numberWithInt:SYNC_STATUS_OK];
        [assp setValue:syncStatusNum forKey:@"syncStatus"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        
        if ([payload objectForKey:@"Date"]) {
            [assp setDate:[dateFormatter dateFromString:[payload objectForKey:@"Date"]]];
        }
        
        NSError *saveError;
        if (![managedContext save:&saveError]) {
            NSLog(@"Whoops, couldn't save: %@", [saveError localizedDescription]);
        }
    }
}

+ (void)parseDailyInspectionItem:(id)payload {
    
    if ([payload objectForKey:@"id"]) {
        
        DailyInspectionItem *assp;
        
        NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
        
        NSError *retrieveError;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"DailyInspectionItem"
                                                  inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
        [fetchRequest setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(inspectionID = %@ AND no = %@)",
                                  [payload objectForKey:@"inspectionID"], [payload objectForKey:@"No"]];
        [fetchRequest setPredicate:predicate];
        
        NSArray *fetchedObjects = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&retrieveError];
        
        if (fetchedObjects && [fetchedObjects count] > 0) {
            assp = [fetchedObjects objectAtIndex:0];
        }
        
        if (!assp) {
            assp = [NSEntityDescription
                    insertNewObjectForEntityForName:@"DailyInspectionItem"
                    inManagedObjectContext:managedContext];
        }
        
        [assp setId:[NSNumber numberWithInt:[[payload objectForKey:@"id"] intValue]]];
        [assp setInspectionID:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"inspectionID"]]];
        [assp setNo:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"No"]]];
        [assp setDesc:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Description"]]];
        [assp setQty:[NSNumber numberWithInt:[[payload objectForKey:@"Qty"] intValue]]];
        
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        if ([payload objectForKey:@"date"]) {
            [assp setDate:[dateFormatter dateFromString:[payload objectForKey:@"date"]]];
        }
        
        NSError *saveError;
        if (![managedContext save:&saveError]) {
            NSLog(@"Whoops, couldn't save: %@", [saveError localizedDescription]);
        }
    }
}

+ (void)parseexpensedata:(id)payload {
    
    if ([payload objectForKey:@"id"]) {
        
        Expensedata *assp;
        
        NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
        
        NSError *retrieveError;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Expensedata"
                                                  inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
        [fetchRequest setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(eXReportNo = %s AND eRJobNo1 = %s)",
                                  [[payload objectForKey:@"EXReportNo"] intValue], [[payload objectForKey:@"ERJobNo1"] intValue]];
        [fetchRequest setPredicate:predicate];
        
        NSArray *fetchedObjects = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&retrieveError];
        
        if (fetchedObjects && [fetchedObjects count] > 0) {
            assp = [fetchedObjects objectAtIndex:0];
        }
        
        if (!assp) {
            assp = [NSEntityDescription
                    insertNewObjectForEntityForName:@"Expensedata"
                    inManagedObjectContext:managedContext];
        }
        
        [assp setId:[NSNumber numberWithInt:[[payload objectForKey:@"id"] intValue]]];
        [assp setEXReportNo:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"EXReportNo"]]];
        [assp setERDescription1:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"ERDescription1"]]];
        [assp setERJobNo1:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"ERJobNo1"]]];
        [assp setERType1:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"ERType1"]]];
        [assp setImages_uploaded:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"images_uploaded"]]];
        [assp setERPAMilage1:[NSNumber numberWithInt:[[payload objectForKey:@"ERPAMilage1"] intValue]]];
        [assp setERPARate1:[NSNumber numberWithInt:[[payload objectForKey:@"ERPARate1"] intValue]]];
        [assp setERTotal1:[NSNumber numberWithInt:[[payload objectForKey:@"ERTotal1"] intValue]]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        if ([payload objectForKey:@"ERDate1"]) {
            [assp setERDate1:[dateFormatter dateFromString:[payload objectForKey:@"ERDate1"]]];
        }
        
        NSError *saveError;
        if (![managedContext save:&saveError]) {
            NSLog(@"Whoops, couldn't save: %@", [saveError localizedDescription]);
        }
    }
}

+ (void)parseExpenseReport:(id)payload {
    
    if ([payload objectForKey:@"id"]) {
        
        ExpenseReportModel *assp;
        
        NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
        
        NSError *retrieveError;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"ExpenseReportModel"
                                                  inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
        [fetchRequest setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(eXReportNo = %@)", [[payload objectForKey:@"EXReportNo"] intValue]];
        [fetchRequest setPredicate:predicate];
        
        NSArray *fetchedObjects = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&retrieveError];
        
        if (fetchedObjects && [fetchedObjects count] > 0) {
            assp = [fetchedObjects objectAtIndex:0];
        }
        
        if (!assp) {
            assp = [NSEntityDescription
                    insertNewObjectForEntityForName:@"ExpenseReportModel"
                    inManagedObjectContext:managedContext];
        }
        
        [assp setId:[NSNumber numberWithInt:[[payload objectForKey:@"id"] intValue]]];
        [assp setEXReportNo:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"EXReportNo"]]];
        [assp setProject_id:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Project_id"]]];
        [assp setERFHeader:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"ERFHeader"]]];
        [assp setEMPName:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"EMPName"]]];
        [assp setImages_uploaded:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"images_uploaded"]]];
        [assp setERCashAdvance:[NSNumber numberWithInt:[[payload objectForKey:@"ERCashAdvance"] intValue]]];
        [assp setERReimbursement:[NSNumber numberWithInt:[[payload objectForKey:@"ERReimbursement"] intValue]]];
        [assp setERReimbursement:[NSNumber numberWithInt:[[payload objectForKey:@"ERReimbursement"] intValue]]];
        [assp setSignature:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Signature"]]];
        [assp setEmployeeNo:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"EmployeeNo"]]];
        [assp setApprovedBy:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"ApprovedBy"]]];
        [assp setAttachment:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Attachment"]]];
        [assp setCheckNo:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"CheckNo"]]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        if ([payload objectForKey:@"WeekEnding"]) {
            [assp setWeekEnding:[dateFormatter dateFromString:[payload objectForKey:@"WeekEnding"]]];
        }
        
        if ([payload objectForKey:@"Date"]) {
            [assp setDate:[dateFormatter dateFromString:[payload objectForKey:@"Date"]]];
        }
        
        
        NSError *saveError;
        if (![managedContext save:&saveError]) {
            NSLog(@"Whoops, couldn't save: %@", [saveError localizedDescription]);
        }
    }
}

+ (void)parsenonComplianceForm:(id)payload {
    
    if ([payload objectForKey:@"id"]) {
        
        NonComplianceForm *assp;
        
        NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
        
        NSError *retrieveError;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"NonComplianceForm"
                                                  inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
        [fetchRequest setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(non_ComplianceNoticeNo = %@)", [payload objectForKey:@"Non_ComplianceNoticeNo"]];
        [fetchRequest setPredicate:predicate];
        
        NSArray *fetchedObjects = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&retrieveError];
        
        if (fetchedObjects && [fetchedObjects count] > 0) {
            assp = [fetchedObjects objectAtIndex:0];
        }
        
        if (!assp) {
            assp = [NSEntityDescription
                    insertNewObjectForEntityForName:@"NonComplianceForm"
                    inManagedObjectContext:managedContext];
        }
        
        [assp setId:[NSNumber numberWithInt:[[payload objectForKey:@"id"] intValue]]];
        [assp setNon_ComHeader:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Non_ComHeader"]]];
        [assp setContractNo:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"ContractNo"]]];
        [assp setNon_ComplianceNoticeNo:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Non_ComplianceNoticeNo"]]];
        [assp setProjectDescription:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"ProjectDescription"]]];
        [assp setImages_uploaded:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"images_uploaded"]]];
        [assp setTitle:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Title"]]];
        [assp setProject:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Project"]]];
        [assp setProject_id:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Project_id"]]];
        [assp setContractorResponsible:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"ContractorResponsible"]]];
        [assp setTo:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"To"]]];
        [assp setUserID:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"UserID"]]];
        [assp setDescriptionOfNonCompliance:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"DescriptionOfNonCompliance"]]];
        [assp setSignature:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Signature"]]];
        [assp setPrintedName:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"PrintedName"]]];
        [assp setSketch_images:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"sketch_images"]]];
        
        NSNumber* syncStatusNum = [NSNumber numberWithInt:SYNC_STATUS_OK];
        [assp setValue:syncStatusNum forKey:@"syncStatus"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        if ([payload objectForKey:@"DateIssued"]) {
            [assp setDateIssued:[dateFormatter dateFromString:[payload objectForKey:@"DateIssued"]]];
        }
        
        if ([payload objectForKey:@"DateCRTCB"]) {
            [assp setDateCRTCB:[dateFormatter dateFromString:[payload objectForKey:@"DateCRTCB"]]];
        }
        
        if ([payload objectForKey:@"DateContractorStarted"]) {
            [assp setDateContractorStarted:[dateFormatter dateFromString:[payload objectForKey:@"DateContractorStarted"]]];
        }
        
        if ([payload objectForKey:@"DateContractorCompleted"]) {
            [assp setDateContractorCompleted:[dateFormatter dateFromString:[payload objectForKey:@"DateContractorCompleted"]]];
        }
        
        if ([payload objectForKey:@"DateOfDWRReported"]) {
            [assp setDateOfDWRReported:[dateFormatter dateFromString:[payload objectForKey:@"DateOfDWRReported"]]];
        }
        
        if ([payload objectForKey:@"Date"]) {
            [assp setDate:[dateFormatter dateFromString:[payload objectForKey:@"Date"]]];
        }
        
        NSError *saveError;
        if (![managedContext save:&saveError]) {
            NSLog(@"Whoops, couldn't save: %@", [saveError localizedDescription]);
        }
    }
}

+ (void)parseProjects:(id)payload {
    //NSLog(@"Project payload: %@", payload);
    
    if ([payload objectForKey:@"id"]) {
        
        Projects *assp;
        
        NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
        
        NSError *retrieveError;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Projects"
                                                  inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
        [fetchRequest setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(projecct_id = %@)", [payload objectForKey:@"projecct_id"] ];
        [fetchRequest setPredicate:predicate];
        
        NSArray *fetchedObjects = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&retrieveError];
        
        if (fetchedObjects && [fetchedObjects count] > 0) {
            assp = [fetchedObjects objectAtIndex:0];
        }
        
        if (!assp) {
            assp = [NSEntityDescription
                    insertNewObjectForEntityForName:@"Projects"
                    inManagedObjectContext:managedContext];
        }
        
        [assp setId:[NSNumber numberWithInt:[[payload objectForKey:@"id"] intValue]]];
        [assp setProjecct_id:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"projecct_id"]]];
        [assp setContract_no:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"contract_no"]]];
        [assp setP_name:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"p_name"]]];
        [assp setP_description:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"p_description"]]];
        [assp setP_title:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"p_title"]]];
        [assp setAddress:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Address"]]];
        [assp setStreet:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"street"]]];
        [assp setCity:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"city"]]];
        [assp setState:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"state"]]];
        [assp setZip:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"zip"]]];
        [assp setPhone:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"phone"]]];
        [assp setClient_name:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"client_name"]]];
        [assp setProject_manager:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"project_manager"]]];
        [assp setInspecter:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"inspecter"]]];
        [assp setP_latitude:[NSNumber numberWithDouble:[[payload objectForKey:@"p_latitude"] doubleValue]]];
        [assp setP_longitude:[NSNumber numberWithDouble:[[payload objectForKey:@"p_longitude"] doubleValue]]];
        [assp setStatus:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"status"]]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDateFormatter *dateFormatterTime = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd  HH:mm:ss"];
        
        if ([payload objectForKey:@"p_date"]) {
            [assp setP_date:[dateFormatterTime dateFromString:[payload objectForKey:@"p_date"]]];
        }
        
        if ([payload objectForKey:@"created_date"]) {
            [assp setCreated_date:[dateFormatterTime dateFromString:[payload objectForKey:@"DateCRTCB"]]];
        }
        
        NSError *saveError;
        if (![managedContext save:&saveError]) {
            NSLog(@"Whoops, couldn't save: %@", [saveError localizedDescription]);
        }else{
            NSLog(@"Successfully saved Project with id: %@", [assp id]);
        }
    }
}

+ (void)parseQuantitySummaryDetailsType:(id)payload {
    
    if ([payload objectForKey:@"id"]) {
        
        QuantitySummaryDetails *assp;
        
        NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
        
        NSError *retrieveError;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"QuantitySummaryDetails"
                                                  inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
        [fetchRequest setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id = %@)", [payload objectForKey:@"id"]];
        [fetchRequest setPredicate:predicate];
        
        NSArray *fetchedObjects = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&retrieveError];
        
        if (fetchedObjects && [fetchedObjects count] > 0) {
            assp = [fetchedObjects objectAtIndex:0];
        }
        
        if (!assp) {
            assp = [NSEntityDescription
                    insertNewObjectForEntityForName:@"QuantitySummaryDetails"
                    inManagedObjectContext:managedContext];
        }
        
        [assp setId:[NSNumber numberWithInt:[[payload objectForKey:@"id"] intValue]]];
        [assp setProject_id:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"project_id"]]];
        [assp setProject:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"project"]]];
        [assp setItem_no:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"item_no"]]];
        [assp setEst_qty:[NSNumber numberWithInt:[[payload objectForKey:@"est_qty"] intValue]]];
        [assp setUnit:[NSNumber numberWithInt:[[payload objectForKey:@"unit"] intValue]]];
        [assp setUnit_price:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"unit_price"]]];
        [assp setUser:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"user"]]];
        
        NSError *saveError;
        if (![managedContext save:&saveError]) {
            NSLog(@"Whoops, couldn't save: %@", [saveError localizedDescription]);
        }
    }
}

+ (void)parseQuantitySummaryItems:(id)payload {
    
    if ([payload objectForKey:@"item_no"]) {
        
        QuantitySummaryItems *assp;
        
        NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
        
        NSError *retrieveError;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"QuantitySummaryItems"
                                                  inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
        [fetchRequest setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(item_no = %@)", [payload objectForKey:@"item_no"]];
        [fetchRequest setPredicate:predicate];
        
        NSArray *fetchedObjects = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&retrieveError];
        
        if (fetchedObjects && [fetchedObjects count] > 0) {
            assp = [fetchedObjects objectAtIndex:0];
        }
        
        if (!assp) {
            assp = [NSEntityDescription
                    insertNewObjectForEntityForName:@"QuantitySummaryItems"
                    inManagedObjectContext:managedContext];
        }
        
        [assp setItem_no:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"item_no"]]];
        [assp setLocation_station:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"location_station"]]];
        [assp setItem_no:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"item_no"]]];
        [assp setQuantity_sum_details_no:[NSNumber numberWithInt:[[payload objectForKey:@"quantity_sum_details_no"] intValue]]];
        [assp setDaily:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"daily"]]];
        [assp setAccum:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"accum"]]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        if ([payload objectForKey:@"date"]) {
            [assp setDate:[dateFormatter dateFromString:[payload objectForKey:@"date"]]];
        }
        
        NSError *saveError;
        if (![managedContext save:&saveError]) {
            NSLog(@"Whoops, couldn't save: %@", [saveError localizedDescription]);
        }
    }
}

+ (void)parseSummarySheet1:(id)payload {
    
    if ([payload objectForKey:@"id"]) {
        
        SummarySheet1 *assp;
        
        NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
        
        NSError *retrieveError;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"SummarySheet1"
                                                  inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
        [fetchRequest setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(sMSheetNo = %@)", [payload objectForKey:@"SMSheetNo"]];
        [fetchRequest setPredicate:predicate];
        
        NSArray *fetchedObjects = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&retrieveError];
        
        if (fetchedObjects && [fetchedObjects count] > 0) {
            assp = [fetchedObjects objectAtIndex:0];
        }
        
        if (!assp) {
            assp = [NSEntityDescription
                    insertNewObjectForEntityForName:@"SummarySheet1"
                    inManagedObjectContext:managedContext];
        }
        
        [assp setId:[NSNumber numberWithInt:[[payload objectForKey:@"id"] intValue]]];
        [assp setSMSheetNo:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"SMSheetNo"]]];
        [assp setSSHeader:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"SSHeader"]]];
        [assp setContractor:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Contractor"]]];
        [assp setPOBox:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"POBox"]]];
        [assp setZip:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"zip"]]];
        [assp setProject_id:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Project_id"]]];
        [assp setTelephoneNo:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"TelephoneNo"]]];
        [assp setReportNo:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"ReportNo"]]];
        [assp setConPeWork:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"ConPeWork"]]];
        [assp setFederalAidNumber:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"FederalAidNumber"]]];
        [assp setCity:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"City"]]];
        [assp setState:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"State"]]];
        [assp setProjectNo:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"ProjectNo"]]];
        [assp setDescr:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Description"]]];
        [assp setConstructionOrder:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"ConstructionOrder"]]];
        [assp setLAClass1:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"LAClass1"]]];
        [assp setLANo1:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"LANo1"]]];
        [assp setLANo2:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"LANo2"]]];
        [assp setLANo3:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"LANo3"]]];
        [assp setLANo4:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"LANo4"]]];
        [assp setLANo5:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"LANo5"]]];
        [assp setLARate1:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"LARate1"]]];
        [assp setLARate2:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"LARate2"]]];
        [assp setLARate3:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"LARate3"]]];
        [assp setLARate4:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"LARate4"]]];
        [assp setLARate5:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"LARate5"]]];
        [assp setLAAmount1:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"LAAmount1"]]];
        [assp setLAAmount2:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"LAAmount2"]]];
        [assp setLAAmount3:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"LAAmount3"]]];
        [assp setLAAmount4:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"LAAmount4"]]];
        [assp setLAAmount5:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"LAAmount5"]]];
        [assp setLAClass2:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"LAClass2"]]];
        [assp setLAClass3:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"LAClass3"]]];
        [assp setLAClass4:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"LAClass4"]]];
        [assp setLAClass5:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"LAClass5"]]];
        [assp setLATotalHours1:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"LATotalHours1"]]];
        [assp setLATotalHours2:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"LATotalHours2"]]];
        [assp setLATotalHours3:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"LATotalHours3"]]];
        [assp setLATotalHours4:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"LATotalHours4"]]];
        [assp setLATotalHours5:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"LATotalHours5"]]];
        [assp setTotalLabor:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"TotalLabor"]]];
        [assp setHealWelAndPension:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"HealWelAndPension"]]];
        [assp setInsAndTaxesOnItem1:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"InsAndTaxesOnItem1"]]];
        [assp setItemDescount20per:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"itemDescount20per"]]];
        [assp setTotal:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"total"]]];
        [assp setPrintedName:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"printedName"]]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        
        if ([payload objectForKey:@"Date"]) {
            [assp setDate:[dateFormatter dateFromString:[payload objectForKey:@"Date"]]];
        }
        
        NSError *saveError;
        if (![managedContext save:&saveError]) {
            NSLog(@"Whoops, couldn't save: %@", [saveError localizedDescription]);
        }
    }
}

+ (void)parseSummarySheet2:(id)payload {
    
    if ([payload objectForKey:@"SMSSheetNo"]) {
        
        SummarySheet2 *assp;
        
        NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
        
        NSError *retrieveError;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"SummarySheet2"
                                                  inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
        [fetchRequest setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(sMSSheetNo = %@)", [payload objectForKey:@"SMSSheetNo"]];
        [fetchRequest setPredicate:predicate];
        
        NSArray *fetchedObjects = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&retrieveError];
        
        if (fetchedObjects && [fetchedObjects count] > 0) {
            assp = [fetchedObjects objectAtIndex:0];
        }
        
        if (!assp) {
            assp = [NSEntityDescription
                    insertNewObjectForEntityForName:@"SummarySheet2"
                    inManagedObjectContext:managedContext];
        }
        [assp setAdditionalDiscount:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"AdditionalDiscount"]]];
        [assp setLessDiscount:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"LessDiscount"]]];
        
        [assp setMEDescription1:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"MEDescription1"]]];
        [assp setMEDescription2:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"MEDescription2"]]];
        [assp setMEDescription3:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"MEDescription3"]]];
        [assp setMEDescription4:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"MEDescription4"]]];
        [assp setMEDescription5:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"MEDescription5"]]];
        [assp setMEQuantity1:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"MEQuantity1"]]];
        [assp setMEQuantity2:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"MEQuantity2"]]];
        [assp setMEQuantity3:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"MEQuantity3"]]];
        [assp setMEQuantity4:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"MEQuantity4"]]];
        [assp setMEQuantity5:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"MEQuantity5"]]];
        [assp setMEUnitPrice1:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"MEUnitPrice1"]]];
        [assp setMEUnitPrice2:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"MEUnitPrice2"]]];
        [assp setMEUnitPrice3:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"MEUnitPrice3"]]];
        [assp setMEUnitPrice4:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"MEUnitPrice4"]]];
        [assp setMEUnitPrice5:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"MEUnitPrice5"]]];
        [assp setMEAmount1:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"MEAmount1"]]];
        [assp setMEAmount2:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"MEAmount2"]]];
        [assp setMEAmount3:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"MEAmount3"]]];
        [assp setMEAmount4:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"MEAmount4"]]];
        [assp setMEAmount5:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"MEAmount5"]]];
        [assp setProject_id:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Project_id"]]];
        [assp setSMSSheetNo:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"SMSSheetNo"]]];
        [assp setTotal1:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Total1"]]];
        [assp setTotal2:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Total2"]]];
        [assp setTotal3:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Total3"]]];
        
        NSError *saveError;
        if (![managedContext save:&saveError]) {
            NSLog(@"Whoops, couldn't save: %@", [saveError localizedDescription]);
        }
    }
}

+ (void)parseSummarySheet3:(id)payload {
    
    if ([payload objectForKey:@"SMSheetNo"]) {
        
        SummarySheet3 *assp;
        
        NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
        
        NSError *retrieveError;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"SummarySheet3"
                                                  inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
        [fetchRequest setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(sMSheetNo = %@)", [payload objectForKey:@"SMSheetNo"]];
        [fetchRequest setPredicate:predicate];
        
        NSArray *fetchedObjects = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&retrieveError];
        
        if (fetchedObjects && [fetchedObjects count] > 0) {
            assp = [fetchedObjects objectAtIndex:0];
        }
        
        if (!assp) {
            assp = [NSEntityDescription
                    insertNewObjectForEntityForName:@"SummarySheet3"
                    inManagedObjectContext:managedContext];
        }
        
        [assp setSMSheetNo:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"SMSheetNo"]]];
        [assp setProject_id:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Project_id"]]];
        [assp setEQSizeandClass1:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"EQSizeandClass1"]]];
        [assp setEQSizeandClass2:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"EQSizeandClass2"]]];
        [assp setEQSizeandClass3:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"EQSizeandClass3"]]];
        [assp setEQSizeandClass4:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"EQSizeandClass4"]]];
        [assp setEQSizeandClass5:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"EQSizeandClass5"]]];
        [assp setEQIdleActive1:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"EQIdleActive1"]]];
        [assp setEQIdleActive2:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"EQIdleActive2"]]];
        [assp setEQIdleActive3:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"EQIdleActive3"]]];
        [assp setEQIdleActive4:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"EQIdleActive4"]]];
        [assp setEQIdleActive5:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"EQIdleActive5"]]];
        [assp setEQNo1:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"EQNo1"]]];
        [assp setEQNo2:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"EQNo2"]]];
        [assp setEQNo3:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"EQNo3"]]];
        [assp setEQNo4:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"EQNo4"]]];
        [assp setEQNo5:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"EQNo5"]]];
        [assp setEQTotalHours1:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"EQTotalHours1"]]];
        [assp setEQTotalHours2:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"EQTotalHours2"]]];
        [assp setEQTotalHours3:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"EQTotalHours3"]]];
        [assp setEQTotalHours4:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"EQTotalHours4"]]];
        [assp setEQTotalHours5:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"EQTotalHours5"]]];
        [assp setEQRAte1:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"EQRAte1"]]];
        [assp setEQRAte2:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"EQRAte2"]]];
        [assp setEQRAte3:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"EQRAte3"]]];
        [assp setEQRAte4:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"EQRAte4"]]];
        [assp setEQRAte5:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"EQRAte5"]]];
        [assp setEQAmount1:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"EQAmount1"]]];
        [assp setEQAmount2:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"EQAmount2"]]];
        [assp setEQAmount3:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"EQAmount3"]]];
        [assp setEQAmount4:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"EQAmount4"]]];
        [assp setEQAmount5:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"EQAmount5"]]];
        [assp setInspector:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Inspector"]]];
        [assp setSignature1:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Signature1"]]];
        [assp setSignature2:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Signature2"]]];
        [assp setContractorRepresentative:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"ContractorRepresentative"]]];
        [assp setDailyTotal:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"DailyTotal"]]];
        [assp setTotal_to_date:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"total_to_date"]]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        if ([payload objectForKey:@"Date1"]) {
            [assp setDate1:[dateFormatter dateFromString:[payload objectForKey:@"Date1"]]];
        }
        
        if ([payload objectForKey:@"Date2"]) {
            [assp setDate2:[dateFormatter dateFromString:[payload objectForKey:@"Date2"]]];
        }
        
        NSError *saveError;
        if (![managedContext save:&saveError]) {
            NSLog(@"Whoops, couldn't save: %@", [saveError localizedDescription]);
        }
    }
}

+ (void)parseUsers:(id)payload {
    
    if ([payload objectForKey:@"id"]) {
        
        Users *assp;
        
        NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
        
        NSError *retrieveError;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Users"
                                                  inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
        [fetchRequest setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(username = %@)", [payload objectForKey:@"username"]];
        [fetchRequest setPredicate:predicate];
        
        NSArray *fetchedObjects = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&retrieveError];
        
        if (fetchedObjects && [fetchedObjects count] > 0) {
            assp = [fetchedObjects objectAtIndex:0];
        }
        
        if (!assp) {
            assp = [NSEntityDescription
                    insertNewObjectForEntityForName:@"Users"
                    inManagedObjectContext:managedContext];
        }
        
        [assp setId:[NSNumber numberWithInt:[[payload objectForKey:@"id"] intValue]]];
        [assp setUsername:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"username"]]];
        [assp setPassword:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"password"]]];
        [assp setFirstname:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"firstname"]]];
        [assp setLastname:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"lastname"]]];
        [assp setEmail:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"email"]]];
        [assp setUser_type:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"user_type"]]];
        [assp setId_no:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"id_no"]]];
        [assp setActive:[NSNumber numberWithInt:[[payload objectForKey:@"active"] intValue]]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        if ([payload objectForKey:@"created"]) {
            [assp setCreated:[dateFormatter dateFromString:[payload objectForKey:@"created"]]];
        }
        
        NSError *saveError;
        if (![managedContext save:&saveError]) {
            NSLog(@"Whoops, couldn't save: %@", [saveError localizedDescription]);
        }
    }
}

+ (NSString *) getExpenceIdByProjID:(NSString *)projId{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ExpenseReportModel"
                                              inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(project_id=%@)", projId];
    [fetchRequest setPredicate:predicate];
    
    NSArray *speakers = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if (speakers && [speakers count] > 0) {
        return [[speakers objectAtIndex:0] objectForKey:@"eXReportNo"];
    }
    
    return nil;
}


+ (BOOL)saveComplianceForm:(NSString *)username complianceNoticeNo:(NSString *)complianceNoticeNo title:(NSString *)title contractNo:(NSString *)contractNo proDesc:(NSString *)proDesc comTitle:(NSString *)comTitle project:(NSString *)project
                dateIssued:(NSString *)dateIssued conRespon:(NSString *)conRespon to:(NSString *)to dateConStarted:(NSString *)dateConStarted dateConComplteted:(NSString *)dateConCopleted dateRawReport:(NSString *)dateRawReport userId:(NSString *)userId correctiveAction:(NSString *)correctiveAct signature:(NSString *)signature printedName:(NSString *)printedName projId:(NSString *)projId sketchImg:(NSString *)sketchImg images_uploaded:(NSString *)images_uploaded
{
    ComplianceForm *assp;
    NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ComplianceForm"
                                              inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"complianceNoticeNo = %@", complianceNoticeNo];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *existingIDs = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if (error != nil) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
    NSString *newIDD;
    
    if ([existingIDs count] > 0){
        assp = [existingIDs objectAtIndex:0];
        NSLog(@"Updating existing Compliance Report complianceNoticeNo: %@", complianceNoticeNo);
    }else{
        int randNum = 0;
        BOOL hasConflicts = TRUE;
        while (hasConflicts){
            hasConflicts = FALSE;
            randNum = rand() % (100000000) + 100000; //create the random number.
            newIDD = [NSString stringWithFormat:@"%@-%@-CM%d", projId, userId, randNum];
            
            for (NSDictionary *dict in existingIDs) {
                NSString *str = [dict valueForKey:@"complianceNoticeNo"];
                if ([str isEqualToString:newIDD]){
                    hasConflicts = TRUE;
                    break;
                }
            }
        }
        NSLog(@"New Compliance Report complianceNoticeNo: %@", newIDD);
    }
    
    
    
    if (!assp) {
        assp = [NSEntityDescription
                insertNewObjectForEntityForName:@"ComplianceForm"
                inManagedObjectContext:managedContext];
        [assp setValue:newIDD forKey:@"complianceNoticeNo"];
    }
    
    [assp setValue:[NSNumber numberWithInt:[contractNo integerValue]] forKey:@"contractNo"];
    [assp setValue:title forKey:@"comHeader"];
    [assp setValue:proDesc forKey:@"projectDescription"];
    [assp setValue:comTitle forKey:@"title"];
    [assp setValue:project forKey:@"project"];
    [assp setValue:projId forKey:@"project_id"];
    [assp setValue:conRespon forKey:@"contractorResponsible"];
    [assp setValue:to forKey:@"to"];
    [assp setValue:userId forKey:@"userID"];
    [assp setValue:correctiveAct forKey:@"correctiveActionCompliance"];
    [assp setValue:signature forKey:@"signature"];
    [assp setValue:printedName forKey:@"printedName"];
    
    NSDateFormatter *myXMLdateReader = [[NSDateFormatter alloc] init];
    [myXMLdateReader setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateIssued_Date = [myXMLdateReader dateFromString:dateIssued];
    NSDate *dateContractorStarted_Date = [myXMLdateReader dateFromString:dateConStarted];
    NSDate *dateContractorCompleted_Date = [myXMLdateReader dateFromString:dateConCopleted];
    NSDate *dateOfDWRReported_Date = [myXMLdateReader dateFromString:dateRawReport];
    
    [assp setValue:dateIssued_Date forKey:@"dateIssued"];
    [assp setValue:dateContractorStarted_Date forKey:@"dateContractorStarted"];
    [assp setValue:dateContractorCompleted_Date forKey:@"dateContractorCompleted"];
    [assp setValue:dateOfDWRReported_Date forKey:@"dateOfDWRReported"];
    [assp setValue:[NSDate date] forKeyPath:@"date"];
    
    [assp setValue:images_uploaded forKey:@"images_uploaded"];
    [assp setValue:sketchImg forKey:@"sketch_images"];
    
    NSNumber* syncStatusNum = [NSNumber numberWithInt:SYNC_STATUS_PENDING];
    [assp setValue:syncStatusNum forKey:@"syncStatus"];
    
    NSError *saveError;
    if (![managedContext save:&saveError]) {
        NSLog(@"Whoops, couldn't save: %@", [saveError debugDescription ]);
        return FALSE;
    }else{
        return TRUE;
    }
}


+(BOOL)saveNonComplianceForm:(NSString *)username non_ComplianceNoticeNo:(NSString *)non_ComplianceNoticeNo title:(NSString *)title contractNo:(NSString *)contractNo proDesc:(NSString *)proDesc comTitle:(NSString *)comTitle project:(NSString *)project
                  dateIssued:(NSString *)dateIssued conRespon:(NSString *)conRespon to:(NSString *)to dateConStarted:(NSString *)dateConStarted dateConComplteted:(NSString *)dateConCopleted dateRawReport:(NSString *)dateRawReport userId:(NSString *)userId correctiveAction:(NSString *)correctiveAct signature:(NSString *)signature printedName:(NSString *)printedName projId:(NSString *)projId sketchImg:(NSString *)sketchImg images_uploaded:(NSString *)images_uploaded
{
    
    NonComplianceForm *assp;
    NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"NonComplianceForm"
                                              inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"non_ComplianceNoticeNo = %@", non_ComplianceNoticeNo];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *existingIDs = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if (error != nil) {
        NSLog(@"Error: %@", [error debugDescription]);
    }
    
    int randNum = 0;
    NSString *newIDD;
    if ([existingIDs count] > 0){
        assp = [existingIDs objectAtIndex:0];
        NSLog(@"Updating existing Non-Compliance Report non-ComplianceNoticeNo: %@", non_ComplianceNoticeNo);
    }else{
        BOOL hasConflicts = TRUE;
        while (hasConflicts){
            hasConflicts = FALSE;
            randNum = rand() % (100000000) + 100000; //create the random number.
            newIDD = [NSString stringWithFormat:@"%@-%@-CM%d", projId, userId, randNum];
            
            for (NSDictionary *dict in existingIDs) {
                NSString *str = [dict valueForKey:@"non_ComplianceNoticeNo"];
                if ([str isEqualToString:newIDD]){
                    hasConflicts = TRUE;
                    break;
                }
            }
        }
        NSLog(@"New Non-Compliance Report non-ComplianceNoticeNo: %@", newIDD);
    }
    
    if (!assp) {
        assp = [NSEntityDescription
                insertNewObjectForEntityForName:@"NonComplianceForm"
                inManagedObjectContext:managedContext];
        [assp setValue:newIDD forKey:@"non_ComplianceNoticeNo"];
    }
    
    [assp setValue:contractNo forKey:@"contractNo"];
    [assp setValue:title forKey:@"non_ComHeader"];
    [assp setValue:proDesc forKey:@"projectDescription"];
    [assp setValue:comTitle forKey:@"title"];
    [assp setValue:project forKey:@"project"];
    [assp setValue:projId forKey:@"Project_id"];
    [assp setValue:conRespon forKey:@"contractorResponsible"];
    [assp setValue:to forKey:@"to"];
    [assp setValue:userId forKey:@"userID"];
    [assp setValue:correctiveAct forKey:@"descriptionOfNonCompliance"];
    [assp setValue:signature forKey:@"signature"];
    [assp setValue:printedName forKey:@"printedName"];
    
    NSDateFormatter *myXMLdateReader = [[NSDateFormatter alloc] init];
    [myXMLdateReader setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateIssued_Date = [myXMLdateReader dateFromString:dateIssued];
    NSDate *dateContractorStarted_Date = [myXMLdateReader dateFromString:dateConStarted];
    NSDate *dateContractorCompleted_Date = [myXMLdateReader dateFromString:dateConCopleted];
    NSDate *dateOfDWRReported_Date = [myXMLdateReader dateFromString:dateRawReport];
    
    [assp setValue:dateIssued_Date forKey:@"dateIssued"];
    [assp setValue:dateContractorStarted_Date forKey:@"dateContractorStarted"];
    [assp setValue:dateContractorCompleted_Date forKey:@"dateContractorCompleted"];
    [assp setValue:dateOfDWRReported_Date forKey:@"dateOfDWRReported"];
    [assp setValue:[NSDate date] forKeyPath:@"date"];
    
    [assp setValue:images_uploaded forKey:@"images_uploaded"];
    [assp setValue:sketchImg forKey:@"sketch_images"];
    
    NSNumber* syncStatusNum = [NSNumber numberWithInt:SYNC_STATUS_PENDING];
    [assp setValue:syncStatusNum forKey:@"syncStatus"];
    
    NSError *saveError;
    if (![managedContext save:&saveError]) {
        NSLog(@"Whoops, couldn't save: %@", [saveError debugDescription]);
        return FALSE;
    }else{
        return TRUE;
    }
}



+(BOOL) saveDailyInspectionForm:(NSString *)username calendar_Days_Used:(NSString *)calendar_Days_Used city:(NSString *)city competentPerson:(NSString *) competentPerson con_Name:(NSString *) con_Name contractor:(NSString *) contractor contractorsHoursOfWork:(NSNumber *) contractorsHoursOfWork date:(NSString *) date dIFHeader:(NSString *) dIFHeader e_Mail:(NSString *) e_Mail i_Desc1:(NSString *) i_Desc1 i_Desc2:(NSString *) i_Desc2 i_Desc3:(NSString *) i_Desc3 i_Desc4:(NSString *) i_Desc4 i_Desc5:(NSString *) i_Desc5 i_No1:(NSString *) i_No1 i_No2:(NSString *) i_No2 i_No3:(NSString *) i_No3 i_No4:(NSString *) i_No4 i_No5:(NSString *) i_No5 i_QTY1:(NSString *) i_QTY1 i_QTY2:(NSString *) i_QTY2 i_QTY3:(NSString *) i_QTY3 i_QTY4:(NSString *) i_QTY4 i_QTY5:(NSString *) i_QTY5 iFName1:(NSString *) iFName1 iFName2:(NSString *) iFName2 iFName3:(NSString *) iFName3 iFName4:(NSString *) iFName4 iFTitle1:(NSString *) iFTitle1 iFTitle2:(NSString *) iFTitle2 iFTitle3:(NSString *) iFTitle3 iFTitle4:(NSString *) iFTitle4 images_uploaded:(NSString *) images_uploaded inspectionID:(NSString *) inspectionID inspectorSign:(NSString *) inspectorSign signature:(NSString*)signature original_Calendar_Days:(NSString *) original_Calendar_Days oVJName1:(NSString *) oVJName1 oVJName2:(NSString *) oVJName2 oVJName3:(NSString *) oVJName3 oVJName4:(NSString *) oVJName4 oVJTitle1:(NSString *) oVJTitle1 oVJTitle2:(NSString *) oVJTitle2 oVJTitle3:(NSString *) oVJTitle3 oVJTitle4:(NSString *) oVJTitle4 p_o_Box:(NSString *) p_o_Box printedName:(NSString *) printedName project:(NSString *) project project_id:(NSString *) project_id report_No:(NSString *) report_No sketch_images:(NSString *) sketch_images state:(NSString *) state telephone_No:(NSString *) telephone_No time:(NSString *) time town_city:(NSString *) town_city wDODepartmentOrCompany1:(NSString *) wDODepartmentOrCompany1 wDODepartmentOrCompany2:(NSString *) wDODepartmentOrCompany2 wDODepartmentOrCompany3:(NSString *) wDODepartmentOrCompany3 wDODepartmentOrCompany4:(NSString *) wDODepartmentOrCompany4 wDODescriptionOfWork1:(NSString *) wDODescriptionOfWork1 wDODescriptionOfWork2:(NSString *) wDODescriptionOfWork2 wDODescriptionOfWork3:(NSString *) wDODescriptionOfWork3 wDODescriptionOfWork4:(NSString *) wDODescriptionOfWork4 weather:(NSString *)weather workDoneBy:(NSString *) workDoneBy zip_Code:(NSString *) zip_Code{
    
    DailyInspectionForm *assp;
    NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DailyInspectionForm"
                                              inManagedObjectContext:managedContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(inspectionID=%@)", inspectionID];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *existingIDs = [managedContext executeFetchRequest:fetchRequest error:&error];
    
    if (error != nil) {
        NSLog(@"Error: %@", [error debugDescription]);
    }
    
    // inspection record already exists...do not overwrite
    if ([existingIDs count] > 0){
        assp = [existingIDs objectAtIndex:0];
        NSLog(@"Updating existing inspection report with ID: %@", inspectionID);
    }
    
    if (!assp) {
        assp = [NSEntityDescription
                insertNewObjectForEntityForName:@"DailyInspectionForm"
                inManagedObjectContext:managedContext];
        [assp setValue:inspectionID forKey:@"inspectionID"];
        NSLog(@"Creating a new inspection report with ID: %@", inspectionID);
    }
    
    
    [assp setValue:calendar_Days_Used forKey:@"calendar_Days_Used"];
    [assp setValue:city forKey:@"city"];
    [assp setValue:competentPerson forKey:@"competentPerson"];
    [assp setValue:con_Name forKey:@"con_Name"];
    [assp setValue:contractor forKey:@"contractor"];
    [assp setValue:contractorsHoursOfWork forKey:@"contractorsHoursOfWork"];
    [assp setValue:dIFHeader forKey:@"dIFHeader"];
    [assp setValue:project forKey:@"project"];
    [assp setValue:project_id forKey:@"Project_id"];
    [assp setValue:e_Mail forKey:@"e_Mail"];
    
    [assp setValue:i_Desc1 forKey:@"i_Desc1"];
    [assp setValue:i_Desc2 forKey:@"i_Desc2"];
    [assp setValue:i_Desc3 forKey:@"i_Desc3"];
    [assp setValue:i_Desc4 forKey:@"i_Desc4"];
    [assp setValue:i_Desc5 forKey:@"i_Desc5"];
    
    [assp setValue:i_No1 forKey:@"i_No1"];
    [assp setValue:i_No2 forKey:@"i_No2"];
    [assp setValue:i_No3 forKey:@"i_No3"];
    [assp setValue:i_No4 forKey:@"i_No4"];
    [assp setValue:i_No5 forKey:@"i_No5"];
    
    [assp setValue:i_QTY1 forKey:@"i_QTY1"];
    [assp setValue:i_QTY2 forKey:@"i_QTY2"];
    [assp setValue:i_QTY3 forKey:@"i_QTY3"];
    [assp setValue:i_QTY4 forKey:@"i_QTY4"];
    [assp setValue:i_QTY5 forKey:@"i_QTY5"];
    
    [assp setValue:iFName1 forKey:@"iFName1"];
    [assp setValue:iFName2 forKey:@"iFName2"];
    [assp setValue:iFName3 forKey:@"iFName3"];
    [assp setValue:iFName4 forKey:@"iFName4"];
    
    [assp setValue:iFTitle1 forKey:@"iFTitle1"];
    [assp setValue:iFTitle2 forKey:@"iFTitle2"];
    [assp setValue:iFTitle3 forKey:@"iFTitle3"];
    [assp setValue:iFTitle4 forKey:@"iFTitle4"];
    
    [assp setValue:inspectorSign forKey:@"inspectorSign"];
    [assp setValue:signature forKey:@"signature"];
    
    [assp setValue:original_Calendar_Days forKey:@"original_Calendar_Days"];
    
    [assp setValue:oVJName1 forKey:@"oVJName1"];
    [assp setValue:oVJName2 forKey:@"oVJName2"];
    [assp setValue:oVJName3 forKey:@"oVJName3"];
    [assp setValue:oVJName4 forKey:@"oVJName4"];
    
    [assp setValue:oVJTitle1 forKey:@"oVJTitle1"];
    [assp setValue:oVJTitle2 forKey:@"oVJTitle2"];
    [assp setValue:oVJTitle3 forKey:@"oVJTitle3"];
    [assp setValue:oVJTitle4 forKey:@"oVJTitle4"];
    
    [assp setValue:p_o_Box forKey:@"p_o_Box"];
    
    [assp setValue:printedName forKey:@"printedName"];
    [assp setValue:report_No forKey:@"report_No"];
    [assp setValue:state forKey:@"state"];
    
    [assp setValue:telephone_No forKey:@"telephone_No"];
    [assp setValue:time forKey:@"time"];
    [assp setValue:town_city forKey:@"town_city"];
    
    [assp setValue:wDODepartmentOrCompany1 forKey:@"wDODepartmentOrCompany1"];
    [assp setValue:wDODepartmentOrCompany2 forKey:@"wDODepartmentOrCompany2"];
    [assp setValue:wDODepartmentOrCompany3 forKey:@"wDODepartmentOrCompany3"];
    [assp setValue:wDODepartmentOrCompany4 forKey:@"wDODepartmentOrCompany4"];
    
    [assp setValue:wDODescriptionOfWork1 forKey:@"wDODescriptionOfWork1"];
    [assp setValue:wDODescriptionOfWork2 forKey:@"wDODescriptionOfWork2"];
    [assp setValue:wDODescriptionOfWork3 forKey:@"wDODescriptionOfWork3"];
    [assp setValue:wDODescriptionOfWork4 forKey:@"wDODescriptionOfWork4"];
    
    
    [assp setValue:weather forKey:@"weather"];
    [assp setValue:workDoneBy forKey:@"workDoneBy"];
    [assp setValue:zip_Code forKey:@"zip_Code"];
    
    NSDateFormatter *myXMLdateReader = [[NSDateFormatter alloc] init];
    [myXMLdateReader setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateType = [myXMLdateReader dateFromString:date];
    [assp setValue:dateType forKey:@"date"];
    
    [assp setValue:images_uploaded forKey:@"images_uploaded"];
    [assp setValue:sketch_images forKey:@"sketch_images"];
    
    NSNumber* syncStatusNum = [NSNumber numberWithInt:SYNC_STATUS_PENDING];
    [assp setValue:syncStatusNum forKey:@"syncStatus"];
    
    
    // delete existing inspection items for this inspection ID
    NSEntityDescription *dailyInspectionItemEntity = [NSEntityDescription entityForName:@"DailyInspectionItem"
                                                                 inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
    [fetchRequest setEntity:dailyInspectionItemEntity];
    NSPredicate *dailyInspectionItemsPredicate = [NSPredicate predicateWithFormat:@"(inspectionID=%@)", inspectionID];
    [fetchRequest setPredicate:dailyInspectionItemsPredicate];
    existingIDs = [managedContext executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *obj in existingIDs){
        [managedContext deleteObject:obj];
    }
    
    if (error != nil) {
        NSLog(@"Error: %@", [error debugDescription]);
    }
    
    // save daily inspection items
    BOOL *saveItems = TRUE;
    
    if ( ![@"" isEqualToString:i_No1] &&  ![PRIMECMController saveDailyInspectionItem:username date:date desc:i_Desc1 inspectionID:inspectionID no:i_No1 qty:i_QTY1]){
        saveItems = FALSE;
    }
    
    if (![@"" isEqualToString:i_No2] &&   ![PRIMECMController saveDailyInspectionItem:username date:date desc:i_Desc2 inspectionID:inspectionID no:i_No2 qty:i_QTY2]){
        saveItems = FALSE;
    }
    
    if (![@"" isEqualToString:i_No3] &&   ![PRIMECMController saveDailyInspectionItem:username date:date desc:i_Desc3 inspectionID:inspectionID no:i_No3 qty:i_QTY3]){
        saveItems = FALSE;
    }
    
    if (![@"" isEqualToString:i_No4] &&   ![PRIMECMController saveDailyInspectionItem:username date:date desc:i_Desc4 inspectionID:inspectionID no:i_No4 qty:i_QTY4]){
        saveItems = FALSE;
    }
    
    if (![@"" isEqualToString:i_No5] &&   ![PRIMECMController saveDailyInspectionItem:username date:date desc:i_Desc5 inspectionID:inspectionID no:i_No5 qty:i_QTY5]){
        saveItems = FALSE;
    }
    
    NSError *saveError;
    if (![managedContext save:&saveError] || !saveItems) {
        NSLog(@"Whoops, couldn't save: %@", [saveError debugDescription]);
        return FALSE;
    }else{
        return TRUE;
    }
}


+ (BOOL)saveDailyInspectionItem:(NSString *)username date:(NSString *)date desc:(NSString *) desc inspectionID:(NSString *) inspectionID no:(NSString *) no qty:(NSString *) qty{
    
    DailyInspectionItem *assp;
    NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DailyInspectionItem"
                                              inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    // NSArray *existingIDs = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if (error != nil) {
        NSLog(@"Error: %@", [error debugDescription]);
    }
    
    if (!assp) {
        assp = [NSEntityDescription
                insertNewObjectForEntityForName:@"DailyInspectionItem"
                inManagedObjectContext:managedContext];
    }
    
    [assp setValue:inspectionID forKey:@"inspectionID"];
    
    [assp setValue:no forKey:@"no"];
    [assp setValue:[NSNumber numberWithInt:[qty intValue]] forKey:@"qty"];
    [assp setValue:desc forKey:@"desc"];
    
    NSDateFormatter *myXMLdateReader = [[NSDateFormatter alloc] init];
    [myXMLdateReader setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateType = [myXMLdateReader dateFromString:date];
    [assp setValue:dateType forKey:@"date"];
    
    
    NSError *saveError;
    if (![managedContext save:&saveError]) {
        NSLog(@"Whoops, couldn't save: %@", [saveError debugDescription]);
        return FALSE;
    }else{
        return TRUE;
    }
}


+(NSArray *)getDailyInspectionItemsFromInspectionID:(NSString *)inspectionID
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DailyInspectionItem"
                                              inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    [fetchRequest setResultType:NSDictionaryResultType];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(inspectionID=%@)", inspectionID];
    [fetchRequest setPredicate:predicate];
    
    
    NSError *error = nil;
    NSArray *itemsForInspection = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if (error != nil) {
        NSLog(@"Error: %@", [error debugDescription]);
    }
    
    return itemsForInspection;
}

+(BOOL)saveQuantitySummaryDetails:(NSString *)username est_qty:(NSString *)est_qty item_no:(NSString *) item_no project:(NSString *) project project_id:(NSString *) project_id unit:(NSString *) unit unit_price:(NSString *) unit_price user:(NSString *) user idStr:(NSString *)idStr isEdit:(BOOL)isEdit
{
    QuantitySummaryDetails *assp;
    NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"QuantitySummaryDetails"
                                              inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"item_no == %@",item_no];
    [fetchRequest setPredicate:predicate];
    
    //[fetchRequest setResultType:NSDictionaryResultType];
    //[fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:@"item_no"]];
    NSError *error = nil;
    NSArray *existingIDs = [managedContext executeFetchRequest:fetchRequest error:&error];
    NSLog(@"Before saving ids are %@",existingIDs);
    if (error != nil) {
        NSLog(@"Error: %@", [error debugDescription]);
    }
    
    if(isEdit)
    {
        if([existingIDs count]>0)
        {
            assp = [existingIDs firstObject];
        }
    }
    if (!assp) {
        assp = [NSEntityDescription
                insertNewObjectForEntityForName:@"QuantitySummaryDetails"
                inManagedObjectContext:managedContext];
    }
    if(idStr)
        [assp setValue:[NSNumber numberWithInt:[idStr intValue]] forKey:@"id"];
    else
    {
        //New Record
        fetchRequest = [[NSFetchRequest alloc] init];
        entity = [NSEntityDescription entityForName:@"QuantitySummaryDetails"
                             inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
        // [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:@"id"]];
        [fetchRequest setEntity:entity];
        existingIDs = [managedContext executeFetchRequest:fetchRequest error:&error];
        NSLog(@"existingIDs are %@",existingIDs);
        
        
        int randNum = 0;
        NSString *newIDD;
        BOOL hasConflicts = TRUE;
        while (hasConflicts){
            hasConflicts = FALSE;
            randNum = rand() % (100000000) + 100000; //create the random number.
            //newIDD = [NSString stringWithFormat:@"%d",randNum];
            
            for (NSDictionary *dict in existingIDs) {
                int value = [[dict valueForKey:@"id"] intValue];
                if (value == randNum){
                    hasConflicts = TRUE;
                    break;
                }
            }
        }
        NSLog(@"New Expense Report eXReportNo: %@", newIDD);
        [assp setValue:[NSNumber numberWithInt:randNum]  forKey:@"id"];
    }
    
    
    [assp setValue:item_no forKey:@"item_no"];
    [assp setValue:[NSNumber numberWithInt:[est_qty intValue]] forKey:@"est_qty"];
    [assp setValue:project forKey:@"project"];
    [assp setValue:project_id forKey:@"project_id"];
    //Radha
    [assp setValue:[NSNumber numberWithInt:[unit intValue]] forKey:@"unit"];
    [assp setValue:unit_price forKey:@"unit_price"];
    [assp setValue:username forKey:@"user"];
    
    NSError *saveError;
    if (![managedContext save:&saveError]) {
        NSLog(@"Whoops, couldn't save: %@", [saveError debugDescription]);
        return FALSE;
    }else{
        return TRUE;
    }
}


+ (BOOL)saveQuantitySummaryItems:(NSString *)username accum:(NSString *) accum daily:(NSString *) daily date:(NSString *) date item_no:(NSString *) item_no location_station:(NSString *) location_station quantity_sum_details_no:(NSString *) quantity_sum_details_no{
    
    QuantitySummaryItems *assp;
    NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"QuantitySummaryItems"
                                              inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:@"item_no"]];
    NSError *error = nil;
    //NSArray *existingIDs = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if (error != nil) {
        NSLog(@"Error: %@", [error debugDescription]);
    }
    
    if (!assp) {
        assp = [NSEntityDescription
                insertNewObjectForEntityForName:@"QuantitySummaryItems"
                inManagedObjectContext:managedContext];
    }
    
    [assp setValue:item_no forKey:@"item_no"];
    
    [assp setValue:accum forKey:@"accum"];
    [assp setValue:daily forKey:@"daily"];
    
    NSDateFormatter *myXMLdateReader = [[NSDateFormatter alloc] init];
    [myXMLdateReader setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateType = [myXMLdateReader dateFromString:date];
    [assp setValue:dateType forKey:@"date"];
    
    [assp setValue:location_station forKey:@"location_station"];
    [assp setValue:quantity_sum_details_no forKey:@"quantity_sum_details_no"];
    
    NSError *saveError;
    if (![managedContext save:&saveError]) {
        NSLog(@"Whoops, couldn't save: %@", [saveError debugDescription]);
        return FALSE;
    }else{
        return TRUE;
    }
    
}

+ (BOOL)saveExpenseForm:(NSString *)username approvedBy:(NSString *)approvedBy attachment:(NSString *)attachment checkNo:(NSString *)checkNo date:(NSString *)date employeeNo:(NSString *)employeeNo eMPName:(NSString *)eMPName eRCashAdvance:(NSString *)eRCashAdvance eRFHeader:(NSString *)eRFHeader eRReimbursement:(NSString *)eRReimbursement eXReportNo:(NSString *)eXReportNo images_uploaded:(NSString *)images_uploaded project_id:(NSString *)project_id signature:(NSString *)signature weekEnding:(NSString *)weekEnding isEdit:(BOOL)isEdit {
    ExpenseReportModel *assp;
    NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ExpenseReportModel"
                                              inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    // [fetchRequest setResultType:NSDictionaryResultType];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eXReportNo == %@ AND project_id == %@", eXReportNo,project_id];
    
    [fetchRequest setPredicate:predicate];
    //   [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:@"eXReportNo"]];
    NSError *error = nil;
    NSArray *existingIDs = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&error];
    NSLog(@"existingIDs are %@",existingIDs);
    if (error != nil) {
        NSLog(@"Error: %@", [error debugDescription]);
    }
    if(isEdit)
    {
        NSLog(@"Edited ");
        if([existingIDs count]>0)
        {
            assp =[existingIDs firstObject];
        }
    }
    if (!assp) {
        assp = [NSEntityDescription
                insertNewObjectForEntityForName:@"ExpenseReportModel"
                inManagedObjectContext:managedContext];
        [assp setValue:eXReportNo forKey:@"eXReportNo"];
    }
    
    
    [assp setValue:approvedBy forKey:@"approvedBy"];
    [assp setValue:attachment forKey:@"attachment"];
    [assp setValue:checkNo forKey:@"checkNo"];
    
    
    NSDateFormatter *myXMLdateReader = [[NSDateFormatter alloc] init];
    [myXMLdateReader setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateType = [myXMLdateReader dateFromString:date];
    if (!dateType) {
        dateType = [NSDate date];
    }
    [assp setValue:dateType forKey:@"date"];
    
    NSDate *weekEndingdateType = [myXMLdateReader dateFromString:weekEnding];
    [assp setValue:weekEndingdateType forKey:@"weekEnding"];
    [assp setValue:employeeNo forKey:@"employeeNo"];
    
    [assp setValue:eMPName forKey:@"eMPName"];
    
    NSNumber *eRCashAdvanceNum = [NSNumber numberWithInt:[eRCashAdvance intValue]];
    [assp setValue:eRCashAdvanceNum forKey:@"eRCashAdvance"];
    
    [assp setValue:eRFHeader forKey:@"eRFHeader"];
    
    NSNumber *eRReimbursementNum = [NSNumber numberWithInt:[eRReimbursement intValue]];
    [assp setValue:eRReimbursementNum forKey:@"eRReimbursement"];
    
    [assp setValue:images_uploaded forKey:@"images_uploaded"];
    [assp setValue:project_id forKey:@"project_id"];
    [assp setValue:signature forKey:@"signature"];
    
    
    NSError *saveError;
    if (![managedContext save:&saveError]) {
        NSLog(@"Whoops, couldn't save: %@", [saveError debugDescription]);
        return FALSE;
    }else{
        return TRUE;
    }
}


+ (BOOL)saveExpenseData:(NSString *)username eRDate1:(NSString *)eRDate1 eRDescription1:(NSString *)eRDescription1 eRJobNo1:(NSString *)eRJobNo1 eRPAMilage1:(NSString *)eRPAMilage1 eRPARate1:(NSString *)eRPARate1 eRTotal1:(NSString *)eRTotal1 eRType1:(NSString *)eRType1 eXReportNo:(NSString *)eXReportNo images_uploaded:(NSString *)images_uploaded   project_id:(NSString *)project_id imgPath:(NSString *)imgPath {
    
    
    Expensedata *assp;
    NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Expensedata"
                                              inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    [fetchRequest setResultType:NSDictionaryResultType];
    //[fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:@"eXReportNo"]];
    NSError *error = nil;
    NSArray *existingIDs = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&error];
    NSLog(@"existingIDs are %@",existingIDs);
    if (error != nil) {
        NSLog(@"Error: %@", [error debugDescription]);
    }
    if (!assp) {
        assp = [NSEntityDescription
                insertNewObjectForEntityForName:@"Expensedata"
                inManagedObjectContext:managedContext];
    }
    
    //Radha
    if(imgPath)
    {
        //save the Image in Core Data
        NSData *imgData = [NSData dataWithContentsOfFile:imgPath];
        [assp setValue:imgData forKey:@"imageData"];
    }
    
    [assp setValue:eXReportNo forKey:@"eXReportNo"];
    
    [assp setValue:eRDescription1 forKey:@"eRDescription1"];
    [assp setValue:eRJobNo1 forKey:@"eRJobNo1"];
    
    NSDateFormatter *myXMLdateReader = [[NSDateFormatter alloc] init];
    [myXMLdateReader setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateType = [myXMLdateReader dateFromString:eRDate1];
    if (!dateType) {
        dateType = [NSDate date];
    }
    [assp setValue:dateType forKey:@"eRDate1"];
    
    
    NSNumber *eRPAMilage1Num = [NSNumber numberWithInt:[eRPAMilage1 intValue]];
    [assp setValue:eRPAMilage1Num forKey:@"eRPAMilage1"];
    
    NSNumber *eRPARate1Num = [NSNumber numberWithInt:[eRPARate1 intValue]];
    [assp setValue:eRPARate1Num forKey:@"eRPARate1"];
    
    NSNumber *eRTotal1Num = [NSNumber numberWithInt:[eRTotal1 intValue]];
    [assp setValue:eRTotal1Num forKey:@"eRTotal1"];
    
    [assp setValue:eRType1 forKey:@"eRType1"];
    [assp setValue:images_uploaded forKey:@"images_uploaded"];
    
    NSError *saveError;
    if (![managedContext save:&saveError]) {
        NSLog(@"Whoops, couldn't save: %@", [saveError debugDescription]);
        return FALSE;
    }else{
        return TRUE;
    }
    
}

+(BOOL)uploadExpencesImages:(NSString *)username comNotiseNo:(NSString *)RecId imageName:(NSString *)imageName{
    
    Expensedata *assp;
    NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Expensedata"
                                              inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id = %@)", RecId];
    [fetchRequest setPredicate:predicate];
    
    if (!assp) {
        assp = [NSEntityDescription
                insertNewObjectForEntityForName:@"Expensedata"
                inManagedObjectContext:managedContext];
    }
    
    [assp setValue:username forKey:@"username"];
    [assp setValue:imageName forKey:@"images_uploaded"];
    
    NSError *saveError;
    if (![managedContext save:&saveError]) {
        NSLog(@"Whoops, couldn't save: %@", [saveError localizedDescription]);
    }
    return TRUE;
}

+(int)totalObjectsOfSummarySheet
{
    NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SummarySheet1"
                                              inManagedObjectContext:managedContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:@"sMSheetNo"]];
    NSError *error = nil;
    NSArray *existingIDs = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&error];
    NSLog(@"existingIDs are %@",existingIDs);
    if(!existingIDs)
        return 0;
    return [existingIDs count];
}

// summary sheet 1

+ (BOOL)saveSummarySheet1:(NSString *)username city:(NSString *)city conPeWork:(NSString *) conPeWork constructionOrder:(NSString *) constructionOrder contractor:(NSString *) contractor date:(NSString *) date descr:(NSString *) descr federalAidNumber:(NSString *) federalAidNumber healWelAndPension:(NSString *) healWelAndPension insAndTaxesOnItem1:(NSString *) insAndTaxesOnItem1 itemDescount20per:(NSString *) itemDescount20per lAAmount1:(NSString *) lAAmount1 lAAmount2:(NSString *) lAAmount2 lAAmount3:(NSString *) lAAmount3 lAAmount4:(NSString *) lAAmount4 lAAmount5:(NSString *) lAAmount5 lAClass1:(NSString *) lAClass1 lAClass2:(NSString *) lAClass2 lAClass3:(NSString *) lAClass3 lAClass4:(NSString *) lAClass4 lAClass5:(NSString *) lAClass5 lANo1:(NSString *) lANo1 lANo2:(NSString *) lANo2 lANo3:(NSString *) lANo3 lANo4:(NSString *) lANo4 lANo5:(NSString *) lANo5 lARate1:(NSString *) lARate1 lARate2:(NSString *) lARate2 lARate3:(NSString *) lARate3 lARate4:(NSString *) lARate4 lARate5:(NSString *) lARate5 lATotalHours1:(NSString *) lATotalHours1 lATotalHours2:(NSString *) lATotalHours2 lATotalHours3:(NSString *) lATotalHours3 lATotalHours4:(NSString *) lATotalHours4 lATotalHours5:(NSString *) lATotalHours5 pOBox:(NSString *) pOBox printedName:(NSString *) printedName project_id:(NSString *) project_id projectNo:(NSString *) projectNo reportNo:(NSString *) reportNo sMSheetNo:(NSString *) sMSheetNo sSHeader:(NSString *) sSHeader state:(NSString *) state telephoneNo:(NSString *) telephoneNo total:(NSString *) total totalLabor:(NSString *) totalLabor zip:(NSString *) zip
{
    SummarySheet1 *assp;
    NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SummarySheet1"
                                              inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    // [fetchRequest setResultType:NSDictionaryResultType];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sMSheetNo == %@ AND project_id == %@",sMSheetNo,contractor];
    [fetchRequest setPredicate:predicate];
    //[fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:@"sMSheetNo"]];
    NSError *error = nil;
    NSArray *existingIDs = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if (error != nil) {
        NSLog(@"Error: %@", [error debugDescription]);
    }
    else
    {
        NSLog(@"Existing Ids %@",existingIDs);
    }
    
    if ([existingIDs count] > 0)
        assp = [existingIDs objectAtIndex:0];
    
    if (!assp) {
        assp = [NSEntityDescription
                insertNewObjectForEntityForName:@"SummarySheet1"
                inManagedObjectContext:managedContext];
    }
    
    [assp setValue:sMSheetNo forKey:@"sMSheetNo"];
    [assp setValue:city forKey:@"city"];
    [assp setValue:conPeWork forKey:@"conPeWork"];
    [assp setValue:constructionOrder forKey:@"constructionOrder"];
    [assp setValue:contractor forKey:@"contractor"];
    
    NSDateFormatter *myXMLdateReader = [[NSDateFormatter alloc] init];
    [myXMLdateReader setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateType = [myXMLdateReader dateFromString:date];
    
    if(dateType)
        [assp setValue:dateType forKey:@"date"];
    else
        [assp setValue:[NSDate date] forKey:@"date"];
    
    
    [assp setValue:descr forKey:@"descr"];
    
    
    [assp setValue:federalAidNumber forKey:@"federalAidNumber"];
    [assp setValue:healWelAndPension forKey:@"healWelAndPension"];
    [assp setValue:insAndTaxesOnItem1 forKey:@"insAndTaxesOnItem1"];
    [assp setValue:itemDescount20per forKey:@"itemDescount20per"];
    [assp setValue:lAAmount1 forKey:@"lAAmount1"];
    [assp setValue:lAAmount2 forKey:@"lAAmount2"];
    [assp setValue:lAAmount3 forKey:@"lAAmount3"];
    [assp setValue:lAAmount4 forKey:@"lAAmount4"];
    [assp setValue:lAAmount5 forKey:@"lAAmount5"];
    
    [assp setValue:lAClass1 forKey:@"lAClass1"];
    [assp setValue:lAClass2 forKey:@"lAClass2"];
    [assp setValue:lAClass3 forKey:@"lAClass3"];
    [assp setValue:lAClass4 forKey:@"lAClass4"];
    [assp setValue:lAClass5 forKey:@"lAClass5"];
    
    [assp setValue:lANo1 forKey:@"lANo1"];
    [assp setValue:lANo2 forKey:@"lANo2"];
    [assp setValue:lANo3 forKey:@"lANo3"];
    [assp setValue:lANo4 forKey:@"lANo4"];
    [assp setValue:lANo5 forKey:@"lANo5"];
    
    [assp setValue:lARate1 forKey:@"lARate1"];
    [assp setValue:lARate2 forKey:@"lARate2"];
    [assp setValue:lARate3 forKey:@"lARate3"];
    [assp setValue:lARate4 forKey:@"lARate4"];
    [assp setValue:lARate5 forKey:@"lARate5"];
    
    [assp setValue:lATotalHours1 forKey:@"lATotalHours1"];
    [assp setValue:lATotalHours2 forKey:@"lATotalHours2"];
    [assp setValue:lATotalHours3 forKey:@"lATotalHours3"];
    [assp setValue:lATotalHours4 forKey:@"lATotalHours4"];
    [assp setValue:lATotalHours5 forKey:@"lATotalHours5"];
    
    
    [assp setValue:pOBox forKey:@"pOBox"];
    [assp setValue:printedName forKey:@"printedName"];
    [assp setValue:project_id forKey:@"project_id"];
    [assp setValue:projectNo forKey:@"projectNo"];
    [assp setValue:reportNo forKey:@"reportNo"];
    [assp setValue:sSHeader forKey:@"sSHeader"];
    [assp setValue:telephoneNo forKey:@"telephoneNo"];
    [assp setValue:total forKey:@"total"];
    [assp setValue:totalLabor forKey:@"totalLabor"];
    [assp setValue:zip forKey:@"zip"];
    [assp setValue:state forKey:@"state"];
    
    NSLog(@"Added Record is %@",assp);
    
    NSError *saveError;
    if (![managedContext save:&saveError]) {
        NSLog(@"Whoops, couldn't save: %@", [saveError debugDescription]);
        return FALSE;
    }else{
        
        
        
        NSLog(@"saved summary1: %@", assp);
        
        return TRUE;
    }
    
}


//Summary2

+(BOOL)saveSummery2:(NSString *)username additionalDiscount:(NSString *) additionalDiscount lessDiscount:(NSString *) lessDiscount mEAmount1:(NSString *) mEAmount1 mEAmount2:(NSString *) mEAmount2 mEAmount3:(NSString *) mEAmount3 mEAmount4:(NSString *) mEAmount4 mEAmount5:(NSString *) mEAmount5 mEDescription1:(NSString *) mEDescription1 mEDescription2:(NSString *) mEDescription2 mEDescription3:(NSString *) mEDescription3 mEDescription4:(NSString *) mEDescription4 mEDescription5:(NSString *) mEDescription5 mEQuantity1:(NSString *) mEQuantity1 mEQuantity2:(NSString *) mEQuantity2 mEQuantity3:(NSString *) mEQuantity3 mEQuantity4:(NSString *) mEQuantity4 mEQuantity5:(NSString *) mEQuantity5 mEUnitPrice1:(NSString *) mEUnitPrice1 mEUnitPrice2:(NSString *) mEUnitPrice2 mEUnitPrice3:(NSString *) mEUnitPrice3 mEUnitPrice4:(NSString *) mEUnitPrice4 mEUnitPrice5:(NSString *) mEUnitPrice5 project_id:(NSString *) project_id sMSSheetNo:(NSString *) sMSSheetNo total1:(NSString *) total1 total2:(NSString *) total2 total3:(NSString *) total3
{
    
    SummarySheet2*assp;
    NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SummarySheet2"
                                              inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sMSSheetNo == %@",sMSSheetNo];
    [fetchRequest setPredicate:predicate];
    
    //  [fetchRequest setResultType:NSDictionaryResultType];
    //[fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:@"sMSSheetNo"]];
    NSError *error = nil;
    NSArray *existingIDs = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&error];
    NSLog(@"smsheet2 values are %@",existingIDs);
    
    if ([existingIDs count] > 0){
        assp = [existingIDs firstObject];
        // return FALSE;
    }
    
    
    if (error != nil) {
        NSLog(@"Error: %@", [error debugDescription]);
    }
    NSLog(@"New Summary Sheet 2 Report sMSheetNo: %@", sMSSheetNo);
    
    if (!assp) {
        assp = [NSEntityDescription
                insertNewObjectForEntityForName:@"SummarySheet2"
                inManagedObjectContext:managedContext];
    }
    
    
    [assp setValue:additionalDiscount forKey:@"additionalDiscount"];
    [assp setValue:lessDiscount forKey:@"lessDiscount"];
    [assp setValue:mEAmount1 forKey:@"mEAmount1"];
    [assp setValue:mEAmount2 forKey:@"mEAmount2"];
    [assp setValue:mEAmount3 forKey:@"mEAmount3"];
    [assp setValue:mEAmount4 forKey:@"mEAmount4"];
    [assp setValue:mEAmount5 forKey:@"mEAmount5"];
    [assp setValue:mEDescription1 forKey:@"mEDescription1"];
    [assp setValue:mEDescription2 forKey:@"mEDescription2"];
    [assp setValue:mEDescription3 forKey:@"mEDescription3"];
    [assp setValue:mEDescription4 forKey:@"mEDescription4"];
    [assp setValue:mEDescription5 forKey:@"mEDescription5"];
    [assp setValue:mEQuantity1 forKey:@"mEQuantity1"];
    [assp setValue:mEQuantity2 forKey:@"mEQuantity2"];
    [assp setValue:mEQuantity3 forKey:@"mEQuantity3"];
    [assp setValue:mEQuantity4 forKey:@"mEQuantity4"];
    [assp setValue:mEQuantity5 forKey:@"mEQuantity5"];
    [assp setValue:mEUnitPrice1 forKey:@"mEUnitPrice1"];
    [assp setValue:mEUnitPrice2 forKey:@"mEUnitPrice2"];
    [assp setValue:mEUnitPrice3 forKey:@"mEUnitPrice3"];
    [assp setValue:mEUnitPrice4 forKey:@"mEUnitPrice4"];
    [assp setValue:mEUnitPrice5 forKey:@"mEUnitPrice5"];
    [assp setValue:project_id forKey:@"project_id"];
    [assp setValue:sMSSheetNo forKey:@"sMSSheetNo"];
    [assp setValue:total1 forKey:@"total1"];
    [assp setValue:total2 forKey:@"total2"];
    [assp setValue:total3 forKey:@"total3"];
    
    NSLog(@"Summary 2 saved Data is %@",assp);
    NSError *saveError;
    if (![managedContext save:&saveError]) {
        NSLog(@"Whoops, couldn't save: %@", [saveError localizedDescription]);
        return FALSE;
    }else{
        NSLog(@"saved summary2: %@", assp);
        return TRUE;
    }
}



//Summery3
+ (BOOL)saveSummery3:(NSString *)username contractorRepresentative:(NSString *) contractorRepresentative dailyTotal:(NSString *) dailyTotal date1:(NSString *) date1 date2:(NSString *) date2 eQAmount1:(NSString *) eQAmount1 eQAmount2:(NSString *) eQAmount2 eQAmount3:(NSString *) eQAmount3 eQAmount4:(NSString *) eQAmount4 eQAmount5:(NSString *) eQAmount5 eQIdleActive1:(NSString *) eQIdleActive1 eQIdleActive2:(NSString *) eQIdleActive2 eQIdleActive3:(NSString *) eQIdleActive3 eQIdleActive4:(NSString *) eQIdleActive4 eQIdleActive5:(NSString *) eQIdleActive5 eQNo1:(NSString *) eQNo1 eQNo2:(NSString *) eQNo2 eQNo3:(NSString *) eQNo3 eQNo4:(NSString *) eQNo4 eQNo5:(NSString *) eQNo5 eQRAte1:(NSString *) eQRAte1 eQRAte2:(NSString *) eQRAte2 eQRAte3:(NSString *) eQRAte3 eQRAte4:(NSString *) eQRAte4 eQRAte5:(NSString *) eQRAte5 eQSizeandClass1:(NSString *) eQSizeandClass1 eQSizeandClass2:(NSString *) eQSizeandClass2 eQSizeandClass3:(NSString *) eQSizeandClass3 eQSizeandClass4:(NSString *) eQSizeandClass4 eQSizeandClass5:(NSString *) eQSizeandClass5 eQTotalHours1:(NSString *) eQTotalHours1 eQTotalHours2:(NSString *) eQTotalHours2 eQTotalHours3:(NSString *) eQTotalHours3 eQTotalHours4:(NSString *) eQTotalHours4 eQTotalHours5:(NSString *) eQTotalHours5 inspector:(NSString *) inspector project_id:(NSString *) project_id signature1:(NSString *) signature1 signature2:(NSString *) signature2 sMSheetNo:(NSString *) sMSheetNo total_to_date:(NSString *) total_to_date
{
    
    SummarySheet3*assp;
    NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SummarySheet3"
                                              inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sMSheetNo == %@",sMSheetNo];
    [fetchRequest setPredicate:predicate];
    
    
    // [fetchRequest setResultType:NSDictionaryResultType];
    //[fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:@"sMSheetNo"]];
    NSError *error = nil;
    NSArray *existingIDs = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&error];
    NSLog(@"Existing ids are %@",existingIDs);
    
    
    if ([existingIDs count] > 0){
        assp = [existingIDs firstObject];
        // return FALSE;
    }
    
    
    if (error != nil) {
        NSLog(@"Error: %@", [error debugDescription]);
    }
    
    NSLog(@"New Summary Sheet 2 Report sMSheetNo: %@", sMSheetNo);
    
    
    if (!assp) {
        assp = [NSEntityDescription
                insertNewObjectForEntityForName:@"SummarySheet3"
                inManagedObjectContext:managedContext];
    }
    
    [assp setValue:sMSheetNo forKey:@"sMSheetNo"];
    [assp setValue:project_id forKey:@"project_id"];
    [assp setValue:eQSizeandClass1 forKey:@"eQSizeandClass1"];
    [assp setValue:eQSizeandClass2 forKey:@"eQSizeandClass2"];
    [assp setValue:eQSizeandClass3 forKey:@"eQSizeandClass3"];
    [assp setValue:eQSizeandClass4 forKey:@"eQSizeandClass4"];
    [assp setValue:eQSizeandClass5 forKey:@"eQSizeandClass5"];
    
    [assp setValue:eQIdleActive1 forKey:@"eQIdleActive1"];
    [assp setValue:eQIdleActive2 forKey:@"eQIdleActive2"];
    [assp setValue:eQIdleActive3 forKey:@"eQIdleActive3"];
    [assp setValue:eQIdleActive4 forKey:@"eQIdleActive4"];
    [assp setValue:eQIdleActive5 forKey:@"eQIdleActive5"];
    
    
    [assp setValue:eQAmount1 forKey:@"eQAmount1"];
    [assp setValue:eQAmount2 forKey:@"eQAmount2"];
    [assp setValue:eQAmount3 forKey:@"eQAmount3"];
    [assp setValue:eQAmount4 forKey:@"eQAmount4"];
    [assp setValue:eQAmount5 forKey:@"eQAmount5"];
    
    
    [assp setValue:eQNo1 forKey:@"eQNo1"];
    [assp setValue:eQNo2 forKey:@"eQNo2"];
    [assp setValue:eQNo3 forKey:@"eQNo3"];
    [assp setValue:eQNo4 forKey:@"eQNo4"];
    [assp setValue:eQNo5 forKey:@"eQNo5"];
    [assp setValue:eQTotalHours1 forKey:@"eQTotalHours1"];
    [assp setValue:eQTotalHours2 forKey:@"eQTotalHours2"];
    [assp setValue:eQTotalHours3 forKey:@"eQTotalHours3"];
    [assp setValue:eQTotalHours4 forKey:@"eQTotalHours4"];
    [assp setValue:eQTotalHours5 forKey:@"eQTotalHours5"];
    [assp setValue:eQRAte1 forKey:@"eQRAte1"];
    [assp setValue:eQRAte2 forKey:@"eQRAte2"];
    [assp setValue:eQRAte3 forKey:@"eQRAte3"];
    [assp setValue:eQRAte4 forKey:@"eQRAte4"];
    [assp setValue:eQRAte4 forKey:@"eQRAte5"];
    
    [assp setValue:eQTotalHours1 forKey:@"eQTotalHours1"];
    [assp setValue:eQTotalHours2 forKey:@"eQTotalHours2"];
    [assp setValue:eQTotalHours3 forKey:@"eQTotalHours3"];
    [assp setValue:eQTotalHours4 forKey:@"eQTotalHours4"];
    [assp setValue:eQTotalHours5 forKey:@"eQTotalHours5"];
    [assp setValue:inspector forKey:@"inspector"];
    [assp setValue:signature1 forKey:@"signature1"];
    [assp setValue:signature2 forKey:@"signature2"];
    
    [assp setValue:contractorRepresentative forKey:@"contractorRepresentative"];
    [assp setValue:project_id forKey:@"project_id"];
    
    NSDateFormatter *myXMLdateReader = [[NSDateFormatter alloc] init];
    [myXMLdateReader setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date1Type = [myXMLdateReader dateFromString:date1];
    [assp setValue:date1Type forKey:@"date1"];
    
    NSDate *date2Type = [myXMLdateReader dateFromString:date2];
    [assp setValue:date2Type forKey:@"date2"];
    
    
    
    [assp setValue:dailyTotal forKey:@"dailyTotal"];
    [assp setValue:total_to_date forKey:@"total_to_date"];
    
    
    
    NSLog(@"Summary 3 saved Data is %@",assp);
    NSError *saveError;
    if (![managedContext save:&saveError]) {
        NSLog(@"Whoops, couldn't save: %@", [saveError localizedDescription]);
        return FALSE;
    }else{
        
        
        NSLog(@"saved summary3: %@", assp);
        
        return TRUE;
    }
}

+(BOOL) saveAssignProject:(NSString *)username inspectors:(NSString *)inspectors projId:(NSString *)projId date:(NSDate *)date
{
    Assign_project *assp;
    NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Assign_project"
                                              inManagedObjectContext:managedContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"projectid = %@", projId];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *existingIDs = [managedContext executeFetchRequest:fetchRequest error:&error];
    
    
    for(Assign_project *assp in existingIDs){
        [managedContext deleteObject:assp];
    }
    
    
    if (error != nil) {
        NSLog(@"Error: %@", [error debugDescription]);
    }
    
    assp = [NSEntityDescription
            insertNewObjectForEntityForName:@"Assign_project"
            inManagedObjectContext:managedContext];
    
    NSArray *inspectorArr = [inspectors componentsSeparatedByString:@","];
    
    for (NSString *inspectorObj in inspectorArr){
        [assp setValue:projId forKey:@"projectid"];
        [assp setValue:inspectorObj forKey:@"username"];
        [assp setValue:date forKey:@"assign_date"];
        NSError *saveError;
        if (![managedContext save:&saveError]) {
            NSLog(@"Whoops, couldn't save: %@", [saveError debugDescription]);
            return FALSE;
        }
    }
    
    NSLog(@"saved assign_project: %@", assp);
    return TRUE;
}

+ (BOOL)saveProject:(NSString *)username projId:(NSString *)projId phone:(NSString *)phone projName:(NSString *)projName projDesc:(NSString *)projDesc title:(NSString *)title street:(NSString *)street city:(NSString *)city state:(NSString *)state zip:(NSString *)zip date:(NSString *)date clientName:(NSString *)clientName projMgr:(NSString *)projMgr latitude:(NSString *)latitude longitude:(NSString *)longitude inspector:(NSString *)inspector
{
    
    Projects *assp;
    
    NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Projects"
                                              inManagedObjectContext:managedContext];
    [fetchRequest setEntity:entity];
    NSPredicate *project_predicate = [NSPredicate predicateWithFormat:@"projecct_id = %@", projId];
    [fetchRequest setPredicate:project_predicate];
    
    NSError *error = nil;
    NSArray *existingIDs = [managedContext executeFetchRequest:fetchRequest error:&error];
    
    if ([existingIDs count] > 0){
        assp = [existingIDs objectAtIndex:0];
        NSLog(@"Updating project with projID: %@", projId);
    }
    
    if (error != nil) {
        NSLog(@"Error: %@", [error debugDescription]);
    }
    
    NSNumber *latitudeNum = [NSNumber numberWithDouble:[latitude doubleValue]];
    NSNumber *longitudeNum = [NSNumber numberWithDouble:[longitude doubleValue]];
    NSDateFormatter *myXMLdateReader = [[NSDateFormatter alloc] init];
    [myXMLdateReader setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateIssued_Date = [myXMLdateReader dateFromString:date];
    
    if (assp == NULL) {
        NSLog(@"Creating a new project with projID: %@", projId);
        assp = [NSEntityDescription
                insertNewObjectForEntityForName:@"Projects"
                inManagedObjectContext:managedContext];
        
    }
    
    [assp setValue:projId forKey:@"projecct_id"];
    [assp setValue:projId forKey:@"contract_no"];
    [assp setValue:city forKey:@"city"];
    [assp setValue:clientName forKey:@"client_name"];
    [assp setValue:dateIssued_Date forKey:@"created_date"];
    [assp setValue:inspector forKey:@"inspecter"];
    [assp setValue:dateIssued_Date forKey:@"p_date"];
    [assp setValue:projDesc forKey:@"p_description"];
    [assp setValue:latitudeNum forKey:@"p_latitude"];
    [assp setValue:longitudeNum forKey:@"p_longitude"];
    [assp setValue:projName forKey:@"p_name"];
    [assp setValue:projName forKey:@"p_title"];
    [assp setValue:phone forKey:@"phone"];
    [assp setValue:projMgr forKey:@"project_manager"];
    [assp setValue:state forKey:@"state"];
    [assp setValue:street forKey:@"street"];
    [assp setValue:0 forKey:@"status"];
    [assp setValue:zip forKey:@"zip"];
    
    NSError *saveError;
    
    BOOL projSave = [managedContext save:&saveError];
    BOOL assignProjSave = [PRIMECMController saveAssignProject:username inspectors:inspector projId:projId date:dateIssued_Date];
    
    if (!projSave || !assignProjSave) {
        NSLog(@"Whoops, couldn't save: %@", [saveError debugDescription]);
        return FALSE;
    }else{
        NSLog(@"saved project: %@", assp);
        return TRUE;
    }
}

+ (BOOL) saveAllImages:(NSString *)imgName img:(NSData *)img syncStatus:(int*)syncStatus {
    
    NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Image"
                                              inManagedObjectContext:managedContext];
    [fetchRequest setEntity:entity];
    NSPredicate *project_predicate = [NSPredicate predicateWithFormat:@"imgName = %@", imgName];
    [fetchRequest setPredicate:project_predicate];
    
    NSError *error = nil;
    Image *assp  = nil;
    NSArray *existingIDs = [managedContext executeFetchRequest:fetchRequest error:&error];
    
    if ([existingIDs count] > 0){
        assp = [existingIDs objectAtIndex:0];
    }else{
        assp  = [NSEntityDescription
                 insertNewObjectForEntityForName:@"Image"
                 inManagedObjectContext:managedContext];
        [assp setValue:imgName forKey:@"imgName"];
    }
    
    
    [assp setValue:img forKey:@"img"];
    NSNumber *imgSyncStatus = [NSNumber numberWithInt:syncStatus];
    [assp setValue:imgSyncStatus forKey:@"syncStatus"];
    
    NSError *saveError;
    if (![managedContext save:&saveError]) {
        NSLog(@"Whoops, couldn't save: %@", [saveError debugDescription ]);
        return FALSE;
    }else{
        return TRUE;
    }
    
}

+(NSArray *)getQuantitySummaryDetailsForInspectionID:(NSString *)inspectionId AndItemNum:(NSString *)item_no
{
    //Radha Chnaged Entity name according to Lin
    
    NSError *retrieveError;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DailyInspectionItem"
                                              inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    [fetchRequest setResultType:NSDictionaryResultType];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K == %@) AND (%K == %@)",@"no", item_no, @"inspectionID", inspectionId];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedObjects = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&retrieveError];
    
    NSLog(@"Quantity Table View Data is %@",fetchedObjects);
    return fetchedObjects;
}

+ (UIImage *) getTheImage:(NSString *)imgName{
    
    NSManagedObjectContext *context = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Image" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"imgName= %@", imgName];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    NSLog(@"Object count = %d for image name=%@",[objects count], imgName);
    if([objects count] > 0){
        
        NSManagedObject *complianceReportObject = (NSManagedObject *) [objects objectAtIndex:0];
        return [UIImage imageWithData:[complianceReportObject valueForKey:@"img"]];
    }
    
    return nil;
    
}

@end
