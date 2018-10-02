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

// 目前只处理的 push。
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    // 为 toView 设置阴影。
    toView.layer.shadowColor = [UIColor blackColor].CGColor;
    toView.layer.shadowOffset = CGSizeMake(-2.0f, 0.0f);
    toView.layer.shadowOpacity = 0.3f;
    toView.layer.shadowRadius = 10.0f;
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toView];
    
    CGRect fromViewStartFrame = [transitionContext initialFrameForViewController:fromViewController];
    CGRect toViewEndFrame = [transitionContext finalFrameForViewController:toViewController];
    
    CGRect fromViewEndFrame = fromViewStartFrame;
    CGRect toViewStartFrame = toViewEndFrame;
    
    
    // 在有 tab bar 的时候需要处理 tab bar 的在滑动时的视觉效果。下面的处理方式比较简单。还可以通过截取 fromViewController 图贴在 containerView 再隐藏 tab bar 后再做滑动来改进。
    UIImageView *tabBarSnapshotImageView = nil;
    if (toViewController.hidesBottomBarWhenPushed) {
        UITabBar *tabBar = toViewController.tabBarController.tabBar;
        UIImage *tabBarSnapshotImage = [self snapshotOfView:tabBar];
        tabBarSnapshotImageView = [[UIImageView alloc] initWithImage:tabBarSnapshotImage];
        tabBarSnapshotImageView.frame = CGRectMake(0, screenHeight - tabBarSnapshotImage.size.height, tabBarSnapshotImage.size.width, tabBarSnapshotImage.size.height);
        [containerView insertSubview:tabBarSnapshotImageView belowSubview:toView];
        tabBar.hidden = YES;
    }
    
    CGRect tabBarSnapshotImageViewTargetFrame = CGRectZero;
    if (tabBarSnapshotImageView) {
        CGRect tabBarSnapshotImageViewEndFrame = tabBarSnapshotImageView.frame;
        tabBarSnapshotImageViewEndFrame.origin.x += screenWidth;
        tabBarSnapshotImageViewTargetFrame = tabBarSnapshotImageViewEndFrame;
        tabBarSnapshotImageViewTargetFrame.origin.x = -0.3 * screenWidth;
    }
    
    if (self.operation == UINavigationControllerOperationPush) {
        toViewStartFrame.origin.x += screenWidth;
    } else if (self.operation == UINavigationControllerOperationPop) {
        fromViewEndFrame.origin.x += screenWidth;
        [containerView sendSubviewToBack:toView];
    }
    
    fromView.frame = fromViewStartFrame;
    toView.frame = toViewStartFrame;
    
    
    // 移动 fromView 的过程 fromView 保持配合移动。
    CGRect fromViewTargetFrame = fromViewEndFrame;
    fromViewTargetFrame.origin.x = -0.3 * screenWidth;
    
    CGRect toViewTargetFrame = toViewEndFrame;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        fromView.frame = fromViewTargetFrame;
        toView.frame = toViewTargetFrame;
        
        if (tabBarSnapshotImageView) {
            tabBarSnapshotImageView.frame = tabBarSnapshotImageViewTargetFrame;
        }

    } completion:^(BOOL finished) {
        
        if (tabBarSnapshotImageView) {
            [tabBarSnapshotImageView removeFromSuperview];
        }
        
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

- (UIImage *)snapshotOfView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
