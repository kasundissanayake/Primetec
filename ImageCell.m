//
//  ImageCell.m
//  BridgeInspection
//
//  Created by Woornika on 1/9/14.
//  Copyright (c) 2014 3SG Corporation. All rights reserved.
//

#import "ImageCell.h"

@implementation ImageCell
@synthesize txvDescription;
@synthesize lblTitle;
@synthesize imageView;
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
