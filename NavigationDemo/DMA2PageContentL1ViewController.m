//
//  DMA2PageContentL1ViewController.m
//  NavigationDemo
//
//  Created by qiufu on 20/04/2018.
//  Copyright © 2018 CX. All rights reserved.
//

#import "DMA2PageContentL1ViewController.h"
#import "DMA2PageContentL2ViewController.h"

@interface DMA2PageContentL1ViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property (copy, nonatomic) NSArray *contentDataArray;
@property (strong, nonatomic) UIPageViewController *pageViewController;

@end

@implementation DMA2PageContentL1ViewController
#pragma mark - Property
- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey: @(0)};
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
        
    }
    
    return _pageViewController;
}

#pragma mark - Lifecycle
- (instancetype)initWithContentArray:(NSArray *)contentArray {
    self = [super init];
    if (self) {
        _contentDataArray = contentArray;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self refreshContent];
}


#pragma mark - Setup
- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Page view controller UI.
    self.pageViewController.view.frame = self.view.bounds;
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];

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
    if (index < 0 || index >= self.contentDataArray.count) {
        return nil;
    }
    
    NSString *content = [self.contentDataArray objectAtIndex:index];
    DMA2PageContentL2ViewController *vc = [[DMA2PageContentL2ViewController alloc] initWithContentString:content];
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
    
    DMA2PageContentL2ViewController *vc = (DMA2PageContentL2ViewController *) viewController;
    NSInteger index = vc.contentIndex;
    index--;
    UIViewController *preVC = [self viewControllerAtIndex:index];
    
    return preVC;
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    DMA2PageContentL2ViewController *vc = (DMA2PageContentL2ViewController *) viewController;
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
