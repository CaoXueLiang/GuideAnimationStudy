//
//  ViewController.m
//  CAEmitterLayerAnimation
//
//  Created by bjovov on 2017/9/14.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic,strong) CAEmitterLayer *emitterLayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:149/255.0 green:170/255.0 blue:211/255.0 alpha:1];
    [self addEmitter];
}

/*
 CAEMitterCell的属性基本上可以分为三种：
 1.这种粒子的某一属性的初始值。比如，color属性指定了一个可以混合图片内容颜色的混合色。在示例中，我们将它设置为桔色。
 2.例子某一属性的变化范围。比如emissionRange属性的值是2π，这意味着例子可以从360度任意位置反射出来。如果指定一个小一些的值，就可以创造出一个圆锥形
 3.指定值在时间线上的变化。比如，在示例中，我们将alphaSpeed设置为-0.4，就是说例子的透明度每过一秒就是减少0.4，这样就有发射出去之后逐渐小时的效果
 */
- (void)addEmitter{
    _emitterLayer = [CAEmitterLayer layer];
    //粒子发射的中心点默认是（0，0）
    _emitterLayer.emitterPosition = CGPointMake(self.view.bounds.size.width/2, 100);
    
    //发射形状的大小
    _emitterLayer.emitterSize  = CGSizeMake(CGRectGetWidth(self.view.bounds)*2, 0);
    _emitterLayer.emitterShape = kCAEmitterLayerPoint;
    _emitterLayer.emitterMode = kCAEmitterLayerOutline;
    _emitterLayer.renderMode = kCAEmitterLayerAdditive;
    _emitterLayer.shadowOpacity = 1.0;
    _emitterLayer.shadowOffset = CGSizeMake(0, 1);
    _emitterLayer.shadowRadius = 0;
    _emitterLayer.shadowColor = [UIColor whiteColor].CGColor;
    
    
    //创建粒子模板
    CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
    //每秒产生多少个粒子对象
    emitterCell.birthRate = 1;
    //粒子对象的寿命
    emitterCell.lifetime = 120;
    //每个粒子的初始速度
    emitterCell.velocity = -10;
    //速度变化范围
    emitterCell.velocityRange = 10;
    //Y轴的加速度
    emitterCell.yAcceleration = 2;
    //粒子发射角度
    emitterCell.emissionRange =2*M_PI;
    //在生命周期中可以旋转的角度范围
    emitterCell.spinRange = 0.25*M_PI;
    emitterCell.contents = (__bridge id)([UIImage imageNamed:@"snow"].CGImage);
    //每一个发射的粒子的颜色平均值
    emitterCell.color = [[UIColor colorWithRed:0.600 green:0.658 blue:0.743 alpha:1.000] CGColor];
    emitterCell.alphaSpeed = -0.05;
    
    _emitterLayer.emitterCells = @[emitterCell];
    [self.view.layer insertSublayer:self.emitterLayer atIndex:0];
}

@end


