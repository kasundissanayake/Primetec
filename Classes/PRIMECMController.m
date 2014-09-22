//
//  PRIMECMController.m
//  PRIMECMAPP
//
//  Created by Kasun Dissanayake on 8/16/14.
//
//

#import "PRIMECMController.h"
#import "PRIMECMAPPUtils.h"
#import "Reachability.h"
#import "TabAndSplitAppAppDelegate.h"

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
#import "Image.h"
#import "QuantityEstimateForm.h"
#import "ImageSyncController.h"
#import "DataSyncController.h"

@implementation PRIMECMController
{


    TabAndSplitAppAppDelegate *appDelegate;




}

+ (int)synchronizeDataWithServer {
    
    if (![self connected]) {
        return 1;
    }
    
    BOOL pushStatus = [DataSyncController pushPendingDataToServer];
    if (!pushStatus){
        NSLog(@"Failed to push data");
        return 2;
    }
    
    BOOL pullStatus = [DataSyncController pullDataFromServer];
    if (!pullStatus){
        NSLog(@"Failed to pull data");
        return 3;
    }
    
    NSLog(@"Successfully synchronized data");
    return 0;
}


+ (int)synchronizeImagesWithServer {
    
    BOOL syncPushStatus = [ImageSyncController pushPendingImagesToServer];
    
    BOOL syncPullStatus = [ImageSyncController pullImagesFromServer];
    
    if (syncPushStatus && syncPullStatus){
        NSLog(@"Successfully synchronized images");
        return 0;
    } else {
        NSLog(@"Failed to synchronize images");
    }
    return 1;
}


