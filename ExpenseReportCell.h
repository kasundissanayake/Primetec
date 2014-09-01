//
//  ExpenseReportCell.h
//  TabAndSplitApp
//
//  Created by Prime on 7/2/14.
//
//

#import <UIKit/UIKit.h>

@interface ExpenseReportCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblJobNo;
@property (weak, nonatomic) IBOutlet UILabel *lblType;
@property (weak, nonatomic) IBOutlet UILabel *lblMilage;
@property (weak, nonatomic) IBOutlet UILabel *lblRate;
@property (weak, nonatomic) IBOutlet UILabel *lblTotal;

@end
