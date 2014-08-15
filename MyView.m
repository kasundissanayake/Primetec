//
//  MyView.m
//  signature
//
//  Created by Shyamal Ranjana on 29/10/13.
//  Copyright (c) 2013 PrivyText LLC. All rights reserved.
//

#import "MyView.h"


@implementation MyView

static NSMutableArray *colorArray;

static NSMutableArray *deleColorArray;

static NSMutableArray *pointArray;

static NSMutableArray *lineArray;

static NSMutableArray *deleArray;

static float lineWidthArray[4]={5.0,20.0,30.0,40.0};

static NSMutableArray *deleWidthArray;

static NSMutableArray *WidthArray;

static int colorCount;

static int widthCount;

static NSMutableArray *colors;
- (id)init
{
    self = [super init];
    if (self) {
     
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        colors=[[NSMutableArray alloc]initWithObjects:[UIColor blackColor],[UIColor redColor],[UIColor greenColor],[UIColor blueColor],[UIColor purpleColor],[UIColor orangeColor], [UIColor yellowColor], [UIColor cyanColor], [UIColor brownColor],[UIColor magentaColor], [UIColor darkGrayColor], [UIColor whiteColor], nil];
        WidthArray=[[NSMutableArray alloc]init];
        deleWidthArray=[[NSMutableArray alloc]init];
        pointArray=[[NSMutableArray alloc]init];
        lineArray=[[NSMutableArray alloc]init];
        deleArray=[[NSMutableArray alloc]init];
        colorArray=[[NSMutableArray alloc]init];
        deleColorArray=[[NSMutableArray alloc]init];
        
        colorCount=0;
        widthCount=0;
        // Initialization code
    }
    return self;
}

-(void)setlineWidth:(NSInteger)width{
    widthCount=width;
}
-(void)setLineColor:(NSInteger)color{
    colorCount=color;
}

- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 10.0f);
    
    CGContextSetLineJoin(context,kCGLineJoinRound);
    
    CGContextSetLineCap(context, kCGLineJoinRound);
    
    if ([lineArray count]>0) {
        for (int i=0; i<[lineArray count]; i++) {
            NSArray * array=[NSArray
                             arrayWithArray:[lineArray objectAtIndex:i]];
           
        if ([array count]>0)
        {
            CGContextBeginPath(context);
            CGPoint myStartPoint=CGPointFromString([array objectAtIndex:0]);
            CGContextMoveToPoint(context, myStartPoint.x, myStartPoint.y);
            
            for (int j=0; j<[array count]-1; j++)
            {
                CGPoint myEndPoint=CGPointFromString([array objectAtIndex:j+1]);
                //--------------------------------------------------------
                CGContextAddLineToPoint(context, myEndPoint.x,myEndPoint.y);
            }
            
            NSNumber *num=[colorArray objectAtIndex:i];
            int count=[num intValue];
            UIColor *lineColor=[colors objectAtIndex:count];
            
            NSNumber *wid=[WidthArray objectAtIndex:i];
            int widthc=[wid intValue];
            float width=lineWidthArray[widthc];
            
            CGContextSetStrokeColorWithColor(context,[lineColor CGColor]);
            //-------------------------------------------------------
            
            CGContextSetLineWidth(context, width);
            
            CGContextStrokePath(context);
        }
     }
    }
    
    if ([pointArray count]>0)
    {
        CGContextBeginPath(context);
        CGPoint myStartPoint=CGPointFromString([pointArray objectAtIndex:0]);
        CGContextMoveToPoint(context, myStartPoint.x, myStartPoint.y);
        
        for (int j=0; j<[pointArray count]-1; j++)
        {
            CGPoint myEndPoint=CGPointFromString([pointArray objectAtIndex:j+1]);
            //--------------------------------------------------------
            CGContextAddLineToPoint(context, myEndPoint.x,myEndPoint.y);
        }
        UIColor *lineColor=[colors objectAtIndex:colorCount];
        float width=lineWidthArray[widthCount];
        CGContextSetStrokeColorWithColor(context,[lineColor CGColor]);
        //-------------------------------------------------------
        CGContextSetLineWidth(context, width);
        CGContextStrokePath(context);
    }

     
}

-(void)addPA:(CGPoint)nPoint{
    NSString *sPoint=NSStringFromCGPoint(nPoint);
    [pointArray addObject:sPoint];
}

-(void)addLA{
    NSNumber *wid=[[NSNumber alloc]initWithInt:widthCount];
    NSNumber *num=[[NSNumber alloc]initWithInt:colorCount];
    [colorArray addObject:num];
    [WidthArray addObject:wid];
    NSArray *array=[NSArray arrayWithArray:pointArray];
    [lineArray addObject:array];
    pointArray=[[NSMutableArray alloc]init];
}

#pragma mark -

static CGPoint MyBeganpoint;
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{	
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch=[touches anyObject];
	MyBeganpoint=[touch locationInView:self];
    NSString *sPoint=NSStringFromCGPoint(MyBeganpoint);
    [pointArray addObject:sPoint];
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
     [self addLA];
//    NSArray *array=[NSArray arrayWithArray:pointArray];
//    [lineArray addObject:array];
//    NSNumber *num=[[NSNumber alloc]initWithInt:colorCount];
//    [colorArray addObject:num];
//    pointArray=[[NSMutableArray alloc]init];
    NSLog(@"touches end");
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"touches Canelled");
}

-(void)revocation{
    if ([lineArray count]) {
        [deleArray addObject:[lineArray lastObject]];
        [lineArray removeLastObject];
    }
    if ([colorArray count]) {
        [deleColorArray addObject:[colorArray lastObject]];
        [colorArray removeLastObject];
    }
    if ([WidthArray count]) {
        [deleWidthArray addObject:[WidthArray lastObject]];
        [WidthArray removeLastObject];
    }
    
    [self setNeedsDisplay];
}

-(void)refrom{
    if ([deleArray count]) {
        [lineArray addObject:[deleArray lastObject]];
        [deleArray removeLastObject];
    }
    if ([deleColorArray count]) {
        [colorArray addObject:[deleColorArray lastObject]];
        [deleColorArray removeLastObject];
    }
    if ([deleWidthArray count]) {
        [WidthArray addObject:[deleWidthArray lastObject]];
        [deleWidthArray removeLastObject];
    }
    [self setNeedsDisplay];
     
}
-(void)clear{
    NSLog(@"1");
   [deleArray removeAllObjects];
     NSLog(@"2");
    [deleColorArray removeAllObjects];
     NSLog(@"3");
    colorCount=0;
     NSLog(@"4");
    [colorArray removeAllObjects];
    NSLog(@"5");
    [lineArray removeAllObjects];
    NSLog(@"6");
    [pointArray removeAllObjects];
    NSLog(@"7");
    [deleWidthArray removeAllObjects];
    NSLog(@"8");
    widthCount=0;
    [WidthArray removeAllObjects];
     NSLog(@"9");
    [self setNeedsDisplay];
     NSLog(@"810");
    
    //    deleColorArray=[[NSMutableArray alloc]init];
    //    deleArray=[[NSMutableArray alloc]init];
    //    deleArray =[NSMutableArray arrayWithArray:lineArray];
    //    deleColorArray =[NSMutableArray arrayWithArray:colorArray];
}
@end
