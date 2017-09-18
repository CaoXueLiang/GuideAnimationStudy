//
//  ReplicatorLoader.m
//  CAReplicatorLayerAnimation
//
//  Created by bjovov on 2017/9/14.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "ReplicatorLoader.h"

/*
 CAReplicator
 他能够创建包含自己在内的n个copies，这些copies是原layer中的所有的sublayers
 并且任何对原layer和sublayer设置的变化是可以累加的
 */

@implementation ReplicatorLoader
#pragma mark - Init Menthod
- (instancetype)initWithFrame:(CGRect)frame Type:(LoaderType)type{
    self = [super initWithFrame:frame];
    if (self) {
        if (type == LoaderTypePulse) {
            [self setUpPulseReplicator];
            
        }else if (type == LoaderTypeDots){
            [self setDotsReplicator];
            
        }else if (type == LoaderTypeGrid){
            [self setGridReplicator];
            
        }else if (type == LoaderTypeCirlce){
            [self setUpCircleReplicator];
            
        }else if (type == LoaderTypeTriangle){
            [self setTriangleReplicator];
        }
        
    }
    return self;
}

- (void)setUpPulseReplicator{
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.frame = self.bounds;
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:circleLayer.bounds];
    circleLayer.path = path.CGPath;
    circleLayer.fillColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.3].CGColor;
    circleLayer.opacity = 0;
    
    
    CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
    replicator.frame = self.bounds;
    //一共显示元素的数目
    replicator.instanceCount = 8;
    //重复元素之间的时间间隔，单位是秒
    replicator.instanceDelay = 0.5;
    /*
     因为CAReplicatorLayer会自动复制其上的所有图层,
     所以我们只要给第一个图层加上动画，之后复制出来的元素都会继承这个动画
     又因为我们前面设置了instanceDelay，所以每个动画都会以相同的间隔错开，conge连接成一个完整的动画
     duration = instanceCount * instanceDelay(保持动画连贯性)
     */
    [circleLayer addAnimation:[self pulseGroupAnimation] forKey:@"pulseGroupAnimation"];
    
    [replicator addSublayer:circleLayer];
    
    [self.layer addSublayer:replicator];
}

- (void)setUpCircleReplicator{
    CGFloat margin = 5;
    CGFloat radius = (CGRectGetWidth(self.bounds) - 2*margin)/3.0;
    CALayer *circleLayer = [CALayer layer];
    circleLayer.frame = CGRectMake(0, CGRectGetWidth(self.bounds)/2 - radius/2.0, radius, radius);
    circleLayer.cornerRadius = radius/2.0;
    circleLayer.masksToBounds = YES;
    circleLayer.backgroundColor = [UIColor redColor].CGColor;
    [circleLayer addAnimation:[self circleAnimation] forKey:@"circleAnimation"];
    
    CAReplicatorLayer *replocator = [CAReplicatorLayer layer];
    replocator.frame = self.bounds;
    replocator.instanceCount = 3;
    replocator.instanceDelay = 0.2;
    replocator.instanceTransform = CATransform3DMakeTranslation(radius + margin, 0, 0);
    
    [replocator addSublayer:circleLayer];
    [self.layer addSublayer:replocator];
}

- (void)setTriangleReplicator{
    CGFloat margin = 30;
    CGFloat radirous  = (CGRectGetWidth(self.bounds) - margin)/2.0;
    
    CALayer *circleLayer = [CALayer layer];
    circleLayer.frame = CGRectMake(0, CGRectGetWidth(self.bounds)/2 - radirous/2, radirous, radirous);
    circleLayer.backgroundColor = [UIColor redColor].CGColor;
    circleLayer.cornerRadius = radirous/2.0;
    circleLayer.masksToBounds = YES;
    [circleLayer addAnimation:[self triangleAnimationMagrin:margin radius:radirous] forKey:@"triangleAnimation"];
    
    CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
    replicator.frame = self.bounds;
    replicator.instanceCount = 3;
    replicator.instanceDelay = 0.2;
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, M_PI*2/3.0, 0, 0,1);
    replicator.instanceTransform = transform;
    
    replicator.backgroundColor = [UIColor yellowColor].CGColor;
    [replicator addSublayer:circleLayer];
    [self.layer addSublayer:replicator];
}

