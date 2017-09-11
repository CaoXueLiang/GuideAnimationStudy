//
//  LabelView.h
//  CurveAnimationFresh
//
//  Created by bjovov on 2017/9/11.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    UP,
    DOWN,
} PULLINGSTATE;


@interface LabelView : UIView
/**
 *  LabelView的进度 0~1
 */
@property(nonatomic,assign)CGFloat progress;


/**
 *  是否正在刷新
 */
@property(nonatomic,assign)BOOL loading;


/**
 *  上拉还是下拉
 */
@property(nonatomic,assign)PULLINGSTATE state;
@end
