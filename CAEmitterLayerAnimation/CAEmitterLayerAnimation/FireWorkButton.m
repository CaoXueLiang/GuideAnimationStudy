//
//  FireWorkButton.m
//  CAEmitterLayerAnimation
//
//  Created by 曹学亮 on 2017/9/15.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "FireWorkButton.h"

@interface FireWorkButton()
@property (nonatomic,strong)CAEmitterLayer *emitterLayer;
@end

@implementation FireWorkButton
#pragma mark - Init Menthod
- (instancetype)initWithFrame:(CGRect)frame normalImage:(NSString *)normalImage selectedImage:(NSString *)selectedImage{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self setBackgroundImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
        [self setUp];
    }
    return self;
}

- (void)setUp{
    _emitterLayer = [CAEmitterLayer layer];
    _emitterLayer.name = @"emitterLayer";
    //粒子发射器的形状
    _emitterLayer.emitterShape = kCAEmitterLayerCircle;
    //从轮廓进行发射
    _emitterLayer.emitterMode = kCAEmitterLayerOutline;
    _emitterLayer.renderMode = kCAEmitterLayerOldestFirst;
    _emitterLayer.emitterPosition = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _emitterLayer.emitterSize = CGSizeMake(25, 0);
    _emitterLayer.masksToBounds = NO;
    
    
    CAEmitterCell *cell = [[CAEmitterCell alloc]init];
    cell.contents = (__bridge id)[UIImage imageNamed:@"Sparkle"].CGImage;
    cell.name = @"explosion";
    cell.alphaRange = 0.2;
    cell.alphaSpeed = -1.0;
    cell.lifetime = 0.7;
    cell.lifetimeRange = 0.3;
    cell.birthRate = 0;
    cell.velocity = 40;
    cell.velocityRange = 10;
    
    //如果你的contents的图片太大了，可以通过设置sacle属性缩小
    cell.scale = 0.05;
    cell.scaleRange = 0.02;
    
    _emitterLayer.emitterCells = @[cell];
    [self.layer addSublayer:_emitterLayer];
}

- (void)buttonSelected:(UIButton *)sender{
    self.selected = !self.selected;
    if (self.selected) {
        CAKeyframeAnimation *animition = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        CATransform3D transform = CATransform3DIdentity;
        CATransform3D transform1 = CATransform3DScale(transform, 1.5, 1.5, 0);
        CATransform3D transform2 = CATransform3DScale(transform, 0.8, 0.8, 0);
        CATransform3D transform3 = CATransform3DScale(transform, 1.0, 1.0, 0);
        animition.values = @[[NSValue valueWithCATransform3D:transform1],[NSValue valueWithCATransform3D:transform2],[NSValue valueWithCATransform3D:transform3]];
        animition.duration = 0.5;
        [self.layer addAnimation:animition forKey:@"animationOne"];
        
        //播放爆炸效果
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startExplosion];
        });
        
    }else{
        CAKeyframeAnimation *animition = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        CATransform3D transform = CATransform3DIdentity;
        CATransform3D transform2 = CATransform3DScale(transform, 0.8, 0.8, 0);
        CATransform3D transform3 = CATransform3DScale(transform, 1.0, 1.0, 0);
        animition.values = @[[NSValue valueWithCATransform3D:transform2],[NSValue valueWithCATransform3D:transform3]];
        animition.duration = 0.4;
        [self.layer addAnimation:animition forKey:@"animationTwo"];
    }
}


/**
 开始粒子效果
 */
- (void)startExplosion{
   /*
    我们需要手动控制动画的开始和结束（name属性）
    想要手动控制动画的开始和结束，我们必须通过KVO的方式设置cell的值才行
    */
    self.emitterLayer.beginTime = CACurrentMediaTime();
    /*
     CAEmitterLayer根据自己的"emitterCells"属性找到名叫"explosion"的cell，并设置他的birthRate = 500，
     从而间接控制了动画的开始
     */
    [self.emitterLayer setValue:@500 forKeyPath:@"emitterCells.explosion.birthRate"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self stopExplosion];
    });
}


/**
 结束粒子效果
 */
- (void)stopExplosion{
    //通过设置birthRate间接控制了动画的结束
    [self.emitterLayer setValue:@0 forKeyPath:@"emitterCells.explosion.birthRate"];
}

@end
