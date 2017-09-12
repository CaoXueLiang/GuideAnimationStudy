//
//  ViewController.m
//  tvOSCardAnimation
//
//  Created by bjovov on 2017/9/11.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "ViewController.h"
#import "tVOSCardView.h"

@interface ViewController ()
@property (nonatomic,strong) tVOSCardView *cardView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:191/255.0 green:209/255.0 blue:220/255.0 alpha:1];
    _cardView = [[tVOSCardView alloc]initWithFrame:CGRectMake(0, 0, 150, 200)];
    _cardView.center = self.view.center;
    [self.view addSubview:_cardView];
}



@end
