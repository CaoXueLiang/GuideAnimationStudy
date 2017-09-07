//
//  CuteView.h
//  QQCuteView
//
//  Created by bjovov on 2017/9/7.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CuteView : UIView

/**
 父视图
 */
@property (nonatomic,strong) UIView *containerView;

/**
 气泡显示的数字
 */
@property (nonatomic,strong) UILabel *bubbleLabel;

/**
 气泡的直径
 */
@property (nonatomic,assign) CGFloat bubbleWidth;

/**
 气泡粘性系数,越大可以拉伸的越长
 */
@property (nonatomic,assign) CGFloat viscosity;

/**
 气泡的颜色
 */
@property (nonatomic,strong) UIColor *bubbleColor;

/**
 需要隐藏气泡时候可以使用这个属性：self.frontView.hidden = YES;
 */
@property (nonatomic,strong)UIView *frontView;


-(id)initWithPoint:(CGPoint)point superView:(UIView *)view;
-(void)setUp;

@end

