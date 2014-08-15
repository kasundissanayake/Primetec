//
//  ExpenseReportCell.m
//  TabAndSplitApp
//
//  Created by Prime on 7/2/14.
//
//

#import "ExpenseReportCell.h"

@implementation ExpenseReportCell
@synthesize lblDate,lblDescription,lblJobNo,lblMilage,lblRate,lblTotal,lblType;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
