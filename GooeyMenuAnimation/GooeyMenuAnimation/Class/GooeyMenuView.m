//
//  GooeyMenuView.m
//  GooeyMenuAnimation
//
//  Created by bjovov on 2017/9/13.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "GooeyMenuView.h"
#import "Cross.h"

@interface GooeyMenuView()
@property(nonatomic,strong)UIView *containerView;
@end

@implementation GooeyMenuView{
    NSMutableDictionary *PointsDic;
    NSMutableArray *Menus;
    NSMutableArray *MenuLayers;
    CGRect menuFrame;
    int menuCount;
    UIColor *menuColor;
    CGFloat R;
    CGFloat r;
    CGFloat distance;
    BOOL isOpened;
    CAShapeLayer *verticalLineLayer;
    
    NSArray *values1_0_right;
    NSArray *values1_0_left;
    NSArray *values0_1_left;
    NSArray *values0_1_right;
    
    Cross *cross;
    
    BOOL once;
}

-(id)initWithOrigin:(CGPoint)origin andDiameter:(CGFloat)diameter andSuperView:(UIView *)superView themeColor:(UIColor *)themeColor{
    menuFrame = CGRectMake(origin.x, origin.y, diameter, diameter);
    self = [super initWithFrame:menuFrame];
    
    if (self) {
        PointsDic = [NSMutableDictionary dictionary];
        menuColor = themeColor;
        isOpened = NO;
        self.containerView = superView;
        [self.containerView addSubview:self];
        once = NO;
        [self addSomeViews];
    }
    
    return self;
}

-(void)setMenuCount:(int)MenuCount{
    Menus = [NSMutableArray arrayWithCapacity:MenuCount];
    MenuLayers = [NSMutableArray arrayWithCapacity:MenuCount];
    menuCount = MenuCount;
    once = NO;
}

-(void)addSomeViews{
    self.mainView = [[UIView alloc]initWithFrame:menuFrame];
    self.mainView.backgroundColor = menuColor;
    self.mainView.layer.cornerRadius = self.mainView.bounds.size.width / 2;
    self.mainView.layer.masksToBounds = YES;
    [self.containerView addSubview:self.mainView];
    
    //The cross view
    cross = [[Cross alloc]init];
    cross.center = CGPointMake(self.mainView.bounds.size.width/2, self.mainView.bounds.size.height/2);
    cross.bounds = CGRectMake(0, 0, menuFrame.size.width/2, menuFrame.size.width/2);
    cross.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:cross];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToSwitchOpenOrClose)];
    [self.mainView addGestureRecognizer:tapGes];
}

-(void)setUpSomeDatas{
    
    //-----------Calculate the destination point of items----------
    R = self.mainView.bounds.size.width / 2;
    r = self.radius;
    
    //the distance between items and menu
    distance = R + r + self.extraDistance;
    
    //the degree of every two items
    CGFloat degree = (180/(menuCount+1))*(M_PI/180);
    
    CGPoint originPoint = self.mainView.center;
    for (int i = 0; i < menuCount; i++) {
        CGFloat cosDegree = cosf(degree * (i+1));
        CGFloat sinDegree = sinf(degree * (i+1));
        
        CGPoint center = CGPointMake(originPoint.x + distance*cosDegree, originPoint.y - distance*sinDegree);
        NSLog(@"centers:%@",NSStringFromCGPoint(center));
        [PointsDic setObject:[NSValue valueWithCGPoint:center] forKey:[NSString stringWithFormat:@"center%d",i+1]];
        
        //Create items
        UIView *item = [[UIView alloc]initWithFrame:CGRectZero];
        item.backgroundColor = menuColor;
        item.tag = i+1;
        item.center = self.mainView.center;
        item.bounds = CGRectMake(0, 0, r *2, r*2);
        item.layer.cornerRadius = item.bounds.size.width / 2;
        item.layer.masksToBounds = YES;
        
        //Setup the image of every item
        CGFloat imageWidth = (item.frame.size.width / 2) *sin(M_PI_4) * 2;
        UIImageView *menuImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageWidth, imageWidth)];
        menuImage.center = CGPointMake(item.frame.size.width/2, item.frame.size.height/2);
        //        if (i<menuCount-1) {
        menuImage.image = self.menuImagesArray[i];
        //        }
        [item addSubview:menuImage];
        
        UITapGestureRecognizer *menuTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(menuTap:)];
        [item addGestureRecognizer:menuTap];
        
        [self.containerView insertSubview:item belowSubview:self.mainView];
        [Menus addObject:item];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.fillColor = menuColor.CGColor;
        [self.containerView.layer insertSublayer:shapeLayer atIndex:0];
        [MenuLayers addObject:shapeLayer];
        
    }
}

#pragma mark - tap the item
-(void)menuTap:(UITapGestureRecognizer *)tapGes{
    
    for (int i = 0; i<menuCount; i++) {
        if ((tapGes.view.tag == i+1) && [self.menuDelegate respondsToSelector:@selector(menuDidSelected:)]) {
            [self.menuDelegate menuDidSelected:i+1];
        }
    }
    
    [self tapToSwitchOpenOrClose];
}


#pragma mark - tap the menu
-(void)tapToSwitchOpenOrClose{
    
    if (!once) {
        [self setUpSomeDatas];
        //        NSAssert(self.menuImagesArray.count == menuCount, @"Images' count is not equal with menus' count");
        once = YES;
    }
    
    if (verticalLineLayer == nil) {
        verticalLineLayer = [CAShapeLayer layer];
        verticalLineLayer.fillColor = [menuColor CGColor];
        [self.containerView.layer insertSublayer:verticalLineLayer below:self.mainView.layer];
    }
    
    if (isOpened == NO) {
        
        for (UIView *item in Menus) {
            
            item.hidden = NO;
            [UIView animateWithDuration:1.0f delay:0.05*item.tag usingSpringWithDamping:0.4f initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
                
                NSValue *pointValue = [PointsDic objectForKey:[NSString stringWithFormat:@"center%d",(int)item.tag]];
                CGPoint terminalPoint = [pointValue CGPointValue];
                item.center = terminalPoint;
                cross.transform = CGAffineTransformMakeRotation(45*(M_PI/180));
                
            } completion:nil];
        }
        
        isOpened = YES;
        
        
    }else{
        
        for (UIView *item in Menus) {
            
            [UIView animateWithDuration:0.3f delay:0.05*item.tag options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
                CGPoint terminalPoint = self.mainView.center;
                item.center = terminalPoint;
                cross.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                //                item.hidden = YES;
            }];
        }
        
        isOpened = NO;
        
    }
    
}


@end
