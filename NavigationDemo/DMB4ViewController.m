//
//  DMB4ViewController.m
//  NavigationDemo
//
//  Created by qiufu on 22/04/2018.
//  Copyright © 2018 CX. All rights reserved.
//

#import "DMB4ViewController.h"
#import "UIViewController+DMB4Navigation.h"
#import "DMB4NavigationController.h"

@interface DMB4ViewController () <DMB4NavigationControllerProtocol>
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIButton *pushButton;
@end

@implementation DMB4ViewController

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
    
    self.dm_fullScreenPopGestureEnabled = YES;
    self.dm_fullScreenPushGestureEnabled = YES;
    
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
    
    self.navigationItem.title = @"B4";
    UIBarButtonItem *closeBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(onCloseBarButtonClicked:)];
    self.navigationItem.rightBarButtonItems = @[closeBarButton];
    
    
    // Content label.
    self.contentLabel.text = [NSString stringWithFormat:@"交互式转场[%d]", (int32_t) self.dm_navigationController.viewControllers.count - 1];
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
                                [NSLayoutConstraint constraintWithItem:self.pushButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:100.0],
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
    DMB4ViewController *vc = [[DMB4ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - DMB4NavigationControllerProtocol
- (void)navigationControllerShouldPushToNextViewController:(DMB4NavigationController *)navigationController {
    NSLog(@"%s, %d, %@", __func__, __LINE__, self);
    DMB4ViewController *vc = [[DMB4ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
