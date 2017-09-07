//
//  GooeySlideMenuView.h
//  GooeySlideMenuDemo
//
//  Created by bjovov on 2017/9/6.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GooeySlideMenuView : UIView
- (instancetype)initWithArray:(NSArray*)array;
- (void)showSliderView;
@property (nonatomic,copy) void(^menuButtonClicked)(NSString *title);
@end
