//
//  PRIMECMController.h
//  PRIMECMAPP
//
//  Created by Kasun Dissanayake on 8/16/14.
//
//

#import <Foundation/Foundation.h>

@interface PRIMECMController : NSObject

+ (int)synchronizeWithServer;

+ (void)parseResponse:(id)responseObject;

+ (NSString *) getExpenceIdByProjID:(NSString *)projId;

+ (BOOL)saveComplianceForm:(NSString *)username title:(NSString *)title contractNo:(NSString *)contractNo proDesc:(NSString *)proDesc comTitle:(NSString *)comTitle project:(NSString *)project
                dateIssued:(NSString *)dateIssued conRespon:(NSString *)conRespon to:(NSString *)to dateConStarted:(NSString *)dateConStarted dateConComplteted:(NSString *)dateConCopleted dateRawReport:(NSString *)dateRawReport userId:(NSString *)userId correctiveAction:(NSString *)correctiveAct signature:(NSString *)signature printedName:(NSString *)printedName projId:(NSString *)projId
                      sketchImg:(NSString *)sketchImg images_uploaded:(NSString *)images_uploaded;


+ (BOOL)saveNonComplianceForm:(NSString *)username title:(NSString *)title contractNo:(NSString *)contractNo proDesc:(NSString *)proDesc comTitle:(NSString *)comTitle project:(NSString *)project
                   dateIssued:(NSString *)dateIssued conRespon:(NSString *)conRespon to:(NSString *)to dateConStarted:(NSString *)dateConStarted dateConComplteted:(NSString *)dateConCopleted dateRawReport:(NSString *)dateRawReport userId:(NSString *)userId correctiveAction:(NSString *)correctiveAct signature:(NSString *)signature printedName:(NSString *)printedName projId:(NSString *)projId sketchImg:(NSString *)sketchImg images_uploaded:(NSString *)images_uploaded;



+ (BOOL)saveExpenseForm:(NSString *)expId projId:(NSString *)projId header:(NSString *)header date:(NSString *)date desc:(NSString *)desc jobNo:(NSString *)jobNo type:(NSString *)type mil:(NSString *)mil rate:(NSString *)rate totl:(NSString *)totl;

+ (BOOL)saveExpenseData:(NSString *)eRDate1 eRDescription1:(NSString *)eRDescription1 eRJobNo1:(NSString *)eRJobNo1 eRPAMilage1:(NSString *)eRPAMilage1 eRPARate1:(NSString *)eRPARate1 eRTotal1:(NSString *)eRTotal1 eRType1:(NSString *)eRType1 eXReportNo:(NSString *)eXReportNo images_uploaded:(NSString *)images_uploaded;



+ (BOOL)saveSummery3:(NSString *)username saveVal:(NSString *)saveVal projId:(NSString *)projId class1:(NSString *)class1 active1:(NSString *)active1 no1:(NSString *)no1 hours1:(NSString *)hours1 rate1:(NSString *)rate1 total1:(NSString *)total1 class2:(NSString *)class2 active2:(NSString *)active2 no2:(NSString *)no2 hours2:(NSString *)hours2 rate2:(NSString *)rate2 total2:(NSString *)total2 class3:(NSString *)class3 active3:(NSString *)active3 no3:(NSString *)no3 hours3:(NSString *)hours3 rate3:(NSString *)rate3 total3:(NSString *)total3 class4:(NSString *)class4 active4:(NSString *)active4 no4:(NSString *)no4 hours4:(NSString *)hours4 rate4:(NSString *)rate4 total4:(NSString *)total4 class5:(NSString *)class5 active5:(NSString *)active5 no5:(NSString *)no5 hours5:(NSString *)hours5 rate5:(NSString *)rate5 total5:(NSString *)total5 inspecter:(NSString *)inspecter signame1:(NSString *)signame1 signame2:(NSString *)signame2 dateIns:(NSString *)dateIns projMan:(NSString *)projMan dateCr:(NSString *)dateCr totalToDate:(NSString *)totalToDate l5:(NSString *)l5;

