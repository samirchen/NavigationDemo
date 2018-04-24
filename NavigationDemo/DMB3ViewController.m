//
//  DMB3ViewController.m
//  NavigationDemo
//
//  Created by qiufu on 22/04/2018.
//  Copyright © 2018 CX. All rights reserved.
//

#import "DMB3ViewController.h"

typedef NS_ENUM(int32_t, DMPanMode) {
    DMPanModeNone = 0,
    DMPanModeUp = 1,
    DMPanModeDown = 2,
    DMPanModeLeft = 3,
    DMPanModeRight = 4
};

@interface DMB3ViewController () <UIGestureRecognizerDelegate>
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIButton *pushButton;

@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;

@property (strong, nonatomic) UIViewController *nextViewController;
@end

@implementation DMB3ViewController
#pragma mark - Property
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        //_contentLabel.backgroundColor = [UIColor blueColor];
        [_contentLabel setFont:[UIFont systemFontOfSize:30.0]];
        [_contentLabel setTextColor:[UIColor whiteColor]];
        [_contentLabel setTextAlignment:NSTextAlignmentCenter];
        _contentLabel.numberOfLines = 0;
    }
    
    return _contentLabel;
}

#pragma mark - Lifecycle
// 这里的交互式 Push 是通过自己监听手势做动画来实现的，会有比较多的细节问题：
// 提前创建下一个 VC 并将其 view 添加到当前 self.view 会提早触发新 VC 的 viewDidLoad、viewWillAppear 和 viewDidAppear 操作，而这时候新 VC 还未添加到当前的 Navigation Controller 里管理起来。
// 交互式 Push 新的 VC 成功或失败的情况下可能多次调用到新 VC 的 viewWillAppear、viewDidAppear、viewWillDisappear、viewDidDisappear。

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%s, %d, %@", __func__, __LINE__, self);
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"%s, %d, %@", __func__, __LINE__, self);

    if (self.navigationController) {
        self.contentLabel.text = [NSString stringWithFormat:@"交互式转场[%d]", (int32_t) self.navigationController.viewControllers.count - 1];
    }

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"%s, %d, %@", __func__, __LINE__, self);
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSLog(@"%s, %d, %@", __func__, __LINE__, self);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    NSLog(@"%s, %d, %@", __func__, __LINE__, self);
}

- (void)dealloc {
    
    NSLog(@"%s, %d, %@", __func__, __LINE__, self);
    
}

#pragma mark - Setup
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0f];
    
    self.navigationItem.title = @"交互式转场-PopPush1";
    UIBarButtonItem *closeBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(onCloseBarButtonClicked:)];
    self.navigationItem.rightBarButtonItems = @[closeBarButton];
    
    // 通过滑动手势来做交互式 VC 转场。
    self.panGesture = [[UIPanGestureRecognizer alloc] init];
    [self.view addGestureRecognizer:self.panGesture];
    self.panGesture.delegate = self;
    // 把当前 VC 作为 panGesture 的另一个 target，这样在当前 VC 也能处理到滑动手势，从而处理左滑 Push 的操作。
    [self.panGesture addTarget:self action:@selector(onPanGesture:)];

    
    // Content label.
    self.contentLabel.text = @"交互式转场";
    [self.view addSubview:self.contentLabel];
    self.contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:self.contentLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0],
                                [NSLayoutConstraint constraintWithItem:self.contentLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0],
                                //[NSLayoutConstraint constraintWithItem:self.contentTitleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40.0],
                                [NSLayoutConstraint constraintWithItem:self.contentLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30.0]
                                ]];
    
    // Push button.
    self.pushButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.pushButton setTitle:@"Push" forState:UIControlStateNormal];
    [self.pushButton addTarget:self action:@selector(onPushButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.pushButton];
    self.pushButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:self.pushButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:80.0],
                                [NSLayoutConstraint constraintWithItem:self.pushButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.pushButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60.0],
                                [NSLayoutConstraint constraintWithItem:self.pushButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30.0]
                                ]];
    
}

