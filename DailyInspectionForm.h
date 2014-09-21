//
//  DailyInspectionForm.h
//  PRIMECMAPP
//
//  Created by Kasun Dissanayake on 8/16/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ExtendedManagedObject.h"

@interface DailyInspectionForm : ExtendedManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * competentPerson;
@property (nonatomic, retain) NSString * contractor;
@property (nonatomic, retain) NSNumber * contractorsHoursOfWork;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * dIFHeader;
@property (nonatomic, retain) NSString * e_Mail;
@property (nonatomic, retain) NSString * iFName1;
@property (nonatomic, retain) NSString * iFName2;
@property (nonatomic, retain) NSString * iFName3;
@property (nonatomic, retain) NSString * iFName4;
@property (nonatomic, retain) NSString * iFTitle1;
@property (nonatomic, retain) NSString * iFTitle2;
@property (nonatomic, retain) NSString * iFTitle3;
@property (nonatomic, retain) NSString * iFTitle4;
@property (nonatomic, retain) NSString * images_uploaded;
@property (nonatomic, retain) NSString * inspectionID;
@property (nonatomic, retain) NSString * inspectorSign;
@property (nonatomic, retain) NSString * oVJName1;
@property (nonatomic, retain) NSString * oVJName2;
@property (nonatomic, retain) NSString * oVJName3;
@property (nonatomic, retain) NSString * oVJName4;
@property (nonatomic, retain) NSString * oVJTitle1;
@property (nonatomic, retain) NSString * oVJTitle2;
@property (nonatomic, retain) NSString * oVJTitle3;
@property (nonatomic, retain) NSString * oVJTitle4;
@property (nonatomic, retain) NSString * p_o_Box;
@property (nonatomic, retain) NSString * project;
@property (nonatomic, retain) NSString * project_id;
@property (nonatomic, retain) NSString * sketch_images;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * telephone_No;
@property (nonatomic, retain) NSString * town_city;
@property (nonatomic, retain) NSString * wDODepartmentOrCompany1;
@property (nonatomic, retain) NSString * wDODepartmentOrCompany2;
@property (nonatomic, retain) NSString * wDODepartmentOrCompany3;
@property (nonatomic, retain) NSString * wDODepartmentOrCompany4;
@property (nonatomic, retain) NSString * wDODescriptionOfWork1;
@property (nonatomic, retain) NSString * wDODescriptionOfWork2;
@property (nonatomic, retain) NSString * wDODescriptionOfWork3;
@property (nonatomic, retain) NSString * wDODescriptionOfWork4;
@property (nonatomic, retain) NSString * workDoneBy;
@property (nonatomic, retain) NSString * zip_Code;
@property (nonatomic, retain) NSString * report_No;
@property (nonatomic, retain) NSString * con_Name;
@property (nonatomic, retain) NSString * weather;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * printedName;
@property (nonatomic, retain) NSString * original_Calendar_Days;
@property (nonatomic, retain) NSString * calendar_Days_Used;
@property (nonatomic, retain) NSString * i_No1;
@property (nonatomic, retain) NSString * i_No2;
@property (nonatomic, retain) NSString * i_No3;
@property (nonatomic, retain) NSString * i_No4;
@property (nonatomic, retain) NSString * i_No5;
@property (nonatomic, retain) NSString * i_Desc1;
@property (nonatomic, retain) NSString * i_Desc2;
@property (nonatomic, retain) NSString * i_Desc3;
@property (nonatomic, retain) NSString * i_Desc4;
@property (nonatomic, retain) NSString * i_Desc5;
@property (nonatomic, retain) NSString * i_QTY1;
@property (nonatomic, retain) NSString * i_QTY2;
@property (nonatomic, retain) NSString * i_QTY3;
@property (nonatomic, retain) NSString * i_QTY4;
@property (nonatomic, retain) NSString * i_QTY5;
@property (nonatomic, retain) NSNumber * syncStatus;
@property (nonatomic, retain) NSString * signature;

@end
