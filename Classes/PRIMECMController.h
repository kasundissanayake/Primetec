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

+ (BOOL)saveComplianceForm:(NSString *)username complianceNoticeNo:(NSString *)complianceNoticeNo title:(NSString *)title contractNo:(NSString *)contractNo proDesc:(NSString *)proDesc comTitle:(NSString *)comTitle project:(NSString *)project
                dateIssued:(NSString *)dateIssued conRespon:(NSString *)conRespon to:(NSString *)to dateConStarted:(NSString *)dateConStarted dateConComplteted:(NSString *)dateConCopleted dateRawReport:(NSString *)dateRawReport userId:(NSString *)userId correctiveAction:(NSString *)correctiveAct signature:(NSString *)signature printedName:(NSString *)printedName projId:(NSString *)projId
                 sketchImg:(NSString *)sketchImg images_uploaded:(NSString *)images_uploaded;


+ (BOOL)saveNonComplianceForm:(NSString *)username non_ComplianceNoticeNo:(NSString *)non_ComplianceNoticeNo title:(NSString *)title contractNo:(NSString *)contractNo proDesc:(NSString *)proDesc comTitle:(NSString *)comTitle project:(NSString *)project
                   dateIssued:(NSString *)dateIssued conRespon:(NSString *)conRespon to:(NSString *)to dateConStarted:(NSString *)dateConStarted dateConComplteted:(NSString *)dateConCopleted dateRawReport:(NSString *)dateRawReport userId:(NSString *)userId correctiveAction:(NSString *)correctiveAct signature:(NSString *)signature printedName:(NSString *)printedName projId:(NSString *)projId sketchImg:(NSString *)sketchImg images_uploaded:(NSString *)images_uploaded;

+ (BOOL)saveDailyInspectionForm:(NSString *)username calendar_Days_Used:(NSString *)calendar_Days_Used city:(NSString *)city competentPerson:(NSString *) competentPerson con_Name:(NSString *) con_Name contractor:(NSString *) contractor contractorsHoursOfWork:(NSNumber *) contractorsHoursOfWork date:(NSString *) date dIFHeader:(NSString *) dIFHeader e_Mail:(NSString *) e_Mail i_Desc1:(NSString *) i_Desc1 i_Desc2:(NSString *) i_Desc2 i_Desc3:(NSString *) i_Desc3 i_Desc4:(NSString *) i_Desc4 i_Desc5:(NSString *) i_Desc5 i_No1:(NSString *) i_No1 i_No2:(NSString *) i_No2 i_No3:(NSString *) i_No3 i_No4:(NSString *) i_No4 i_No5:(NSString *) i_No5 i_QTY1:(NSString *) i_QTY1 i_QTY2:(NSString *) i_QTY2 i_QTY3:(NSString *) i_QTY3 i_QTY4:(NSString *) i_QTY4 i_QTY5:(NSString *) i_QTY5 iFName1:(NSString *) iFName1 iFName2:(NSString *) iFName2 iFName3:(NSString *) iFName3 iFName4:(NSString *) iFName4 iFTitle1:(NSString *) iFTitle1 iFTitle2:(NSString *) iFTitle2 iFTitle3:(NSString *) iFTitle3 iFTitle4:(NSString *) iFTitle4 images_uploaded:(NSString *) images_uploaded inspectionID:(NSString *) inspectionID inspectorSign:(NSString *) inspectorSign signature:(NSString*)signature original_Calendar_Days:(NSString *) original_Calendar_Days oVJName1:(NSString *) oVJName1 oVJName2:(NSString *) oVJName2 oVJName3:(NSString *) oVJName3 oVJName4:(NSString *) oVJName4 oVJTitle1:(NSString *) oVJTitle1 oVJTitle2:(NSString *) oVJTitle2 oVJTitle3:(NSString *) oVJTitle3 oVJTitle4:(NSString *) oVJTitle4 p_o_Box:(NSString *) p_o_Box printedName:(NSString *) printedName project:(NSString *) project project_id:(NSString *) project_id report_No:(NSString *) report_No sketch_images:(NSString *) sketch_images state:(NSString *) state telephone_No:(NSString *) telephone_No time:(NSString *) time town_city:(NSString *) town_city wDODepartmentOrCompany1:(NSString *) wDODepartmentOrCompany1 wDODepartmentOrCompany2:(NSString *) wDODepartmentOrCompany2 wDODepartmentOrCompany3:(NSString *) wDODepartmentOrCompany3 wDODepartmentOrCompany4:(NSString *) wDODepartmentOrCompany4 wDODescriptionOfWork1:(NSString *) wDODescriptionOfWork1 wDODescriptionOfWork2:(NSString *) wDODescriptionOfWork2 wDODescriptionOfWork3:(NSString *) wDODescriptionOfWork3 wDODescriptionOfWork4:(NSString *) wDODescriptionOfWork4 weather:(NSString *)weather workDoneBy:(NSString *) workDoneBy zip_Code:(NSString *) zip_Code;

