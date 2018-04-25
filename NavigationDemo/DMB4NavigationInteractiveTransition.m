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
@property (weak, nonatomic) DMB4NavigationController *navigationController;
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *myInteractiveTransition;
@property (strong, nonatomic) DMB4AnimatedTransitioning *myAnimatedTransitioning;
@end

@implementation DMB4NavigationInteractiveTransition
#pragma mark - Property
- (UIPercentDrivenInteractiveTransition *)myInteractiveTransition{
    if (!_myInteractiveTransition) {
        _myInteractiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        _myInteractiveTransition.completionCurve = UIViewAnimationCurveEaseOut;
    }
    
    return _myInteractiveTransition;
}

- (DMB4AnimatedTransitioning *)myAnimatedTransitioning{
    if (!_myAnimatedTransitioning) {
        _myAnimatedTransitioning = [[DMB4AnimatedTransitioning alloc] init];
        _myAnimatedTransitioning.operation = UINavigationControllerOperationPush;
    }
    return _myAnimatedTransitioning;
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
        
        [self.myInteractiveTransition updateInteractiveTransition:0];
        
    } else if (panGesture.state == UIGestureRecognizerStateChanged) {
        
        NSLog(@"InteractivePush: %s, %d, %@", __func__, __LINE__, self);
        
        if (progress <= 0) {
            progress = fabs(progress);
            progress = MIN(1.0, MAX(0.0, progress));
        } else {
            progress = 0;
        }
        
        [self.myInteractiveTransition updateInteractiveTransition:progress];
        
    } else if (panGesture.state == UIGestureRecognizerStateEnded || panGesture.state == UIGestureRecognizerStateCancelled) {
        
        //if (fabs(progress) > 0.3) {
        //    [self.myInteractiveTransition finishInteractiveTransition];
        //} else {
        //    [self.myInteractiveTransition cancelInteractiveTransition];
        //}
        
        [self.myInteractiveTransition finishInteractiveTransition];
    }
}

#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationControxller animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {

    if (operation == UINavigationControllerOperationPush) {
        self.myAnimatedTransitioning.operation = UINavigationControllerOperationPush;
        return self.myAnimatedTransitioning;
    }

    return nil;
}


- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    
    return self.myInteractiveTransition;
}

@end