#pragma mark - Action
- (void)onCloseBarButtonClicked:(UIBarButtonItem *)barButtonItem {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onPushButtonClicked:(UIButton *)button {
    DMB3ViewController *vc = [[DMB3ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onPanGesture:(UIPanGestureRecognizer *)gesture {
    static DMPanMode panMode = DMPanModeNone;
    
    CGPoint offset = [gesture translationInView:self.view];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        // 当需要判断上下左右 4 个方向时：
//        if (fabs(offset.x) < fabs(offset.y)) {
//            if (offset.y > 0) {
//                panMode = DMPanModeDown;
//            } else {
//                panMode = DMPanModeUp;
//            }
//        } else {
//            if (offset.x > 0) {
//                panMode = DMPanModeRight;
//            } else {
//                panMode = DMPanModeLeft;
//            }
//        }
        
        // 当只需要判断左右 2 个方向时：
        if (offset.x > 0) {
            panMode = DMPanModeRight;
        } else {
            panMode = DMPanModeLeft;
        }
        
        
        NSLog(@"PanMode: %d", panMode);
        
        if (panMode == DMPanModeLeft) {
            NSLog(@"New VC.");
            // 左滑时，创建 nextViewController 并准备跟着手势移动。
            // 这里的问题在于：一旦调用了 addSubview 处理了 nextViewController 的 view 则会在此触发对应的 viewWillAppear 和 viewDidAppear 方法。而这时候 nextViewController 还未添加到对应的 Navigation Controller 中。
            if (!_nextViewController) {
                self.nextViewController = [[DMB3ViewController alloc] init];
                self.nextViewController.view.frame = CGRectMake(self.view.frame.origin.x + self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                [self.view addSubview:self.nextViewController.view];
            }
        }
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        
        //NSLog(@"Pan Transition: (%.2f, %.2f)", offset.x, offset.y);
        
        if (panMode == DMPanModeLeft) {
            if (_nextViewController) {
                CGFloat transitionX = self.view.frame.origin.x + self.view.frame.size.width + offset.x;
                CGRect transitionFrame = CGRectMake(transitionX, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                self.nextViewController.view.frame = transitionFrame;
            }
        }
        
    } else if (gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"PanEnd");
        
        if (panMode == DMPanModeLeft) {
            if (_nextViewController) {
                
                // 如果页面拖动超过 1/3 屏，则滑动过来，否则滑回去。
                // 这里的问题在于：会多次触发 nextViewController 的 viewWillAppear、viewDidAppear、viewWillDisappear、viewDidDisappear。
                if (offset.x < 0 && fabs(offset.x) > self.view.frame.size.width/3) {
                    [UIView animateWithDuration:0.3 animations:^{
                        self.nextViewController.view.frame = self.view.frame;
                    } completion:^(BOOL finished) {
                        
                        [self.nextViewController.view removeFromSuperview];
                        [self.navigationController pushViewController:self.nextViewController animated:NO];
                        self.nextViewController = nil;
                    }];
                } else {
                    [UIView animateWithDuration:0.3 animations:^{
                        self.nextViewController.view.frame = CGRectMake(self.view.frame.origin.x + self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                    } completion:^(BOOL finished) {
                        [self.nextViewController.view removeFromSuperview];
                        self.nextViewController = nil;
                    }];
                }
                
                
            }
        }
        
        panMode = DMPanModeNone;
    }
    
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.panGesture) {
        if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) {
            return NO;
        }

        // 如果当前的 Navigation Controller 有压栈的 VC 时，则用 panGesture 来 hook 对应的处理方法来实现全屏右滑 Pop 返回。
        if (self.navigationController.viewControllers.count > 1) {
            // 获取系统自带滑动返回手势的 target 对象。把系统自带滑动返回手势的 target 的 action 方法添加到 panGesture 上。
            id target = self.navigationController.interactivePopGestureRecognizer.delegate;
            SEL action = NSSelectorFromString(@"handleNavigationTransition:");
            [self.panGesture addTarget:target action:action];
            
            // 禁止使用系统自带的滑动手势。
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }

        return YES;
        
    }
    
    return YES;
}


@end
