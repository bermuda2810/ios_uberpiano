//
//  BaseViewController.m
//  UberPiano
//
//  Created by Bui Quoc Viet on 9/1/17.
//  Copyright © 2017 Mobile Team. All rights reserved.
//

#import "BaseViewController.h"
#import <MBProgressHUD.h>
#import "AppDelegate.h"

#define AppDelegate [UIApplication sharedApplication].delegate

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showLoading {
    UIView *windown = [AppDelegate window];
    [MBProgressHUD showHUDAddedTo:windown animated:YES];
}

- (void)hideLoading {
    UIView *windown = [AppDelegate window];
    [MBProgressHUD hideAllHUDsForView:windown animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
