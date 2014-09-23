//
//  DataSyncController.m
//  PRIMECMAPP
//
//  Created by Akila Perera on 9/21/14.
//
//

#import "DataSyncController.h"
#import "PRIMECMAPPUtils.h"
#import "ExtendedManagedObject.h"
#import "Reachability.h"
#import "PRIMECMController.h"

#import "Assign_project.h"
#import "ComplianceForm.h"
#import "DailyInspectionForm.h"
#import "DailyInspectionItem.h"
#import "ExpenseReportModel.h"
#import "NonComplianceForm.h"
#import "Projects.h"
#import "SummarySheet1.h"
#import "SummarySheet2.h"
#import "SummarySheet3.h"
#import "Users.h"
#import "QuantityEstimateForm.h"


@implementation DataSyncController


+(BOOL) pushPendingDataToServer {
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    NSArray *entities = [PRIMECMAPPUtils getEntities];
    NSError *error = [[NSError alloc] init];
    NSManagedObjectContext *context = [PRIMECMAPPUtils getManagedObjectContext];
    
    for (NSString *entityItem in entities){
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:entityItem inManagedObjectContext:context];
        
        [fetchRequest setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(syncStatus = %d)", SYNC_STATUS_PENDING ];
        [fetchRequest setPredicate:predicate];
        
        NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
        NSMutableArray *entityObjArray =[[NSMutableArray alloc] init];
        
        for (ExtendedManagedObject *managedObj in objects){
            NSDictionary *itemDict =  [managedObj toDictionary];
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

+(BOOL) pullDataFromServer {
    
    NSString *url = [NSString stringWithFormat:@"%@", [PRIMECMAPPUtils getAPISyncPullEndpoint]];
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
                
                [DataSyncController parseResponse:jsonResponse];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reload_table_data" object:self];
                NSLog(@"Successfully parsed complete json");
                
                return TRUE;
            }else{
                NSLog(@"Response message status failed: %@", msgStatus);
                return FALSE;
            }
        }else{
            NSLog(@"%@", [jsonError description]);
            return FALSE;
        }
    }
    else
    {
        NSLog(@"Server is not responding. Failed to download complete json. Response code: %ld", (long)[urlResponse statusCode]);
        return FALSE;
    }
}

+ (void)parseResponse:(id)responseObject {
    
    NSDictionary *responseDictionary = (NSDictionary *)responseObject;
    if (responseDictionary) {
        
        NSArray *projectsArray = [responseDictionary objectForKey:@"projects"];
        
        if (projectsArray) {
            for (NSDictionary *projects in projectsArray) {
                [self parseProjects:projects];
            }
        }
        
        
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
        
        
        NSArray *expenseReportArray = [responseDictionary objectForKey:@"expenseReportModel"];
        if (expenseReportArray) {
            for (NSDictionary *expenseReport in expenseReportArray) {
                [self parseExpenseReportModel:expenseReport];
            }
        }
        
        
        NSArray *nonComplianceFormArray = [responseDictionary objectForKey:@"nonComplianceForm"];
        
        if (nonComplianceFormArray) {
            for (NSDictionary *nonComplianceForm in nonComplianceFormArray) {
                [self parsenonComplianceForm:nonComplianceForm];
            }
        }
        
        
        NSArray *quantityEstimateFormArray = [responseDictionary objectForKey:@"quantityEstimateForm"];
        
        if (quantityEstimateFormArray) {
            for (NSDictionary *quantityEstimateForm in quantityEstimateFormArray) {
                [self parseQuantityEstimateForm:quantityEstimateForm];
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

+ (void)parseAssignProject:(id)payload {
    
    if ([payload objectForKey:@"projectid"] && [payload objectForKey:@"username"]) {
        
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
            [assp setComplianceNoticeNo:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"ComplianceNoticeNo"]]];
        }
        
        [assp setContractNo:[NSNumber numberWithInt:[[payload objectForKey:@"ContractNo"] intValue]]];
        [assp setComHeader:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"comHeader"]]];
        [assp setTitle:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Title"]]];
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
        [assp setSyncStatus:syncStatusNum];
        
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
    
    if ([payload objectForKey:@"inspectionID"]) {
        
        DailyInspectionForm *assp;
        NSError *error = nil;
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
            [assp setInspectionID:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"inspectionID"]]];
        }
        
        
        [assp setReport_No:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"report_No"]]];
        [assp setDIFHeader:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"DIFHeader"]]];
        [assp setContractor:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Contractor"]]];
        [assp setCon_Name:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"con_Name"]]];
        [assp setProject_id:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Project_id"]]];
        [assp setWeather:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"weather"]]];
        [assp setTime:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"time"]]];
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
        [assp setSyncStatus:syncStatusNum];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        
        if ([payload objectForKey:@"Date"]) {
            [assp setDate:[dateFormatter dateFromString:[payload objectForKey:@"Date"]]];
        }
        
        
        
        // delete existing inspection items for this inspection ID
        NSEntityDescription *dailyInspectionItemEntity = [NSEntityDescription entityForName:@"DailyInspectionItem"
                                                                     inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
        [fetchRequest setEntity:dailyInspectionItemEntity];
        NSPredicate *dailyInspectionItemsPredicate = [NSPredicate predicateWithFormat:@"(inspectionID=%@)", [payload objectForKey:@"inspectionID"]];
        [fetchRequest setPredicate:dailyInspectionItemsPredicate];
        NSArray *existingIDs = [managedContext executeFetchRequest:fetchRequest error:&error];
        
        for (NSManagedObject *obj in existingIDs){
            [managedContext deleteObject:obj];
        }
        
        if (error != nil) {
            NSLog(@"Error: %@", [error debugDescription]);
        }
        
        NSError *saveError;
        if (![managedContext save:&saveError]) {
            NSLog(@"Whoops, couldn't save: %@", [saveError localizedDescription]);
        }
    }
}

