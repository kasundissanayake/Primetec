//
//  ReportDetailsCell.h
//  TabAndSplitApp
//
//  Created by Prime on 5/28/14.
//
//

#import <UIKit/UIKit.h>

@interface ReportDetailsCell : UITableViewCell
@property(nonatomic,strong)IBOutlet UILabel *lblReportName;
@property(nonatomic,strong)IBOutlet UILabel *lblReportDate;
@property(nonatomic,strong)IBOutlet UILabel *lblReportInspectedBy;
@property(nonatomic,strong)IBOutlet UILabel *lblReportProjectManager;

@end
