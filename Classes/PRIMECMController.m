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

+ (int)synchronizeWithServer:(NSString *)url {
    
    if (![self connected]) {
        return 1;
    }
    
    NSURL *endpoint = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL: endpoint];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    BOOL status;
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse* urlResponse = nil;    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSLog(@"Sync Response Code: %d", [urlResponse statusCode]);
    
    if ( !([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300))
    {
        NSLog(@"Server is not responding. Failed to download complete json. Response code: %ld", (long)[urlResponse statusCode]);
        status = 2;
    }
    else
    {
        NSString *responsestr = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        NSLog(@"Successfully downloaded complete json");
        NSError *jsonError;
        id jsonResponse = [NSJSONSerialization JSONObjectWithData:[responsestr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonError];
        
        if (!jsonError) {
            [self parseResponse:jsonResponse];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reload_table_data" object:self];
            NSLog(@"Successfully parsed complete json");
            status = 0;
        } else {
            NSLog(@"%@", [jsonError description]);
            status = 3;
        }
    }
    
    NSLog(@"Sync status code: %hhd", status);
    return status;
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
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id = %d)", [[payload objectForKey:@"id"] intValue]];
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
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id = %d)", [[payload objectForKey:@"id"] intValue]];
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
        [assp setContractorsHoursOfWork:[NSNumber numberWithInt:[[payload objectForKey:@"ContractorsHoursOfWork"] intValue]]];
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
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id = %d)", [[payload objectForKey:@"id"] intValue]];
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
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id = %d)", [[payload objectForKey:@"id"] intValue]];
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
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id = %d)", [[payload objectForKey:@"id"] intValue]];
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
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id = %d)", [[payload objectForKey:@"id"] intValue]];
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
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id = %d)", [[payload objectForKey:@"id"] intValue]];
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
        [assp setP_latitude:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"p_latitude"]]];
        [assp setP_longitude:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"p_longitude"]]];
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
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id = %d)", [[payload objectForKey:@"id"] intValue]];
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
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id = %d)", [[payload objectForKey:@"id"] intValue]];
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
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(sMSSheetNo = %@)", [payload objectForKey:@"id"]];
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
        
        [assp setSMSSheetNo:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"SMSSheetNo"]]];
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
        [assp setTotal1:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Total1"]]];
        [assp setTotal2:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Total2"]]];
        [assp setTotal3:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"Total3"]]];
        [assp setLessDiscount:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"LessDiscount"]]];
        [assp setAdditionalDiscount:[PRIMECMAPPUtils filterValue:[payload objectForKey:@"AdditionalDiscount"]]];
        
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
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(sMSheetNo = %@)", [payload objectForKey:@"id"]];
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
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id = %d)", [[payload objectForKey:@"id"] intValue]];
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Expensedata"
                                              inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id = %d)", projId];
    [fetchRequest setPredicate:predicate];
    
    NSArray *speakers = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if (speakers && [speakers count] > 0) {
        return [speakers objectAtIndex:0];
    }
    
    return nil;
}


