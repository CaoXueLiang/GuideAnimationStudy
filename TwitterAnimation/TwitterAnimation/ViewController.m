//
//  ViewController.m
//  TwitterAnimation
//
//  Created by bjovov on 2017/9/7.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic,strong) UIImageView *tmpView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"首页";
    self.tmpView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    self.tmpView.image = [UIImage imageNamed:@"home_demo"];
    [self.view addSubview:self.tmpView];
}

@end
