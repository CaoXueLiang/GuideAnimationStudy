//
//  SpreadTranstionAimation.m
//  MaskTransition
//
//  Created by bjovov on 2017/9/8.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "SpreadTranstionAimation.h"
#import "ViewController.h"
#import "SecondViewController.h"

@interface SpreadTranstionAimation()
@property (nonatomic,strong) id<UIViewControllerContextTransitioning> transitionContext;
@end

@implementation SpreadTranstionAimation
/*规定过度动画时间，必须和动画时间保持一致*/
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.7f;
}

/*
 present和dissMiss的时候调用这个方法
 在这个放方法中配置customTransition的动画
 */
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    //将过度上下文对象保存下来
    self.transitionContext = transitionContext;
    
    ViewController *fromVC = (ViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    SecondViewController *toVc = (SecondViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *contView = [transitionContext containerView];
    [contView addSubview:fromVC.view];
    [contView addSubview:toVc.view];
    
    
    /*
     创建两个圆形的 UIBezierPath 实例；
    一个是 button 的 size ，另外一个则拥有足够覆盖屏幕的半径。
    最终的动画则是在这两个贝塞尔路径之间进行的
     */
    UIBezierPath *maskStartPath = [UIBezierPath bezierPathWithOvalInRect:fromVC.rightButton.frame];
    CGPoint finalPoint;
    CGPoint buttonCenter = fromVC.rightButton.center;
    if (fromVC.rightButton.frame.origin.x > toVc.view.bounds.size.width / 2.0) {
        if (fromVC.rightButton.frame.origin.y < toVc.view.bounds.size.height/2) {
             //第一象限
            finalPoint = CGPointMake(buttonCenter.x, CGRectGetMaxY(toVc.view.bounds)-buttonCenter.y);
        }else{
            //第四象限
            finalPoint = CGPointMake(buttonCenter.x, buttonCenter.y);
        }
    }else{
        if (fromVC.rightButton.frame.origin.y < toVc.view.bounds.size.height / 2) {
           //第二象限
            finalPoint = CGPointMake(CGRectGetMaxX(toVc.view.bounds) - buttonCenter.x, CGRectGetMaxY(toVc.view.bounds)- buttonCenter.y);
        }else{
           //第三象限
            finalPoint = CGPointMake(CGRectGetMaxY(toVc.view.bounds) - buttonCenter.x, buttonCenter.y);
        }
    }
    
    CGFloat distant = sqrt((finalPoint.x * finalPoint.x) + (finalPoint.y * finalPoint.y));
    UIBezierPath *maskEndPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(fromVC.rightButton.frame, -distant, -distant)];
    
    //创建一个 CAShapeLayer 来负责展示圆形遮盖
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = maskEndPath.CGPath; //将它的 path 指定为最终的 path 来避免在动画完成后会回弹
    toVc.view.layer.mask = maskLayer;
    
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id)(maskStartPath.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((maskEndPath.CGPath));
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    maskLayerAnimation.delegate = self;
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
    
    //清除 fromVC 的 mask
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
}


@end

