//
//  ViewController.m
//  CAReplicatorLayerAnimation
//
//  Created by bjovov on 2017/9/14.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "ViewController.h"
#import "ReplicatorLoader.h"

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
}

@end
