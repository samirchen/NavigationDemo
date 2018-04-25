//
//  AppDelegate.m
//  NavigationDemo
//
//  Created by qiufu on 20/04/2018.
//  Copyright © 2018 CX. All rights reserved.
//

#import "AppDelegate.h"
#import "DMA1ViewController.h"
#import "DMB1ViewController.h"
#import "DMB1NavigationController.h"
#import "DMB4ViewController.h"
#import "DMB4NavigationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 使用 UIPageViewController 来实现全屏上下左右滑动切换页面。
    DMA1ViewController *a1VC = [[DMA1ViewController alloc] init];
    UINavigationController *aNavC = [[UINavigationController alloc] initWithRootViewController:a1VC];
    aNavC.title = @"A";
    
    // 使用自定义的 Navigation Controller 来实现自定义的 push/pop 转场效果。
    DMB1ViewController *b1VC = [[DMB1ViewController alloc] init];
    DMB1NavigationController *bNavC = [[DMB1NavigationController alloc] initWithRootViewController:b1VC];
    bNavC.title = @"B";

    DMB4ViewController *c1VC = [[DMB4ViewController alloc] init];
    DMB4NavigationController *cNavC = [[DMB4NavigationController alloc] initWithRootViewController:c1VC];
    cNavC.title = @"B4+TabBar";
    cNavC.fullScreenPopGestureEnabled = YES;
    cNavC.fullScreenPushGestureEnabled = YES;
    

    UIViewController *d1VC = [[UIViewController alloc] init];
    UINavigationController *dNavC = [[UINavigationController alloc] initWithRootViewController:d1VC];
    dNavC.title = @"D";
    
    
    UITabBarController *mainTabBarController = [[UITabBarController alloc] init];
    [mainTabBarController setViewControllers:@[aNavC, bNavC, cNavC, dNavC]];
    

    
    [self.window setBackgroundColor:[UIColor whiteColor]];
    self.window.rootViewController = mainTabBarController;
    [self.window makeKeyAndVisible];

    return YES;
}




@end
