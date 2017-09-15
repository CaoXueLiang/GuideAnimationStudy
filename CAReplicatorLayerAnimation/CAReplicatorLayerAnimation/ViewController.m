//
//  ViewController.m
//  CAReplicatorLayerAnimation
//
//  Created by bjovov on 2017/9/14.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "ViewController.h"
#import "ReplicatorLoader.h"
#import "ReplicatorCircleView.h"
#import "ReflectionView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat WIDTH = CGRectGetWidth(self.view.bounds);
    CGFloat HEIGHT = CGRectGetHeight(self.view.bounds);
    
    ReplicatorLoader *pulseLoader = [[ReplicatorLoader alloc]initWithFrame:CGRectMake(WIDTH/2-50, HEIGHT/2-50, 100, 100) Type:LoaderTypePulse];
    [self.view addSubview:pulseLoader];
    
    ReplicatorLoader *dotsLoader = [[ReplicatorLoader alloc]initWithFrame:CGRectMake(WIDTH/2-50, 100, 100, 100) Type:LoaderTypeDots];
    [self.view addSubview:dotsLoader];
    
    ReplicatorLoader *girdLoader = [[ReplicatorLoader alloc]initWithFrame:CGRectMake(WIDTH/2-50, HEIGHT - 200, 100, 100) Type:LoaderTypeGrid];
    [self.view addSubview:girdLoader];
    
    
    //圆环动画
    /*ReplicatorCircleView *circleView = [[ReplicatorCircleView alloc]initWithFrame:CGRectMake(WIDTH/2-50, HEIGHT/2-50, 100, 100)];
    [self.view addSubview:circleView];*/
    
    
    //反射
    /*ReflectionView *reflect = [[ReflectionView alloc]initWithFrame:CGRectMake(WIDTH/2-100, HEIGHT/2-60, 200, 120)];
    UIImageView *image = [[UIImageView alloc]initWithFrame:reflect.bounds];
    image.image = [UIImage imageNamed:@"IMG_1988"];
    reflect.reflectionScale = 0.5;
    reflect.reflectionAlpha = 0.5;
    reflect.reflectionGap = 4;
    [reflect addSubview:image];
    [self.view addSubview:reflect];*/
    
}

@end


