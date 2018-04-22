//
//  DMB2ViewController.m
//  NavigationDemo
//
//  Created by qiufu on 20/04/2018.
//  Copyright © 2018 CX. All rights reserved.
//

#import "DMB2ViewController.h"

@interface DMB2ViewController () <UIGestureRecognizerDelegate>
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIButton *pushButton;
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
    
    NSLog(@"%s, %d, %@", __func__, __LINE__, self);
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"%s, %d, %@", __func__, __LINE__, self);
    
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
    
    self.navigationItem.title = @"交互式转场-Pop";
    UIBarButtonItem *closeBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(onCloseBarButtonClicked:)];
    self.navigationItem.rightBarButtonItems = @[closeBarButton];
    
    // 通过滑动手势来做交互式 VC 转场。
    // 如果当前的 Navigation Controller 有压栈的 VC 时，则用 panGesture 来 hook 对应的处理方法来实现全屏右滑 Pop 返回。
    if (self.navigationController.viewControllers.count > 1) {
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] init];
        [self.view addGestureRecognizer:panGesture];

        // 获取系统自带滑动返回手势的 target 对象。
        id target = self.navigationController.interactivePopGestureRecognizer.delegate;
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        // 把系统自带滑动返回手势的 target 的 action 方法添加到 panGesture 上。
        [panGesture addTarget:target action:@selector(handleNavigationTransition:)];
#pragma clang diagnostic pop
        
        // 设置手势代理，拦截手势触发。
        panGesture.delegate = self;
        
        // 禁止使用系统自带的滑动手势。
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
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

@end