+ (BOOL)saveSummery2:(NSString *)username saveVal:(NSString *)saveVal projId:(NSString *)projId desc1:(NSString *)desc1 qty1:(NSString *)qty1 rate1:(NSString *)rate1 total1:(NSString *)total1 desc2:(NSString *)desc2 qty2:(NSString *)qty2 rate2:(NSString *)rate2 total2:(NSString *)total2 desc3:(NSString *)desc3 qty3:(NSString *)qty3 rate3:(NSString *)rate3 total3:(NSString *)total3 desc4:(NSString *)desc4 qty4:(NSString *)qty4 rate4:(NSString *)rate4 total4:(NSString *)total4 desc5:(NSString *)desc5 qty5:(NSString *)qty5 rate5:(NSString *)rate5 total5:(NSString *)total5 totalTxt:(NSString *)totalTxt insu:(NSString *)insu lTotal:(NSString *)lTotal txt20:(NSString *)txt20 GRTotal:(NSString *)GRTotal;

+ (BOOL)saveProject:(NSString *)username projId:(NSString *)projId phone:(NSString *)phone projName:(NSString *)projName projDesc:(NSString *)projDesc title:(NSString *)title street:(NSString *)street city:(NSString *)city state:(NSString *)state zip:(NSString *)zip date:(NSString *)date clientName:(NSString *)clientName projMgr:(NSString *)projMgr latitude:(NSString *)latitude longitude:(NSString *)longitude inspector:(NSString *)inspector;



//start brin
+ (BOOL)saveDailyinspectionForm:(NSString *)username dIFHeader:(NSString *)dIFHeader contractor:(NSString *)contractor report_No:(NSString *)report_No con_Name:(NSString *)con_Name p_o_Box:(NSString *)p_o_Box
                           city:(NSString *)city state:(NSString *)state zip_Code:(NSString *)zip_Code telephone_No:(NSString *)telephone_No date:(NSString *)date competentPerson:(NSString *)competentPerson town_city:(NSString *)town_city weather:(NSString *)weather time:(NSString *)time project:(NSString *)project e_Mail:(NSString *)e_Mail workDoneBy:(NSString *)workDoneBy contractorsHoursOfWork:(NSString *)contractorsHoursOfWork  printedName:(NSString *)printedName project_id:(NSString *)project_id signature:(NSString *)signature original_Calendar_Days:(NSString *)original_Calendar_Days calendar_Days_Used:(NSString *)calendar_Days_Used  sketchImg:(NSString *)sketchImg images_uploaded:(NSString *)images_uploaded oVJName1:(NSString *)oVJName1 oVJName2:(NSString *)oVJName2 oVJName3:(NSString *)oVJName3 oVJName4:(NSString *)oVJName4 oVJTitle1:(NSString *)oVJTitle1 oVJTitle2:(NSString *)oVJTitle2 oVJTitle3:(NSString *)oVJTitle3 oVJTitle4:(NSString *)oVJTitle4;



/*
 
 
 iFName1:(NSString *)iFName1 iFName2:(NSString *)iFName2 iFName3:(NSString *)iFName3 iFName4:(NSString *)iFName4 iFTitle1:(NSString *)iFTitle1 iFTitle2:(NSString *)iFTitle2 iFTitle3:(NSString *)iFTitle3 iFTitle4:(NSString *)iFTitle4 wDODepartmentOrCompany1:(NSString *)wDODepartmentOrCompany1 wDODepartmentOrCompany2:(NSString *)wDODepartmentOrCompany2 wDODepartmentOrCompany3:(NSString *)wDODepartmentOrCompany3 wDODepartmentOrCompany4:(NSString *)wDODepartmentOrCompany4 wDODescriptionOfWork1:(NSString *)wDODescriptionOfWork1 wDODescriptionOfWork2:(NSString *)wDODescriptionOfWork2 wDODescriptionOfWork3:(NSString *)wDODescriptionOfWork3 wDODescriptionOfWork4:(NSString *)wDODescriptionOfWork4;
 
 
 */



//end brin


+ (BOOL) saveAllImages:(NSString *)imgName img:(NSData *)img;

+ (UIImage *) getTheImage:(NSString *)imgName;

@end
