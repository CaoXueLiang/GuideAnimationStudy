//
//  ViewController.m
//  InteractiveCardAnimation
//
//  Created by bjovov on 2017/9/11.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "ViewController.h"
#import "InteractiveCardView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    InteractiveCardView *cardView = [[InteractiveCardView alloc]initWithImage:[UIImage imageNamed:@"pic01"]];
    cardView.center = self.view.center;
    cardView.bounds = CGRectMake(0, 0, 200, 150);
    [cardView setGestureView:self.view];
    
    
    //添加模糊视图
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    blurView.frame = self.view.bounds;
    [self.view addSubview:blurView];
    cardView.dimmingView = blurView;
    
    
    //interactiveView 的父视图。
    //注意：interactiveView 和 blurView 不能添加到同一个父视图。否则透视效果会使 interactiveView 穿过 blurView
    UIView *back = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:back];
    [back addSubview:cardView];
}


@end
