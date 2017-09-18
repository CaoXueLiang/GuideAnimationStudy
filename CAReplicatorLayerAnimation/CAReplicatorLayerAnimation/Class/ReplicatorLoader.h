//
//  ReplicatorLoader.h
//  CAReplicatorLayerAnimation
//
//  Created by bjovov on 2017/9/14.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger ,LoaderType) {
     LoaderTypePulse,
     LoaderTypeCirlce,
     LoaderTypeDots,
     LoaderTypeGrid,
     LoaderTypeTriangle,
};

@interface ReplicatorLoader : UIView
- (instancetype)initWithFrame:(CGRect)frame Type:(LoaderType)type;
@end
