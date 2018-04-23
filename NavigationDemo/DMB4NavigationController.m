//
//  DMB4NavigationController.m
//  NavigationDemo
//
//  Created by qiufu on 23/04/2018.
//  Copyright © 2018 CX. All rights reserved.
//

#import "DMB4NavigationController.h"
#import "UIViewController+DMB4Navigation.h"

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
@interface DMB4NavigationController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) UIPanGestureRecognizer *popPanGesture;
@property (strong, nonatomic) id popGestureDelegate;
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
    
    [self setNavigationBarHidden:YES];
    self.delegate = self;
    
    // 用自己增加的全屏滑动手势 popPanGesture 来 hook 原来的边缘滑动手势的 Pop 处理，从而支持全屏 Pop。
    self.popGestureDelegate = self.interactivePopGestureRecognizer.delegate;
    SEL action = NSSelectorFromString(@"handleNavigationTransition:");
    self.popPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.popGestureDelegate action:action];
    self.popPanGesture.maximumNumberOfTouches = 1;
    
}


#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    BOOL isRootVC = (viewController == navigationController.viewControllers.firstObject);
    
    if (viewController.dm_fullScreenPopGestureEnabled) {
        if (isRootVC) {
            [self.view removeGestureRecognizer:self.popPanGesture];
        } else {
            [self.view addGestureRecognizer:self.popPanGesture];
        }
        self.interactivePopGestureRecognizer.delegate = self.popGestureDelegate;
        self.interactivePopGestureRecognizer.enabled = NO;
    } else {
        [self.view removeGestureRecognizer:self.popPanGesture];
        self.interactivePopGestureRecognizer.delegate = self;
        self.interactivePopGestureRecognizer.enabled = !isRootVC;
    }
    
}

#pragma mark - UIGestureRecognizerDelegate
// 修复有水平方向滚动的 ScrollView 时边缘返回手势失效的问题。
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}



@end
