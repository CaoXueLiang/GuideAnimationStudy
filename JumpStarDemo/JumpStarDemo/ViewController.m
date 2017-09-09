//
//  ViewController.m
//  JumpStarDemo
//
//  Created by bjovov on 2017/9/8.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic,strong) UIButton *jumpButton;
@property (nonatomic,strong) UIImageView *starImageView;
@property (nonatomic,copy)   NSString *currentImageName;
@end

static CGFloat UpDurition = 0.125;
static CGFloat DownDurition = 0.215;
@implementation ViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    [self.view addSubview:self.starImageView];
    [self.view addSubview:self.jumpButton];
    self.starImageView.frame = CGRectMake(width/2-10, height/2 - 10, 20, 20);
    self.jumpButton.frame = CGRectMake(width/2 - 40, height/2 + 40, 80, 40);
    self.currentImageName = @"circle";
}

#pragma mark - Event Response
- (void)clickedMenthod{
    [self animationMenthod];
}

/*动画分析：
 一个弹上去的阶段，一个落下来的阶段。弹上去的过程让视图绕 y 轴旋转 90 °，此时第一阶段的动画结束。
 在代理方法 animationDidStop 中开始第二个动画 ——、下落。在这个阶段一开始立刻替换图片， 随后在落下的同时让视图 继续旋转 90°
 */
- (void)animationMenthod{
    CABasicAnimation *upAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    upAnimation.fromValue = @(self.starImageView.center.y);
    upAnimation.toValue = @(self.starImageView.center.y - 14);
    upAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CABasicAnimation *transFormAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    transFormAnimation.fromValue = @(0);
    transFormAnimation.toValue = @(M_PI_2);
    transFormAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.duration = UpDurition;
    groupAnimation.animations = @[upAnimation,transFormAnimation];
    groupAnimation.removedOnCompletion = NO;
    groupAnimation.fillMode = kCAFillModeForwards;
    groupAnimation.delegate = self;
    [self.starImageView.layer addAnimation:groupAnimation forKey:@"UPAnimation"];
}

- (void)downAnimation{
    if ([self.currentImageName isEqualToString:@"circle"]) {
        self.currentImageName = @"star";
    }else{
        self.currentImageName = @"circle";
    }
    self.starImageView.image = [UIImage imageNamed:self.currentImageName];
    
    CABasicAnimation *upAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    upAnimation.toValue = @(self.starImageView.center.y);
    upAnimation.fromValue = @(self.starImageView.center.y - 14);
    upAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CABasicAnimation *transFormAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    transFormAnimation.toValue = @(M_PI);
    transFormAnimation.fromValue = @(M_PI_2);
    transFormAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.duration = DownDurition;
    groupAnimation.animations = @[upAnimation,transFormAnimation];
    groupAnimation.removedOnCompletion = NO;
    groupAnimation.fillMode = kCAFillModeForwards;
    groupAnimation.delegate = self;
    [self.starImageView.layer addAnimation:groupAnimation forKey:@"DownAnimation"];
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    if ([anim isEqual:[self.starImageView.layer animationForKey:@"UPAnimation"]]) {
        [self downAnimation];
    }else if ([anim isEqual:[self.starImageView.layer animationForKey:@"DownAnimation"]]){
        [self.starImageView.layer removeAllAnimations];
    }
}

#pragma mark - Setter && Getter
- (UIImageView *)starImageView{
    if (!_starImageView) {
        _starImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"circle"]];
    }
    return _starImageView;
}

- (UIButton *)jumpButton{
    if (!_jumpButton) {
        _jumpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_jumpButton setTitle:@"Clicked" forState:UIControlStateNormal];
        [_jumpButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_jumpButton addTarget:self action:@selector(clickedMenthod) forControlEvents:UIControlEventTouchUpInside];
    }
    return _jumpButton;
}

@end


