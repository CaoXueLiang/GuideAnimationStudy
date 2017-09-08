//
//  SecondViewController.m
//  BuddleTransition
//
//  Created by bjovov on 2017/9/8.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "SecondViewController.h"
#import "SpreadInvertTranslationAnimation.h"

@interface SecondViewController ()<UINavigationControllerDelegate>
@property (nonatomic,strong) SpreadInvertTranslationAnimation *buddleTransition;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.delegate = self;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    [self.navigationController popViewControllerAnimated:YES];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPop) {
        return [SpreadInvertTranslationAnimation new];
    }else{
        return nil;
    }
}

@end
