//
//  LabelView.m
//  CurveAnimationFresh
//
//  Created by bjovov on 2017/9/11.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "LabelView.h"
#import "UIView+Convenient.h"

#define kPullingDownString   @"下拉即可刷新..."
#define kPullingUpString     @"上拉即可刷新"
#define kReleaseString       @"松开即可刷新..."

#define kPullingString   self.state == UP ? kPullingUpString : kPullingDownString

#define LabelHeight 50

@implementation LabelView
{
    UILabel *titleLabel;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    
    return self;
}


-(void)setUp {
    self.state = DOWN;
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height/2-LabelHeight/2, self.width, LabelHeight)];
    titleLabel.text = kPullingString;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:titleLabel];
}

-(void)setProgress:(CGFloat)progress{
    titleLabel.alpha = progress;
    if (!self.loading) {
        if (progress >= 1.0) {
            titleLabel.text = kReleaseString;
        }else{
            titleLabel.text = kPullingString;
        }
    }else{
        if (progress >= 0.91) {
            titleLabel.text = kReleaseString;
        }else{
            titleLabel.text = kPullingString;
        }
    }
    
}
@end
