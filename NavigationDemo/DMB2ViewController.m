//
//  DMB2ViewController.m
//  NavigationDemo
//
//  Created by qiufu on 20/04/2018.
//  Copyright © 2018 CX. All rights reserved.
//

#import "DMB2ViewController.h"

typedef NS_ENUM(int32_t, DMPanMode) {
    DMPanModeNone = 0,
    DMPanModeUp = 1,
    DMPanModeDown = 2,
    DMPanModeLeft = 3,
    DMPanModeRight = 4
};

@interface DMB2ViewController () <UIGestureRecognizerDelegate>
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIButton *pushButton;

@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;

@property (strong, nonatomic) UIViewController *nextViewController;
@end

@implementation DMB2ViewController
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
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"B2 viewDidLoad");
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"B2 viewWillAppear");
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"B2 viewDidAppear");
    
}

#pragma mark - Setup
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0f];
    
    self.navigationItem.title = @"交互式转场";
    UIBarButtonItem *closeBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(onCloseBarButtonClicked:)];
    self.navigationItem.rightBarButtonItems = @[closeBarButton];
    
    // 通过滑动手势来做交互式 VC 转场。
    if (!_panGesture) {
        self.panGesture = [[UIPanGestureRecognizer alloc] init];
        [self.view addGestureRecognizer:self.panGesture];
        // 1、如果当前的 Navigation Controller 有压栈的 VC 时，则用 panGesture 来 hook 对应的处理方法来实现全屏滑动返回。
        if (self.navigationController.viewControllers.count > 1) {
            // 1.1、获取系统自带滑动返回手势的 target 对象。
            id target = self.navigationController.interactivePopGestureRecognizer.delegate;
            
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            // 1.2、把系统自带滑动返回手势的 target 的 action 方法添加到 panGesture 上。
            [self.panGesture addTarget:target action:@selector(handleNavigationTransition:)];
#pragma clang diagnostic pop
            
            // 1.3、设置手势代理，拦截手势触发。
            self.panGesture.delegate = self;
            
            // 1.4、禁止使用系统自带的滑动手势。
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
        // 2、把当前 VC 作为 panGesture 的一个 target。这样在当前 VC 也能处理到滑动手势。
        [self.panGesture addTarget:self action:@selector(onPanGesture:)];
    }

    
    // Content label.
    self.contentLabel.text = [NSString stringWithFormat:@"交互式转场[%d]", (int32_t) self.navigationController.viewControllers.count - 1];
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
    DMB2ViewController *vc = [[DMB2ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onPanGesture:(UIPanGestureRecognizer *)gesture {
    NSLog(@"onPanGesture");
    
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
            // 左滑时，创建新的 VC 并准备跟着手势移动。
            if (!_nextViewController) {
                self.nextViewController = [[DMB2ViewController alloc] init];
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

        if (panMode == DMPanModeLeft) {
            if (_nextViewController) {
                
                // 如果页面拖动超过 1/3 屏，则滑动过来，否则滑回去。
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

#pragma mark - Utility
- (UIImage *)snapshotImageOfView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