+ (BOOL)saveDailyInspectionItem:(NSString *)username date:(NSString *)date desc:(NSString *) desc inspectionID:(NSString *) inspectionID no:(NSString *) no qty:(NSString *) qty;

+ (BOOL)saveQuantitySummaryDetails:(NSString *)username est_qty:(NSString *)est_qty item_no:(NSString *) item_no project:(NSString *) project project_id:(NSString *) project_id unit:(NSString *) unit unit_price:(NSString *) unit_price user:(NSString *) user;

+ (BOOL)saveQuantitySummaryItems:(NSString *)username accum:(NSString *) accum daily:(NSString *) daily date:(NSString *) date item_no:(NSString *) item_no location_station:(NSString *) location_station quantity_sum_details_no:(NSString *) quantity_sum_details_no;

/*

+ (BOOL)saveExpenseForm:(NSString *)username approvedBy:(NSString *)approvedBy attachment:(NSString *)attachment checkNo:(NSString *)checkNo date:(NSString *)date employeeNo:(NSString *)employeeNo eMPName:(NSString *)eMPName eRCashAdvance:(NSString *)eRCashAdvance eRFHeader:(NSString *)eRFHeader eRReimbursement:(NSString *)eRReimbursement eXReportNo:(NSString *)eXReportNo images_uploaded:(NSString *)images_uploaded project_id:(NSString *)project_id signature:(NSString *)signature weekEnding:(NSString *)weekEnding;*/


//radha

+ (BOOL)saveExpenseForm:(NSString *)username approvedBy:(NSString *)approvedBy attachment:(NSString *)attachment checkNo:(NSString *)checkNo date:(NSString *)date employeeNo:(NSString *)employeeNo eMPName:(NSString *)eMPName eRCashAdvance:(NSString *)eRCashAdvance eRFHeader:(NSString *)eRFHeader eRReimbursement:(NSString *)eRReimbursement eXReportNo:(NSString *)eXReportNo images_uploaded:(NSString *)images_uploaded project_id:(NSString *)project_id signature:(NSString *)signature weekEnding:(NSString *)weekEnding isEdit:(BOOL)isEdit;



/*
+ (BOOL)saveExpenseData:(NSString *)username eRDate1:(NSString *)eRDate1 eRDescription1:(NSString *)eRDescription1 eRJobNo1:(NSString *)eRJobNo1 eRPAMilage1:(NSString *)eRPAMilage1 eRPARate1:(NSString *)eRPARate1 eRTotal1:(NSString *)eRTotal1 eRType1:(NSString *)eRType1 eXReportNo:(NSString *)eXReportNo images_uploaded:(NSString *)images_uploaded;*/

//radha

+ (BOOL)saveExpenseData:(NSString *)username eRDate1:(NSString *)eRDate1 eRDescription1:(NSString *)eRDescription1 eRJobNo1:(NSString *)eRJobNo1 eRPAMilage1:(NSString *)eRPAMilage1 eRPARate1:(NSString *)eRPARate1 eRTotal1:(NSString *)eRTotal1 eRType1:(NSString *)eRType1 eXReportNo:(NSString *)eXReportNo images_uploaded:(NSString *)images_uploaded project_id:(NSString *)project_id imgPath:(NSString *)imgPath ;


