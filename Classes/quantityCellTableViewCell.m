//
//  quantityCellTableViewCell.m
//  PRIMECMAPP
//
//  Created by 3SG Corporation on 8/24/14.
//
//

#import "quantityCellTableViewCell.h"

@implementation quantityCellTableViewCell

@synthesize i_Accum,i_Daily,i_Date,i_number,imageView,indentationLevel,location_station;



- (void)awakeFromNib
{
    // Initialization code
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end