//
//  InteractiveCardView.h
//  InteractiveCardAnimation
//
//  Created by bjovov on 2017/9/11.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InteractiveCardView : UIImageView
@property (nonatomic,weak) UIView *dimmingView;
@property (nonatomic,weak) UIView *gestureView;
@end
