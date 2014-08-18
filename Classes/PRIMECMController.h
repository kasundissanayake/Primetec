//
//  PRIMECMController.h
//  PRIMECMAPP
//
//  Created by Kasun Dissanayake on 8/16/14.
//
//

#import <Foundation/Foundation.h>

@interface PRIMECMController : NSObject
- (void)synchronizeWithServer:(NSString *)url;
- (void)parseResponse:(id)responseObject;

- (NSString *) getExpenceIdByProjID:(NSString *)projId;

-(void)uploadComplienceImages:(NSString *)username comNotiseNo:(NSString *)comNotiseNo imageName:(NSString *)imageName;
-(void)uploadComplienceSignature:(NSString *)username comNotiseNo:(NSString *)comNotiseNo signature:(NSString *)signature;
-(void)uploadComplienceSketch:(NSString *)username comNotiseNo:(NSString *)comNotiseNo sketch:(NSString *)sketch;
- (void)saveComplianceForm:(NSString *)username title:(NSString *)title contractNo:(NSString *)contractNo proDesc:(NSString *)proDesc comTitle:(NSString *)comTitle project:(NSString *)project
                dateIssued:(NSString *)dateIssued conRespon:(NSString *)conRespon to:(NSString *)to dateConStarted:(NSString *)dateConStarted dateConComplteted:(NSString *)dateConCopleted dateRawReport:(NSString *)dateRawReport userId:(NSString *)userId correctiveAction:(NSString *)correctiveAct signature:(NSString *)signature printedName:(NSString *)printedName projId:(NSString *)projId;

-(void)uploadNonComplienceImages:(NSString *)username comNotiseNo:(NSString *)comNotiseNo imageName:(NSString *)imageName;
-(void)uploadNonComplienceSignature:(NSString *)username comNotiseNo:(NSString *)comNotiseNo signature:(NSString *)signature;
-(void)uploadNonComplienceSketch:(NSString *)username comNotiseNo:(NSString *)comNotiseNo sketch:(NSString *)sketch;
- (void)saveNonComplianceForm:(NSString *)username title:(NSString *)title contractNo:(NSString *)contractNo proDesc:(NSString *)proDesc comTitle:(NSString *)comTitle project:(NSString *)project
                   dateIssued:(NSString *)dateIssued conRespon:(NSString *)conRespon to:(NSString *)to dateConStarted:(NSString *)dateConStarted dateConComplteted:(NSString *)dateConCopleted dateRawReport:(NSString *)dateRawReport userId:(NSString *)userId correctiveAction:(NSString *)correctiveAct signature:(NSString *)signature printedName:(NSString *)printedName projId:(NSString *)projId;


-(void)uploadExpencesImages:(NSString *)username comNotiseNo:(NSString *)RecId imageName:(NSString *)imageName;
- (void)saveExpensec:(NSString *)expId projId:(NSString *)projId header:(NSString *)header date:(NSString *)date desc:(NSString *)desc jobNo:(NSString *)jobNo type:(NSString *)type mil:(NSString *)mil rate:(NSString *)rate totl:(NSString *)totl;



@end
