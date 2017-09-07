//
//  AppDelegate.m
//  TwitterAnimation
//
//  Created by bjovov on 2017/9/7.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor redColor];
    UINavigationController *controller = [[UINavigationController alloc]initWithRootViewController:[[ViewController alloc]init]];
    self.window.rootViewController = controller;
    [self.window makeKeyAndVisible];
    
    //添加logo遮罩
    CALayer *logoLayer = [CALayer layer];
    UIImage *image = [UIImage imageNamed:@"logo"];
    logoLayer.contents = (__bridge id)(image.CGImage);
    logoLayer.position = controller.view.center;
    logoLayer.bounds = CGRectMake(0, 0, 60, 60);
    controller.view.layer.mask = logoLayer;
    
    //在navigationView上添加backgroundView
    UIView *backGroundView = [[UIView alloc]initWithFrame:controller.view.bounds];
    backGroundView.backgroundColor = [UIColor whiteColor];
    [controller.view addSubview:backGroundView];
    [controller.view bringSubviewToFront:backGroundView];
    
    
    //添加logoLayer动画
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    animation.duration = 1;
    animation.beginTime = CACurrentMediaTime() + 1;
    CGRect initalBounds = logoLayer.bounds;
    CGRect secondBounds = CGRectMake(0, 0, 50, 50);
    CGRect finalBounds  = CGRectMake(0, 0, 2000, 2000);
    animation.values = @[[NSValue valueWithCGRect:initalBounds],[NSValue valueWithCGRect:secondBounds],[NSValue valueWithCGRect:finalBounds]];
    animation.keyTimes = @[@(0),@(0.5),@(1)];
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [logoLayer addAnimation:animation forKey:@"maskAniamtion"];
    
    
    //backGroundView隐藏动画
    [UIView animateWithDuration:0.1 delay:1.35 options:UIViewAnimationOptionCurveLinear animations:^{
        backGroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [backGroundView removeFromSuperview];
    }];
    
    
    //navc.view bounce animation
    [UIView animateWithDuration:0.25 delay:1.3 options:UIViewAnimationOptionTransitionNone animations:^{
        controller.view.transform = CGAffineTransformMakeScale(1.05, 1.05);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            controller.view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            controller.view.layer.mask = nil;
        }];
    }];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
