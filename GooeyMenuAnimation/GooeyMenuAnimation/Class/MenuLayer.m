//
//  MenuLayer.m
//  GooeyMenuAnimation
//
//  Created by bjovov on 2017/9/13.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "MenuLayer.h"
#import <UIKit/UIKit.h>

#define OFF 30//距矩形边界的距离
@implementation MenuLayer
- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

/**
 拷贝前一个layer的相应的属性
 否则当我们每次调用- (void)drawInContext:(CGContextRef)ctx方法时
 当前layer的属性都将是缺失的
 */
-(id)initWithLayer:(MenuLayer*)layer{
    self = [super initWithLayer:layer];
    if (self) {
        self.XAxisPercent = layer.XAxisPercent;
        self.showDebug = layer.showDebug;
        self.animateState = layer.animateState;
    }
    return self;
}


/**
 通过CAKeyframeAnimation 改变一个layer的自定义属性
 在这个layer中监听该属性的变化，一旦该属性变化立即重绘

 @param key layer属性
 @return BOOL
 */
+ (BOOL)needsDisplayForKey:(NSString *)key{
    if ([key isEqualToString:@"XAxisPercent"]) {
        return YES;
    }
   return [super needsDisplayForKey:key];
}


/**
 动画轨迹:
 1.从初始位置运动到左侧最远位置
 2.从左侧最远位置运动到右侧最原位置
 3.从右侧最远位置以弹性动画恢复到初始位置
 */
- (void)drawInContext:(CGContextRef)ctx{
    CGRect real_rect = CGRectInset(self.frame, OFF, OFF);
    //这样画出来的贝塞尔曲线更接近圆形
    CGFloat offSet = CGRectGetWidth(real_rect)/3.6;
    CGPoint center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    //获取控制点的坐标
    CGPoint top_left = CGPointZero;
    CGPoint top_center = CGPointZero;
    CGPoint top_right = CGPointZero;
   
    if (self.animateState == STATE1) {
        CGFloat moveDistance = _XAxisPercent*(CGRectGetWidth(real_rect)/2 - offSet)/2;
        top_left = CGPointMake(center.x - offSet - moveDistance*2, OFF);
        top_center = CGPointMake(center.x - moveDistance, OFF);
        top_right = CGPointMake(center.x + offSet, OFF);
        
    }else if (_animateState == STATE2){
        CGFloat moveDistance = (CGRectGetWidth(real_rect)/2 - offSet)/2;
        CGFloat moveDistance_2 = _XAxisPercent*(CGRectGetWidth(real_rect)/3);
        top_left = CGPointMake(center.x - offSet - moveDistance*2 + moveDistance_2, OFF);
        top_center = CGPointMake(center.x - moveDistance + moveDistance_2, OFF);
        top_right = CGPointMake(center.x + offSet + moveDistance_2, OFF);
        
    }else if (_animateState == STATE3){
        CGFloat moveDistance = (CGRectGetWidth(real_rect)/2 - offSet)/2;
        CGFloat moveDistance_2 = (CGRectGetWidth(real_rect)/3);
     
        CGFloat factor_1 = _XAxisPercent*(center.x - offSet - moveDistance*2 + moveDistance_2 - (center.x - offSet));
        CGFloat factor_2 = _XAxisPercent*(center.x - moveDistance + moveDistance_2 - center.x);
        CGFloat factor_3 = _XAxisPercent*(center.x + offSet + moveDistance_2 - (center.x + offSet));
        
        top_left = CGPointMake(center.x - offSet - moveDistance*2 + moveDistance_2 - factor_1, OFF);
        top_center = CGPointMake(center.x - moveDistance + moveDistance_2 - factor_2, OFF);
        top_right = CGPointMake(center.x + offSet + moveDistance_2 - factor_3, OFF);
    }
    
    
    CGPoint left_top = CGPointMake(OFF, center.y - offSet);
    CGPoint left_center = CGPointMake(OFF, center.y);
    CGPoint left_bottom = CGPointMake(OFF, center.y + offSet);
    
    CGPoint right_top = CGPointMake(CGRectGetMaxX(real_rect), center.y - offSet);
    CGPoint right_center = CGPointMake(CGRectGetMaxX(real_rect), center.y);
    CGPoint right_bottom = CGPointMake(CGRectGetMaxX(real_rect), center.y + offSet);
    
    CGPoint bottom_left = CGPointMake(center.x - offSet, CGRectGetMaxY(real_rect));
    CGPoint bottom_center = CGPointMake(center.x, CGRectGetMaxY(real_rect));
    CGPoint bottom_right = CGPointMake(center.x + offSet, CGRectGetMaxY(real_rect));
    
    
    //画三次贝塞尔曲线
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:top_center];
    [path addCurveToPoint:right_center controlPoint1:top_right controlPoint2:right_top];
    [path addCurveToPoint:bottom_center controlPoint1:right_bottom controlPoint2:bottom_right];
    [path addCurveToPoint:left_center controlPoint1:bottom_left controlPoint2:left_bottom];
    [path addCurveToPoint:top_center controlPoint1:left_top controlPoint2:top_left];
    [path closePath];
    
    CGContextAddPath(ctx, path.CGPath);
    CGContextSetStrokeColorWithColor(ctx, [UIColor clearColor].CGColor);
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:29.0/255.0 green:163.0/255.0 blue:1 alpha:1].CGColor);
    CGContextDrawPath(ctx, kCGPathFill);
    
    //画辅助点
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:top_left];
    [linePath addLineToPoint:top_center];
    [linePath addLineToPoint:top_right];
    [linePath addLineToPoint:right_top];
    [linePath addLineToPoint:right_center];
    [linePath addLineToPoint:right_bottom];
    [linePath addLineToPoint:bottom_right];
    [linePath addLineToPoint:bottom_center];
    [linePath addLineToPoint:bottom_left];
    [linePath addLineToPoint:left_bottom];
    [linePath addLineToPoint:left_center];
    [linePath addLineToPoint:left_top];
    [linePath closePath];
    
    CGFloat length[2] = {2,2};
    CGContextAddPath(ctx, linePath.CGPath);
    CGContextSetLineDash(ctx, 0, length, 2);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(ctx, 1);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextFillRect(ctx, [self pointRectWith:top_center]);
    CGContextFillRect(ctx, [self pointRectWith:top_left]);
    CGContextFillRect(ctx, [self pointRectWith:top_right]);
    CGContextFillRect(ctx, [self pointRectWith:left_top]);
    CGContextFillRect(ctx, [self pointRectWith:left_center]);
    CGContextFillRect(ctx, [self pointRectWith:left_bottom]);
    CGContextFillRect(ctx, [self pointRectWith:right_top]);
    CGContextFillRect(ctx, [self pointRectWith:right_center]);
    CGContextFillRect(ctx, [self pointRectWith:right_bottom]);
    CGContextFillRect(ctx, [self pointRectWith:bottom_left]);
    CGContextFillRect(ctx, [self pointRectWith:bottom_right]);
    CGContextFillRect(ctx, [self pointRectWith:bottom_center]);
}

- (CGRect)pointRectWith:(CGPoint)point{
    return CGRectMake(point.x - 1.5, point.y - 1.5, 3, 3);
}

@end

