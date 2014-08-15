//
//  GIKCalloutContentView.h
//  AnimatedCallout
//
//  Created by Gordon on 2/14/11.
//  Copyright 2011 GeeksInKilts. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	GIKContentModeDefault,
	GIKContentModeDetail
} GIKContentMode;

@protocol GIKCalloutContentViewDelegate;

@interface GIKCalloutContentView : UIView {
	GIKContentMode mode;
	UIView *detailView;
	id<GIKCalloutContentViewDelegate> __weak delegate;
	
@private
	UILabel *textLabel;
    UILabel *textLabel2;
    UILabel *textLabel3;
	UIButton *rightAccessoryView;
	CGRect textLabelFrame;
	NSString *textLabelText;
}

@property (nonatomic, assign) GIKContentMode mode;
@property (nonatomic, strong) UIView *detailView;
@property (nonatomic, weak) id<GIKCalloutContentViewDelegate> delegate;

+ (GIKCalloutContentView *)viewWithLabelText:(NSString *)text;
- (id)initWithFrame:(CGRect)frame text:(NSString *)theText textSize:(CGSize)theTextSize;
- (void)disableMapSelections;
@end


@protocol GIKCalloutContentViewDelegate <NSObject>
- (void)accessoryButtonTapped;
- (void)disableMapSelections;
@end