+ (BOOL)saveSummarySheet1:(NSString *)username city:(NSString *)city conPeWork:(NSString *) conPeWork constructionOrder:(NSString *) constructionOrder contractor:(NSString *) contractor date:(NSString *) date descr:(NSString *) descr federalAidNumber:(NSString *) federalAidNumber healWelAndPension:(NSString *) healWelAndPension insAndTaxesOnItem1:(NSString *) insAndTaxesOnItem1 itemDescount20per:(NSString *) itemDescount20per lAAmount1:(NSString *) lAAmount1 lAAmount2:(NSString *) lAAmount2 lAAmount3:(NSString *) lAAmount3 lAAmount4:(NSString *) lAAmount4 lAAmount5:(NSString *) lAAmount5 lAClass1:(NSString *) lAClass1 lAClass2:(NSString *) lAClass2 lAClass3:(NSString *) lAClass3 lAClass4:(NSString *) lAClass4 lAClass5:(NSString *) lAClass5 lANo1:(NSString *) lANo1 lANo2:(NSString *) lANo2 lANo3:(NSString *) lANo3 lANo4:(NSString *) lANo4 lANo5:(NSString *) lANo5 lARate1:(NSString *) lARate1 lARate2:(NSString *) lARate2 lARate3:(NSString *) lARate3 lARate4:(NSString *) lARate4 lARate5:(NSString *) lARate5 lATotalHours1:(NSString *) lATotalHours1 lATotalHours2:(NSString *) lATotalHours2 lATotalHours3:(NSString *) lATotalHours3 lATotalHours4:(NSString *) lATotalHours4 lATotalHours5:(NSString *) lATotalHours5 pOBox:(NSString *) pOBox printedName:(NSString *) printedName project_id:(NSString *) project_id projectNo:(NSString *) projectNo reportNo:(NSString *) reportNo sMSheetNo:(NSString *) sMSheetNo sSHeader:(NSString *) sSHeader state:(NSString *) state telephoneNo:(NSString *) telephoneNo total:(NSString *) total totalLabor:(NSString *) totalLabor zip:(NSString *) zip;


+ (BOOL)saveSummery2:(NSString *)username additionalDiscount:(NSString *) additionalDiscount lessDiscount:(NSString *) lessDiscount mEAmount1:(NSString *) mEAmount1 mEAmount2:(NSString *) mEAmount2 mEAmount3:(NSString *) mEAmount3 mEAmount4:(NSString *) mEAmount4 mEAmount5:(NSString *) mEAmount5 mEDescription1:(NSString *) mEDescription1 mEDescription2:(NSString *) mEDescription2 mEDescription3:(NSString *) mEDescription3 mEDescription4:(NSString *) mEDescription4 mEDescription5:(NSString *) mEDescription5 mEQuantity1:(NSString *) mEQuantity1 mEQuantity2:(NSString *) mEQuantity2 mEQuantity3:(NSString *) mEQuantity3 mEQuantity4:(NSString *) mEQuantity4 mEQuantity5:(NSString *) mEQuantity5 mEUnitPrice1:(NSString *) mEUnitPrice1 mEUnitPrice2:(NSString *) mEUnitPrice2 mEUnitPrice3:(NSString *) mEUnitPrice3 mEUnitPrice4:(NSString *) mEUnitPrice4 mEUnitPrice5:(NSString *) mEUnitPrice5 project_id:(NSString *) project_id sMSSheetNo:(NSString *) sMSSheetNo total1:(NSString *) total1 total2:(NSString *) total2 total3:(NSString *) total3;

