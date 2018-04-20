//
//  DMB1AnimationController.m
//  NavigationDemo
//
//  Created by qiufu on 20/04/2018.
//  Copyright © 2018 CX. All rights reserved.
//

#import "DMB1AnimationController.h"

@implementation DMB1AnimationController

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
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
        toViewStartFrame.origin.y -= toViewEndFrame.size.height;
    } else if (self.operation == UINavigationControllerOperationPop) {
        fromViewEndFrame.origin.y -= fromViewStartFrame.size.height;
        [containerView sendSubviewToBack:toView];
    }
    
    fromView.frame = fromViewStartFrame;
    toView.frame = toViewStartFrame;

    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromView.frame = fromViewEndFrame;
        toView.frame = toViewEndFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end
