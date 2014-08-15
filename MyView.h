//
//  MyView.h
//  signature
//
//  Created by Shyamal Ranjana on 29/10/13.
//  Copyright (c) 2013 PrivyText LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MyView : UIView
// get point  in view
-(void)addPA:(CGPoint)nPoint;
-(void)addLA;
-(void)revocation;
-(void)refrom;
-(void)clear;
-(void)setLineColor:(NSInteger)color;
-(void)setlineWidth:(NSInteger)width;
@end
