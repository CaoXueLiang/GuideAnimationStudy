//
//  ReflectView.m
//  CAReplicatorLayerAnimation
//
//  Created by bjovov on 2017/9/15.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "ReflectView.h"

@interface ReflectView()
@property (nonatomic,copy) NSString *imageName;
@end

//图片反射效果
//https://github.com/nicklockwood/ReflectionView

@implementation ReflectView
+ (Class)layerClass{
    return [CAReplicatorLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageName = imageName;
        [self refelectMenthod];
    }
    return self;
}

- (void)refelectMenthod{
    CGFloat height = CGRectGetHeight(self.bounds);
    
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), height);
    imageLayer.contents = (__bridge id)[UIImage imageNamed:self.imageName].CGImage;
    imageLayer.contentsGravity = kCAGravityResizeAspect;
    imageLayer.masksToBounds = YES;
    imageLayer.contentsScale = [UIScreen mainScreen].scale;
    
    CAReplicatorLayer *layer = (CAReplicatorLayer *)self.layer;
    layer.instanceCount = 2;
    layer.instanceDelay = 0.1;
    layer.instanceAlphaOffset = -0.6;
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1/500.0;
    transform = CATransform3DTranslate(transform, 0, height + 2, 0);
    transform = CATransform3DScale(transform, 1, -1, 0);
    layer.instanceTransform = transform;
    [layer addSublayer:imageLayer];
}

@end
