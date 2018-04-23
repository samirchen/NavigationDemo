//
//  DMB1NavigationController.m
//  NavigationDemo
//
//  Created by qiufu on 20/04/2018.
//  Copyright © 2018 CX. All rights reserved.
//

#import "DMB1NavigationController.h"
#import "DMB1AnimatedTransitioning.h"

@interface DMB1NavigationController () <UINavigationControllerDelegate>

@end

@implementation DMB1NavigationController
#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.delegate = self;
}

#pragma mark - UINavigationControllerDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    DMB1AnimatedTransitioning *ac = [[DMB1AnimatedTransitioning alloc] init];
    ac.operation = operation;
    return ac;
}

@end
