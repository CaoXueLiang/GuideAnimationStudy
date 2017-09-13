//
//  ViewController.m
//  GooeyMenuAnimation
//
//  Created by bjovov on 2017/9/12.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "ViewController.h"
#import "Menu.h"
#import "GooeyMenuView.h"

@interface ViewController ()<menuDidSelectedDelegate>
@property (nonatomic,strong) Menu *menu;
@end

@implementation ViewController{
    GooeyMenuView *gooeyMenu;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    /*gooeyMenu = [[GooeyMenuView alloc]initWithOrigin:CGPointMake(CGRectGetMidX(self.view.frame)-50, 500) andDiameter:100.0f andSuperView:self.view themeColor:[UIColor redColor]];
    gooeyMenu.menuDelegate = self;
    gooeyMenu.radius = 100/4;//大圆的1/4
    gooeyMenu.extraDistance = 20;
    gooeyMenu.menuCount = 5;
    gooeyMenu.menuImagesArray = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"tabbarItem_discover highlighted"],[UIImage imageNamed:@"tabbarItem_group highlighted"],[UIImage imageNamed:@"tabbarItem_home highlighted"],[UIImage imageNamed:@"tabbarItem_message highlighted"],[UIImage imageNamed:@"tabbarItem_user_man_highlighted"], nil];*/
    
    [self addMenu];
}

-(void)menuDidSelected:(int)index{
    NSLog(@"选中第%d",index);
}


- (void)addMenu{
    _menu = [[Menu alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    _menu.center = self.view.center;
    [self.view addSubview:_menu];
}

@end
