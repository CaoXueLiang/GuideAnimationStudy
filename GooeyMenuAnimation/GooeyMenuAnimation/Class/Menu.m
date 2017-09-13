//
//  Menu.m
//  GooeyMenuAnimation
//
//  Created by bjovov on 2017/9/13.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "Menu.h"
#import "KYSpringLayerAnimation.h"

@interface Menu()
@property (nonatomic,strong) NSMutableArray *animationArray;
@end

@implementation Menu
- (instancetype)initWithFrame:(CGRect)frame{
    CGRect real_rect = CGRectInset(frame, -30, -30);
    self = [super initWithFrame:real_rect];
    if (self) {
        _animationArray = [[NSMutableArray alloc]init];
        _menuLayer = [MenuLayer layer];
        _menuLayer.frame = self.bounds;
        _menuLayer.contentsScale = [UIScreen mainScreen].scale;
        [self.layer addSublayer:_menuLayer];
        [_menuLayer setNeedsDisplay];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if (touch.tapCount == 1) {
        [self openAnimation];
    }
}

- (void)openAnimation{
    CAKeyframeAnimation *animation1 = [[KYSpringLayerAnimation sharedAnimManager]createBasicAnima:@"XAxisPercent" duration:0.3 fromValue:@(0) toValue:@(1)];
    [_menuLayer addAnimation:animation1 forKey:@"animationState1"];
    animation1.delegate = self;
    
    CAKeyframeAnimation *animation2 = [[KYSpringLayerAnimation sharedAnimManager]createBasicAnima:@"XAxisPercent" duration:0.3 fromValue:@(0) toValue:@(1)];
    animation2.delegate = self;
    
    CAKeyframeAnimation *animation3 = [[KYSpringLayerAnimation sharedAnimManager]createSpringAnima:@"XAxisPercent" duration:1.0 usingSpringWithDamping:0.5 initialSpringVelocity:3 fromValue:@(0) toValue:@(1)];
    animation3.delegate = self;
    
    [_animationArray addObject:animation1];
    [_animationArray addObject:animation2];
    [_animationArray addObject:animation3];
    self.userInteractionEnabled = NO;
    _menuLayer.animateState = STATE1;
    [_menuLayer addAnimation:animation1 forKey:@"animationState1"];
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        if ([anim isEqual:[self.menuLayer animationForKey:@"animationState1"]]) {
            [_menuLayer removeAllAnimations];
            [_menuLayer addAnimation:_animationArray[1] forKey:@"animationState2"];
            _menuLayer.animateState = STATE2;
            
        }else if ([anim isEqual:[self.menuLayer animationForKey:@"animationState2"]]){
            [_menuLayer removeAllAnimations];
            [_menuLayer addAnimation:_animationArray[2] forKey:@"animationState3"];
            _menuLayer.animateState = STATE3;
            
        }else if ([anim isEqual:[self.menuLayer animationForKey:@"animationState3"]]){
            
            //最后一定要设置为1,否则动画会变形
            self.menuLayer.XAxisPercent = 1.0;
            [_menuLayer removeAllAnimations];
            self.userInteractionEnabled = YES;
        }
    }
}

@end

