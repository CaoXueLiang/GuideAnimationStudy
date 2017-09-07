//
//  MenuButton.m
//  GooeySlideMenuDemo
//
//  Created by bjovov on 2017/9/7.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "MenuButton.h"

@interface MenuButton()
@property (nonatomic,copy) NSString *buttonSting;
@end

@implementation MenuButton
#pragma mark - Init Menthod
- (instancetype)initWithTitle:(NSString *)title{
    self = [super init];
    if (self) {
        self.buttonSting = title;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddRect(context, rect);
    CGContextSetFillColorWithColor(context, self.buttonColor.CGColor);
    CGContextDrawPath(context, kCGPathFill);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, 1, 1) cornerRadius:rect.size.height/2.0];
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextAddPath(context, path.CGPath);
    CGContextDrawPath(context, kCGPathStroke);

    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attr = @{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:[UIFont systemFontOfSize:24.0f],NSForegroundColorAttributeName:[UIColor whiteColor]};
    CGSize size = [self.buttonSting sizeWithAttributes:attr];
    
    CGRect r = CGRectMake(rect.origin.x,
                          rect.origin.y + (rect.size.height - size.height)/2.0,
                          rect.size.width,
                          size.height);
    
    [self.buttonSting drawInRect:r withAttributes:attr];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    NSInteger tapNum = [touch tapCount];
    if (tapNum == 1) {
        if (_buttonClciked) {
            _buttonClciked();
        }
    }
}

@end

