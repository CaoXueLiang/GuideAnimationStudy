//
//  ReplicatorCircleView.m
//  CAReplicatorLayerAnimation
//
//  Created by bjovov on 2017/9/15.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "ReplicatorCircleView.h"

@implementation ReplicatorCircleView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self circleAnimation];
    }
    return self;
}

- (void)circleAnimation{
    CALayer *singleLayer = [CALayer layer];
    singleLayer.bounds = CGRectMake(0, 0, 10, 25);
    singleLayer.position = CGPointMake(CGRectGetMidX(self.bounds), 0);
    singleLayer.backgroundColor = [UIColor redColor].CGColor;
    [singleLayer addAnimation:[self opacityAnimation] forKey:@"opacityAnimation"];
    
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = self.bounds;
    replicatorLayer.instanceCount = 20.0;
    replicatorLayer.instanceDelay = 0.1;
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, 10, 0, 0);
    transform = CATransform3DRotate(transform, M_PI*2/replicatorLayer.instanceCount, 0, 0, 1);
    replicatorLayer.instanceTransform = transform;
    [replicatorLayer addSublayer:singleLayer];
    [self.layer addSublayer:replicatorLayer];
}

- (CABasicAnimation *)opacityAnimation{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @1;
    animation.toValue = @0;
    animation.duration = 2;
    animation.repeatCount = HUGE;
    return animation;
}

@end
