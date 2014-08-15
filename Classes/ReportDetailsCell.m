//
//  ReportDetailsCell.m
//  TabAndSplitApp
//
//  Created by Prime on 5/28/14.
//
//

#import "ReportDetailsCell.h"

@implementation ReportDetailsCell
@synthesize lblReportDate,lblReportInspectedBy,lblReportName,lblReportProjectManager;

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
