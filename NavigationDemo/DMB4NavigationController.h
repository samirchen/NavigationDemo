//
//  DMB4NavigationController.h
//  NavigationDemo
//
//  Created by qiufu on 23/04/2018.
//  Copyright © 2018 CX. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - DMB4WrapViewController Interface
@interface DMB4WrapViewController: UIViewController

@property (strong, nonatomic, readonly) UIViewController *rootViewController;

+ (DMB4WrapViewController *)wrapViewControllerWithViewController:(UIViewController *)viewController;

@end


#pragma mark - DMB4NavigationController Interface
@interface DMB4NavigationController : UINavigationController

@property (strong, nonatomic) UIImage *backButtonImage;
@property (assign, nonatomic) BOOL fullScreenPopGestureEnabled;
@property (copy, nonatomic, readonly) NSArray *dm_viewControllers;

@end