//ComplienceForm
+(BOOL)uploadComplienceImages:(NSString *)username comNotiseNo:(NSString *)comNotiseNo imageName:(NSString *)imageName
{
    ComplianceForm *assp;
    NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ComplianceForm"
                                              inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(complianceNoticeNo = %@)", comNotiseNo];
    [fetchRequest setPredicate:predicate];
    
    if (!assp) {
        assp = [NSEntityDescription
                insertNewObjectForEntityForName:@"ComplianceForm"
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

+(BOOL)uploadComplienceSignature:(NSString *)username comNotiseNo:(NSString *)comNotiseNo signature:(NSString *)signature
{
    ComplianceForm *assp;
    NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ComplianceForm"
                                              inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(complianceNoticeNo = %@)", comNotiseNo];
    [fetchRequest setPredicate:predicate];
    if (!assp) {
        assp = [NSEntityDescription
                insertNewObjectForEntityForName:@"ComplianceForm"
                inManagedObjectContext:managedContext];
    }
    
    [assp setValue:username forKey:@"username"];
    [assp setValue:signature forKey:@"signature"];
    
    NSError *saveError;
    if (![managedContext save:&saveError]) {
        NSLog(@"Whoops, couldn't save: %@", [saveError localizedDescription]);
    }
    return TRUE;
}

+(BOOL)uploadComplienceSketch:(NSString *)username comNotiseNo:(NSString *)comNotiseNo sketch:(NSString *)sketch
{
    ComplianceForm *assp;
    NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ComplianceForm"
                                              inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(complianceNoticeNo = %@)", comNotiseNo];
    [fetchRequest setPredicate:predicate];
    
    if (!assp) {
        assp = [NSEntityDescription
                insertNewObjectForEntityForName:@"ComplianceForm"
                inManagedObjectContext:managedContext];
    }
    
    [assp setValue:username forKey:@"username"];
    [assp setValue:sketch forKey:@"sketch_images"];
    
    NSError *saveError;
    if (![managedContext save:&saveError]) {
        NSLog(@"Whoops, couldn't save: %@", [saveError localizedDescription]);
    }
    return TRUE;
}

+ (BOOL)saveComplianceForm:(NSString *)username title:(NSString *)title contractNo:(NSString *)contractNo proDesc:(NSString *)proDesc comTitle:(NSString *)comTitle project:(NSString *)project
                dateIssued:(NSString *)dateIssued conRespon:(NSString *)conRespon to:(NSString *)to dateConStarted:(NSString *)dateConStarted dateConComplteted:(NSString *)dateConCopleted dateRawReport:(NSString *)dateRawReport userId:(NSString *)userId correctiveAction:(NSString *)correctiveAct signature:(NSString *)signature printedName:(NSString *)printedName projId:(NSString *)projId
{
    ComplianceForm *assp;
    NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ComplianceForm"
                                              inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:@"complianceNoticeNo"]];
    
    NSError *error = nil;
    NSArray *existingIDs = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if (error != nil) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }

    int randNum = 0;
    NSString *newIDD;
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
    
    if (!assp) {
        assp = [NSEntityDescription
                insertNewObjectForEntityForName:@"ComplianceForm"
                inManagedObjectContext:managedContext];
    }
    
    [assp setValue:newIDD forKey:@"complianceNoticeNo"];
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
    
    NSError *saveError;
    if (![managedContext save:&saveError]) {
        NSLog(@"Whoops, couldn't save: %@", [saveError debugDescription ]);
        return FALSE;
    }else{
        return TRUE;
    }
}

//Non complience
+(BOOL)saveNonComplienceImages:(NSString *)username comNotiseNo:(NSString *)comNotiseNo imageName:(NSString *)imageName
{
    NonComplianceForm *assp;
    NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"NonComplianceForm"
                                              inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id = %@)", comNotiseNo];
    [fetchRequest setPredicate:predicate];
    
    if (!assp) {
        assp = [NSEntityDescription
                insertNewObjectForEntityForName:@"NonComplianceForm"
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


+(BOOL)saveNonComplienceSignature:(NSString *)username comNotiseNo:(NSString *)comNotiseNo signature:(NSString *)signature
{
    NonComplianceForm *assp;
    NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"NonComplianceForm"
                                              inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id = %@)", comNotiseNo];
    [fetchRequest setPredicate:predicate];
    
    if (!assp) {
        assp = [NSEntityDescription
                insertNewObjectForEntityForName:@"NonComplianceForm"
                inManagedObjectContext:managedContext];
    }
    [assp setValue:username forKey:@"username"];
    [assp setValue:signature forKey:@"signature"];
    NSError *saveError;
    if (![managedContext save:&saveError]) {
        NSLog(@"Whoops, couldn't save: %@", [saveError localizedDescription]);
        return FALSE;
    }else{
        return TRUE;
    }
}

+(BOOL)saveNonComplienceSketch:(NSString *)username comNotiseNo:(NSString *)comNotiseNo sketch:(NSString *)sketch{
    
    NonComplianceForm *assp;
    NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"NonComplianceForm"
                                              inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id = %@)", comNotiseNo];
    [fetchRequest setPredicate:predicate];
    
    if (!assp) {
        assp = [NSEntityDescription
                insertNewObjectForEntityForName:@"NonComplianceForm"
                inManagedObjectContext:managedContext];
    }
    
    [assp setValue:username forKey:@"username"];
    [assp setValue:sketch forKey:@"sketch_images"];
    
    NSError *saveError;
    if (![managedContext save:&saveError]) {
        NSLog(@"Whoops, couldn't save: %@", [saveError localizedDescription]);
        return FALSE;
    }else{
        return TRUE;
    }
}

