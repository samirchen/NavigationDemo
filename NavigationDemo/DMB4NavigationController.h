//
//  DMB4NavigationController.h
//  NavigationDemo
//
//  Created by qiufu on 23/04/2018.
//  Copyright © 2018 CX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DMB4NavigationController;

#pragma mark - DMB4WrapViewController Interface
@interface DMB4WrapViewController: UIViewController

@property (strong, nonatomic, readonly) UIViewController *rootViewController;

+ (DMB4WrapViewController *)wrapViewControllerWithViewController:(UIViewController *)viewController;

@end



#pragma mark - DMB4NavigationController Protocol
@protocol DMB4NavigationControllerProtocol <NSObject>

@optional
- (void)navigationControllerShouldPushToNextViewController:(DMB4NavigationController *)navigationController;

@end



#pragma mark - DMB4NavigationController Interface
@interface DMB4NavigationController : UINavigationController

@property (strong, nonatomic) UIImage *backButtonImage;
@property (assign, nonatomic) BOOL fullScreenPopGestureEnabled; // DMB4NavigationController 管理的 ViewController 是否开启全屏 Pop 的总全局开关。
@property (assign, nonatomic) BOOL fullScreenPushGestureEnabled; // DMB4NavigationController 管理的 ViewController 是否开启全屏 Push 的总全局开关。
@property (copy, nonatomic, readonly) NSArray *dm_viewControllers; // DMB4NavigationController 管理的实际展示的 ViewController。

@end
