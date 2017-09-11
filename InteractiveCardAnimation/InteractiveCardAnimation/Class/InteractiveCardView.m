//
//  InteractiveCardView.m
//  InteractiveCardAnimation
//
//  Created by bjovov on 2017/9/11.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "InteractiveCardView.h"

#define SCREENWIDTH     [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT    [UIScreen mainScreen].bounds.size.height
#define ANIMATEDURATION 0.5
#define ANIMATEDAMPING  0.6
#define SCROLLDISTANCE  200.0

@implementation InteractiveCardView
- (instancetype)initWithImage:(UIImage *)image{
    self = [super initWithImage:image];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.layer.cornerRadius = 7.0f;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setGestureView:(UIView *)gestureView{
    _gestureView = gestureView;
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [gestureView addGestureRecognizer:panGesture];
}

/*
 随着滑动距离绝对值(离开初始位置的距离，竖直向上或竖直向下) 的增加，逐渐接近最大滑动距离。
 这个过程中，视图同时做三个变换:
 1. 第一个是 translation .让视图的 center 的位移等于手指的位移;
 2. 其次是scale.从1.0到0.8;
 3. 另一个变换是 Rotate(绕 x 轴且带透视效果) ，从0增长到1，之后 立即从1减小到0。
 */
- (void)pan:(UIPanGestureRecognizer *)recognizer{
    CGPoint point = [recognizer translationInView:self.superview];
    static CGPoint initialPoint;
    CGFloat factorOfSacle = 0;
    CGFloat factorOfAngle = 0;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        initialPoint = self.center;
    }else if (recognizer.state == UIGestureRecognizerStateChanged){
      
        self.center = CGPointMake(initialPoint.x, initialPoint.y + point.y);
        CGFloat Y = MIN(SCROLLDISTANCE, MAX(0, ABS(point.y)));
        
        //一个开口向下,顶点(SCROLLDISTANCE,1),过(0,0),(2*SCROLLDISTANCE,0)的二次函数
        factorOfSacle = MAX(0, -1/(SCROLLDISTANCE *SCROLLDISTANCE)*Y*(Y - 2*SCROLLDISTANCE));
        //一个开口向下,顶点(SCROLLDISTANCE/2,1),过(0,0),(SCROLLDISTANCE,0)的二次函数
        factorOfAngle = MAX(0,-4/(SCROLLDISTANCE*SCROLLDISTANCE)*Y*(Y-SCROLLDISTANCE));
        
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = -1/1000;
        transform = CATransform3DScale(transform, 1-0.2*factorOfSacle, 1-0.2*factorOfSacle, 0);
        transform = CATransform3DRotate(transform,factorOfAngle*(M_PI/5) , point.y>0 ? -1 : 1, 0, 0);
    
        self.layer.transform = transform;
        self.dimmingView.alpha = 1 - Y/SCROLLDISTANCE;
    }else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled){
       
        [UIView animateWithDuration:ANIMATEDURATION delay:0 usingSpringWithDamping:ANIMATEDAMPING initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.dimmingView.alpha = 1;
            self.layer.transform = CATransform3DIdentity;
            self.center = initialPoint;
        } completion:nil];
    }
}

@end