+(BOOL)saveNonComplianceForm:(NSString *)username title:(NSString *)title contractNo:(NSString *)contractNo proDesc:(NSString *)proDesc comTitle:(NSString *)comTitle project:(NSString *)project
                   dateIssued:(NSString *)dateIssued conRespon:(NSString *)conRespon to:(NSString *)to dateConStarted:(NSString *)dateConStarted dateConComplteted:(NSString *)dateConCopleted dateRawReport:(NSString *)dateRawReport userId:(NSString *)userId correctiveAction:(NSString *)correctiveAct signature:(NSString *)signature printedName:(NSString *)printedName projId:(NSString *)projId
{
    
    NonComplianceForm *assp;
    NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"NonComplianceForm"
                                              inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:@"non_ComplianceNoticeNo"]];
    NSError *error = nil;
    NSArray *existingIDs = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if (error != nil) {
        NSLog(@"Error: %@", [error debugDescription]);
    }
    
    int randNum = 0;
    NSString *newIDD;
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
    
    
    if (!assp) {
        assp = [NSEntityDescription
                insertNewObjectForEntityForName:@"NonComplianceForm"
                inManagedObjectContext:managedContext];
    }
    
    [assp setValue:newIDD forKey:@"non_ComplianceNoticeNo"];
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


+(BOOL)saveExpensec:(NSString *)expId projId:(NSString *)projId header:(NSString *)header date:(NSString *)date desc:(NSString *)desc jobNo:(NSString *)jobNo type:(NSString *)type mil:(NSString *)mil rate:(NSString *)rate totl:(NSString *)totl
{
    Expensedata *assp;
    NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Expensedata"
                                              inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:@"id"]];
    NSError *error = nil;
    NSArray *existingIDs = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if (error != nil) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
    
    NSInteger newID = 0;
    for (NSDictionary *dict in existingIDs) {
        NSInteger IDToCompare = [[dict objectForKey:@"id"] integerValue];
        if (IDToCompare >= newID) {
            newID = IDToCompare + 1;
        }
    }
    
    if (!assp) {
        assp = [NSEntityDescription
                insertNewObjectForEntityForName:@"Expensedata"
                inManagedObjectContext:managedContext];
    }
    
    [assp setValue:expId forKey:@"id"];
    [assp setValue:date forKey:@"eRDate1"];
    [assp setValue:desc forKey:@"eRDescription1"];
    [assp setValue:jobNo forKey:@"eRJobNo1"];
    [assp setValue:mil forKey:@"eRPAMilage1"];
    [assp setValue:rate forKey:@"eRPARate1"];
    [assp setValue:totl forKey:@"eRTotal1"];
    
    NSError *saveError;
    if (![managedContext save:&saveError]) {
        NSLog(@"Whoops, couldn't save: %@", [saveError localizedDescription]);
        return FALSE;
    }else{
     return TRUE;
    }
}


