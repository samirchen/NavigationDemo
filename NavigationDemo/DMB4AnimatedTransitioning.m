//
//  DMB4AnimatedTransitioning.m
//  NavigationDemo
//
//  Created by qiufu on 24/04/2018.
//  Copyright © 2018 CX. All rights reserved.
//

#import "DMB4AnimatedTransitioning.h"

@implementation DMB4AnimatedTransitioning

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toView];
    
    CGRect fromViewStartFrame = [transitionContext initialFrameForViewController:fromViewController];
    CGRect toViewEndFrame = [transitionContext finalFrameForViewController:toViewController];
    CGRect fromViewEndFrame = fromViewStartFrame;
    CGRect toViewStartFrame = toViewEndFrame;
    
    if (self.operation == UINavigationControllerOperationPush) {
        toViewStartFrame.origin.x += toViewEndFrame.size.width;
    } else if (self.operation == UINavigationControllerOperationPop) {
        fromViewEndFrame.origin.x += fromViewStartFrame.size.width;
        [containerView sendSubviewToBack:toView];
    }
    
    fromView.frame = fromViewStartFrame;
    toView.frame = toViewStartFrame;
    
    // 在有 tab bar 的时候需要处理 tab bar 的在滑动时的视觉效果。下面的处理方式比较简单。还可以通过截取 fromViewController 图贴在 containerView 再隐藏 tab bar 后再做滑动来改进。
    if (toViewController.hidesBottomBarWhenPushed) {
        UITabBar *tabBar = toViewController.tabBarController.tabBar;
        tabBar.hidden = YES;
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        fromView.frame = fromViewEndFrame;
        toView.frame = toViewEndFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

@end