+ (void)parseDailyInspectionItem:(id)payload {
    
    if ([payload objectForKey:@"inspectionID"] && [payload objectForKey:@"No"]) {
        
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
            [assp setInspectionID:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"inspectionID"]]];
            [assp setNo:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"No"]]];
        }
        
        
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


+ (void)parseExpenseReportModel:(id)payload {
    
    if ([payload objectForKey:@"EXReportNo"]) {
        
        ExpenseReportModel *assp;
        
        NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
        
        NSError *retrieveError;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"ExpenseReportModel"
                                                  inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
        [fetchRequest setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(eXReportNo = %@)", [payload objectForKey:@"EXReportNo"]];
        [fetchRequest setPredicate:predicate];
        
        NSArray *fetchedObjects = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&retrieveError];
        
        if (fetchedObjects && [fetchedObjects count] > 0) {
            assp = [fetchedObjects objectAtIndex:0];
        }
        
        if (!assp) {
            assp = [NSEntityDescription
                    insertNewObjectForEntityForName:@"ExpenseReportModel"
                    inManagedObjectContext:managedContext];
            [assp setEXReportNo:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"EXReportNo"]]];
        }
        
        [assp setProject_id:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Project_id"]]];
        [assp setERFHeader:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"ERFHeader"]]];
        [assp setEMPName:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"EMPName"]]];
        [assp setImages_uploaded:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"images_uploaded"]]];
        [assp setERCashAdvance:[NSNumber numberWithInt:[[payload objectForKey:@"ERCashAdvance"] intValue]]];
        [assp setERReimbursement:[NSNumber numberWithInt:[[payload objectForKey:@"ERReimbursement"] intValue]]];
        [assp setSignature:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Signature"]]];
        [assp setApprovedBy:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"ApprovedBy"]]];
        [assp setCheckNo:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"CheckNo"]]];
        [assp setERDescription1:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"ERDescription1"]]];
        [assp setERJobNo1:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"ERJobNo1"]]];
        [assp setERType1:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"ERType1"]]];
        [assp setERPAMilage1:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"ERPAMilage1"]]];
        [assp setERPARate1:[NSNumber numberWithInt:[[payload objectForKey:@"ERPARate1"] intValue]]];
        [assp setERTotal1:[NSNumber numberWithInt:[[payload objectForKey:@"ERTotal1"] intValue]]];
        
        NSNumber* syncStatusNum = [NSNumber numberWithInt:SYNC_STATUS_OK];
        [assp setSyncStatus:syncStatusNum];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        if ([payload objectForKey:@"ERDate1"]) {
            [assp setERDate1:[dateFormatter dateFromString:[payload objectForKey:@"ERDate1"]]];
        }
        
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



+ (void)parseQuantityEstimateForm:(id)payload {
    if ([payload objectForKey:@"qtyEstID"]) {
        
        QuantityEstimateForm *assp;
        
        NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
        
        NSError *retrieveError;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"QuantityEstimateForm"
                                                  inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
        [fetchRequest setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(qtyEstID = %@)", [payload objectForKey:@"qtyEstID"]];
        [fetchRequest setPredicate:predicate];
        
        NSArray *fetchedObjects = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&retrieveError];
        
        if (fetchedObjects && [fetchedObjects count] > 0) {
            assp = [fetchedObjects objectAtIndex:0];
        }
        
        if (!assp) {
            assp = [NSEntityDescription
                    insertNewObjectForEntityForName:@"QuantityEstimateForm"
                    inManagedObjectContext:managedContext];
            [assp setQtyEstID:[payload objectForKey:@"qtyEstID"] ];
        }
        
        
        [assp setEst_qty:[NSNumber numberWithInt:[[payload objectForKey:@"est_Quantity"] intValue]]];
        [assp setItem_no:[payload objectForKey:@"itemNo"] ];
        [assp setProject_id:[payload objectForKey:@"Project_id"] ];
        [assp setUnit:[payload objectForKey:@"unit"] ];
        [assp setUnit_price:[NSNumber numberWithInt:[[payload objectForKey:@"unitPrice"] intValue]]];
        [assp setUser:[payload objectForKey:@"user"] ];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        if ([payload objectForKey:@"date"]) {
            [assp setDate:[dateFormatter dateFromString:[payload objectForKey:@"date"]]];
        }
        
        NSNumber* syncStatusNum = [NSNumber numberWithInt:SYNC_STATUS_OK];
        [assp setSyncStatus:syncStatusNum];
        
        NSError *saveError;
        if (![managedContext save:&saveError]) {
            NSLog(@"Whoops, couldn't save: %@", [saveError localizedDescription]);
        }
    }
}

