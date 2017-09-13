//
//  ViewController.m
//  UIDynamicAnimation
//
//  Created by bjovov on 2017/9/13.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic,strong) UIImageView *lockScreenView;
@property (nonatomic,strong) UIDynamicAnimator *animator;
@property (nonatomic,strong) UIGravityBehavior *gravityBehavior;
@property (nonatomic,strong) UIPushBehavior *pushBehavior;
@property (nonatomic,strong) UIAttachmentBehavior *attachmentBehaviour;
@property (nonatomic,strong) UIDynamicItemBehavior *itermBehaviour;
@property (nonatomic,strong) UIButton *reatoreButton;
@end

@implementation ViewController
#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.reatoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.reatoreButton.frame = CGRectMake(0, 0, 100, 35);
    [self.reatoreButton setTitle:@"恢复" forState:UIControlStateNormal];
    [self.reatoreButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.reatoreButton addTarget:self action:@selector(restore) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.reatoreButton];
    self.reatoreButton.center = self.view.center;
    
    self.lockScreenView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    self.lockScreenView.image = [UIImage imageNamed:@"lockScreen"];
    self.lockScreenView.contentMode = UIViewContentModeScaleToFill;
    self.lockScreenView.userInteractionEnabled = YES;
    [self.view addSubview:self.lockScreenView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnIt:)];
    [self.lockScreenView addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panOnIt:)];
    [self.lockScreenView addGestureRecognizer:pan];
}
/*
 1.UIDynamicItem：用来描述一个力学物体的状态，其实就是实现了UIDynamicItem委托的对象，或者抽象为有面积有旋转的质点；
 2.UIDynamicBehavior：动力行为的描述，用来指定UIDynamicItem应该如何运动，即定义适用的物理规则。一般我们使用这个类的子类对象来对一组UIDynamicItem应该遵守的行为规则进行描述；
 3.UIDynamicAnimator；动画的播放者，动力行为（UIDynamicBehavior）的容器，添加到容器内的行为将发挥作用；
 4.ReferenceView：等同于力学参考系，如果你的初中物理不是语文老师教的话，我想你知道这是啥..只有当想要添加力学的UIView是ReferenceView的子view时，动力UI才发生作用。
 
 
 1.UIAttachmentBehavior 描述一个view和一个锚相连接的情况，也可以描述view和view之间的连接。attachment描述的是两个点之间的连接情况，可以通过设置来模拟无形变或者弹性形变的情况（再次希望你还记得这些概念，简单说就是木棒连接和弹簧连接两个物体）。当然，在多个物体间设定多个；UIAttachmentBehavior，就可以模拟多物体连接了..有了这些，似乎可以做个老鹰捉小鸡的游戏了- -…
 
 2.UISnapBehavior 将UIView通过动画吸附到某个点上。初始化的时候设定一下UISnapBehavior的initWithItem:snapToPoint:就行，因为API非常简单，视觉效果也很棒，估计它是今后非游戏app里会被最常用的效果之一了；
 
 3.UIPushBehavior 可以为一个UIView施加一个力的作用，这个力可以是持续的，也可以只是一个冲量。当然我们可以指定力的大小，方向和作用点等等信息。
 
 4.UIDynamicItemBehavior 其实是一个辅助的行为，用来在item层级设定一些参数，比如item的摩擦，阻力，角阻力，弹性密度和可允许的旋转等等
 */
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    
    //添加碰撞行为
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc]initWithItems:@[self.lockScreenView]];
    [collisionBehavior setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(-_lockScreenView.frame.size.height, 0, 0, 0)];
    [self.animator addBehavior:collisionBehavior];
    
    //添加重力行为
    self.gravityBehavior = [[UIGravityBehavior alloc]initWithItems:@[self.lockScreenView]];
    self.gravityBehavior.gravityDirection = CGVectorMake(0, 1.0);
    self.gravityBehavior.magnitude = 2.6f;
    [self.animator addBehavior:self.gravityBehavior];
    
    //添加push行为
    self.pushBehavior = [[UIPushBehavior alloc]initWithItems:@[self.lockScreenView] mode:UIPushBehaviorModeInstantaneous];
    self.pushBehavior.magnitude = 2.0f;
    self.pushBehavior.angle = M_PI;
    [self.animator addBehavior:self.pushBehavior];
    
    self.itermBehaviour = [[UIDynamicItemBehavior alloc]initWithItems:@[self.lockScreenView]];
    //1.0 完全弹性碰撞，需要非常久才能恢复；
    self.itermBehaviour.elasticity = 0.35;
    [self.animator addBehavior:self.itermBehaviour];
}

#pragma mark - Eevent Response
- (void)tapOnIt:(UITapGestureRecognizer *)recognizer{
    self.pushBehavior.pushDirection = CGVectorMake(0, -80.0f);
    //active is set to NO once the instantaneous force is applied. All we need to do is reactivate it on each button press.
    self.pushBehavior.active = YES;
}

- (void)panOnIt:(UIPanGestureRecognizer *)recognizer{
   CGPoint location = CGPointMake(CGRectGetMidX(_lockScreenView.frame), [recognizer locationInView:self.view].y);
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        //添加吸附行为
        [self.animator removeBehavior:self.gravityBehavior];
        self.attachmentBehaviour = [[UIAttachmentBehavior alloc]initWithItem:self.lockScreenView attachedToAnchor:location];
        [self.animator addBehavior:_attachmentBehaviour];
        
    }else if (recognizer.state == UIGestureRecognizerStateChanged){
        self.attachmentBehaviour.anchorPoint = location;
        
    }else if (recognizer.state == UIGestureRecognizerStateEnded){
        //移动速度，分为x轴和Y轴
        CGPoint velocity = [recognizer velocityInView:_lockScreenView];
        NSLog(@"v:%@",NSStringFromCGPoint(velocity));
        
        [self.animator removeBehavior:self.attachmentBehaviour];
        _attachmentBehaviour = nil;
        
        if (velocity.y < -1300.0f) {
            [self.animator removeBehavior:self.gravityBehavior];
            [self.animator removeBehavior:self.itermBehaviour];
            _gravityBehavior = nil;
            _itermBehaviour = nil;
            
            //重新建立重力和itermBehavior
            self.gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.lockScreenView]];
            self.gravityBehavior.gravityDirection = CGVectorMake(0.0, -1.0);
            self.gravityBehavior.magnitude = 2.6f;
            [self.animator addBehavior:self.gravityBehavior];
            
            self.itermBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self.lockScreenView]];
            self.itermBehaviour.elasticity = 0.0f;//1.0 完全弹性碰撞，需要非常久才能恢复；
            [self.animator addBehavior:_itermBehaviour];
            
            
            self.pushBehavior.pushDirection = CGVectorMake(0.0f, -200.0f);
            self.pushBehavior.active = YES;
            
        }else{
            [self restore];
        }
    }
}

- (void)restore{
    [_animator removeBehavior:_gravityBehavior];
    [_animator removeBehavior:_itermBehaviour];
    _gravityBehavior = nil;
    _itermBehaviour = nil;
    
    
    //gravity
    self.gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.lockScreenView]];
    self.gravityBehavior.gravityDirection = CGVectorMake(0.0, 1.0);
    self.gravityBehavior.magnitude = 2.6f;
    
    //item
    self.itermBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self.lockScreenView]];
    self.itermBehaviour.elasticity = 0.35f;//1.0 完全弹性碰撞，需要非常久才能恢复；
    [self.animator addBehavior:_itermBehaviour];
    
    [self.animator addBehavior:self.gravityBehavior];
    
}

@end

