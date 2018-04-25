//
//  DMB4NavigationInteractiveTransition.h
//  NavigationDemo
//
//  Created by qiufu on 24/04/2018.
//  Copyright © 2018 CX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DMB4NavigationController.h"

@interface DMB4NavigationInteractiveTransition : NSObject <UINavigationControllerDelegate>

- (instancetype)initWithNavigationController:(DMB4NavigationController *)navigationController;

- (void)onPanGesture:(UIPanGestureRecognizer *)panGesture;

@end