+ (BOOL)saveExpensecRep:(NSString *)expId projId:(NSString *)projId header:(NSString *)header date:(NSString *)date desc:(NSString *)desc jobNo:(NSString *)jobNo type:(NSString *)type mil:(NSString *)mil rate:(NSString *)rate totl:(NSString *)totl
{
    
    ExpenseReportModel *assp;
    
    NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ExpenseReportModel"
                                              inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:@"id"]];
    
    NSError *error = nil;
    
    NSArray *existingIDs = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    
    if (error != nil) {
        
        NSLog(@"Error: %@", [error localizedDescription]);
    }
    
    NSInteger newID = 0;
    
    for (NSDictionary *dict in existingIDs) {
        
        NSInteger IDToCompare = [[dict objectForKey:@"id"] integerValue];
        
        if (IDToCompare >= newID) {
            newID = IDToCompare + 1;
        }
    }
    
    
    if (!assp) {
        assp = [NSEntityDescription
                insertNewObjectForEntityForName:@"ExpenseReportModel"
                inManagedObjectContext:managedContext];
    }
    
    [assp setValue:expId forKey:@"id"];
    [assp setValue:header forKey:@"eRFHeader"];
    [assp setValue:projId forKey:@"project_id"];
    
    
    NSError *saveError;
    if (![managedContext save:&saveError]) {
        NSLog(@"Whoops, couldn't save: %@", [saveError localizedDescription]);
        return FALSE;
    }else{
        return TRUE;
    }
}


//Summery3
+ (BOOL)saveSummery3:(NSString *)username saveVal:(NSString *)saveVal projId:(NSString *)projId class1:(NSString *)class1 active1:(NSString *)active1 no1:(NSString *)no1 hours1:(NSString *)hours1 rate1:(NSString *)rate1 total1:(NSString *)total1 class2:(NSString *)class2 active2:(NSString *)active2 no2:(NSString *)no2 hours2:(NSString *)hours2 rate2:(NSString *)rate2 total2:(NSString *)total2 class3:(NSString *)class3 active3:(NSString *)active3 no3:(NSString *)no3 hours3:(NSString *)hours3 rate3:(NSString *)rate3 total3:(NSString *)total3 class4:(NSString *)class4 active4:(NSString *)active4 no4:(NSString *)no4 hours4:(NSString *)hours4 rate4:(NSString *)rate4 total4:(NSString *)total4 class5:(NSString *)class5 active5:(NSString *)active5 no5:(NSString *)no5 hours5:(NSString *)hours5 rate5:(NSString *)rate5 total5:(NSString *)total5 inspecter:(NSString *)inspecter signame1:(NSString *)signame1 signame2:(NSString *)signame2 dateIns:(NSString *)dateIns projMan:(NSString *)projMan dateCr:(NSString *)dateCr totalToDate:(NSString *)totalToDate l5:(NSString *)l5
{
    
    SummarySheet3*assp;
    
    NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SummarySheet3"
                                              inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:@"sMSheetNo"]];
    
    NSError *error = nil;
    
    NSArray *existingIDs = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    
    if (error != nil) {
        
        NSLog(@"Error: %@", [error localizedDescription]);
    }
    
    NSInteger newID = 0;
    
    for (NSDictionary *dict in existingIDs) {
        
        NSString *str = [dict valueForKey:@"sMSheetNo"] ;
        NSArray *arr = [str componentsSeparatedByString:@"M"];
        NSInteger IDToCompare = [[arr objectAtIndex:0] integerValue];
        
        if (IDToCompare >= newID) {
            newID = IDToCompare + 1;
        }
    }
    
    NSString *newIDD = [NSString stringWithFormat:@"SM%d",newID];
    
    if (!assp) {
        assp = [NSEntityDescription
                insertNewObjectForEntityForName:@"SummarySheet3"
                inManagedObjectContext:managedContext];
    }
    
    [assp setValue:newIDD forKey:@"sMSheetNo"];
    [assp setValue:projId forKey:@"project_id"];
    [assp setValue:class1 forKey:@"eQSizeandClass1"];
    [assp setValue:class2 forKey:@"eQSizeandClass2"];
    [assp setValue:class3 forKey:@"eQSizeandClass3"];
    [assp setValue:class4 forKey:@"eQSizeandClass4"];
    [assp setValue:class5 forKey:@"eQSizeandClass5"];
    [assp setValue:active1 forKey:@"eQIdleActive1"];
    [assp setValue:active2 forKey:@"eQIdleActive2"];
    [assp setValue:active3 forKey:@"eQIdleActive3"];
    [assp setValue:active4 forKey:@"eQIdleActive4"];
    [assp setValue:active5 forKey:@"eQIdleActive5"];
    [assp setValue:no1 forKey:@"eQNo1"];
    [assp setValue:no2 forKey:@"eQNo2"];
    [assp setValue:no3 forKey:@"eQNo3"];
    [assp setValue:no4 forKey:@"eQNo4"];
    [assp setValue:no5 forKey:@"eQNo5"];
    [assp setValue:hours1 forKey:@"eQTotalHours1"];
    [assp setValue:hours2 forKey:@"eQTotalHours2"];
    [assp setValue:hours3 forKey:@"eQTotalHours3"];
    [assp setValue:hours4 forKey:@"eQTotalHours4"];
    [assp setValue:hours5 forKey:@"eQTotalHours5"];
    [assp setValue:rate1 forKey:@"eQRAte1"];
    [assp setValue:rate2 forKey:@"eQRAte2"];
    [assp setValue:rate3 forKey:@"eQRAte3"];
    [assp setValue:rate4 forKey:@"eQRAte4"];
    [assp setValue:rate5 forKey:@"eQRAte5"];
    [assp setValue:total1 forKey:@"eQTotalHours1"];
    [assp setValue:total2 forKey:@"eQTotalHours2"];
    [assp setValue:total3 forKey:@"eQTotalHours3"];
    [assp setValue:total4 forKey:@"eQTotalHours4"];
    [assp setValue:total5 forKey:@"eQTotalHours5"];
    [assp setValue:inspecter forKey:@"inspector"];
    [assp setValue:signame1 forKey:@"signature1"];
    [assp setValue:signame2 forKey:@"signature2"];
    [assp setValue:dateIns forKey:@""];
    [assp setValue:projMan forKey:@"contractorRepresentative"];
    [assp setValue:projId forKey:@"project_id"];
    [assp setValue:dateCr forKey:@"date1"];
    [assp setValue:totalToDate forKey:@"dailyTotal"];
    
    NSError *saveError;
    if (![managedContext save:&saveError]) {
        NSLog(@"Whoops, couldn't save: %@", [saveError localizedDescription]);
        return FALSE;
    }else{
        return TRUE;
    }
}