+ (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
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


+ (BOOL)saveComplianceForm:(NSString *)username complianceNoticeNo:(NSString *)complianceNoticeNo title:(NSString *)title contractNo:(NSString *)contractNo comTitle:(NSString *)comTitle dateIssued:(NSString *)dateIssued conRespon:(NSString *)conRespon to:(NSString *)to dateConStarted:(NSString *)dateConStarted dateConComplteted:(NSString *)dateConCopleted dateRawReport:(NSString *)dateRawReport userId:(NSString *)userId correctiveAction:(NSString *)correctiveAct signature:(NSString *)signature printedName:(NSString *)printedName projId:(NSString *)projId sketchImg:(NSString *)sketchImg images_uploaded:(NSString *)images_uploaded
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
        
        fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"ComplianceForm"
                                                  inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
        [fetchRequest setEntity:entity];
        existingIDs = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&error];
        
        int randNum = 0;
        BOOL hasConflicts = TRUE;
        while (hasConflicts){
            hasConflicts = FALSE;
            randNum = rand() % (100000000) + 100000; //create the random number.
            newIDD = [NSString stringWithFormat:@"%@-%@-CM-%d", projId, userId, randNum];
            
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
    [assp setValue:comTitle forKey:@"title"];
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


+(BOOL)saveNonComplianceForm:(NSString *)username non_ComplianceNoticeNo:(NSString *)non_ComplianceNoticeNo title:(NSString *)title contractNo:(NSString *)contractNo comTitle:(NSString *)comTitle dateIssued:(NSString *)dateIssued conRespon:(NSString *)conRespon to:(NSString *)to dateDCRC:(NSString *)dateDCRC dateConStarted:(NSString *)dateConStarted dateConComplteted:(NSString *)dateConCopleted dateRawReport:(NSString *)dateRawReport userId:(NSString *)userId correctiveAction:(NSString *)correctiveAct signature:(NSString *)signature printedName:(NSString *)printedName projId:(NSString *)projId sketchImg:(NSString *)sketchImg images_uploaded:(NSString *)images_uploaded
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
        
        fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"NonComplianceForm"
                                                  inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
        [fetchRequest setEntity:entity];
        existingIDs = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&error];
        
        
        BOOL hasConflicts = TRUE;
        while (hasConflicts){
            hasConflicts = FALSE;
            randNum = rand() % (100000000) + 100000; //create the random number.
            newIDD = [NSString stringWithFormat:@"%@-%@-NCM-%d", projId, userId, randNum];
            
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
    [assp setValue:comTitle forKey:@"title"];
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
    NSDate *dateDCRC_Date = [myXMLdateReader dateFromString:dateDCRC];
    
    [assp setValue:dateIssued_Date forKey:@"dateIssued"];
    [assp setValue:dateContractorStarted_Date forKey:@"dateContractorStarted"];
    [assp setValue:dateContractorCompleted_Date forKey:@"dateContractorCompleted"];
    [assp setValue:dateOfDWRReported_Date forKey:@"dateOfDWRReported"];
    [assp setValue:dateDCRC_Date forKey:@"dateCRTCB"];
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



+(BOOL) saveDailyInspectionForm:(NSString *)username calendar_Days_Used:(NSString *)calendar_Days_Used city:(NSString *)city competentPerson:(NSString *) competentPerson con_Name:(NSString *) con_Name contractor:(NSString *) contractor contractorsHoursOfWork:(NSNumber *) contractorsHoursOfWork date:(NSString *) date dIFHeader:(NSString *) dIFHeader e_Mail:(NSString *) e_Mail i_Desc1:(NSString *) i_Desc1 i_Desc2:(NSString *) i_Desc2 i_Desc3:(NSString *) i_Desc3 i_Desc4:(NSString *) i_Desc4 i_Desc5:(NSString *) i_Desc5 i_No1:(NSString *) i_No1 i_No2:(NSString *) i_No2 i_No3:(NSString *) i_No3 i_No4:(NSString *) i_No4 i_No5:(NSString *) i_No5 i_QTY1:(NSString *) i_QTY1 i_QTY2:(NSString *) i_QTY2 i_QTY3:(NSString *) i_QTY3 i_QTY4:(NSString *) i_QTY4 i_QTY5:(NSString *) i_QTY5 iFName1:(NSString *) iFName1 iFName2:(NSString *) iFName2 iFName3:(NSString *) iFName3 iFName4:(NSString *) iFName4 iFTitle1:(NSString *) iFTitle1 iFTitle2:(NSString *) iFTitle2 iFTitle3:(NSString *) iFTitle3 iFTitle4:(NSString *) iFTitle4 images_uploaded:(NSString *) images_uploaded inspectionID:(NSString *) inspectionID inspectorSign:(NSString *) inspectorSign signature:(NSString*)signature original_Calendar_Days:(NSString *) original_Calendar_Days oVJName1:(NSString *) oVJName1 oVJName2:(NSString *) oVJName2 oVJName3:(NSString *) oVJName3 oVJName4:(NSString *) oVJName4 oVJTitle1:(NSString *) oVJTitle1 oVJTitle2:(NSString *) oVJTitle2 oVJTitle3:(NSString *) oVJTitle3 oVJTitle4:(NSString *) oVJTitle4 p_o_Box:(NSString *) p_o_Box printedName:(NSString *) printedName project_id:(NSString *) project_id report_No:(NSString *) report_No sketch_images:(NSString *) sketch_images state:(NSString *) state telephone_No:(NSString *) telephone_No time:(NSString *) time town_city:(NSString *) town_city wDODepartmentOrCompany1:(NSString *) wDODepartmentOrCompany1 wDODepartmentOrCompany2:(NSString *) wDODepartmentOrCompany2 wDODepartmentOrCompany3:(NSString *) wDODepartmentOrCompany3 wDODepartmentOrCompany4:(NSString *) wDODepartmentOrCompany4 wDODescriptionOfWork1:(NSString *) wDODescriptionOfWork1 wDODescriptionOfWork2:(NSString *) wDODescriptionOfWork2 wDODescriptionOfWork3:(NSString *) wDODescriptionOfWork3 wDODescriptionOfWork4:(NSString *) wDODescriptionOfWork4 weather:(NSString *)weather workDoneBy:(NSString *) workDoneBy zip_Code:(NSString *) zip_Code{
    
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
    
    if ( ![@"" isEqualToString:i_No1] && ![@"" isEqualToString:i_QTY1] &&
        ![PRIMECMController saveDailyInspectionItem:username date:date desc:i_Desc1 inspectionID:inspectionID no:i_No1 qty:i_QTY1]){
        saveItems = FALSE;
    }
    
    if (![@"" isEqualToString:i_No2] &&  ![@"" isEqualToString:i_QTY2] &&
        ![PRIMECMController saveDailyInspectionItem:username date:date desc:i_Desc2 inspectionID:inspectionID no:i_No2 qty:i_QTY2]){
        saveItems = FALSE;
    }
    
    if (![@"" isEqualToString:i_No3] && ![@"" isEqualToString:i_QTY3] &&
        ![PRIMECMController saveDailyInspectionItem:username date:date desc:i_Desc3 inspectionID:inspectionID no:i_No3 qty:i_QTY3]){
        saveItems = FALSE;
    }
    
    if (![@"" isEqualToString:i_No4] && ![@"" isEqualToString:i_QTY4] &&
        ![PRIMECMController saveDailyInspectionItem:username date:date desc:i_Desc4 inspectionID:inspectionID no:i_No4 qty:i_QTY4]){
        saveItems = FALSE;
    }
    
    if (![@"" isEqualToString:i_No5] &&  ![@"" isEqualToString:i_QTY5] &&
        ![PRIMECMController saveDailyInspectionItem:username date:date desc:i_Desc5 inspectionID:inspectionID no:i_No5 qty:i_QTY5]){
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



+ (BOOL)saveExpenseForm:(NSString *)username approvedBy:(NSString *)approvedBy eRDate1:(NSString *)eRDate1 checkNo:(NSString *)checkNo date:(NSString *)date eRDescription1:(NSString *)eRDescription1 eMPName:(NSString *)eMPName eRCashAdvance:(NSString *)eRCashAdvance eRFHeader:(NSString *)eRFHeader eRReimbursement:(NSString *)eRReimbursement eXReportNo:(NSString *)eXReportNo images_uploaded:(NSString *)images_uploaded project_id:(NSString *)project_id signature:(NSString *)signature weekEnding:(NSString *)weekEnding eRJobNo1:(NSString *)eRJobNo1 eRPAMilage1:(NSString *)eRPAMilage1 eRPARate1:(NSString *)eRPARate1 eRTotal1:(NSString *)eRTotal1 eRType1:(NSString *)eRType1;

{
    ExpenseReportModel *assp;
    NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ExpenseReportModel"
                                              inManagedObjectContext:managedContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K=%@)", @"eXReportNo", eXReportNo];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *existingIDs = [managedContext executeFetchRequest:fetchRequest error:&error];
    NSString *newIDD;
    
    if (error != nil) {
        NSLog(@"Error: %@", [error debugDescription]);
    }
    
    if([existingIDs count]>0)
    {
        assp =[existingIDs firstObject];
    }else{
        
        fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"ExpenseReportModel"
                                                  inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
        [fetchRequest setEntity:entity];
        existingIDs = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&error];
        
        int randNum = 0;
        BOOL hasConflicts = TRUE;
        while (hasConflicts){
            hasConflicts = FALSE;
            randNum = rand() % (100000000) + 100000; //create the random number.
            newIDD = [NSString stringWithFormat:@"%@-%@-EX-%d", project_id, username, randNum];
            
            for (NSDictionary *dict in existingIDs) {
                NSString *str = [dict valueForKey:@"eXReportNo"];
                if ([str isEqualToString:newIDD]){
                    hasConflicts = TRUE;
                    break;
                }
            }
        }
        NSLog(@"New ExpenseReportModel Report eXReportNo: %@", newIDD);
    }
    
    if (!assp) {
        assp = [NSEntityDescription
                insertNewObjectForEntityForName:@"ExpenseReportModel"
                inManagedObjectContext:managedContext];
        [assp setValue:newIDD forKey:@"eXReportNo"];
    }
    
    [assp setValue:approvedBy forKey:@"approvedBy"];
    [assp setValue:checkNo forKey:@"checkNo"];
    
    NSDateFormatter *myXMLdateReader = [[NSDateFormatter alloc] init];
    [myXMLdateReader setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateType = [myXMLdateReader dateFromString:date];
    if (!dateType) {
        dateType = [NSDate date];
    }
    [assp setValue:dateType forKey:@"date"];
    
    NSDate *eRDate1dateType = [myXMLdateReader dateFromString:eRDate1];
    [assp setValue:eRDate1dateType forKey:@"eRDate1"];
    
    NSDate *weekEndingdateType = [myXMLdateReader dateFromString:weekEnding];
    [assp setValue:weekEndingdateType forKey:@"weekEnding"];
    
    
    [assp setValue:eRDescription1 forKey:@"eRDescription1"];
    [assp setValue:eMPName forKey:@"eMPName"];
    
    NSNumber *eRCashAdvanceNum = [NSNumber numberWithInt:[eRCashAdvance intValue]];
    [assp setValue:eRCashAdvanceNum forKey:@"eRCashAdvance"];
    [assp setValue:eRFHeader forKey:@"eRFHeader"];
    NSNumber *eRReimbursementNum = [NSNumber numberWithInt:[eRReimbursement intValue]];
    [assp setValue:eRReimbursementNum forKey:@"eRReimbursement"];
    
    [assp setValue:images_uploaded forKey:@"images_uploaded"];
    [assp setValue:project_id forKey:@"project_id"];
    [assp setValue:signature forKey:@"signature"];
    
    
    [assp setValue:eRJobNo1 forKey:@"eRJobNo1"];
    [assp setValue:eRPAMilage1 forKey:@"eRPAMilage1"];
    
    NSNumber *erateNum = [NSNumber numberWithInt:[eRPARate1 intValue]];
    [assp setValue:erateNum forKey:@"eRPARate1"];
    
    [assp setValue:[NSNumber numberWithInt:[eRTotal1 intValue]] forKey:@"eRTotal1"];
    [assp setValue:eRType1 forKey:@"eRType1"];
    
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

+ (BOOL)saveSummarySheet1:(NSString *)username city:(NSString *)city conPeWork:(NSString *) conPeWork constructionOrder:(NSString *) constructionOrder contractor:(NSString *) contractor date:(NSString *) date descr:(NSString *) descr federalAidNumber:(NSString *) federalAidNumber healWelAndPension:(NSString *) healWelAndPension insAndTaxesOnItem1:(NSString *) insAndTaxesOnItem1 itemDescount20per:(NSString *) itemDescount20per lAAmount1:(NSString *) lAAmount1 lAAmount2:(NSString *) lAAmount2 lAAmount3:(NSString *) lAAmount3 lAAmount4:(NSString *) lAAmount4 lAAmount5:(NSString *) lAAmount5 lAClass1:(NSString *) lAClass1 lAClass2:(NSString *) lAClass2 lAClass3:(NSString *) lAClass3 lAClass4:(NSString *) lAClass4 lAClass5:(NSString *) lAClass5 lANo1:(NSString *) lANo1 lANo2:(NSString *) lANo2 lANo3:(NSString *) lANo3 lANo4:(NSString *) lANo4 lANo5:(NSString *) lANo5 lARate1:(NSString *) lARate1 lARate2:(NSString *) lARate2 lARate3:(NSString *) lARate3 lARate4:(NSString *) lARate4 lARate5:(NSString *) lARate5 lATotalHours1:(NSString *) lATotalHours1 lATotalHours2:(NSString *) lATotalHours2 lATotalHours3:(NSString *) lATotalHours3 lATotalHours4:(NSString *) lATotalHours4 lATotalHours5:(NSString *) lATotalHours5 pOBox:(NSString *) pOBox printedName:(NSString *) printedName project_id:(NSString *) project_id reportNo:(NSString *) reportNo sMSheetNo:(NSString *) sMSheetNo sSHeader:(NSString *) sSHeader state:(NSString *) state telephoneNo:(NSString *) telephoneNo total:(NSString *) total totalLabor:(NSString *) totalLabor zip:(NSString *) zip
{
    SummarySheet1 *assp;
    NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SummarySheet1"
                                              inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    // [fetchRequest setResultType:NSDictionaryResultType];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(sMSheetNo = %@)",sMSheetNo];
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
        [assp setValue:sMSheetNo forKey:@"sMSheetNo"];
    }
    
    
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
    [assp setValue:reportNo forKey:@"reportNo"];
    [assp setValue:sSHeader forKey:@"sSHeader"];
    [assp setValue:telephoneNo forKey:@"telephoneNo"];
    [assp setValue:total forKey:@"total"];
    [assp setValue:totalLabor forKey:@"totalLabor"];
    [assp setValue:zip forKey:@"zip"];
    [assp setValue:state forKey:@"state"];
    
    NSNumber* syncStatusNum = [NSNumber numberWithInt:SYNC_STATUS_PENDING];
    [assp setValue:syncStatusNum forKey:@"syncStatus"];
    
    NSLog(@"Added Record is %@",assp);
    
    NSError *saveError;
    if (![managedContext save:&saveError]) {
        NSLog(@"Whoops, couldn't save: %@", [saveError debugDescription]);
        return FALSE;
    }else{
        NSLog(@"saved summary1: %@", sMSheetNo);
        
        

        
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
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(sMSSheetNo = %@)",sMSSheetNo];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *existingIDs = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if ([existingIDs count] > 0){
        assp = [existingIDs firstObject];
    }
    
    
    if (error != nil) {
        NSLog(@"Error: %@", [error debugDescription]);
    }
    
    if (!assp) {
        assp = [NSEntityDescription
                insertNewObjectForEntityForName:@"SummarySheet2"
                inManagedObjectContext:managedContext];
        [assp setValue:sMSSheetNo forKey:@"sMSSheetNo"];
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
    
    [assp setValue:total1 forKey:@"total1"];
    [assp setValue:total2 forKey:@"total2"];
    [assp setValue:total3 forKey:@"total3"];
    
    NSNumber* syncStatusNum = [NSNumber numberWithInt:SYNC_STATUS_PENDING];
    [assp setValue:syncStatusNum forKey:@"syncStatus"];
    
    NSLog(@"Summary 2 saved Data is %@",assp);
    NSError *saveError;
    if (![managedContext save:&saveError]) {
        NSLog(@"Whoops, couldn't save: %@", [saveError localizedDescription]);
        return FALSE;
    }else{
        NSLog(@"saved summary2: %@", sMSSheetNo);
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(sMSheetNo = %@)",sMSheetNo];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *existingIDs = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if ([existingIDs count] > 0){
        assp = [existingIDs firstObject];
    }
    
    
    if (error != nil) {
        NSLog(@"Error: %@", [error debugDescription]);
    }
    
    NSLog(@"New Summary Sheet 3 Report sMSheetNo: %@", sMSheetNo);
    
    
    if (!assp) {
        assp = [NSEntityDescription
                insertNewObjectForEntityForName:@"SummarySheet3"
                inManagedObjectContext:managedContext];
        [assp setValue:sMSheetNo forKey:@"sMSheetNo"];
    }
    
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
    
    NSNumber* syncStatusNum = [NSNumber numberWithInt:SYNC_STATUS_PENDING];
    [assp setValue:syncStatusNum forKey:@"syncStatus"];
    
    NSError *saveError;
    if (![managedContext save:&saveError]) {
        NSLog(@"Whoops, couldn't save: %@", [saveError localizedDescription]);
        return FALSE;
    }else{
        NSLog(@"saved summary3: %@", sMSheetNo);
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
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(projectid = %@)", projId];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *existingIDs = [managedContext executeFetchRequest:fetchRequest error:&error];
    
    
    for(Assign_project *assp in existingIDs){
        [managedContext deleteObject:assp];
    }
    
    
    if (error != nil) {
        NSLog(@"Error: %@", [error debugDescription]);
    }
    
    NSArray *inspectorArr = [inspectors componentsSeparatedByString:@","];
    
    for (NSString *inspectorObj in inspectorArr){
        
        assp = [NSEntityDescription
                insertNewObjectForEntityForName:@"Assign_project"
                inManagedObjectContext:managedContext];
        
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
    NSPredicate *project_predicate = [NSPredicate predicateWithFormat:@"(projecct_id = %@)", projId];
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
    [assp setValue:title forKey:@"p_title"];
    [assp setValue:phone forKey:@"phone"];
    [assp setValue:projMgr forKey:@"project_manager"];
    [assp setValue:state forKey:@"state"];
    [assp setValue:street forKey:@"street"];
    [assp setValue:0 forKey:@"status"];
    [assp setValue:zip forKey:@"zip"];
    
    NSNumber* syncStatusNum = [NSNumber numberWithInt:SYNC_STATUS_PENDING];
    [assp setValue:syncStatusNum forKey:@"syncStatus"];
    
    NSError *saveError;
    
    BOOL projSave = [managedContext save:&saveError];
    BOOL assignProjSave = [PRIMECMController saveAssignProject:username inspectors:inspector projId:projId date:dateIssued_Date];
    
    if (!projSave || !assignProjSave) {
        NSLog(@"Whoops, couldn't save: %@", [saveError debugDescription]);
        return FALSE;
    }else{
        NSLog(@"saved project: %@", projId);
        return TRUE;
    }
}

+ (BOOL)saveQuantityEstimateForm:(NSString *)username est_qty:(NSString *)est_qty item_no:(NSString *) item_no project_id:(NSString *) project_id unit:(NSString *) unit unit_price:(NSString *) unit_price qtyEstID:(NSString *)qtyEstID {
    
    QuantityEstimateForm *assp;
    
    NSManagedObjectContext *managedContext = [PRIMECMAPPUtils getManagedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"QuantityEstimateForm"
                                              inManagedObjectContext:managedContext];
    [fetchRequest setEntity:entity];
    NSPredicate *project_predicate = [NSPredicate predicateWithFormat:@"(qtyEstID = %@)", qtyEstID];
    [fetchRequest setPredicate:project_predicate];
    
    NSError *error = nil;
    NSArray *existingIDs = [managedContext executeFetchRequest:fetchRequest error:&error];
    NSString *newIDD;
    
    if ([existingIDs count] > 0){
        assp = [existingIDs objectAtIndex:0];
        NSLog(@"Updating QuantityEstimateForm with qtyEstID: %@", qtyEstID);
    }else {
        
        fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"QuantityEstimateForm"
                                                  inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
        [fetchRequest setEntity:entity];
        existingIDs = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&error];
        
        
        int randNum = 0;
        BOOL hasConflicts = TRUE;
        while (hasConflicts){
            hasConflicts = FALSE;
            randNum = rand() % (100000000) + 100000; //create the random number.
            newIDD = [NSString stringWithFormat:@"%@-%@-QE-%d", project_id, username, randNum];
            
            for (NSDictionary *dict in existingIDs) {
                NSString *str = [dict valueForKey:@"qtyEstID"];
                if ([str isEqualToString:newIDD]){
                    hasConflicts = TRUE;
                    break;
                }
            }
        }
        NSLog(@"New QuantityEstimateForm qtyEstID: %@", newIDD);
    }
    
    if (error != nil) {
        NSLog(@"Error: %@", [error debugDescription]);
    }
    
    
    if (assp == NULL) {
        NSLog(@"Creating a new QuantityEstimateForm with qtyEstID: %@", qtyEstID);
        assp = [NSEntityDescription
                insertNewObjectForEntityForName:@"QuantityEstimateForm"
                inManagedObjectContext:managedContext];
        [assp setValue:newIDD forKey:@"qtyEstID"];
        
    }
    
    [assp setValue:[NSNumber numberWithDouble:[est_qty intValue]] forKey:@"est_qty"];
    [assp setValue:item_no forKey:@"item_no"];
    [assp setValue:project_id forKey:@"project_id"];
    [assp setValue:[NSDate date] forKey:@"date"];
    [assp setValue:unit forKey:@"unit"];
    [assp setValue:[NSNumber numberWithDouble:[unit_price intValue]] forKey:@"unit_price"];
    [assp setValue:username forKey:@"user"];
    
    NSNumber* syncStatusNum = [NSNumber numberWithInt:SYNC_STATUS_PENDING];
    [assp setValue:syncStatusNum forKey:@"syncStatus"];
    
    NSError *saveError;
    if (![managedContext save:&saveError]) {
        NSLog(@"Whoops, couldn't save: %@", [saveError debugDescription]);
        return FALSE;
    }else{
        NSLog(@"saved QuantityEstimateForm: %@", qtyEstID);
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

+(NSArray *)getInspectionsForProject:(NSString *)projID {
    
    NSError *retrieveError;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DailyInspectionForm"
                                              inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    // [fetchRequest setResultType:NSDictionaryResultType];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(project_id = %@)", projID];
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:@"inspectionID"]];
    
    
    NSArray *fetchedObjects = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&retrieveError];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    if (fetchedObjects && [fetchedObjects count] > 0){
        
        for (id obj in fetchedObjects){
            [arr addObject:[obj valueForKey:@"inspectionID"]];
        }
        return arr;
    }
    return NULL;
}


+(NSArray *)getInspectionSummaryForItemID:(NSString *)itemNo
{
    NSError *retrieveError;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DailyInspectionItem"
                                              inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    //[fetchRequest setResultType:NSDictionaryResultType];
    
    TabAndSplitAppAppDelegate *appDelegate=(TabAndSplitAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    NSArray *inspectionArr = [self getInspectionsForProject:appDelegate.projId];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K=%@) AND (%K IN %@)", @"no", itemNo, @"inspectionID", inspectionArr];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedObjects = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&retrieveError];
    
    return fetchedObjects;
}

+(NSArray *)getQuantitySummaryDetailsForItem:(NSString *)itemNo {
    return nil;
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

+(id) getProjectFromID:(NSString*)projID {
    NSError *retrieveError;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Projects"
                                              inManagedObjectContext:[PRIMECMAPPUtils getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    [fetchRequest setResultType:NSDictionaryResultType];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(projecct_id = %@)", projID];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedObjects = [[PRIMECMAPPUtils getManagedObjectContext] executeFetchRequest:fetchRequest error:&retrieveError];
    
    if (fetchedObjects && [fetchedObjects count] >0){
        id project = [fetchedObjects firstObject];
        return project;
    }
    return NULL;
}

@end
