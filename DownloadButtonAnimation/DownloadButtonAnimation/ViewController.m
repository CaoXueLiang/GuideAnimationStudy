//
//  ViewController.m
//  DownloadButtonAnimation
//
//  Created by bjovov on 2017/9/8.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "ViewController.h"
#import "DownLoadButton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    DownLoadButton *button = [[DownLoadButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    button.center = self.view.center;
    [self.view addSubview:button];
    button.progressBarWidth = 200;
    button.progressBarHeight = 30;
}


@end
