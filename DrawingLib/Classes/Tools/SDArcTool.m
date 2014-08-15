//
//  SDArcTool.m
//  BridgeInspection
//
//  Created by Woornika on 12/31/13.
//  Copyright (c) 2013 3SG Corporation. All rights reserved.
//

#import "SDArcTool.h"

@implementation SDArcTool

- (void)touchMoved:(UITouch*)touch {
    
    [super touchMoved:touch];
    
    CGPoint currentPoint = [touch locationInView:self.drawingImageView];
    [self drawEllipseFromPoint:self.firstPoint toPoint:currentPoint];
    
}

- (void)drawEllipseFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint {
    
    [self setupImageContextForDrawing];
    
        
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapSquare);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
//    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), fromPoint.x, fromPoint.y);
//    
//    CGContextAddArcToPoint(UIGraphicsGetCurrentContext(), fromPoint.x, fromPoint.y, toPoint.x, toPoint.y, 100);
    
    NSLog(@"--- %f---- %f---- %f---- %f",fromPoint.x,fromPoint.y,toPoint.x,toPoint.y);
    
//
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(),fromPoint.x, fromPoint.y);
    //CGContextAddArcToPoint(CGContextRef c, CGFloat x1, CGFloat y1, CGFloat x2, CGFloat y2, CGFloat radius)
     CGContextAddArcToPoint(UIGraphicsGetCurrentContext(), fromPoint.x +toPoint.x,fromPoint.y, 300,200, 100);
    
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
//    
    self.drawingImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
}


@end
