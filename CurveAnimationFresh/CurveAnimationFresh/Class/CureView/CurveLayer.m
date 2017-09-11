//
//  CurveLayer.m
//  CurveAnimationFresh
//
//  Created by bjovov on 2017/9/11.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "CurveLayer.h"
#import <UIKit/UIKit.h>

#define Radius  10     //圆形半径
#define Space    1     //间隔
#define LineLength 30  //线段长度
#define CenterY  self.frame.size.height/2
#define Degree M_PI/3  //箭头旋转的角度

@implementation CurveLayer
#pragma mark - Draw Menthod
- (void)drawInContext:(CGContextRef)ctx{
    [super drawInContext:ctx];
    
    UIGraphicsPushContext(ctx);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /*
     我把这个动画分成了两部分:0~0.5 和 0.5~1.0
     1.这一个阶段两条线段分别从上方和下方两个方向向中间运动，直到接触到中线为止。
     2.B点保持不动，A点继续运动到 B的位置，同时，在顶部根据当前的进度再画出圆弧。
     */
    
    UIBezierPath *curvePath1 = [UIBezierPath bezierPath];
    curvePath1.lineCapStyle = kCGLineCapRound;
    curvePath1.lineJoinStyle = kCGLineJoinRound;
    curvePath1.lineWidth = 2.0f;
    
    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    
    //画左侧线段
    if (self.progress <= 0.5) {
        CGPoint pointA = CGPointMake(self.frame.size.width/2 - Radius, CenterY - Space + LineLength + (1-2*self.progress)*(CenterY-LineLength));
        CGPoint pointB = CGPointMake(self.frame.size.width/2-Radius, CenterY - Space + (1-2*self.progress)*(CenterY-LineLength));
        [curvePath1 moveToPoint:pointA];
        [curvePath1 addLineToPoint:pointB];
        
        //画箭头
        [arrowPath moveToPoint:pointB];
        [arrowPath addLineToPoint:CGPointMake(pointB.x - 3*(cosf(Degree)), pointB.y + 3*(sinf(Degree)))];
        [curvePath1 appendPath:arrowPath];
        
    }else if (self.progress > 0.5){
        CGPoint pointA = CGPointMake(self.frame.size.width/2-Radius, CenterY - Space + LineLength - LineLength*(self.progress-0.5)*2);
        CGPoint pointB = CGPointMake(self.frame.size.width/2-Radius, CenterY - Space);
        [curvePath1 moveToPoint:pointA];
        [curvePath1 addLineToPoint:pointB];
        [curvePath1 addArcWithCenter:CGPointMake(self.frame.size.width/2, CenterY - Space) radius:Radius startAngle:M_PI endAngle:(M_PI + (M_PI*9/10)*(self.progress - 0.5)*2) clockwise:1];
        
        //画箭头
        [arrowPath moveToPoint:curvePath1.currentPoint];
        [arrowPath addLineToPoint:CGPointMake(curvePath1.currentPoint.x - 3*(cosf(Degree  - ((M_PI*9/10) * (self.progress-0.5)*2))), curvePath1.currentPoint.y + 3*(sinf(Degree - ((M_PI*9/10) * (self.progress-0.5)*2))))];
        [curvePath1 appendPath:arrowPath];
    }
    
    //画右侧线段
    UIBezierPath *curvePath2 = [UIBezierPath bezierPath];
    curvePath2.lineCapStyle = kCGLineCapRound;
    curvePath2.lineJoinStyle = kCGLineJoinRound;
    curvePath2.lineWidth = 2.0f;
    if (self.progress <= 0.5) {
        
        CGPoint pointA = CGPointMake(self.frame.size.width/2+Radius, 2*self.progress * (CenterY + Space - LineLength));
        CGPoint pointB = CGPointMake(self.frame.size.width/2+Radius,LineLength + 2*self.progress*(CenterY + Space - LineLength));
        [curvePath2 moveToPoint:pointA];
        [curvePath2 addLineToPoint:pointB];
        
        //arrow
        [arrowPath moveToPoint:pointB];
        [arrowPath addLineToPoint:CGPointMake(pointB.x + 3*(cosf(Degree)), pointB.y - 3*(sinf(Degree)))];
        [curvePath2 appendPath:arrowPath];
        
    }
    if (self.progress > 0.5) {
        [curvePath2 moveToPoint:CGPointMake(self.frame.size.width/2+Radius, CenterY + Space - LineLength + LineLength*(self.progress-0.5)*2)];
        [curvePath2 addLineToPoint:CGPointMake(self.frame.size.width/2+Radius, CenterY + Space)];
        [curvePath2 addArcWithCenter:CGPointMake(self.frame.size.width/2, (CenterY+Space)) radius:Radius startAngle:0 endAngle:(M_PI*9/10)*(self.progress-0.5)*2 clockwise:YES];
        
        //arrow
        [arrowPath moveToPoint:curvePath2.currentPoint];
        [arrowPath addLineToPoint:CGPointMake(curvePath2.currentPoint.x + 3*(cosf(Degree - ((M_PI*9/10) * (self.progress-0.5)*2))), curvePath2.currentPoint.y - 3*(sinf(Degree - ((M_PI*9/10) * (self.progress-0.5)*2))))];
        [curvePath2 appendPath:arrowPath];
        
    }
    
    CGContextSaveGState(context);
    CGContextRestoreGState(context);
    
    [[UIColor blackColor]setStroke];
    [arrowPath stroke];
    [curvePath1 stroke];
    [curvePath2 stroke];
    
    UIGraphicsPopContext();
    
}

@end