+ (BOOL)saveSummery3:(NSString *)username contractorRepresentative:(NSString *) contractorRepresentative dailyTotal:(NSString *) dailyTotal date1:(NSString *) date1 date2:(NSString *) date2 eQAmount1:(NSString *) eQAmount1 eQAmount2:(NSString *) eQAmount2 eQAmount3:(NSString *) eQAmount3 eQAmount4:(NSString *) eQAmount4 eQAmount5:(NSString *) eQAmount5 eQIdleActive1:(NSString *) eQIdleActive1 eQIdleActive2:(NSString *) eQIdleActive2 eQIdleActive3:(NSString *) eQIdleActive3 eQIdleActive4:(NSString *) eQIdleActive4 eQIdleActive5:(NSString *) eQIdleActive5 eQNo1:(NSString *) eQNo1 eQNo2:(NSString *) eQNo2 eQNo3:(NSString *) eQNo3 eQNo4:(NSString *) eQNo4 eQNo5:(NSString *) eQNo5 eQRAte1:(NSString *) eQRAte1 eQRAte2:(NSString *) eQRAte2 eQRAte3:(NSString *) eQRAte3 eQRAte4:(NSString *) eQRAte4 eQRAte5:(NSString *) eQRAte5 eQSizeandClass1:(NSString *) eQSizeandClass1 eQSizeandClass2:(NSString *) eQSizeandClass2 eQSizeandClass3:(NSString *) eQSizeandClass3 eQSizeandClass4:(NSString *) eQSizeandClass4 eQSizeandClass5:(NSString *) eQSizeandClass5 eQTotalHours1:(NSString *) eQTotalHours1 eQTotalHours2:(NSString *) eQTotalHours2 eQTotalHours3:(NSString *) eQTotalHours3 eQTotalHours4:(NSString *) eQTotalHours4 eQTotalHours5:(NSString *) eQTotalHours5 inspector:(NSString *) inspector project_id:(NSString *) project_id signature1:(NSString *) signature1 signature2:(NSString *) signature2 sMSheetNo:(NSString *) sMSheetNo total_to_date:(NSString *) total_to_date;


+ (BOOL)saveProject:(NSString *)username projId:(NSString *)projId phone:(NSString *)phone projName:(NSString *)projName projDesc:(NSString *)projDesc title:(NSString *)title street:(NSString *)street city:(NSString *)city state:(NSString *)state zip:(NSString *)zip date:(NSString *)date clientName:(NSString *)clientName projMgr:(NSString *)projMgr latitude:(NSString *)latitude longitude:(NSString *)longitude inspector:(NSString *)inspector;

+ (BOOL) saveAllImages:(NSString *)imgName img:(NSData *)img syncStatus:(int*)syncStatus;

+ (UIImage *) getTheImage:(NSString *)imgName;

+(NSArray *)getDailyInspectionItemsFromInspectionID:(NSString *)inspectionID;


+ (int)synchronizeImagesWithServer;

//radha
+(NSArray *)getQuantitySummaryDetailsForProjectID:(NSString *)projId AndItemNum:(NSString *)item_no;


@end




/************************************Radha**********************/


//
//  PRIMECMController.h
//  PRIMECMAPP
//
//  Created by Kasun Dissanayake on 8/16/14.
//
//


