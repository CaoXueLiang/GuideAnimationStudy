//
//  CircleView.m
//  CiycleAniamtionDemo
//
//  Created by bjovov on 2017/9/6.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "CircleView.h"
#import "CircleLayer.h"

@interface CircleView()
@property (nonatomic,strong) CircleLayer *circleLayer;
@end

@implementation CircleView
#pragma mark - Init Menthod
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews{
    _circleLayer = [[CircleLayer alloc]init];
    _circleLayer.frame = self.bounds;
    [self.layer addSublayer:_circleLayer];
}

- (void)setProgressValue:(CGFloat)progressValue{
    _circleLayer.progress = progressValue;
}

@end