//Summary2


/*NSString *strURL = [NSString stringWithFormat:@"http://data.privytext.us/contructionapi.php/api/summary2/create/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@",appDelegate.username,appDelegate.saveVal,appDelegate.projId,field1,field2,field3,field4,field5,field6,field7,field8,field9,field10,field11,field12,field13,field14,field15,field16,field17,field18,field19,field20,tTotal.text,txtInsu.text,txtLTotal.text,txt20.text,txtGRTotal.text];*/


+ (BOOL)saveSummery2:(NSString *)username saveVal:(NSString *)saveVal projId:(NSString *)projId desc1:(NSString *)desc1 qty1:(NSString *)qty1 rate1:(NSString *)rate1 total1:(NSString *)total1 desc2:(NSString *)desc2 qty2:(NSString *)qty2 rate2:(NSString *)rate2 total2:(NSString *)total2 desc3:(NSString *)desc3 qty3:(NSString *)qty3 rate3:(NSString *)rate3 total3:(NSString *)total3 desc4:(NSString *)desc4 qty4:(NSString *)qty4 rate4:(NSString *)rate4 total4:(NSString *)total4 desc5:(NSString *)desc5 qty5:(NSString *)qty5 rate5:(NSString *)rate5 total5:(NSString *)total5 totalTxt:(NSString *)totalTxt insu:(NSString *)insu lTotal:(NSString *)lTotal txt20:(NSString *)txt20 GRTotal:(NSString *)GRTotal
{
    
    SummarySheet2*assp;
    
    NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SummarySheet2"
                                              inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:@"sMSheetNo"]];
    
    NSError *error = nil;
    
    NSArray *existingIDs = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    
    if (error != nil) {
        
        NSLog(@"Error: %@", [error localizedDescription]);
    }
    
    NSInteger newID = 0;
    
    for (NSDictionary *dict in existingIDs) {
        
        NSString *str = [dict valueForKey:@"sMSSheetNo"] ;
        NSArray *arr = [str componentsSeparatedByString:@"M"];
        NSInteger IDToCompare = [[arr objectAtIndex:0] integerValue];
        
        if (IDToCompare >= newID) {
            newID = IDToCompare + 1;
        }
    }
    
    NSString *newIDD = [NSString stringWithFormat:@"SM%d",newID];
    
    if (!assp) {
        assp = [NSEntityDescription
                insertNewObjectForEntityForName:@"SummarySheet2"
                inManagedObjectContext:managedContext];
    }
    
    [assp setValue:newIDD forKey:@"sMSSheetNo"];
    [assp setValue:projId forKey:@"project_id"];
    [assp setValue:desc1 forKey:@"mEDescription1"];
    [assp setValue:desc2 forKey:@"mEDescription2"];
    [assp setValue:desc3 forKey:@"mEDescription3"];
    [assp setValue:desc4 forKey:@"mEDescription4"];
    [assp setValue:desc5 forKey:@"mEDescription5"];
    [assp setValue:qty1 forKey:@"mEQuantity1"];
    [assp setValue:qty2 forKey:@"mEQuantity2"];
    [assp setValue:qty3 forKey:@"mEQuantity3"];
    [assp setValue:qty4 forKey:@"mEQuantity4"];
    [assp setValue:qty5 forKey:@"mEQuantity5"];
    [assp setValue:rate1 forKey:@"mEUnitPrice1"];
    [assp setValue:rate2 forKey:@"mEUnitPrice2"];
    [assp setValue:rate3 forKey:@"mEUnitPrice3"];
    [assp setValue:rate4 forKey:@"mEUnitPrice4"];
    [assp setValue:rate5 forKey:@"mEUnitPrice5"];
    [assp setValue:total1 forKey:@"total1"];
    [assp setValue:total2 forKey:@"total2"];
    [assp setValue:total3 forKey:@"total3"];
    
    NSError *saveError;
    if (![managedContext save:&saveError]) {
        NSLog(@"Whoops, couldn't save: %@", [saveError localizedDescription]);
        return FALSE;
    }else{
        NSLog(@"saved summary2: %@", assp);
        return TRUE;
    }
}

