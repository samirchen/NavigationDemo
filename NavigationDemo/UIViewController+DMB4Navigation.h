//
//  UIViewController+DMB4Navigation.h
//  NavigationDemo
//
//  Created by qiufu on 23/04/2018.
//  Copyright © 2018 CX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMB4NavigationController.h"

@interface UIViewController (DMB4Navigation)

@property (assign, nonatomic) BOOL dm_fullScreenPopGestureEnabled; // 每个 ViewController 自己是否开启全屏 Pop。
@property (assign, nonatomic) BOOL dm_fullScreenPushGestureEnabled; // 每个 ViewController 自己是否开启全屏 Push。
@property (weak, nonatomic) DMB4NavigationController *dm_navigationController; // ViewController 最底下有实际控制权的 NavigationController。

@end
