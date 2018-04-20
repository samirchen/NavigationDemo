//
//  DMA1PageContentViewController.h
//  NavigationDemo
//
//  Created by qiufu on 20/04/2018.
//  Copyright © 2018 CX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMA1PageContentViewController : UIViewController

@property (assign, nonatomic) NSString *contentString;
@property (assign, nonatomic) NSUInteger contentIndex;

- (instancetype)initWithContentString:(NSString *)content;

@end