+(BOOL) saveAssignProject:(NSString *)username projMgr:(NSString *)projMgr projId:(NSString *)projId date:(NSDate *)date
{
    Assign_project *assp;
    NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Assign_project"
                                              inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:@"projectid"]];
    
    NSError *error = nil;
    
    if (error != nil) {
        NSLog(@"Error: %@", [error debugDescription]);
    }

    if (!assp) {
        assp = [NSEntityDescription
                insertNewObjectForEntityForName:@"Assign_project"
                inManagedObjectContext:managedContext];
    }
    
    [assp setValue:projId forKey:@"projectid"];
    [assp setValue:projMgr forKey:@"username"];
    [assp setValue:date forKey:@"assign_date"];
    NSError *saveError;
    if (![managedContext save:&saveError]) {
        NSLog(@"Whoops, couldn't save: %@", [saveError debugDescription]);
        return FALSE;
    }else{
        NSLog(@"saved assign_project: %@", assp);
        return TRUE;
    }

}

+ (BOOL)saveProject:(NSString *)username projId:(NSString *)projId phone:(NSString *)phone projName:(NSString *)projName projDesc:(NSString *)projDesc title:(NSString *)title street:(NSString *)street city:(NSString *)city state:(NSString *)state zip:(NSString *)zip date:(NSString *)date clientName:(NSString *)clientName projMgr:(NSString *)projMgr latitude:(NSString *)latitude longitude:(NSString *)longitude inspector:(NSString *)inspector
{
    
    Projects *assp;
    
    NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Projects"
                                              inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:@"projecct_id"]];
    
    NSError *error = nil;
    NSArray *existingIDs = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if (error != nil) {
        NSLog(@"Error: %@", [error debugDescription]);
    }

    int randNum = 0;
    NSString *newIDD;
    BOOL hasConflicts = TRUE;
    while (hasConflicts){
        hasConflicts = FALSE;
        randNum = rand() % (100000000) + 100000; //create the random number.
        newIDD = [NSString stringWithFormat:@"%d", randNum];
        
        for (NSDictionary *dict in existingIDs) {
            NSString *str = [dict valueForKey:@"projecct_id"];
            if ([str isEqualToString:newIDD]){
                hasConflicts = TRUE;
                break;
            }
        }
    }
    NSLog(@"Project id: %@", newIDD);
    
    if (!assp) {
        assp = [NSEntityDescription
                insertNewObjectForEntityForName:@"Projects"
                inManagedObjectContext:managedContext];
    }
    
    [assp setValue:newIDD forKey:@"projecct_id"];
    [assp setValue:city forKey:@"city"];
    [assp setValue:clientName forKey:@"client_name"];
    [assp setValue:newIDD forKey:@"contract_no"];
    
    NSDateFormatter *myXMLdateReader = [[NSDateFormatter alloc] init];
    [myXMLdateReader setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateIssued_Date = [myXMLdateReader dateFromString:date];
    
    [assp setValue:dateIssued_Date forKey:@"created_date"];
    
    [assp setValue:inspector forKey:@"inspecter"];
    [assp setValue:dateIssued_Date forKey:@"p_date"];
    [assp setValue:projDesc forKey:@"p_description"];
    [assp setValue:latitude forKey:@"p_latitude"];
    [assp setValue:longitude forKey:@"p_longitude"];
    [assp setValue:projName forKey:@"p_name"];
    [assp setValue:projName forKey:@"p_title"];
    [assp setValue:phone forKey:@"phone"];
    [assp setValue:projMgr forKey:@"project_manager"];
    [assp setValue:state forKey:@"state"];
    [assp setValue:street forKey:@"street"];
    [assp setValue:0 forKey:@"status"];
    [assp setValue:zip forKey:@"zip"];
    
    BOOL assignProjSave = [PRIMECMController saveAssignProject:username projMgr:projMgr projId:newIDD date:dateIssued_Date];
    
    NSError *saveError;
    if (![managedContext save:&saveError] || !assignProjSave) {
        NSLog(@"Whoops, couldn't save: %@", [saveError debugDescription]);
        return FALSE;
    }else{
        NSLog(@"saved project: %@", assp);
        return TRUE;
    }
}

