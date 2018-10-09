//
//  AccountViewController.m
//  Klik8
//
//  Created by mac on 17/5/27.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "AccountViewController.h"

@interface AccountViewController ()

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [TabBarAndNavagation setLeftBarButtonItemImageName:@"btn_back" TintColor:[UIColor whiteColor] target:self action:@selector(backAction)];
    [TabBarAndNavagation setBackImage:[UIColor imageWithColor:[[UIColor whiteColor]colorWithAlphaComponent:0.2]] ForNavagationBar:self];
    [TabBarAndNavagation setShadowImage:[UIColor imageWithColor:[[UIColor whiteColor]colorWithAlphaComponent:0.2]] ForNavagationBar:self];
}

- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
