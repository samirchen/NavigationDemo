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

@property (assign, nonatomic) BOOL dm_fullScreenPopGestureEnabled;
@property (weak, nonatomic) DMB4NavigationController *dm_navigationController;

@end