- (void)setDotsReplicator{
    CGFloat margin = 5;
    CGFloat dotsWidth = (self.bounds.size.width - 2*margin)/3.0;
    CAShapeLayer *shaperLayer = [CAShapeLayer layer];
    shaperLayer.frame = CGRectMake(0, (CGRectGetHeight(self.bounds) - dotsWidth)/2.0, dotsWidth, dotsWidth);
    shaperLayer.backgroundColor = [UIColor redColor].CGColor;
    
    CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
    replicator.frame = self.bounds;
    replicator.instanceCount = 3;
    replicator.instanceDelay = 0.1;
    //设置instanceTransform,旋转之后坐标系也会跟着旋转
    replicator.instanceTransform = CATransform3DMakeTranslation(dotsWidth+margin, 0, 0);
    [shaperLayer addAnimation:[self dotsAnimation] forKey:@"dotsAnimation"];
    [replicator addSublayer:shaperLayer];
    
    [self.layer addSublayer:replicator];
}

- (void)setGridReplicator{
    CGFloat margin = 15;
    CGFloat singleWidth = (CGRectGetWidth(self.bounds) - margin*2)/3.0;
    CAShapeLayer *shaperLayer = [CAShapeLayer layer];
    shaperLayer.frame = CGRectMake(0, 0, singleWidth, singleWidth);
    shaperLayer.cornerRadius = singleWidth/2.0;
    shaperLayer.masksToBounds = YES;
    shaperLayer.backgroundColor = [UIColor redColor].CGColor;
    [shaperLayer addAnimation:[self girdAnimation] forKey:@"girdAnimation"];
    
    //先水平复制3个
    CAReplicatorLayer *replicatorX = [CAReplicatorLayer layer];
    replicatorX.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), singleWidth);
    replicatorX.instanceCount = 3;
    replicatorX.instanceDelay = 0.3;
    replicatorX.instanceTransform = CATransform3DMakeTranslation(margin + singleWidth, 0, 0);
    [replicatorX addSublayer:shaperLayer];
    
    //在竖直复制三个
    CAReplicatorLayer *replicatorY = [CAReplicatorLayer layer];
    replicatorY.frame = self.bounds;
    replicatorY.instanceCount = 3;
    replicatorY.instanceDelay = 0.3;
    replicatorY.instanceTransform = CATransform3DMakeTranslation(0, margin + singleWidth, 0);
    [replicatorY addSublayer:replicatorX];
    
    [self.layer addSublayer:replicatorY];
}

#pragma mark - Animation Menthod
- (CAAnimationGroup *)pulseGroupAnimation{
    CABasicAnimation *sacleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D transform = CATransform3DIdentity;
    CATransform3D transform1 = CATransform3DScale(transform, 0, 0, 0);
    CATransform3D transform2 = CATransform3DScale(transform, 1, 1, 0);
    sacleAnimation.fromValue = [NSValue valueWithCATransform3D:transform1];
    sacleAnimation.toValue = [NSValue valueWithCATransform3D:transform2];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @1;
    opacityAnimation.toValue = @0;
    
    CAAnimationGroup *groupAnimation = [[CAAnimationGroup alloc]init];
    groupAnimation.animations = @[sacleAnimation,opacityAnimation];
    groupAnimation.duration = 4;
    groupAnimation.repeatCount = HUGE;
    return groupAnimation;
}

- (CABasicAnimation *)circleAnimation{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D transform = CATransform3DIdentity;
    CATransform3D transform1 = CATransform3DScale(transform, 1, 1, 0);
    CATransform3D transform2 = CATransform3DScale(transform, 0.3, 0.3, 0);
    animation.fromValue = [NSValue valueWithCATransform3D:transform1];
    animation.toValue = [NSValue valueWithCATransform3D:transform2];
    animation.repeatCount = HUGE;
    animation.autoreverses = YES;
    animation.duration = 0.6;
    return animation;
}

- (CABasicAnimation *)dotsAnimation{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    animation.fromValue = @0;
    animation.toValue = @(M_PI);
    animation.duration = 0.6;
    animation.repeatCount = HUGE;
    return animation;
}

- (CAAnimationGroup *)girdAnimation{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D transform = CATransform3DIdentity;
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(transform, 1.0, 1.0, 0)];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(transform, 0.2, 0.2, 0)];
    
    
    CABasicAnimation *opacityAniamtion = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAniamtion.fromValue = @1;
    opacityAniamtion.toValue = @0.3;
    
    CAAnimationGroup *group = [[CAAnimationGroup alloc]init];
    group.animations = @[scaleAnimation,opacityAniamtion];
    group.duration = 1.0;
    group.repeatCount = HUGE;
    group.autoreverses = YES;
    return group;
}

- (CABasicAnimation *)triangleAnimationTransX:(CGFloat)lenght{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, lenght, 0, 0);
    transform = CATransform3DRotate(transform,M_PI*2/3.0, 0, 0, 1);
    animation.toValue = [NSValue valueWithCATransform3D:transform];
    animation.duration = 0.6;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.repeatCount = HUGE;
    return animation;
    
}

@end

