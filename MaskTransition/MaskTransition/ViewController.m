//
//  ViewController.m
//  MaskTransition
//
//  Created by bjovov on 2017/9/7.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "SpreadTranstionAimation.h"

@interface ViewController ()<UINavigationControllerDelegate>
@property (nonatomic,strong) UIImageView *imageView;
@end

@implementation ViewController
/*
 iOS7 开始苹果推出了自定义转场的 API 。
 从此，任何可以用 CoreAnimation 实现的动画，都可以出现在两个 ViewController 的切换之间。
 并且实现方式高度解耦,这也意味着在保证代码干净的同时想要替换其他动画方案时只需简单改一个类名就可以了
 
 
 使用准则就是:
 UINavigationController push- ViewController 时重载 UINavigationControllerDelegate 的方法;
 UIViewController presentViewController 时 重 载 UIViewController- TransitioningDelegate 的方法
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.rightButton];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.delegate = self;
}

- (void)transformMenthod{
    SecondViewController *controller = [[SecondViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UINavigationControllerDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush) {
        SpreadTranstionAimation *animation = [SpreadTranstionAimation new];
        return animation;
    }else{
        return nil;
    }
}

#pragma mark - Setter && Getter
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"page1"]];
        _imageView.frame = self.view.bounds;
    }
    return _imageView;
}

- (UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _rightButton.frame = CGRectMake(CGRectGetMaxX(self.view.bounds)-90, 10, 80, 80);
        [_rightButton addTarget:self action:@selector(transformMenthod) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

@end

