//
//  SpreadTranstionAimation.h
//  MaskTransition
//
//  Created by bjovov on 2017/9/8.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*
 动画类创建步骤:
 1.创 建 继 承 自 NSObject 并 且 声 明 UIViewControllerAnimatedTran-sitioning 的的动画类。
 2.重载 UIViewControllerAnimatedTransitioning 中的协议方法。
 */

@interface SpreadTranstionAimation : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic,assign) CGPoint currentPoint;
@end
