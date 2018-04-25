//
//  DMB1ViewController.m
//  NavigationDemo
//
//  Created by qiufu on 20/04/2018.
//  Copyright © 2018 CX. All rights reserved.
//

#import "DMB1ViewController.h"
#import "DMB2ViewController.h"
#import "DMB3ViewController.h"
#import "DMB4ViewController.h"
#import "DMB4NavigationController.h"

@interface DMB1ViewController ()
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIButton *pushButton;
@end

@implementation DMB1ViewController
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

    [self setupUI];
}

#pragma mark - Setup
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0f];
    
    self.navigationItem.title = @"B1";
    UIBarButtonItem *B2BarButton = [[UIBarButtonItem alloc] initWithTitle:@"B2" style:UIBarButtonItemStylePlain target:self action:@selector(onB2BarButtonClicked:)];
    UIBarButtonItem *B3BarButton = [[UIBarButtonItem alloc] initWithTitle:@"B3" style:UIBarButtonItemStylePlain target:self action:@selector(onB3BarButtonClicked:)];
    UIBarButtonItem *B4BarButton = [[UIBarButtonItem alloc] initWithTitle:@"B4" style:UIBarButtonItemStylePlain target:self action:@selector(onB4BarButtonClicked:)];
    self.navigationItem.rightBarButtonItems = @[B2BarButton, B3BarButton, B4BarButton];
    
    // Content label.
    self.contentLabel.text = [NSString stringWithFormat:@"自定义转场[%d]", (int32_t) self.navigationController.viewControllers.count - 1];
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
- (void)onPushButtonClicked:(UIButton *)button {
    DMB1ViewController *vc = [[DMB1ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onB2BarButtonClicked:(UIBarButtonItem *)barButtonItem {
    DMB2ViewController *vc = [[DMB2ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc]; // 使用系统的 UINavigationController。
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)onB3BarButtonClicked:(UIBarButtonItem *)barButtonItem {
    DMB3ViewController *vc = [[DMB3ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc]; // 使用系统的 UINavigationController。
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)onB4BarButtonClicked:(UIBarButtonItem *)barButtonItem {
    DMB4ViewController *vc = [[DMB4ViewController alloc] init];
    DMB4NavigationController *nav = [[DMB4NavigationController alloc] initWithRootViewController:vc];
    nav.fullScreenPopGestureEnabled = YES;
    nav.fullScreenPushGestureEnabled = YES;
    [self presentViewController:nav animated:YES completion:nil];
}


@end
