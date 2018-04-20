//
//  DMB1AnimationController.h
//  NavigationDemo
//
//  Created by qiufu on 20/04/2018.
//  Copyright © 2018 CX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DMB1AnimationController : NSObject<UIViewControllerAnimatedTransitioning>

@property (assign, nonatomic) UINavigationControllerOperation operation;

@end
