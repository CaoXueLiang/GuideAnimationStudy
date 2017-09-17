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
    //[self snowEmitter];
    [self addStarEmitter];
    [self addFireButton];
    //[self fireworkEmitter];
}


/**
 雪花飘落
 */
- (void)snowEmitter{
    //创建粒子发射器
    CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
    emitterLayer.emitterPosition = CGPointMake(CGRectGetMidX(self.view.bounds),-10);
    emitterLayer.emitterSize = CGSizeMake(CGRectGetWidth(self.view.bounds), 0);
    emitterLayer.emitterShape = kCAEmitterLayerLine;
    emitterLayer.emitterMode = kCAEmitterLayerOutline;
    
    
    //创建粒子模型
    CAEmitterCell *cell = [CAEmitterCell emitterCell];
    cell.birthRate = 3;
    cell.lifetime = 100;
    cell.contents = (__bridge id)[UIImage imageNamed:@"snow"].CGImage;
    cell.color = [[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0] CGColor];
    cell.velocity = 10;
    cell.velocityRange = 10;
    cell.yAcceleration = 5;
    cell.redRange = 0.8;
    cell.blueRange = 0.8;
    cell.greenRange = 0.8;
    cell.spin = M_PI/2;
    cell.spinRange = M_PI/4;
    cell.emissionRange = M_PI_2;
    
    emitterLayer.emitterCells = @[cell];
    [self.view.layer addSublayer:emitterLayer];
    
}


/**
 粒子发射动画
 */
- (void)addStarEmitter{
    self.view.backgroundColor = [UIColor blackColor];
    //创建粒子发射器
    _emitterLayer = [CAEmitterLayer layer];
    _emitterLayer.masksToBounds = YES;
    _emitterLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:_emitterLayer];
    
    //设置CAEmitterLayer
    _emitterLayer.renderMode = kCAEmitterLayerAdditive;
    _emitterLayer.emitterPosition = CGPointMake(CGRectGetMidX(self.view.bounds)+50, 150);
    
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
    emitterCell.scaleRange = 0.2;
    emitterCell.scaleSpeed = 0.1;
    
    emitterCell.spin = 130*M_PI/180.0;;
    emitterCell.spinRange = 0;
    
    emitterCell.emissionLatitude = 0;
    emitterCell.emissionLongitude = 0;
    emitterCell.emissionRange = M_PI *2;
    
    emitterCell.lifetime = 1;
    emitterCell.lifetimeRange = 0;
    emitterCell.birthRate = 200;
    emitterCell.velocity = 50;
    emitterCell.velocityRange = 500;
    emitterCell.xAcceleration = -750;
    emitterCell.yAcceleration = 0;
    
    //将粒子添加到发射器上
    _emitterLayer.emitterCells = @[emitterCell];
}


/**
 烟花效果
 */
- (void)fireworkEmitter{
    CGFloat rocketLifeTime = 1.0;
    //创建粒子发射器
    CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
    emitterLayer.emitterPosition = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetHeight(self.view.bounds));
    emitterLayer.emitterSize = CGSizeMake(CGRectGetWidth(self.view.bounds), 0);
    emitterLayer.emitterShape = kCAEmitterLayerLine;
    emitterLayer.emitterMode = kCAEmitterLayerOutline;
    emitterLayer.renderMode = kCAEmitterLayerAdditive;
    
    //创建粒子模板(发射阶段)
    CAEmitterCell *rocket = [CAEmitterCell emitterCell];
    rocket.contents = (__bridge id)[UIImage imageNamed:@"小圆球"].CGImage;
    rocket.color = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1].CGColor;
    rocket.scale = 0.5;
    rocket.redRange = 0.7;
    rocket.greenRange = 0.7;
    rocket.birthRate = 1;
    rocket.lifetime = rocketLifeTime + 0.02;
    rocket.velocity = 500;
    rocket.velocityRange = 100;
    rocket.yAcceleration = 75;
    rocket.emissionRange = M_PI_4;

    
    //创建粒子模板(爆炸阶段)
    CAEmitterCell *spark = [CAEmitterCell emitterCell];
    spark.birthRate = 10000;
    spark.scale = 0.6;
    spark.velocity = 125;
    spark.emissionRange = 2* M_PI;
    spark.yAcceleration = 75;
    spark.lifetime = 2;
    spark.contents = (id)[[UIImage imageNamed:@"星"] CGImage];
    spark.scaleSpeed = -0.2;
    spark.greenRange = 0.4;
    spark.redRange = 0.7;
    spark.blueRange = 0.9;
    spark.alphaSpeed =-0.25;
    spark.spin = 2* M_PI;
    spark.spinRange = M_PI;
    spark.beginTime = rocketLifeTime;
    

    emitterLayer.emitterCells = @[rocket];
    rocket.emitterCells = @[spark];
    [self.view.layer addSublayer:emitterLayer];
}


/**
 点击按钮爆炸动画
 */
- (void)addFireButton{
    _fireButton = [[FireWorkButton alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetHeight(self.view.bounds)/2 + 150, 30, 30) normalImage:@"Like" selectedImage:@"Like-Blue"];
    [self.view addSubview:_fireButton];
}

@end


