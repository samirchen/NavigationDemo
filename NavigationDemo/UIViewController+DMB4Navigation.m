//
//  UIViewController+DMB4Navigation.m
//  NavigationDemo
//
//  Created by qiufu on 23/04/2018.
//  Copyright © 2018 CX. All rights reserved.
//

#import "UIViewController+DMB4Navigation.h"
#import <objc/runtime.h>

@implementation UIViewController (DMB4Navigation)

- (BOOL)dm_fullScreenPopGestureEnabled {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setDm_fullScreenPopGestureEnabled:(BOOL)fullScreenPopGestureEnabled {
    objc_setAssociatedObject(self, @selector(dm_fullScreenPopGestureEnabled), @(fullScreenPopGestureEnabled), OBJC_ASSOCIATION_RETAIN);
}

- (DMB4NavigationController *)dm_navigationController {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDm_navigationController:(DMB4NavigationController *)navigationController {
    objc_setAssociatedObject(self, @selector(dm_navigationController), navigationController, OBJC_ASSOCIATION_ASSIGN);
}

@end
