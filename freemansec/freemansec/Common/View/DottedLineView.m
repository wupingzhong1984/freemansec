//
//  DottedLineView.m
//  freemansec
//
//  Created by adamwu on 2017/7/30.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "DottedLineView.h"
#import <CoreGraphics/CoreGraphics.h>

@interface DottedLineView ()
@property (nonatomic,strong) UIColor *color;
@property (nonatomic,assign) CGFloat lineWidth;
@end

@implementation DottedLineView

- (id)initWithLineColor:(UIColor*)color width:(CGFloat)width frame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.color = color;
        self.lineWidth = width;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    NSArray *array = [Utility getRGBByColor:_color];
    
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条样式
    CGContextSetLineCap(context, kCGLineCapSquare);
    //设置线条粗细宽度
    CGContextSetLineWidth(context, _lineWidth);
    //设置颜色
    CGContextSetRGBStrokeColor(context, [array[0] floatValue], [array[1] floatValue], [array[2] floatValue], [array[3] floatValue]);
    CGFloat lengths[] = {2,5};
    CGContextSetLineDash(context, 0, lengths, 2);  //画虚线
    CGContextBeginPath(context);
    //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标
    CGContextMoveToPoint(context, 0, 0);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, self.width, 0);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, self.width, self.height);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, 0, self.height);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, 0, 0);
    
    //连接上面定义的坐标点
    CGContextStrokePath(context);
}


@end
