//
//  HotelDetailViewController.h
//  AnimatedCallout
//
//  Created by Gordon on 2/15/11.
//  Copyright 2011 GeeksInKilts. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Hotel;

@interface HotelDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate> {
	UITableView *table;
	Hotel *hotel;
	UINavigationController *__weak detailedNavigationController;
@private
	NSArray *directions;
}

@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) Hotel *hotel;
@property(nonatomic,weak) UINavigationController *detailedNavigationController;

@end









