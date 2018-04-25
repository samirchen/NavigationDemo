//
//  DMB4NavigationInteractiveTransition.m
//  NavigationDemo
//
//  Created by qiufu on 24/04/2018.
//  Copyright © 2018 CX. All rights reserved.
//

#import "DMB4NavigationInteractiveTransition.h"
#import "DMB4NavigationController.h"
#import "DMB4AnimatedTransitioning.h"

@interface DMB4NavigationInteractiveTransition ()

@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *interactiveTransition;
@property (weak, nonatomic) DMB4NavigationController *navigationController;
@property (strong, nonatomic) DMB4AnimatedTransitioning *animatedTransitioning;

@end

@implementation DMB4NavigationInteractiveTransition
#pragma mark - Property
- (UIPercentDrivenInteractiveTransition *)interactiveTransition{
    if (!_interactiveTransition) {
        _interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        _interactiveTransition.completionCurve = UIViewAnimationCurveEaseOut;
    }
    
    return _interactiveTransition;
}

- (DMB4AnimatedTransitioning *)animatedTransitioning{
    if (!_animatedTransitioning) {
        _animatedTransitioning = [[DMB4AnimatedTransitioning alloc] init];
    }
    return _animatedTransitioning;
}

#pragma mark - Lifecycle
- (instancetype)initWithNavigationController:(DMB4NavigationController *)navigationController {
    self = [super init];
    if (self) {
        _navigationController = navigationController;
    }
    
    return self;
}

#pragma mark - Action
- (void)onPanGesture:(UIPanGestureRecognizer *)panGesture {
    CGFloat progress = [panGesture translationInView:panGesture.view].x / panGesture.view.bounds.size.width;
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        
        [self.interactiveTransition updateInteractiveTransition:0];
        
    } else if (panGesture.state == UIGestureRecognizerStateChanged) {
        
        NSLog(@"InteractivePush: %s, %d, %@", __func__, __LINE__, self);
        
        if (progress <= 0) {
            progress = fabs(progress);
            progress = MIN(1.0, MAX(0.0, progress));
        } else {
            progress = 0;
        }
        
        [self.interactiveTransition updateInteractiveTransition:progress];
        
    } else if (panGesture.state == UIGestureRecognizerStateEnded || panGesture.state == UIGestureRecognizerStateCancelled) {
        
        if (fabs(progress) > 0.3) {
            [self.interactiveTransition finishInteractiveTransition];
        } else {
            [self.interactiveTransition cancelInteractiveTransition];
        }
    }
}

#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationControxller animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {

    if (operation == UINavigationControllerOperationPush) {
        return self.animatedTransitioning;
    }

    return nil;
}


- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    
    return self.interactiveTransition;
}

@end