+ (void)parsenonComplianceForm:(id)payload {
    
    if ([payload objectForKey:@"Non_ComplianceNoticeNo"]) {
        
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
            [assp setNon_ComplianceNoticeNo:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Non_ComplianceNoticeNo"]]];
        }
        
        [assp setNon_ComHeader:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Non_ComHeader"]]];
        [assp setContractNo:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"ContractNo"]]];
        [assp setImages_uploaded:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"images_uploaded"]]];
        [assp setTitle:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Title"]]];
        [assp setProject_id:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Project_id"]]];
        [assp setContractorResponsible:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"ContractorResponsible"]]];
        [assp setTo:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"To"]]];
        [assp setUserID:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"UserID"]]];
        [assp setDescriptionOfNonCompliance:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"DescriptionOfNonCompliance"]]];
        [assp setSignature:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Signature"]]];
        [assp setPrintedName:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"PrintedName"]]];
        [assp setSketch_images:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"sketch_images"]]];
        
        NSNumber* syncStatusNum = [NSNumber numberWithInt:SYNC_STATUS_OK];
        [assp setSyncStatus:syncStatusNum];
        
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
    
    if ([payload objectForKey:@"projecct_id"]) {
        
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
            [assp setProjecct_id:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"projecct_id"]]];
        }
        
        
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
        
        NSNumber* syncStatusNum = [NSNumber numberWithInt:SYNC_STATUS_OK];
        [assp setSyncStatus:syncStatusNum];
        
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
        
        
        // delete existing assign_project records for this project ID
        NSError *error;
        NSEntityDescription *assignProject = [NSEntityDescription entityForName:@"Assign_project"
                                                         inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
        [fetchRequest setEntity:assignProject];
        NSPredicate *assignProjectPredicate = [NSPredicate predicateWithFormat:@"(projectid=%@)", [payload objectForKey:@"projecct_id"]];
        [fetchRequest setPredicate:assignProjectPredicate];
        NSArray *existingIDs = [managedContext executeFetchRequest:fetchRequest error:&error];
        
        for (NSManagedObject *obj in existingIDs){
            [managedContext deleteObject:obj];
        }
        
        if (error != nil) {
            NSLog(@"Error: %@", [error debugDescription]);
        }
        
        
        NSError *saveError;
        if (![managedContext save:&saveError]) {
            NSLog(@"Whoops, couldn't save: %@", [saveError localizedDescription]);
        }else{
            NSLog(@"Successfully saved Project with id: %@", [assp projecct_id]);
        }
    }
}


+ (void)parseSummarySheet1:(id)payload {
    
    if ([payload objectForKey:@"SMSheetNo"]) {
        
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
            [assp setSMSheetNo:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"SMSheetNo"]]];
        }
        
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
        [assp setDescr:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Description"]]];
        [assp setConstructionOrder:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"ConstructionOrder"]]];
        
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
        
        [assp setLAClass1:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"LAClass1"]]];
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
        
        NSNumber* syncStatusNum = [NSNumber numberWithInt:SYNC_STATUS_OK];
        [assp setSyncStatus:syncStatusNum];
        
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
            [assp setSMSSheetNo:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"SMSSheetNo"]]];
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
        [assp setTotal1:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Total1"]]];
        [assp setTotal2:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Total2"]]];
        [assp setTotal3:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Total3"]]];
        
        NSNumber* syncStatusNum = [NSNumber numberWithInt:SYNC_STATUS_OK];
        [assp setSyncStatus:syncStatusNum];
        
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
            [assp setSMSheetNo:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"SMSheetNo"]]];
        }
        
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
        
        NSNumber* syncStatusNum = [NSNumber numberWithInt:SYNC_STATUS_OK];
        [assp setSyncStatus:syncStatusNum];
        
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
    
    if ([payload objectForKey:@"username"]) {
        
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
            [assp setUsername:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"username"]]];
        }
        
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

+ (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

@end
