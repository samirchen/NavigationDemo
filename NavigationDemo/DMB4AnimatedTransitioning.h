//
//  DMB4AnimatedTransitioning.h
//  NavigationDemo
//
//  Created by qiufu on 24/04/2018.
//  Copyright © 2018 CX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DMB4AnimatedTransitioning : NSObject<UIViewControllerAnimatedTransitioning>

@property (assign, nonatomic) UINavigationControllerOperation operation;

@end
