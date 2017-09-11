//
//  CurveView.m
//  CurveAnimationFresh
//
//  Created by bjovov on 2017/9/11.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "CurveView.h"
#import "CurveLayer.h"

@interface CurveView()
@property (nonatomic,strong) CurveLayer *curveLayer;
@end

@implementation CurveView
+ (Class)layerClass{
    return [CurveLayer class];
}


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


- (void)setProgress:(CGFloat)progress{
    self.curveLayer.progress = progress;
    [self.curveLayer setNeedsDisplay];
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    NSLog(@"move to superView");
    self.curveLayer = [CurveLayer layer];
    self.curveLayer.frame = self.bounds;
    self.curveLayer.contentsScale = [UIScreen mainScreen].scale;
    self.curveLayer.progress = 0;
    [self.curveLayer setNeedsDisplay];
    
    [self.layer addSublayer:self.curveLayer];
}

@end
