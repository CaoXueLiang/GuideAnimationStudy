//
//  MenuButton.h
//  GooeySlideMenuDemo
//
//  Created by bjovov on 2017/9/7.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuButton : UIView

/**
 初始化方法
 @param title title
 @return button
 */
- (instancetype)initWithTitle:(NSString*)title;

/**
 按钮颜色
 */
@property (nonatomic,strong) UIColor *buttonColor;

/**
 点击回调
 */
@property (nonatomic,copy) void(^buttonClciked)();
@end
