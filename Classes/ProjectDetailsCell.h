//
//  ProjectDetailsCell.h
//  TabAndSplitApp
//
//  Created by Prime on 5/27/14.
//
//

#import <UIKit/UIKit.h>

@interface ProjectDetailsCell : UITableViewCell
@property(nonatomic,strong)IBOutlet UILabel *lblProjectName;
@property(nonatomic,strong)IBOutlet UILabel *lblProjectNo;
@property(nonatomic,strong)IBOutlet UILabel *lblProjectAddress;

@property (weak, nonatomic) IBOutlet UILabel *lblCity;


@property (weak, nonatomic) IBOutlet UIImageView *imageTag;

@end
