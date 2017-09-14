//
//  DynamicView.m
//  UIDynamicBlockAnimation
//
//  Created by bjovov on 2017/9/13.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "DynamicView.h"

#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
@interface DynamicView()
@property (strong,nonatomic) UIView *panView;
@property (strong,nonatomic) UIImageView *ballImageView;
@property (strong,nonatomic) UIView *middleView;
@property (strong,nonatomic) UIView *topView;
@property (strong,nonatomic) UIView *bottomView;
@property (strong,nonatomic) CAShapeLayer *shapeLayer;

@property (nonatomic,strong) UIDynamicAnimator *animator;
@property (nonatomic,strong) UIGravityBehavior *panGravity;
@property (nonatomic,strong) UIGravityBehavior *viewsGravity;

@end

@implementation DynamicView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews{
    //添加上部拖拽视图
    self.panView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight/2)];
    self.panView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.panView.layer.shadowOffset = CGSizeMake(-1, 2);
    self.panView.layer.shadowRadius = 5;
    self.panView.layer.shadowOpacity = 0.5;
    
    CAGradientLayer *layer = [[CAGradientLayer alloc]init];
    layer.frame = self.panView.frame;
    layer.colors = @[(__bridge id)([UIColor colorWithRed:0.0 green:191.0/255.0 blue:255.0/255.0 alpha:1].CGColor),(__bridge id)([UIColor whiteColor].CGColor)];
    layer.startPoint = CGPointMake(0.5, 0);
    layer.endPoint = CGPointMake(0.5, 1);
    [self.panView.layer addSublayer:layer];
    [self addSubview:self.panView];
    
    UIPanGestureRecognizer *pangesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panTheView:)];
    [self.panView addGestureRecognizer:pangesture];
    
    
    //添加足球
    _ballImageView = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth/2-30, KScreenHeight/1.5, 60, 60)];
    _ballImageView.image = [UIImage imageNamed:@"ball"];
    [self addSubview:_ballImageView];
    _ballImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    _ballImageView.layer.shadowOpacity = 0.5;
    _ballImageView.layer.shadowOffset = CGSizeMake(-4, 4);
    _ballImageView.layer.shadowRadius = 5;
    
    
    //添加方块
    _middleView = [[UIView alloc]initWithFrame:CGRectMake(KScreenWidth/2-15, KScreenHeight/2-15, 30, 30)];
    _middleView.backgroundColor = [UIColor grayColor];
    [self addSubview:_middleView];
    
    _topView = [[UIView alloc]initWithFrame:CGRectMake(KScreenWidth/2-15, KScreenHeight/4 + KScreenHeight/8 - 15, 30, 30)];
    _topView.backgroundColor = [UIColor grayColor];
    [self addSubview:_topView];
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(KScreenWidth/2-15, KScreenHeight/2 + KScreenHeight/8 - 15, 30, 30)];
    _bottomView.backgroundColor = [UIColor grayColor];
    [self addSubview:_bottomView];
    
    //设置重力效果
    [self setUpDynamicBehavior];
}


