//
//  ViewController.m
//  GooeySlideMenuDemo
//
//  Created by bjovov on 2017/9/6.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "ViewController.h"
#import "GooeySlideMenuView.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *myTable;
@property (nonatomic,strong) UIButton *tapButton;
@property (nonatomic,strong) GooeySlideMenuView *menuView;
@end

@implementation ViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"首页";
    [self addSubViews];
}

- (void)addSubViews{
    [self.view addSubview:self.myTable];
    [self.view addSubview:self.tapButton];
    self.menuView.menuButtonClicked = ^(NSString *menu){
        NSLog(@"%@",menu);
    };
}

#pragma mark - Event Response
- (void)clicked{
    [self.menuView showSliderView];
}

#pragma mark - UITableView M
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.text = [NSString stringWithFormat:@"NO%ld",indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

#pragma mark - Setter && Getter
- (UITableView *)myTable{
    if (!_myTable) {
        _myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)style:UITableViewStylePlain];
        _myTable.delegate = self;
        _myTable.dataSource = self;
        _myTable.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _myTable;
}

- (UIButton *)tapButton{
    if (!_tapButton) {
        _tapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _tapButton.backgroundColor = [UIColor clearColor];
        _tapButton.frame = CGRectMake(CGRectGetWidth(self.view.bounds) - 100, CGRectGetHeight(self.view.bounds) - 80, 80, 50);
        [_tapButton setTitle:@"Clicked" forState:UIControlStateNormal];
        [_tapButton setTitleColor:[UIColor colorWithRed:0 green:0.722 blue:1 alpha:1] forState:UIControlStateNormal];
        [_tapButton addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tapButton;
}

- (GooeySlideMenuView *)menuView{
    if (!_menuView) {
        _menuView = [[GooeySlideMenuView alloc]initWithArray:@[@"首页",@"消息",@"发布",@"发现",@"个人",@"设置"]];
    }
    return _menuView;
}

@end

