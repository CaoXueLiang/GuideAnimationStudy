//
//  GooeySlideMenuView.m
//  GooeySlideMenuDemo
//
//  Created by bjovov on 2017/9/6.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "GooeySlideMenuView.h"
#import "MenuButton.h"

#define KEYWINDOW [UIApplication sharedApplication].keyWindow
#define KSCREENWIDTH [UIApplication sharedApplication].keyWindow.frame.size.width
#define KSCREENHEIGHT [UIApplication sharedApplication].keyWindow.frame.size.height
#define RIGHTMARGIN 50
#define buttonSpace 30
#define buttonHeight 40
@interface GooeySlideMenuView()
@property (nonatomic,strong) UIView *backGroundView;
@property (nonatomic,strong) CADisplayLink *displayLink;
@property (nonatomic,strong) UIView *helperSideView;
@property (nonatomic,strong) UIView *helperCenderView;
@property (nonatomic,assign) NSInteger animationCount; //记录动画的数量
@property (nonatomic,assign) float diff;//X轴的差值
@end

@implementation GooeySlideMenuView
#pragma mark - Init Menthod
- (instancetype)initWithArray:(NSArray*)array{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(-KSCREENWIDTH/2.0-RIGHTMARGIN, 0, KSCREENWIDTH/2.0+RIGHTMARGIN, KSCREENHEIGHT);
        [KEYWINDOW addSubview:self];
        [KEYWINDOW addSubview:self.helperSideView];
        [KEYWINDOW addSubview:self.helperCenderView];
        [self addGesture];
        [self addButtons:array];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(KEYWINDOW.frame.size.width/2, 0)];
    [path addQuadCurveToPoint:CGPointMake(KSCREENWIDTH/2, KSCREENHEIGHT) controlPoint:CGPointMake(KSCREENWIDTH/2+self.diff, KSCREENHEIGHT/2)];
    [path addLineToPoint:CGPointMake(0, KSCREENHEIGHT)];
    [path closePath];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, path.CGPath);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0 green:0.722 blue:1 alpha:1].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextDrawPath(context, kCGPathFill);
}

- (void)addButtons:(NSArray *)array{
    if (array.count % 2 == 0) {
       __block NSInteger index_down = array.count/2;
       __block NSInteger index_up = -1;
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *title = obj;
            MenuButton *button = [[MenuButton alloc]initWithTitle:title];
            button.frame = CGRectMake(0, 0, KSCREENWIDTH/2.0-20*2, buttonHeight);
            if (idx >= array.count/2) {
                index_up++;
                button.center = CGPointMake(KSCREENWIDTH/4, KSCREENHEIGHT/2 + buttonHeight*index_up + buttonSpace/2.0 + buttonSpace*index_up + buttonHeight/2.0);
            }else{
                index_down--;
                button.center = CGPointMake(KEYWINDOW.frame.size.width/4, KEYWINDOW.frame.size.height/2 - buttonHeight*index_down - buttonSpace*index_down - buttonSpace/2 - buttonHeight/2);
            }
            button.buttonColor = [UIColor colorWithRed:0 green:0.722 blue:1 alpha:1];
            [self addSubview:button];
            NSLog(@"%@",button);
            __weak typeof(self) weakSelf = self;
            button.buttonClciked = ^(){
                [weakSelf dissMenthod];
                if (weakSelf.menuButtonClicked) {
                    weakSelf.menuButtonClicked(title);
                }
            };
        }];
    }else{
        NSInteger index = (array.count - 1) /2 +1;
        for (NSInteger i = 0; i < array.count; i++) {
            index --;
            NSString *title = array[i];
            MenuButton *home_button = [[MenuButton alloc]initWithTitle:title];
            home_button.frame = CGRectMake(0, 0, KEYWINDOW.frame.size.width/2 - 20*2, buttonHeight);
            home_button.center = CGPointMake(KEYWINDOW.frame.size.width/4, KEYWINDOW.frame.size.height/2 - buttonHeight*index - 20*index);
            home_button.buttonColor = [UIColor colorWithRed:0 green:0.722 blue:1 alpha:1];
            [self addSubview:home_button];
            
            __weak typeof(self) WeakSelf = self;
            home_button.buttonClciked = ^(){
                [WeakSelf dissMenthod];
                if (WeakSelf.menuButtonClicked) {
                    WeakSelf.menuButtonClicked(title);
                }
            };
        }
    }
}

#pragma mark - Event Response
- (void)addGesture{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dissMenthod)];
    [self.backGroundView addGestureRecognizer:tapGesture];
}

