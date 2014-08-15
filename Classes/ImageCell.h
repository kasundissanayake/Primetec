//
//  ImageCell.h
//  BridgeInspection
//
//  Created by Woornika on 1/9/14.
//  Copyright (c) 2014 3SG Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCell : UITableViewCell


@property(nonatomic,strong)IBOutlet UIImageView *imgView;
@property(nonatomic,strong)IBOutlet UILabel *lblTitle;
@property(nonatomic,strong)IBOutlet UITextView *txvDescription;

@end
