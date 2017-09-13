//
//  GooeyMenuView.h
//  GooeyMenuAnimation
//
//  Created by bjovov on 2017/9/13.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol menuDidSelectedDelegate <NSObject>
-(void)menuDidSelected:(int)index;
@end

@interface GooeyMenuView : UIView
/**
 菜单个数
 */
@property (nonatomic,assign) int menuCount;

/**
 圆形菜单半径
 */
@property (nonatomic,assign) CGFloat radius;

/**
 这里的距离是指 除了"R+r" 额外的高度，也就是中间空白的距离，如果distance设为0，你将看到它们相切
 */
@property (nonatomic,assign) CGFloat extraDistance;

/**
 主视图
 */
@property(nonatomic,strong)UIView *mainView;

/**
 图片数组
 */
@property(nonatomic,strong)NSMutableArray *menuImagesArray;

/**
 *  Initialize
 *
 *  @param origin     the origin of menu
 *  @param diameter   diameter
 *  @param superView  superView
 *  @param themeColor the theme color of menu and item
 *
 *  @return self
 */
-(id)initWithOrigin:(CGPoint)origin andDiameter:(CGFloat)diameter andSuperView:(UIView *)superView themeColor:(UIColor *)themeColor;

/**
 *  The delegate of KYGooeyMenu
 */
@property(nonatomic,weak)id<menuDidSelectedDelegate> menuDelegate;

@end

