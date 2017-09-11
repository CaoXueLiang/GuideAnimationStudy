//
//  ViewController.m
//  CurveAnimationFresh
//
//  Created by bjovov on 2017/9/11.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Convenient.h"
#import "KYPullToCurveVeiw.h"
#import "KYPullToCurveVeiw_footer.h"


#define initialOffset 50.0
#define targetHeight 500.0

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *myTable;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.myTable];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    KYPullToCurveVeiw *headerView = [[KYPullToCurveVeiw alloc]initWithAssociatedScrollView:self.myTable withNavigationBar:YES];
    
    __weak KYPullToCurveVeiw *weakHeaderView = headerView;
    
    [headerView triggerPulling];
    [headerView addRefreshingBlock:^{
        //具体的操作
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakHeaderView stopRefreshing];
        });
        
    }];
    
    KYPullToCurveVeiw_footer *footerView = [[KYPullToCurveVeiw_footer alloc]initWithAssociatedScrollView:self.myTable withNavigationBar:YES];
    
    __weak KYPullToCurveVeiw_footer *weakFooterView= footerView;
    
    [footerView addRefreshingBlock:^{
        //具体的操作
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [weakFooterView stopRefreshing];
            
        });
    }];
    
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *testCell = [tableView dequeueReusableCellWithIdentifier:@"testCell" forIndexPath:indexPath];
    testCell.textLabel.text = [NSString stringWithFormat:@"第%ld条",(long)indexPath.row];
    return testCell;
    
}

- (UITableView *)myTable{
    if (!_myTable) {
        _myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) style:UITableViewStylePlain];
        [_myTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"testCell"];
        _myTable.delegate = self;
        _myTable.dataSource = self;
    }
    return _myTable;
}

@end
