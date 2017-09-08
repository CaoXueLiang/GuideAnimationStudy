//
//  ViewController.m
//  BuddleTransition
//
//  Created by bjovov on 2017/9/8.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "ViewController.h"
#import "SpreadTranstionAimation.h"
#import "SecondViewController.h"

@interface ViewController ()<UINavigationControllerDelegate>
@property (nonatomic,strong) SpreadTranstionAimation *animation;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [self.navigationController setNavigationBarHidden:YES];
    _animation = [[SpreadTranstionAimation alloc]init];
}

/*
 必须在这里面设置Delegate
 否则就不走代理方法了
 */
- (void)viewWillAppear:(BOOL)animated{
   self.navigationController.delegate = self;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    _animation.currentPoint = currentPoint;
    _point = currentPoint;
    SecondViewController *controller = [[SecondViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush) {
        return _animation;
    }else{
        return nil;
    }
}


@end



