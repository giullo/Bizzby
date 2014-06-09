//
//  GGAnimalChoiceViewController.m
//  CatsPassion
//
//  Created by giullo on 09/06/2014.
//  Copyright (c) 2014 Giuliano Galea. All rights reserved.
//

#define kCatButtonTag           123
#define kDogButtonTag           456

#import "GGAnimalChoiceViewController.h"
#import "NSURL+Routes.h"
#import <QuartzCore/QuartzCore.h>

@interface GGAnimalChoiceViewController ()

@end

@implementation GGAnimalChoiceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self buildView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)buildView
{
    UIColor *onColor = [UIColor orangeColor];
    UIColor *offColor = [UIColor darkGrayColor];
    NSArray *colors = @[offColor, onColor];
    CGSize btnSize = CGSizeMake(200, 100);
    CGFloat btnDistance = 20;
    UIButton *catsBtn = [self buttonWithTitle:@"Cats" tag:kCatButtonTag colors:colors];
    UIButton *dogsBtn = [self buttonWithTitle:@"Dogs" tag:kDogButtonTag colors:colors];
    [self.view addSubview:catsBtn];
    [catsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(btnSize.width));
        make.height.equalTo(@(btnSize.height));
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).with.offset(-btnSize.height/2 - btnDistance/2 );
    }];
    [self.view addSubview:dogsBtn];
    [dogsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(btnSize.width));
        make.height.equalTo(@(btnSize.height));
        make.centerX.equalTo(catsBtn);
        make.top.equalTo(catsBtn.mas_bottom).with.offset(btnDistance);
    }];
}

- (void)onButtonTapped:(UIButton *)btn
{
    NSURL *url = nil;
    switch (btn.tag) {
        case kCatButtonTag:
            url = [NSURL cp_URLForCatGallery];
            break;
        case kDogButtonTag:
            url = [NSURL cp_URLForDogGallery];
            break;
        default:
            break;
    }
    [[UIApplication sharedApplication] openURL:url];
}

- (UIButton *)buttonWithTitle:(NSString *)title tag:(NSInteger)tag colors:(NSArray *)colors
{
    UIButton *btn = [[UIButton alloc] init];
    btn.layer.borderColor = [colors[0] CGColor];
    btn.layer.cornerRadius = 5.0;
    btn.layer.borderWidth = 2.0;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:colors[0] forState:UIControlStateNormal];
    [btn setTitleColor:colors[1] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(onButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = tag;
    return btn;
}

@end
