//
//  ViewController.m
//  UIDynamicBlockAnimation
//
//  Created by bjovov on 2017/9/13.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "ViewController.h"
#import "DynamicView.h"

@interface ViewController ()
@property (nonatomic,strong) DynamicView *dynamicView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _dynamicView = [[DynamicView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_dynamicView];
}

@end
