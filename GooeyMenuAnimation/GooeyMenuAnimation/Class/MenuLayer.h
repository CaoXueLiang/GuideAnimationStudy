//
//  MenuLayer.h
//  GooeyMenuAnimation
//
//  Created by bjovov on 2017/9/13.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSUInteger, STATE){
    STATE1,
    STATE2,
    STATE3,
};

@interface MenuLayer : CALayer
/**
 动画状态
 */
@property (nonatomic,assign) STATE animateState;

/**
 自定义的layer属性
 */
@property (nonatomic,assign) CGFloat XAxisPercent;

/**
 是否显示辅助视图
 */
@property (nonatomic,assign) BOOL showDebug;

@end
