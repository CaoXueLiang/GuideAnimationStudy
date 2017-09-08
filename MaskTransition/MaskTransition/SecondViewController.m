//
//  SecondViewController.m
//  MaskTransition
//
//  Created by bjovov on 2017/9/7.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "SecondViewController.h"
#import "SpreadInvertTranslationAnimation.h"

@interface SecondViewController ()<UINavigationControllerDelegate>
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *rightButton;
@end

@implementation SecondViewController
{
    UIPercentDrivenInteractiveTransition *percentTransition;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.rightButton];
    
    //添加左滑手势
    UIScreenEdgePanGestureRecognizer *panGesture = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(edgePan:)];
    panGesture.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:panGesture];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.delegate = self;
}

- (void)transformMenthod{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)edgePan:(UIPanGestureRecognizer *)recognizer{
    CGPoint currentPoint = [recognizer locationInView:self.view];
    CGFloat percent = currentPoint.x / self.view.bounds.size.width;
    percent = MIN(1, percent);
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        percentTransition = [[UIPercentDrivenInteractiveTransition alloc]init];
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if (recognizer.state == UIGestureRecognizerStateChanged){
        [percentTransition updateInteractiveTransition:percent];
        
    }else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled){
        if (percent > 0.3) {
            [percentTransition finishInteractiveTransition];
        }else{
            [percentTransition cancelInteractiveTransition];
        }
        percentTransition = nil;
    }
}

#pragma mark - UINavigationControllerDelegate
/*在过度动画中返回一个可交互的动画对象*/
- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    return percentTransition;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    
    if (operation == UINavigationControllerOperationPop) {
        return [SpreadInvertTranslationAnimation new];
    }else{
        return nil;
    }
}

#pragma mark - Setter && Getter
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"page2"]];
        _imageView.frame = self.view.bounds;
    }
    return _imageView;
}

- (UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _rightButton.frame = CGRectMake(10, 10, 80, 80);
        [_rightButton addTarget:self action:@selector(transformMenthod) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}


@end

