//
//  ViewController.m
//  CiycleAniamtionDemo
//
//  Created by bjovov on 2017/9/6.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "ViewController.h"
#import "CircleView.h"

@interface ViewController ()
@property (nonatomic,strong) CircleView *circleView;
@property (nonatomic,strong) UISlider *slider;
@property (nonatomic,strong) UILabel *tipLabel;
@end

@implementation ViewController
#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.circleView];
    [self.view addSubview:self.slider];
    [self.view addSubview:self.tipLabel];
    self.circleView.progressValue = 0.5;
    self.tipLabel.text = [NSString stringWithFormat:@"当前值：%.2f",0.5];
}

#pragma mark - Event Response
- (void)valueChanged{
    self.circleView.progressValue = _slider.value;
    self.tipLabel.text = [NSString stringWithFormat:@"当前值：%.2f",_slider.value];
}

#pragma mark - Setter && Getter
- (CircleView *)circleView{
    if (!_circleView) {
        _circleView = [[CircleView alloc]initWithFrame:self.view.bounds];
    }
    return _circleView;
}

- (UISlider *)slider{
    if (!_slider) {
        _slider = [[UISlider alloc]initWithFrame:CGRectMake(40, self.view.bounds.size.height - 100, self.view.bounds.size.width - 80, 50)];
        _slider.minimumValue = 0;
        _slider.maximumValue = 1;
        _slider.value = 0.5;
        [_slider addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, self.view.bounds.size.height - 150, self.view.bounds.size.width - 80, 20)];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont systemFontOfSize:18];
        _tipLabel.textColor = [UIColor blackColor];
    }
    return _tipLabel;
}

@end

