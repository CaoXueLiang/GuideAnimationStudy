//
//  tVOSCardView.m
//  tvOSCardAnimation
//
//  Created by bjovov on 2017/9/11.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "tVOSCardView.h"

@interface tVOSCardView()
@property (nonatomic,strong) UIImageView *cardImageView;
@property (nonatomic,strong) UIImageView *cardParallaxView;
@end

@implementation tVOSCardView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
     [self setUp];
    }
    return self;
}

- (void)setUp{
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 10);
    self.layer.shadowRadius = 10;
    self.layer.shadowOpacity = 3;
    
    self.cardImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    self.cardImageView.image = [UIImage imageNamed:@"poster"];
    self.cardImageView.layer.cornerRadius = 5;
    self.cardImageView.clipsToBounds = YES;
    [self addSubview:self.cardImageView];
    
    //添加手势
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panInCard:)];
    [self addGestureRecognizer:panGesture];
    
    self.cardParallaxView = [[UIImageView alloc]initWithFrame:_cardImageView.bounds];
    self.cardParallaxView.image = [UIImage imageNamed:@"5"];
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, 0, 0, 200);
    self.cardParallaxView.layer.transform = transform;
    [self insertSubview:self.cardParallaxView aboveSubview:self.cardImageView];
    
}


- (void)panInCard:(UIPanGestureRecognizer *)recognizer{
    CGPoint touchPoint = [recognizer locationInView:self];
    CGFloat HEIGHT = CGRectGetHeight(self.bounds);
    CGFloat WIDTH = CGRectGetWidth(self.bounds);
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat factorX = MIN(1, MAX(-1, (touchPoint.x - WIDTH/2)/(WIDTH/2)));
        CGFloat factorY = MIN(1, MAX(-1, (touchPoint.y - HEIGHT/2)/(HEIGHT/2)));
        
        /*一定记得是1.0不是1，否则透视值就变成0了*/
        self.cardImageView.layer.transform = [self transforM34:-1.0/500 xf:factorX yf:factorY];
        self.cardParallaxView.layer.transform = [self transforM34:-1.0/250 xf:factorX yf:factorY];
        
    }else if (recognizer.state == UIGestureRecognizerStateEnded){
        [UIView animateWithDuration:0.3  animations:^{
            self.cardParallaxView.layer.transform = CATransform3DIdentity;
            self.cardImageView.layer.transform = CATransform3DIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }
    
    NSLog(@"%@",NSStringFromCGPoint(touchPoint));
    
}

- (CATransform3D)transforM34:(CGFloat)m34 xf:(CGFloat)xf yf:(CGFloat)yf{
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = m34;
    transform = CATransform3DRotate(transform, M_PI/9 *xf,0,1,0);
    transform = CATransform3DRotate(transform, M_PI/9 *yf, -1, 0, 0);
    return transform;
}

@end
