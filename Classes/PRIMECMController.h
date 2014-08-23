//
//  PRIMECMController.h
//  PRIMECMAPP
//
//  Created by Kasun Dissanayake on 8/16/14.
//
//

#import <Foundation/Foundation.h>

@interface PRIMECMController : NSObject
+ (int)synchronizeWithServer:(NSString *)url;
+ (void)parseResponse:(id)responseObject;

+ (NSString *) getExpenceIdByProjID:(NSString *)projId;

+(BOOL)saveComplienceImages:(NSString *)username comNotiseNo:(NSString *)comNotiseNo imageName:(NSString *)imageName;
+(BOOL)saveComplienceSignature:(NSString *)username comNotiseNo:(NSString *)comNotiseNo signature:(NSString *)signature;
+(BOOL)saveComplienceSketch:(NSString *)username comNotiseNo:(NSString *)comNotiseNo sketch:(NSString *)sketch;
+ (BOOL)saveComplianceForm:(NSString *)username title:(NSString *)title contractNo:(NSString *)contractNo proDesc:(NSString *)proDesc comTitle:(NSString *)comTitle project:(NSString *)project
                dateIssued:(NSString *)dateIssued conRespon:(NSString *)conRespon to:(NSString *)to dateConStarted:(NSString *)dateConStarted dateConComplteted:(NSString *)dateConCopleted dateRawReport:(NSString *)dateRawReport userId:(NSString *)userId correctiveAction:(NSString *)correctiveAct signature:(NSString *)signature printedName:(NSString *)printedName projId:(NSString *)projId;

+(BOOL)saveNonComplienceImages:(NSString *)username comNotiseNo:(NSString *)comNotiseNo imageName:(NSString *)imageName;
+(BOOL)saveNonComplienceSignature:(NSString *)username comNotiseNo:(NSString *)comNotiseNo signature:(NSString *)signature;
+(BOOL)saveNonComplienceSketch:(NSString *)username comNotiseNo:(NSString *)comNotiseNo sketch:(NSString *)sketch;
+ (BOOL)saveNonComplianceForm:(NSString *)username title:(NSString *)title contractNo:(NSString *)contractNo proDesc:(NSString *)proDesc comTitle:(NSString *)comTitle project:(NSString *)project
                   dateIssued:(NSString *)dateIssued conRespon:(NSString *)conRespon to:(NSString *)to dateConStarted:(NSString *)dateConStarted dateConComplteted:(NSString *)dateConCopleted dateRawReport:(NSString *)dateRawReport userId:(NSString *)userId correctiveAction:(NSString *)correctiveAct signature:(NSString *)signature printedName:(NSString *)printedName projId:(NSString *)projId;


+(BOOL)saveExpencesImages:(NSString *)username comNotiseNo:(NSString *)RecId imageName:(NSString *)imageName;
+ (BOOL)saveExpensec:(NSString *)expId projId:(NSString *)projId header:(NSString *)header date:(NSString *)date desc:(NSString *)desc jobNo:(NSString *)jobNo type:(NSString *)type mil:(NSString *)mil rate:(NSString *)rate totl:(NSString *)totl;


+ (BOOL)saveSummery3:(NSString *)username saveVal:(NSString *)saveVal projId:(NSString *)projId class1:(NSString *)class1 active1:(NSString *)active1 no1:(NSString *)no1 hours1:(NSString *)hours1 rate1:(NSString *)rate1 total1:(NSString *)total1 class2:(NSString *)class2 active2:(NSString *)active2 no2:(NSString *)no2 hours2:(NSString *)hours2 rate2:(NSString *)rate2 total2:(NSString *)total2 class3:(NSString *)class3 active3:(NSString *)active3 no3:(NSString *)no3 hours3:(NSString *)hours3 rate3:(NSString *)rate3 total3:(NSString *)total3 class4:(NSString *)class4 active4:(NSString *)active4 no4:(NSString *)no4 hours4:(NSString *)hours4 rate4:(NSString *)rate4 total4:(NSString *)total4 class5:(NSString *)class5 active5:(NSString *)active5 no5:(NSString *)no5 hours5:(NSString *)hours5 rate5:(NSString *)rate5 total5:(NSString *)total5 inspecter:(NSString *)inspecter signame1:(NSString *)signame1 signame2:(NSString *)signame2 dateIns:(NSString *)dateIns projMan:(NSString *)projMan dateCr:(NSString *)dateCr totalToDate:(NSString *)totalToDate l5:(NSString *)l5;

+ (BOOL)saveSummery2:(NSString *)username saveVal:(NSString *)saveVal projId:(NSString *)projId desc1:(NSString *)desc1 qty1:(NSString *)qty1 rate1:(NSString *)rate1 total1:(NSString *)total1 desc2:(NSString *)desc2 qty2:(NSString *)qty2 rate2:(NSString *)rate2 total2:(NSString *)total2 desc3:(NSString *)desc3 qty3:(NSString *)qty3 rate3:(NSString *)rate3 total3:(NSString *)total3 desc4:(NSString *)desc4 qty4:(NSString *)qty4 rate4:(NSString *)rate4 total4:(NSString *)total4 desc5:(NSString *)desc5 qty5:(NSString *)qty5 rate5:(NSString *)rate5 total5:(NSString *)total5 totalTxt:(NSString *)totalTxt insu:(NSString *)insu lTotal:(NSString *)lTotal txt20:(NSString *)txt20 GRTotal:(NSString *)GRTotal;

+ (BOOL)saveProject:(NSString *)username projId:(NSString *)projId phone:(NSString *)phone projName:(NSString *)projName projDesc:(NSString *)projDesc title:(NSString *)title street:(NSString *)street city:(NSString *)city state:(NSString *)state zip:(NSString *)zip date:(NSString *)date clientName:(NSString *)clientName projMgr:(NSString *)projMgr latitude:(NSString *)latitude longitude:(NSString *)longitude inspector:(NSString *)inspector;

@end
