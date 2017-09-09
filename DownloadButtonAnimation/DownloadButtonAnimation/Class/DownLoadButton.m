//
//  DownLoadButton.m
//  DownloadButtonAnimation
//
//  Created by bjovov on 2017/9/8.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "DownLoadButton.h"

#define Animation_Name  @"animation_Name"
@interface DownLoadButton()<CAAnimationDelegate>
@property (nonatomic,assign) CGRect originalRect; //记录下载按钮的初始frame
@end

@implementation DownLoadButton
#pragma mark - Init Menthod
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTapGesture];
        self.originalRect = frame;
        self.layer.cornerRadius = frame.size.width/2.0;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorWithRed:0.0 green:122/255.0 blue:255/255.0 alpha:1.0];
    }
    return self;
}

- (void)addTapGesture{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)tap:(UITapGestureRecognizer *)recognizer{
    NSInteger tapCount = [recognizer numberOfTouches];
    if (tapCount == 1) {
        [self cornerRadiusAnimation];
        self.userInteractionEnabled = NO;
    }
}

#pragma mark - Animation Menthod
- (void)cornerRadiusAnimation{
    
    //初始化颜色
    if (self.layer.sublayers.count > 0) {
        for (CALayer *layer in self.layer.sublayers) {
            [layer removeFromSuperlayer];
        }
    }
    [self.layer removeAllAnimations];
    self.backgroundColor = [UIColor colorWithRed:0.0 green:122/255.0 blue:255/255.0 alpha:1.0];
    
    self.layer.cornerRadius = _progressBarHeight/2.0;
    CABasicAnimation *cornerRadius = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    cornerRadius.fromValue = @(self.originalRect.size.width/2.0);
    //cornerRadius.toValue = @(self.progressBarHeight/2.0);
    cornerRadius.duration = 0.2f;
    cornerRadius.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    cornerRadius.delegate = self;
    [self.layer addAnimation:cornerRadius forKey:@"cornerRadiusAnimation"];
    
}


/**
 进度条动画:都是用的 strokeEnd 属性
 如何设置直线的起始点才能让白色进度条距离四周的间距相等呢?
 结 论 是 x = _progressBarHeight/2;
 
 lineCap : 线段的线冒有三种样式
 kCALineCapButt: 默认格式，不附加任何形状;
 kCALineCapRound: 在线段头尾添加半径为线段lineWidth 一半的半圆; 
 kCALineCapSquare: 在线段头尾添加半径为线段lineWidth 一半的矩形
 
 假设设space，线宽linewidth = progressBarHeight - 2*space;
 线冒的宽度为 = （progressBarHeight - 2*space) / 2;
 假设支线起点为x则:
 起点: x = space + 线冒宽度 = progressBarHeight/2
 终点: x + 线冒宽度 + space = progressBarWidth
      x = progressBarWidth - progressBarHeight / 2;
 */
- (void)progressAnimation{
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(_progressBarHeight/2.0, self.bounds.size.height/2)];
    [path addLineToPoint:CGPointMake(_progressBarWidth - _progressBarHeight/2.0, self.bounds.size.height/2)];
    progressLayer.path = path.CGPath;
    progressLayer.fillColor = [UIColor clearColor].CGColor;
    progressLayer.strokeColor = [UIColor whiteColor].CGColor;
    progressLayer.lineWidth = _progressBarHeight - 6;
    progressLayer.lineJoin = kCALineJoinRound;
    progressLayer.lineCap = kCALineCapRound;
    
    
    [self.layer addSublayer:progressLayer];
    CABasicAnimation *stokenAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    stokenAnimation.fromValue = @(0);
    stokenAnimation.toValue = @(1);
    stokenAnimation.duration = 2.0f;
    [stokenAnimation setValue:@"progressAnimation" forKey:Animation_Name];
    stokenAnimation.delegate = self;
    [progressLayer addAnimation:stokenAnimation forKey:nil];
}

- (void)checkAnimation{
    CAShapeLayer *checkLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGRect rectInCircle = CGRectInset(self.bounds, self.bounds.size.width*(1-1/sqrt(2.0))/2, self.bounds.size.width*(1-1/sqrt(2.0))/2);
    [path moveToPoint:CGPointMake(rectInCircle.origin.x + rectInCircle.size.width/9, rectInCircle.origin.y + rectInCircle.size.height*2/3)];
    [path addLineToPoint:CGPointMake(rectInCircle.origin.x + rectInCircle.size.width/3,rectInCircle.origin.y + rectInCircle.size.height*9/10)];
    [path addLineToPoint:CGPointMake(rectInCircle.origin.x + rectInCircle.size.width*8/10, rectInCircle.origin.y + rectInCircle.size.height*2/10)];
    
    checkLayer.path = path.CGPath;
    checkLayer.fillColor = [UIColor clearColor].CGColor;
    checkLayer.strokeColor = [UIColor whiteColor].CGColor;
    checkLayer.lineWidth = 10;
    checkLayer.lineJoin = kCALineJoinRound;
    checkLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:checkLayer];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0);
    animation.toValue = @(1);
    animation.duration = 0.3f;
    [animation setValue:@"checkAnimation" forKey:Animation_Name];
    animation.delegate = self;
    [checkLayer addAnimation:animation forKey:nil];
    
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim{
    /*这里介绍两种方式区分不同的anim:
     1、对于加在一个全局变量上的anima，比如例子里的self.AnimateView ，这是一个全局变量，所以我们在这里可以通过[self.AnimateView.layer animationForKey:]根据动画不同的key来区分
     2、然而对于一个非全局的变量，比如demo中的progressLayer，可以用KVO:[pathAnimation setValue:@"strokeEndAnimation" forKey:@"animationName"];注意这个animationName是我们自己设定的。
     */
    
    if ([anim isEqual:[self.layer animationForKey:@"cornerRadiusAnimation"]]) {
        [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.bounds = CGRectMake(0, 0, _progressBarWidth, _progressBarHeight);
        } completion:^(BOOL finished) {
            [self.layer removeAllAnimations];
            [self progressAnimation];
        }];
    }else if ([anim isEqual:[self.layer animationForKey:@"cornerRadiusExpandAnim"]]){
        [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.bounds = CGRectMake(0, 0, self.originalRect.size.width, self.originalRect.size.height);
            self.backgroundColor = [UIColor redColor];
        } completion:^(BOOL finished) {
            [self.layer removeAllAnimations];
            [self checkAnimation];
        }];
    }
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if ([[anim valueForKey:Animation_Name] isEqualToString:@"progressAnimation"]) {
        [UIView animateWithDuration:0.3 animations:^{
            for (CALayer *subLayer in self.layer.sublayers) {
                subLayer.opacity = 0;
            }
        } completion:^(BOOL finished) {
            for (CALayer *subLayer in self.layer.sublayers) {
                [subLayer removeFromSuperlayer];
            }
            NSLog(@"%@",NSStringFromCGRect(self.originalRect));
            self.layer.cornerRadius = self.originalRect.size.width/2;
            CABasicAnimation *radiusExpandAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
            radiusExpandAnimation.duration = 0.2f;
            radiusExpandAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            radiusExpandAnimation.fromValue = @(_progressBarHeight/2);
            //radiusExpandAnimation.toValue = @(self.originalRect.size.width/2);
            radiusExpandAnimation.delegate = self;
            [self.layer addAnimation:radiusExpandAnimation forKey:@"cornerRadiusExpandAnim"];
            
        }];
        
        
    }else if ([[anim valueForKey:Animation_Name] isEqualToString:@"checkAnimation"]){
        self.userInteractionEnabled = YES;
    }
}


@end