+ (BOOL) saveAllImages:(NSString *)imgName img:(NSData *)img{
    
    Image *assp;
    NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Image"
                                              inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:@"imgName"]];
    
    
    if (!assp) {
        assp = [NSEntityDescription
                insertNewObjectForEntityForName:@"Image"
                inManagedObjectContext:managedContext];
    }
    
    [assp setValue:imgName forKey:@"imgName"];
    [assp setValue:img forKey:@"img"];
    
    NSError *saveError;
    if (![managedContext save:&saveError]) {
        NSLog(@"Whoops, couldn't save: %@", [saveError debugDescription ]);
        return FALSE;
    }else{
        return TRUE;
    }
    
}

+ (UIImage *) getTheImage:(NSString *)imgName{
    
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id = %d)", [[payload objectForKey:@"id"] intValue]];
    //[fetchRequest setPredicate:predicate];
    
    NSManagedObjectContext *context = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Image" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(imgName = %@)", imgName];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    NSLog(@"Object count = %d",[objects count]);
    if([objects count] > 0){
        
        NSManagedObject *complianceReportObject = (NSManagedObject *) [objects objectAtIndex:0];
        return [UIImage imageWithData:[complianceReportObject valueForKey:@"img"]];
    }
    
    return nil;
    
}

@end
