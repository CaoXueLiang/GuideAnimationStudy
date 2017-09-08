//
//  SpreadInvertTranslationAnimation.m
//  MaskTransition
//
//  Created by bjovov on 2017/9/8.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "SpreadInvertTranslationAnimation.h"
#import "ViewController.h"
#import "SecondViewController.h"

@interface SpreadInvertTranslationAnimation()
@property (nonatomic,strong) id<UIViewControllerContextTransitioning> transitionContext;
@end

@implementation SpreadInvertTranslationAnimation
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.7;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    self.transitionContext = transitionContext;
    SecondViewController *fromVC = (SecondViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    ViewController *toVC = (ViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *contView = [transitionContext containerView];
    
    /*动画效果和添加的先后顺序也有关*/
    [contView addSubview:toVC.view];
    [contView addSubview:fromVC.view];
    
    UIButton *button = toVC.rightButton;
    UIBezierPath *maskEndPath = [UIBezierPath bezierPathWithOvalInRect:toVC.rightButton.frame];
    CGPoint startPoint;
    if (button.frame.origin.x > CGRectGetWidth(toVC.view.bounds) / 2) {
        if (button.frame.origin.y < CGRectGetHeight(toVC.view.bounds) / 2) {
        //第一象限
            startPoint = CGPointMake(button.center.x, CGRectGetHeight(toVC.view.bounds)-button.center.y);
        }else{
        //第四象限
            startPoint = CGPointMake(button.center.x, button.center.y);
        }
    }else{
        if (button.frame.origin.y < CGRectGetHeight(toVC.view.bounds) / 2) {
       //第二象限
            startPoint = CGPointMake(CGRectGetWidth(toVC.view.bounds) - button.center.x, CGRectGetHeight(toVC.view.bounds) - button.center.y);
        }else{
       //第三象限
            startPoint = CGPointMake(CGRectGetWidth(toVC.view.bounds) - button.center.x, button.center.y);
        }
    }
    
    CGFloat distance = sqrt(pow(startPoint.x, 2) + pow(startPoint.y, 2));
    UIBezierPath *maskStartPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(toVC.rightButton.frame, - distance, -distance)];
    
    //添加动画
    CAShapeLayer *shaperLayer = [CAShapeLayer layer];
    shaperLayer.path = maskEndPath.CGPath;
    fromVC.view.layer.mask = shaperLayer;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.fromValue = (__bridge id)maskStartPath.CGPath;
    animation.toValue = (__bridge id)maskEndPath.CGPath;
    animation.duration = [self transitionDuration:transitionContext];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.delegate = self;
    [shaperLayer addAnimation:animation forKey:@"pathAnimation"];
    
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self.transitionContext  completeTransition:![self.transitionContext transitionWasCancelled]];
    
    //清除mask
    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
}

@end
