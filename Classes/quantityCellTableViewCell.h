//
//  quantityCellTableViewCell.h
//  PRIMECMAPP
//
//  Created by 3SG Corporation on 8/24/14.
//
//

#import <UIKit/UIKit.h>

@interface quantityCellTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *i_number;

@property (strong, nonatomic) IBOutlet UILabel *i_Date;

@property (strong, nonatomic) IBOutlet UILabel *i_location_Satation;

@property (strong, nonatomic) IBOutlet UILabel *i_Daily;
@property (weak, nonatomic) IBOutlet UILabel *location_station;

@property (strong, nonatomic) IBOutlet UILabel *i_Accum;
@end