- (void)displayAction:(CADisplayLink*)link{
    /*
     注意：直接使用self.helperSideView获取到的frame是不变的
     Presentation Layer 的作用 —— 即可以实时获取 Layer 属性的当前值。
     */
    CALayer *sideHelperPresentationLayer   =  (CALayer *)[self.helperSideView.layer presentationLayer];
    CALayer *centerHelperPresentationLayer =  (CALayer *)[self.helperCenderView.layer presentationLayer];
    
    CGRect centerRect = [[centerHelperPresentationLayer valueForKeyPath:@"frame"]CGRectValue];
    CGRect sideRect = [[sideHelperPresentationLayer valueForKeyPath:@"frame"]CGRectValue];
    self.diff = sideRect.origin.x - centerRect.origin.x;
    
    [self setNeedsDisplay];
}

-(void)animateButtons{
    for (NSInteger i = 0; i < self.subviews.count; i++) {
        UIView *menuButton = self.subviews[i];
        menuButton.transform = CGAffineTransformMakeTranslation(-90, 0);
        [UIView animateWithDuration:0.7 delay:i*(0.3/self.subviews.count) usingSpringWithDamping:0.6f initialSpringVelocity:0.0f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
            menuButton.transform =  CGAffineTransformIdentity;
        } completion:NULL];
    }
}

/**
 动画开始之前调用
 */
- (void)beforeAnimation{
    if (!self.displayLink) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayAction:)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    self.animationCount++;
}

/**
 动画结束之后调用
 */
- (void)finishAnimation{
    self.animationCount--;
    if (self.animationCount == 0) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

#pragma mark - Public Menthod
/*
 我们创建了两个辅助视图，设置起点和终点都一样，利用弹性动画天生的回弹特性，
 我们只要赋予两个辅助视图以不同的动画参数，并且实时计算出两个辅助视图的横坐标 X 之差，
 就可以间接地得到一组从 0 增至一个正数后，递减至一个负数，最后再回到 0 的数据
 */
- (void)showSliderView{
    //进行动画第一步
   [KEYWINDOW insertSubview:self.backGroundView belowSubview:self];
   [UIView animateWithDuration:0.3 animations:^{
       self.backGroundView.alpha = 0.7;
       self.frame = CGRectMake(0, 0, KSCREENWIDTH/2+RIGHTMARGIN, KSCREENHEIGHT);
   }completion:^(BOOL finished) {
       
   }];
    
    //弹簧动画
    [self beforeAnimation];
    [UIView animateWithDuration:0.5 delay:0.0f usingSpringWithDamping:0.3 initialSpringVelocity:0.6 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        self.helperSideView.center = CGPointMake(KSCREENWIDTH/2.0, 20);
    } completion:^(BOOL finished) {
        [self finishAnimation];
    }];
    
    [self beforeAnimation];
    [UIView animateWithDuration:0.7 delay:0.0f usingSpringWithDamping:0.8f initialSpringVelocity:2.0f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        self.helperCenderView.center = KEYWINDOW.center;
    } completion:^(BOOL finished) {
        if (finished) {
            [self finishAnimation];
        }
    }];
    
    //按钮动画
    [self animateButtons];
}

- (void)dissMenthod{
    [UIView animateWithDuration:0.3 animations:^{
        self.backGroundView.alpha = 0;
        self.frame = CGRectMake(-KSCREENWIDTH/2-RIGHTMARGIN, 0, KSCREENWIDTH/2+RIGHTMARGIN, KSCREENHEIGHT);
    } completion:^(BOOL finished) {
        //[self removeFromSuperview];
    }];
    
    [self beforeAnimation];
    [UIView animateWithDuration:0.7 delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:0.9f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        self.helperSideView.center = CGPointMake(-20, 0);
    } completion:^(BOOL finished) {
        [self finishAnimation];
    }];
    
    
    [self beforeAnimation];
    [UIView animateWithDuration:0.7 delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:2.0f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        self.helperCenderView.center = CGPointMake(-20, KSCREENWIDTH/2);
    } completion:^(BOOL finished) {
        [self finishAnimation];
    }];
}

#pragma mark - Setter && Getter
- (UIView *)backGroundView{
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc]init];
        _backGroundView.frame = KEYWINDOW.frame;
        _backGroundView.backgroundColor = [UIColor blackColor];
        _backGroundView.alpha = 0;
    }
    return _backGroundView;
}


- (UIView *)helperSideView{
    if (!_helperSideView) {
        _helperSideView = [[UIView alloc]initWithFrame:CGRectMake(-40, 0, 40, 40)];
        _helperSideView.hidden = YES;
    }
    return _helperSideView;
}

- (UIView *)helperCenderView{
    if (!_helperCenderView) {
        _helperCenderView = [[UIView alloc]initWithFrame:CGRectMake(-40, KSCREENHEIGHT/2-20, 40, 40)];
        _helperCenderView.hidden = YES;
    }
    return _helperCenderView;
}

@end