- (void)setUpDynamicBehavior{
    _animator = [[UIDynamicAnimator alloc]initWithReferenceView:self];
    
    //添加重力行为
    _panGravity = [[UIGravityBehavior alloc]initWithItems:@[_panView]];
    [_animator addBehavior:_panGravity];
    
    _viewsGravity = [[UIGravityBehavior alloc]initWithItems:@[_topView,_bottomView,_ballImageView]];
    [_animator addBehavior:_viewsGravity];
    
    __weak typeof(self) weakSelf = self;
    //在动画的每一步调用
    _viewsGravity.action = ^{
        NSLog(@"acting");
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:CGPointMake(weakSelf.panView.center.x, weakSelf.panView.center.y)];
        [bezierPath addCurveToPoint:weakSelf.ballImageView.center controlPoint1:weakSelf.topView.center controlPoint2:weakSelf.bottomView.center];
        
        if (!weakSelf.shapeLayer) {
            weakSelf.shapeLayer = [CAShapeLayer layer];
            weakSelf.shapeLayer.fillColor = [UIColor clearColor].CGColor;
            weakSelf.shapeLayer.strokeColor = [UIColor redColor].CGColor;
            weakSelf.shapeLayer.lineWidth = 5.0f;
            
            //设置阴影
            weakSelf.layer.shadowColor = [UIColor blackColor].CGColor;
            weakSelf.shapeLayer.shadowOffset = CGSizeMake(-1, 2);
            weakSelf.shapeLayer.shadowRadius = 5.0;
            weakSelf.shapeLayer.shadowOpacity = 0.5;
            
            [weakSelf.layer insertSublayer:weakSelf.shapeLayer below:weakSelf.ballImageView.layer];
        }
        weakSelf.shapeLayer.path = bezierPath.CGPath;
    };
    
    //添加碰撞行为
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc]initWithItems:@[_panView]];
    [collisionBehavior addBoundaryWithIdentifier:@"left" fromPoint:CGPointMake(-1, 0) toPoint:CGPointMake(-1, KScreenHeight)];
    [collisionBehavior addBoundaryWithIdentifier:@"right" fromPoint:CGPointMake(KScreenWidth+1, 0) toPoint:CGPointMake(KScreenWidth+1, KScreenHeight)];
    [collisionBehavior addBoundaryWithIdentifier:@"middle" fromPoint:CGPointMake(0, KScreenHeight/2) toPoint:CGPointMake(KScreenWidth, KScreenHeight/2)];
    [_animator addBehavior:collisionBehavior];
    
    //添加吸附行为
    UIAttachmentBehavior *attachment1 = [[UIAttachmentBehavior alloc]initWithItem:_panView attachedToItem:_topView];
    [_animator addBehavior:attachment1];
    
    UIAttachmentBehavior *attachment2 = [[UIAttachmentBehavior alloc]initWithItem:_topView attachedToItem:_bottomView];
    [_animator addBehavior:attachment2];
    
    UIAttachmentBehavior *attachment3 = [[UIAttachmentBehavior alloc]initWithItem:_bottomView offsetFromCenter:UIOffsetZero attachedToItem:_ballImageView offsetFromCenter:UIOffsetMake(0, _ballImageView.bounds.size.height/2)];
    [_animator addBehavior:attachment3];
    
    //添加itermBehavior
    UIDynamicItemBehavior *itermBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[_panView,_topView,_bottomView,_ballImageView]];
    itermBehavior.elasticity = 0.5;
    [_animator addBehavior:itermBehavior];
}

#pragma mark - Event Response
- (void)panTheView:(UIPanGestureRecognizer *)recognizer{
    CGPoint translation = [recognizer translationInView:recognizer.view];
    
    NSLog(@"%@--%@",NSStringFromCGPoint(translation),[recognizer.view class]);
    if (!(recognizer.view.center.y + translation.y > (self.bounds.size.height/2 - recognizer.view.bounds.size.height/2))) {
        recognizer.view.center = CGPointMake(recognizer.view.center.x, recognizer.view.center.y + translation.y);
        [recognizer setTranslation:CGPointMake(0, 0) inView:recognizer.view];
    }
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [_animator removeBehavior:_panGravity];
        
    }else if (recognizer.state == UIGestureRecognizerStateChanged){
    
    }else if (recognizer.state == UIGestureRecognizerStateEnded){
        [_animator addBehavior:_panGravity];
    }
    
    // Update the item state in the animator if an external change was made to this item
    /*
     当外界变化（比如_panGravity开始作用了）开始作用于pan.view上时,去刷新当前_animator中所有iterm的position和rotation,
     而这些iterm包括_ballImageView,_topView,_bottomView,position和rotation的变化又会触发_ballImageView,_topView,_bottomView这三者绑定的_viewsGravity.action
     在这个action中实时绘制一条贝塞尔曲线，就有了你看到的一条弹性的绳子，这个action在动画的每一步都会调用，所以动画会显得流畅.
     */
    [_animator updateItemUsingCurrentState:recognizer.view];
    
}

@end


