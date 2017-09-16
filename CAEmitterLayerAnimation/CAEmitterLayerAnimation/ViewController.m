//
//  ViewController.m
//  CAEmitterLayerAnimation
//
//  Created by bjovov on 2017/9/14.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "ViewController.h"
#import "FireWorkButton.h"

@interface ViewController ()
@property (nonatomic,strong) CAEmitterLayer *emitterLayer;
@property (nonatomic,strong) FireWorkButton *fireButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //[self addEmitter];
    [self addStarEmitter];
    [self addFireButton];
}

/*
 CAEMitterCell的属性基本上可以分为三种：
 1.这种粒子的某一属性的初始值。比如，color属性指定了一个可以混合图片内容颜色的混合色。在示例中，我们将它设置为桔色。
 2.粒子某一属性的变化范围。比如emissionRange属性的值是2π，这意味着例子可以从360度任意位置反射出来。如果指定一个小一些的值，就可以创造出一个圆锥形
 3.指定值在时间线上的变化。比如，在示例中，我们将alphaSpeed设置为-0.4，就是说例子的透明度每过一秒就是减少0.4，这样就有发射出去之后逐渐小时的效果
 4.preservesDepth，是否将3D例子系统平面化到一个图层（默认值）或者可以在3D空间中混合其他的图层
 5.renderMode，控制着在视觉上粒子图片是如何混合的。你可能已经注意到了示例中我们把它设置为kCAEmitterLayerAdditive，它实现了这样一个效果：合并例子重叠部分的亮度使得看上去更亮。如果我们把它设置为默认的kCAEmitterLayerUnordered，效果就没那么好看了
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

- (void)addStarEmitter{
    //创建粒子发射器
    _emitterLayer = [CAEmitterLayer layer];
    _emitterLayer.masksToBounds = YES;
    _emitterLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:_emitterLayer];
    
    //设置CAEmitterLayer
    _emitterLayer.renderMode = kCAEmitterLayerAdditive;
    _emitterLayer.emitterPosition = CGPointMake(CGRectGetMidX(self.view.bounds), 150);
    
    //创建粒子模板
    CAEmitterCell *emitterCell = [[CAEmitterCell alloc]init];
    emitterCell.contents = (__bridge id)[UIImage imageNamed:@"star"].CGImage;
    emitterCell.contentsScale = [UIScreen mainScreen].scale;
    emitterCell.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor;
    emitterCell.redRange = 1.0;
    emitterCell.greenRange = 1.0;
    emitterCell.blueRange = 1.0;
    emitterCell.alphaRange = 0;
    emitterCell.redSpeed = 0;
    emitterCell.greenSpeed = 0;
    emitterCell.blueSpeed = 0;
    emitterCell.alphaSpeed = -0.5;
    
    emitterCell.scale = 1;
    emitterCell.scaleRange = 0;
    emitterCell.scaleSpeed = 0.1;
    
    emitterCell.spin = 130*M_PI/180.0;;
    emitterCell.spinRange = 0;
    
    emitterCell.emissionLatitude = 0;
    emitterCell.emissionLongitude = 0;
    emitterCell.emissionRange = M_PI *2;
    
    emitterCell.lifetime = 1;
    emitterCell.lifetimeRange = 0;
    emitterCell.birthRate = 250;
    emitterCell.velocity = 50;
    emitterCell.velocityRange = 500;
    emitterCell.xAcceleration = -750;
    emitterCell.yAcceleration = 0;
    
    //将粒子添加到发射器上
    _emitterLayer.emitterCells = @[emitterCell];
}

- (void)addFireButton{
    _fireButton = [[FireWorkButton alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetHeight(self.view.bounds)/2 + 150, 30, 30) normalImage:@"Like" selectedImage:@"Like-Blue"];
    [self.view addSubview:_fireButton];
}

@end