/*
#import <Foundation/Foundation.h>

@interface PRIMECMController : NSObject

+ (int)synchronizeWithServer;

+ (void)parseResponse:(id)responseObject;

+ (NSString *) getExpenceIdByProjID:(NSString *)projId;

+ (BOOL)saveComplianceForm:(NSString *)username complianceNoticeNo:(NSString *)complianceNoticeNo title:(NSString *)title contractNo:(NSString *)contractNo proDesc:(NSString *)proDesc comTitle:(NSString *)comTitle project:(NSString *)project
                dateIssued:(NSString *)dateIssued conRespon:(NSString *)conRespon to:(NSString *)to dateConStarted:(NSString *)dateConStarted dateConComplteted:(NSString *)dateConCopleted dateRawReport:(NSString *)dateRawReport userId:(NSString *)userId correctiveAction:(NSString *)correctiveAct signature:(NSString *)signature printedName:(NSString *)printedName projId:(NSString *)projId
                 sketchImg:(NSString *)sketchImg images_uploaded:(NSString *)images_uploaded;


+ (BOOL)saveNonComplianceForm:(NSString *)username non_ComplianceNoticeNo:(NSString *)non_ComplianceNoticeNo title:(NSString *)title contractNo:(NSString *)contractNo proDesc:(NSString *)proDesc comTitle:(NSString *)comTitle project:(NSString *)project
                   dateIssued:(NSString *)dateIssued conRespon:(NSString *)conRespon to:(NSString *)to dateConStarted:(NSString *)dateConStarted dateConComplteted:(NSString *)dateConCopleted dateRawReport:(NSString *)dateRawReport userId:(NSString *)userId correctiveAction:(NSString *)correctiveAct signature:(NSString *)signature printedName:(NSString *)printedName projId:(NSString *)projId sketchImg:(NSString *)sketchImg images_uploaded:(NSString *)images_uploaded;

+ (BOOL)saveDailyInspectionForm:(NSString *)username calendar_Days_Used:(NSString *)calendar_Days_Used city:(NSString *)city competentPerson:(NSString *) competentPerson con_Name:(NSString *) con_Name contractor:(NSString *) contractor contractorsHoursOfWork:(NSNumber *) contractorsHoursOfWork date:(NSString *) date dIFHeader:(NSString *) dIFHeader e_Mail:(NSString *) e_Mail i_Desc1:(NSString *) i_Desc1 i_Desc2:(NSString *) i_Desc2 i_Desc3:(NSString *) i_Desc3 i_Desc4:(NSString *) i_Desc4 i_Desc5:(NSString *) i_Desc5 i_No1:(NSString *) i_No1 i_No2:(NSString *) i_No2 i_No3:(NSString *) i_No3 i_No4:(NSString *) i_No4 i_No5:(NSString *) i_No5 i_QTY1:(NSString *) i_QTY1 i_QTY2:(NSString *) i_QTY2 i_QTY3:(NSString *) i_QTY3 i_QTY4:(NSString *) i_QTY4 i_QTY5:(NSString *) i_QTY5 iFName1:(NSString *) iFName1 iFName2:(NSString *) iFName2 iFName3:(NSString *) iFName3 iFName4:(NSString *) iFName4 iFTitle1:(NSString *) iFTitle1 iFTitle2:(NSString *) iFTitle2 iFTitle3:(NSString *) iFTitle3 iFTitle4:(NSString *) iFTitle4 images_uploaded:(NSString *) images_uploaded inspectionID:(NSString *) inspectionID inspectorSign:(NSString *) inspectorSign signature:(NSString*)signature original_Calendar_Days:(NSString *) original_Calendar_Days oVJName1:(NSString *) oVJName1 oVJName2:(NSString *) oVJName2 oVJName3:(NSString *) oVJName3 oVJName4:(NSString *) oVJName4 oVJTitle1:(NSString *) oVJTitle1 oVJTitle2:(NSString *) oVJTitle2 oVJTitle3:(NSString *) oVJTitle3 oVJTitle4:(NSString *) oVJTitle4 p_o_Box:(NSString *) p_o_Box printedName:(NSString *) printedName project:(NSString *) project project_id:(NSString *) project_id report_No:(NSString *) report_No sketch_images:(NSString *) sketch_images state:(NSString *) state telephone_No:(NSString *) telephone_No time:(NSString *) time town_city:(NSString *) town_city wDODepartmentOrCompany1:(NSString *) wDODepartmentOrCompany1 wDODepartmentOrCompany2:(NSString *) wDODepartmentOrCompany2 wDODepartmentOrCompany3:(NSString *) wDODepartmentOrCompany3 wDODepartmentOrCompany4:(NSString *) wDODepartmentOrCompany4 wDODescriptionOfWork1:(NSString *) wDODescriptionOfWork1 wDODescriptionOfWork2:(NSString *) wDODescriptionOfWork2 wDODescriptionOfWork3:(NSString *) wDODescriptionOfWork3 wDODescriptionOfWork4:(NSString *) wDODescriptionOfWork4 weather:(NSString *)weather workDoneBy:(NSString *) workDoneBy zip_Code:(NSString *) zip_Code;

+ (BOOL)saveDailyInspectionItem:(NSString *)username date:(NSString *)date desc:(NSString *) desc inspectionID:(NSString *) inspectionID no:(NSString *) no qty:(NSString *) qty;

+ (BOOL)saveQuantitySummaryDetails:(NSString *)username est_qty:(NSString *)est_qty item_no:(NSString *) item_no project:(NSString *) project project_id:(NSString *) project_id unit:(NSString *) unit unit_price:(NSString *) unit_price user:(NSString *) user idStr:(NSString *)idStr isEdit:(BOOL)isEdit;

+ (BOOL)saveQuantitySummaryItems:(NSString *)username accum:(NSString *) accum daily:(NSString *) daily date:(NSString *) date item_no:(NSString *) item_no location_station:(NSString *) location_station quantity_sum_details_no:(NSString *) quantity_sum_details_no;



+ (BOOL)saveExpenseForm:(NSString *)username approvedBy:(NSString *)approvedBy attachment:(NSString *)attachment checkNo:(NSString *)checkNo date:(NSString *)date employeeNo:(NSString *)employeeNo eMPName:(NSString *)eMPName eRCashAdvance:(NSString *)eRCashAdvance eRFHeader:(NSString *)eRFHeader eRReimbursement:(NSString *)eRReimbursement eXReportNo:(NSString *)eXReportNo images_uploaded:(NSString *)images_uploaded project_id:(NSString *)project_id signature:(NSString *)signature weekEnding:(NSString *)weekEnding isEdit:(BOOL)isEdit;

+ (BOOL)saveExpenseData:(NSString *)username eRDate1:(NSString *)eRDate1 eRDescription1:(NSString *)eRDescription1 eRJobNo1:(NSString *)eRJobNo1 eRPAMilage1:(NSString *)eRPAMilage1 eRPARate1:(NSString *)eRPARate1 eRTotal1:(NSString *)eRTotal1 eRType1:(NSString *)eRType1 eXReportNo:(NSString *)eXReportNo images_uploaded:(NSString *)images_uploaded project_id:(NSString *)project_id imgPath:(NSString *)imgPath ;

+ (BOOL)saveSummarySheet1:(NSString *)username city:(NSString *)city conPeWork:(NSString *) conPeWork constructionOrder:(NSString *) constructionOrder contractor:(NSString *) contractor date:(NSString *) date descr:(NSString *) descr federalAidNumber:(NSString *) federalAidNumber healWelAndPension:(NSString *) healWelAndPension insAndTaxesOnItem1:(NSString *) insAndTaxesOnItem1 itemDescount20per:(NSString *) itemDescount20per lAAmount1:(NSString *) lAAmount1 lAAmount2:(NSString *) lAAmount2 lAAmount3:(NSString *) lAAmount3 lAAmount4:(NSString *) lAAmount4 lAAmount5:(NSString *) lAAmount5 lAClass1:(NSString *) lAClass1 lAClass2:(NSString *) lAClass2 lAClass3:(NSString *) lAClass3 lAClass4:(NSString *) lAClass4 lAClass5:(NSString *) lAClass5 lANo1:(NSString *) lANo1 lANo2:(NSString *) lANo2 lANo3:(NSString *) lANo3 lANo4:(NSString *) lANo4 lANo5:(NSString *) lANo5 lARate1:(NSString *) lARate1 lARate2:(NSString *) lARate2 lARate3:(NSString *) lARate3 lARate4:(NSString *) lARate4 lARate5:(NSString *) lARate5 lATotalHours1:(NSString *) lATotalHours1 lATotalHours2:(NSString *) lATotalHours2 lATotalHours3:(NSString *) lATotalHours3 lATotalHours4:(NSString *) lATotalHours4 lATotalHours5:(NSString *) lATotalHours5 pOBox:(NSString *) pOBox printedName:(NSString *) printedName project_id:(NSString *) project_id projectNo:(NSString *) projectNo reportNo:(NSString *) reportNo sMSheetNo:(NSString *) sMSheetNo sSHeader:(NSString *) sSHeader state:(NSString *) state telephoneNo:(NSString *) telephoneNo total:(NSString *) total totalLabor:(NSString *) totalLabor zip:(NSString *) zip isEdit:(BOOL)isEdit;


+ (BOOL)saveSummery2:(NSString *)username additionalDiscount:(NSString *) additionalDiscount lessDiscount:(NSString *) lessDiscount mEAmount1:(NSString *) mEAmount1 mEAmount2:(NSString *) mEAmount2 mEAmount3:(NSString *) mEAmount3 mEAmount4:(NSString *) mEAmount4 mEAmount5:(NSString *) mEAmount5 mEDescription1:(NSString *) mEDescription1 mEDescription2:(NSString *) mEDescription2 mEDescription3:(NSString *) mEDescription3 mEDescription4:(NSString *) mEDescription4 mEDescription5:(NSString *) mEDescription5 mEQuantity1:(NSString *) mEQuantity1 mEQuantity2:(NSString *) mEQuantity2 mEQuantity3:(NSString *) mEQuantity3 mEQuantity4:(NSString *) mEQuantity4 mEQuantity5:(NSString *) mEQuantity5 mEUnitPrice1:(NSString *) mEUnitPrice1 mEUnitPrice2:(NSString *) mEUnitPrice2 mEUnitPrice3:(NSString *) mEUnitPrice3 mEUnitPrice4:(NSString *) mEUnitPrice4 mEUnitPrice5:(NSString *) mEUnitPrice5 project_id:(NSString *) project_id sMSSheetNo:(NSString *) sMSSheetNo total1:(NSString *) total1 total2:(NSString *) total2 total3:(NSString *) total3 isEdit:(BOOL)isEdit;

+ (BOOL)saveSummery3:(NSString *)username contractorRepresentative:(NSString *) contractorRepresentative dailyTotal:(NSString *) dailyTotal date1:(NSString *) date1 date2:(NSString *) date2 eQAmount1:(NSString *) eQAmount1 eQAmount2:(NSString *) eQAmount2 eQAmount3:(NSString *) eQAmount3 eQAmount4:(NSString *) eQAmount4 eQAmount5:(NSString *) eQAmount5 eQIdleActive1:(NSString *) eQIdleActive1 eQIdleActive2:(NSString *) eQIdleActive2 eQIdleActive3:(NSString *) eQIdleActive3 eQIdleActive4:(NSString *) eQIdleActive4 eQIdleActive5:(NSString *) eQIdleActive5 eQNo1:(NSString *) eQNo1 eQNo2:(NSString *) eQNo2 eQNo3:(NSString *) eQNo3 eQNo4:(NSString *) eQNo4 eQNo5:(NSString *) eQNo5 eQRAte1:(NSString *) eQRAte1 eQRAte2:(NSString *) eQRAte2 eQRAte3:(NSString *) eQRAte3 eQRAte4:(NSString *) eQRAte4 eQRAte5:(NSString *) eQRAte5 eQSizeandClass1:(NSString *) eQSizeandClass1 eQSizeandClass2:(NSString *) eQSizeandClass2 eQSizeandClass3:(NSString *) eQSizeandClass3 eQSizeandClass4:(NSString *) eQSizeandClass4 eQSizeandClass5:(NSString *) eQSizeandClass5 eQTotalHours1:(NSString *) eQTotalHours1 eQTotalHours2:(NSString *) eQTotalHours2 eQTotalHours3:(NSString *) eQTotalHours3 eQTotalHours4:(NSString *) eQTotalHours4 eQTotalHours5:(NSString *) eQTotalHours5 inspector:(NSString *) inspector project_id:(NSString *) project_id signature1:(NSString *) signature1 signature2:(NSString *) signature2 sMSheetNo:(NSString *) sMSheetNo total_to_date:(NSString *) total_to_date isEdit:(BOOL)isEdit;


+ (BOOL)saveProject:(NSString *)username projId:(NSString *)projId phone:(NSString *)phone projName:(NSString *)projName projDesc:(NSString *)projDesc title:(NSString *)title street:(NSString *)street city:(NSString *)city state:(NSString *)state zip:(NSString *)zip date:(NSString *)date clientName:(NSString *)clientName projMgr:(NSString *)projMgr latitude:(NSString *)latitude longitude:(NSString *)longitude inspector:(NSString *)inspector;

+ (BOOL) saveAllImages:(NSString *)imgName img:(NSData *)img;

+ (UIImage *) getTheImage:(NSString *)imgName;

+(NSArray *)getDailyInspectionItemsFromInspectionID:(NSString *)inspectionID;

//Radha
+(NSArray *)getQuantitySummaryDetailsForProjectID:(NSString *)projId AndItemNum:(NSString *)item_no;
+(int)totalObjectsOfSummarySheet;

@end*/



/***********************************************/




