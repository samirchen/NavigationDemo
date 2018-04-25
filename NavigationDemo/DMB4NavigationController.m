//
//  DMB4NavigationController.m
//  NavigationDemo
//
//  Created by qiufu on 23/04/2018.
//  Copyright © 2018 CX. All rights reserved.
//

#import "DMB4NavigationController.h"
#import "UIViewController+DMB4Navigation.h"
#import "DMB4NavigationInteractiveTransition.h"

#pragma mark - DMB4WrapNavigationController Implementation
// DMB4WrapNavigationController 用来包住最外层实际的 ViewController，为其提供独立的 Navigation Bar，而不受最底下的统一的 Navigation Bar 的影响，解决两个 ViewController 的导航栏颜色风格不一样做切换时的视觉问题。
// DMB4WrapNavigationController 会再被一个 DMB4WrapViewController 包一层，从而能够被底下拥有实际控制权的 Navigation Controller 来管理起来，从而能够正常的 Push/Pop。
@interface DMB4WrapNavigationController : UINavigationController

@end

@implementation DMB4WrapNavigationController

// 覆盖实现下列方法使得被当前 DMB4WrapNavigationController 包住的最外层实际的 ViewController 在调用导航相关方法时能够传导给最底下拥有实际控制权的 Navigation Controller。

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    // 这里的 self.navigationController 获得的是最底下拥有实际控制权的 Navigation Controller。
    return [self.navigationController popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    return [self.navigationController popToRootViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 最底下拥有实际控制权的 Navigation Controller(DMB4NavigationController) 的 viewContollers 中管理的都是 DMB4WrapViewController。
    // 对应的实际展示的 View Controllers 则管理在 dm_viewControllers 中。
    DMB4NavigationController *dm_navigationController = viewController.dm_navigationController;
    NSInteger index = [dm_navigationController.dm_viewControllers indexOfObject:viewController];
    return [self.navigationController popToViewController:dm_navigationController.viewControllers[index] animated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    viewController.dm_navigationController = (DMB4NavigationController *) self.navigationController;
    viewController.dm_fullScreenPopGestureEnabled = viewController.dm_navigationController.fullScreenPopGestureEnabled;
    viewController.dm_fullScreenPushGestureEnabled = viewController.dm_navigationController.fullScreenPushGestureEnabled;
    
    UIImage *backButtonImage = viewController.dm_navigationController.backButtonImage;
    
    if (!backButtonImage) {
        backButtonImage = [UIImage imageNamed:@"barbutton_back"];
    }
    
    SEL sel = NSSelectorFromString(@"didTapBackButton");
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStylePlain target:self action:sel];
    
    // Push 时对实际将要展示的 viewController 做包装，先包一层 DMB4WrapNavigationController，再包一层 DMB4WrapViewController，最后把 DMB4WrapViewController 压栈。
    [self.navigationController pushViewController:[DMB4WrapViewController wrapViewControllerWithViewController:viewController] animated:animated];
}

- (void)didTapBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion{
    [self.navigationController dismissViewControllerAnimated:flag completion:completion];
    self.viewControllers.firstObject.dm_navigationController = nil;
}

@end


#pragma mark - DMB4WrapViewController Implementation

static NSValue *dm_tabBarRectValue;

@implementation DMB4WrapViewController

+ (DMB4WrapViewController *)wrapViewControllerWithViewController:(UIViewController *)viewController {
    
    DMB4WrapNavigationController *wrapNavController = [[DMB4WrapNavigationController alloc] init];
    wrapNavController.viewControllers = @[viewController];
    
    DMB4WrapViewController *wrapViewController = [[DMB4WrapViewController alloc] init];
    [wrapViewController.view addSubview:wrapNavController.view];
    [wrapViewController addChildViewController:wrapNavController];
    
    return wrapViewController;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (self.tabBarController && !dm_tabBarRectValue) {
        dm_tabBarRectValue = [NSValue valueWithCGRect:self.tabBarController.tabBar.frame];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.tabBarController && [self rootViewController].hidesBottomBarWhenPushed) {
        self.tabBarController.tabBar.frame = CGRectZero;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.translucent = YES;
    if (self.tabBarController && !self.tabBarController.tabBar.hidden && dm_tabBarRectValue) {
        self.tabBarController.tabBar.frame = dm_tabBarRectValue.CGRectValue;
    }
}

- (BOOL)dm_fullScreenPopGestureEnabled {
    return [self rootViewController].dm_fullScreenPopGestureEnabled;
}

- (BOOL)hidesBottomBarWhenPushed {
    return [self rootViewController].hidesBottomBarWhenPushed;
}

- (UITabBarItem *)tabBarItem {
    return [self rootViewController].tabBarItem;
}

- (NSString *)title {
    return [self rootViewController].title;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return [self rootViewController];
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return [self rootViewController];
}

- (UIViewController *)rootViewController {
    DMB4WrapNavigationController *wrapNavController = self.childViewControllers.firstObject;
    return wrapNavController.viewControllers.firstObject;
}

@end



#pragma mark - DMB4NavigationController Implementation
@interface DMB4NavigationController () <UIGestureRecognizerDelegate>
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;
@property (weak, nonatomic) id currentPanGestureTarget;
@property (assign, nonatomic) SEL currentPanGestureAction;
@property (strong, nonatomic) DMB4NavigationInteractiveTransition *myInteractiveTransition; // 这个名字不能用 interactiveTransition 会与系统自带的属性名冲突而 crash。
@end

@implementation DMB4NavigationController
#pragma mark - Property
// DMB4NavigationController 的 viewControllers 管理的是 DMB4WrapViewController，实际展示的 View Controllers 是在 dm_viewControllers 中。
- (NSArray *)dm_viewControllers {
    NSMutableArray *viewControllers = [NSMutableArray array];
    for (DMB4WrapViewController *wrapViewController in self.viewControllers) {
        [viewControllers addObject:wrapViewController.rootViewController];
    }
    return viewControllers.copy;
}

- (DMB4NavigationInteractiveTransition *)myInteractiveTransition {
    if (!_myInteractiveTransition) {
        _myInteractiveTransition = [[DMB4NavigationInteractiveTransition alloc] initWithNavigationController:self];
    }

    return _myInteractiveTransition;
}

#pragma mark - Lifecycle
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super init]) {
        rootViewController.dm_navigationController = self;
        self.viewControllers = @[[DMB4WrapViewController wrapViewControllerWithViewController:rootViewController]];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.viewControllers.firstObject.dm_navigationController = self;
        self.viewControllers = @[[DMB4WrapViewController wrapViewControllerWithViewController:self.viewControllers.firstObject]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 隐藏最底下实际控制导航的 Navigation Controller 的 Navigation Bar，最终显示的是 DMB4WrapNavigationController 的 Navigation Bar。
    [self setNavigationBarHidden:YES];

    // 自己增加滑动手势来做交互式 VC 转场。
    self.panGesture = [[UIPanGestureRecognizer alloc] init];
    self.panGesture.maximumNumberOfTouches = 1;
    self.panGesture.delegate = self;
    [self.view addGestureRecognizer:self.panGesture];
    // 给 panGesture 增加一个 target 和对应的 action，从而也能处理左滑 Push 的操作。
    [self.panGesture addTarget:self action:@selector(onPanGesture:)];
    // 禁止使用系统自带的滑动手势。
    self.interactivePopGestureRecognizer.enabled = NO;

}

#pragma mark - Action
- (void)onPanGesture:(UIPanGestureRecognizer *)gesture {
    NSLog(@"%s, %d, %@", __func__, __LINE__, self);

    if (gesture == self.panGesture) {
        if (gesture.state == UIGestureRecognizerStateBegan) {
            CGPoint translation = [gesture translationInView:gesture.view];
            if (translation.x < 0) {
                
                UIViewController *currentVC = [self.dm_viewControllers lastObject];
                if ([currentVC respondsToSelector:@selector(navigationControllerShouldPushToNextViewController:)]) {
                    // 设置 UINavigationControllerDelegate。
                    self.delegate = self.myInteractiveTransition;
                    
                    // 调用代理方法。
                    id<DMB4NavigationControllerProtocol> vc = (id<DMB4NavigationControllerProtocol>) currentVC;
                    [vc navigationControllerShouldPushToNextViewController:self];
                }
                
            }
            
        } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
            
            // 清理 UINavigationControllerDelegate，如果不清理可能会发生 bar button 无法点击等问题。
            self.delegate = nil;
            
            // 移除 panGesture 在这次 Interactive Push/Pop 中使用的 target。
            [self.panGesture removeTarget:self.currentPanGestureTarget action:self.currentPanGestureAction];
        }

    }
    
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.panGesture) {

        // 如果正在做 transition，返回 NO。
        if ([[self valueForKey:@"_isTransitioning"] boolValue]) {
            return NO;
        }
        
        // 分别处理左滑和右滑。
        CGPoint transition = [self.panGesture translationInView:self.view];
        if (transition.x < 0) { // 左滑，进入 Push 操作。
            
            // 如果用户设置 Navigation Controller 全局关闭全屏 Push 手势，返回 NO。
            if (!self.fullScreenPushGestureEnabled) {
                return NO;
            }

            // 如果用户设置当前的 ViewController 关闭全屏 Push 手势，返回 NO。
            UIViewController *currentVC = [self.dm_viewControllers lastObject];
            if (!currentVC.dm_fullScreenPushGestureEnabled) {
                return NO;
            } else {
                // 这里将要做 Interactive Push，先要检查一下 navigationControllerDelegate 代理有没有实现对应的方法。
                if ([currentVC respondsToSelector:@selector(navigationControllerShouldPushToNextViewController:)]) {

                    // 增加 myInteractiveTransition 为 target 来处理 Interactive Push。
                    SEL action = NSSelectorFromString(@"onPanGesture:");
                    [self.panGesture addTarget:self.myInteractiveTransition action:action];
                    // 记录一下，便于后面清理。
                    self.currentPanGestureTarget = self.myInteractiveTransition;
                    self.currentPanGestureAction = action;
                    
                    return YES;
                } else {
                    return NO;
                }
            }
            
        } else { // 右滑，进入 Pop 操作。
            
            // 如果当前压栈的 VC 少于 1 个，则不响应手势。
            if (self.viewControllers.count <= 1) {
                return NO;
            }
            
            // 如果用户设置 Navigation Controller 全局关闭全屏 Pop 手势，返回 NO。
            if (!self.fullScreenPopGestureEnabled) {
                return NO;
            }
            
            // 如果用户设置当前的 ViewController 关闭全屏 Pop 手势，返回 NO。
            UIViewController *currentVC = [self.dm_viewControllers lastObject];
            if (!currentVC.dm_fullScreenPopGestureEnabled) {
                return NO;
            } else {
                
                // 当前显示的不是第一个 VC 时，用自己增加的全屏滑动手势 panGesture 来 hook 原来的边缘滑动手势的 Pop 处理，从而支持全屏 Pop。
                // 获取系统自带滑动返回手势的 target 对象。把系统自带滑动返回手势的 target 的 action 方法添加到 panGesture 上。
                id target = self.interactivePopGestureRecognizer.delegate; // UINavigationInteractiveTransition.
                SEL action = NSSelectorFromString(@"handleNavigationTransition:");
                [self.panGesture addTarget:target action:action];
                // 记录一下，便于后面清理。
                self.currentPanGestureTarget = target;
                self.currentPanGestureAction = action;
                
                return YES;
            }
            
            
            
        }

    }

    return YES;
}

// 修复有水平方向滚动的 ScrollView 时边缘返回手势失效的问题。
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}

@end
