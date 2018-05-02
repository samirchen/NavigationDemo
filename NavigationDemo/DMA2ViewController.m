//
//  DMA2ViewController.m
//  NavigationDemo
//
//  Created by qiufu on 20/04/2018.
//  Copyright © 2018 CX. All rights reserved.
//

#import "DMA2ViewController.h"
#import "DMA2PageContentL1ViewController.h"
#import "UIViewController+DMB4Navigation.h"

@interface DMA2ViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property (copy, nonatomic) NSArray *contentDataD2Array;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) UIButton *refreshButton;

@end

@implementation DMA2ViewController
#pragma mark - Property
- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey: @(0)};
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationVertical options:options];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
        
    }
    
    return _pageViewController;
}

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 防止与 UIPageViewController 的左右滑动冲突。
    self.dm_fullScreenPopGestureEnabled = NO;
    self.dm_fullScreenPushGestureEnabled = NO;
    
    [self loadData];
    [self setupUI];
    [self refreshContent];
}

#pragma mark - Setup
- (void)loadData {
    self.contentDataD2Array = @[@[@"上下[0]左右[0]", @"上下[0]左右[1]"],
                              @[@"上下[1]左右[0]", @"上下[1]左右[1]"],
                              @[@"上下[2]左右[0]", @"上下[2]左右[1]"],
                              @[@"上下[3]左右[0]", @"上下[3]左右[1]"]];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor blackColor];
    
    self.navigationItem.title = @"A2";
    
    // Page view controller UI.
    self.pageViewController.view.frame = self.view.bounds;
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    
    // Refresh button.
    self.refreshButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.refreshButton setTitle:@"Refresh" forState:UIControlStateNormal];
    [self.refreshButton addTarget:self action:@selector(onRefreshButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.refreshButton];
    self.refreshButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:self.refreshButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:100.0],
                                [NSLayoutConstraint constraintWithItem:self.refreshButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:-10],
                                [NSLayoutConstraint constraintWithItem:self.refreshButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60.0],
                                [NSLayoutConstraint constraintWithItem:self.refreshButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30.0]
                                ]];
    
}

#pragma mark - Action
- (void)onRefreshButtonClicked:(UIButton *)button {
    [self refreshContent];
}

#pragma mark - Utility
- (void)refreshContent {
    UIViewController *initialViewController = [self viewControllerAtIndex:0];
    if (initialViewController) {
        NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    }
}

- (UIViewController *)viewControllerAtIndex:(NSInteger)index {
    if (index < 0 || index >= self.contentDataD2Array.count) {
        return nil;
    }
    
    NSArray *contentDataArray = [self.contentDataD2Array objectAtIndex:index];
    DMA2PageContentL1ViewController *vc = [[DMA2PageContentL1ViewController alloc] initWithContentArray:contentDataArray];
    vc.contentIndex = index;
    return vc;
}


#pragma mark - UIPageViewControllerDelegate
//- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
//
//}

//- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
//
//}

//- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
//    return UIPageViewControllerSpineLocationNone;
//}

//- (UIInterfaceOrientationMask)pageViewControllerSupportedInterfaceOrientations:(UIPageViewController *)pageViewController {
//    return UIInterfaceOrientationMaskPortrait;
//}

//- (UIInterfaceOrientation)pageViewControllerPreferredInterfaceOrientationForPresentation:(UIPageViewController *)pageViewController {
//    return UIInterfaceOrientationPortrait;
//}

#pragma mark - UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    DMA2PageContentL1ViewController *vc = (DMA2PageContentL1ViewController *) viewController;
    NSInteger index = vc.contentIndex;
    index--;
    UIViewController *preVC = [self viewControllerAtIndex:index];
    
    return preVC;
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    DMA2PageContentL1ViewController *vc = (DMA2PageContentL1ViewController *) viewController;
    NSInteger index = vc.contentIndex;
    index++;
    UIViewController *nextVC = [self viewControllerAtIndex:index];
    
    return nextVC;
}

//- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
//
//}

//- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
//
//}



@end
