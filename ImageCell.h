//
//  ImageCell.h
//  BridgeInspection
//
//  Created by Woornika on 1/9/14.
//  Copyright (c) 2014 3SG Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCell : UITableViewCell


@property(nonatomic,retain)IBOutlet UIImageView *imgView;
@property(nonatomic,retain)IBOutlet UILabel *lblTitle;
@property(nonatomic,retain)IBOutlet UITextView *txvDescription;

@end
