//
//  CurveLayer.h
//  CurveAnimationFresh
//
//  Created by bjovov on 2017/9/11.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CurveLayer : CALayer

/**
 calayer的进度 0~1之间
 */
@property (nonatomic,assign) CGFloat progress;
@end
