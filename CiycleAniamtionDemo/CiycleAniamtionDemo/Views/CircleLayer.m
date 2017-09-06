//
//  CircleLayer.m
//  CiycleAniamtionDemo
//
//  Created by bjovov on 2017/9/6.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "CircleLayer.h"
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MoveType) {
    MoveTypeLeft,
    MoveTypeRight,
};

static CGFloat OUTSIDE_WIDTH = 90.0;//外接矩形的大小
@interface CircleLayer()
/**
 外接矩形的位置
 */
@property (nonatomic,assign) CGRect outSideRect;
/**
 移动的方向
 */
@property (nonatomic,assign) MoveType moveType;
@end

@implementation CircleLayer
#pragma mark - Init Menthod
- (instancetype)init{
   self = [super init];
    if (self) {
        self.progress = 0.5;
    }
    return self;
}

- (void)drawInContext:(CGContextRef)ctx{
    //用4段3次贝塞尔曲线画圆,当A-C1,B-C2的距离等于正方形的1/3.6时，画出来的弧贴合园形
    CGFloat offSet = self.outSideRect.size.width/3.6;
    
    //A,B,C,D移动的距离，系数为滑块偏离重点0.5的绝对值乘以2，当滑动到两端时，移动的距离最大为【90/6 = 15】
    CGFloat moveDistance = (self.outSideRect.size.width *1/6) * fabs(_progress - 0.5)*2;
    
    //获取外接矩形中心点的坐标
    CGPoint centerPoint = CGPointMake(CGRectGetMidX(self.outSideRect), CGRectGetMidY(self.outSideRect));
    
    //计算A,B,C,D点的坐标
    CGPoint pointA = CGPointMake(centerPoint.x, centerPoint.y - OUTSIDE_WIDTH/2 + moveDistance);
    CGPoint PointB = CGPointMake(self.moveType == MoveTypeRight ? centerPoint.x + OUTSIDE_WIDTH/2 : centerPoint.x + OUTSIDE_WIDTH/2 + moveDistance*2, centerPoint.y);
    CGPoint pointC = CGPointMake(centerPoint.x, centerPoint.y + OUTSIDE_WIDTH/2 - moveDistance);
    CGPoint pointD = CGPointMake(self.moveType == MoveTypeLeft ? centerPoint.x - OUTSIDE_WIDTH/2 : centerPoint.x - OUTSIDE_WIDTH/2 - moveDistance*2, centerPoint.y);
    
    //计算辅助点C1,C2,C3....C8点的坐标
    CGPoint C1 = CGPointMake(pointA.x + offSet, pointA.y);
    CGPoint C8 = CGPointMake(pointA.x - offSet, pointA.y);
    CGPoint C2 = CGPointMake(PointB.x, self.moveType == MoveTypeRight ? PointB.y - offSet : PointB.y - offSet + moveDistance);
    CGPoint C3 = CGPointMake(PointB.x, self.moveType == MoveTypeRight ? PointB.y + offSet : PointB.y + offSet - moveDistance);
    CGPoint C4 = CGPointMake(pointC.x + offSet, pointC.y);
    CGPoint C5 = CGPointMake(pointC.x - offSet, pointC.y);
    CGPoint C6 = CGPointMake(pointD.x, self.moveType == MoveTypeLeft ? pointD.y + offSet : pointD.y + offSet - moveDistance);
    CGPoint C7 = CGPointMake(pointD.x,self.moveType == MoveTypeLeft ? pointD.y - offSet : pointD.y - offSet + moveDistance);
    
    
    //画三次beisaier曲线
    UIBezierPath *circlePath = [UIBezierPath bezierPath];
    [circlePath moveToPoint:pointA];
    [circlePath addCurveToPoint:PointB controlPoint1:C1 controlPoint2:C2];
    [circlePath addCurveToPoint:pointC controlPoint1:C3 controlPoint2:C4];
    [circlePath addCurveToPoint:pointD controlPoint1:C5 controlPoint2:C6];
    [circlePath addCurveToPoint:pointA controlPoint1:C7 controlPoint2:C8];
    [circlePath closePath];
    CGContextAddPath(ctx, circlePath.CGPath);
    CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextSetStrokeColorWithColor(ctx, [UIColor clearColor].CGColor);
    CGContextDrawPath(ctx, kCGPathFill);
    
    //绘制外接矩形边框
    CGContextAddRect(ctx, self.outSideRect);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGFloat lengh[] = {2,2};
    CGContextSetLineDash(ctx, 0, lengh, 2);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    //绘制包裹图
    UIBezierPath *stokePath = [UIBezierPath bezierPath];
    [stokePath moveToPoint:pointA];
    [stokePath addLineToPoint:C1];
    [stokePath addLineToPoint:C2];
    [stokePath addLineToPoint:PointB];
    [stokePath addLineToPoint:C3];
    [stokePath addLineToPoint:C4];
    [stokePath addLineToPoint:pointC];
    [stokePath addLineToPoint:C5];
    [stokePath addLineToPoint:C6];
    [stokePath addLineToPoint:pointD];
    [stokePath addLineToPoint:C7];
    [stokePath addLineToPoint:C8];
    [stokePath closePath];
    CGContextAddPath(ctx, stokePath.CGPath);
    CGFloat dashLength[] = {1,1};
    CGContextSetLineDash(ctx, 0, dashLength, 2);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    //绘制控制点
    CGContextAddRect(ctx, [self rectWithPoint:pointA]);
    CGContextAddRect(ctx, [self rectWithPoint:PointB]);
    CGContextAddRect(ctx, [self rectWithPoint:pointC]);
    CGContextAddRect(ctx, [self rectWithPoint:pointD]);
    CGContextAddRect(ctx, [self rectWithPoint:C8]);
    CGContextAddRect(ctx, [self rectWithPoint:C7]);
    CGContextAddRect(ctx, [self rectWithPoint:C6]);
    CGContextAddRect(ctx, [self rectWithPoint:C5]);
    CGContextAddRect(ctx, [self rectWithPoint:C4]);
    CGContextAddRect(ctx, [self rectWithPoint:C3]);
    CGContextAddRect(ctx, [self rectWithPoint:C2]);
    CGContextAddRect(ctx, [self rectWithPoint:C1]);
    CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextDrawPath(ctx, kCGPathFill);
}

- (CGRect)rectWithPoint:(CGPoint)point{
    return CGRectMake(point.x - 2, point.y - 2, 4, 4);
}

#pragma mark - Setter && Getter
- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    if (_progress <= 0.5) {
        self.moveType = MoveTypeLeft;
    }else{
        self.moveType = MoveTypeRight;
    }
    
    //获取外接矩形的位置
    CGFloat originX = self.position.x - OUTSIDE_WIDTH/2 + (_progress - 0.5)*(self.frame.size.width-OUTSIDE_WIDTH);
    CGFloat originY = self.position.y - OUTSIDE_WIDTH/2;
    self.outSideRect =CGRectMake(originX, originY, OUTSIDE_WIDTH, OUTSIDE_WIDTH);
    
    //调用setNeedsDisplay进行绘制
    [self setNeedsDisplay];
}

@end


