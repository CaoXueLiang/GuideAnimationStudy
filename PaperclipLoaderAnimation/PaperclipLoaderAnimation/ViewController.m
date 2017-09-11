//
//  ViewController.m
//  PaperclipLoaderAnimation
//
//  Created by bjovov on 2017/9/9.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "ViewController.h"
#import "LoadingHUD.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    [LoadingHUD showHUD];
}


@end
