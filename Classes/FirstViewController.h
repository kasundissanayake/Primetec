//
//  FirstViewController.h
//  TabAndSplitApp
//
//  Created by jey on 11/3/11.
//  Copyright 2011 CSS CORP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GIKMapViewController.h"
#import "MBProgressHUD.h"

@interface FirstViewController : GIKMapViewController<GIKCalloutDetailDataSource,UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
{
    UINavigationController *__weak detailedNavigationController;
}
@property(nonatomic,strong)IBOutlet UIView *imageSubView;
@property(nonatomic,weak) UINavigationController *detailedNavigationController;
@property (nonatomic,weak) NSString *mapId;
@property (strong, nonatomic) MBProgressHUD *hud;
@end
