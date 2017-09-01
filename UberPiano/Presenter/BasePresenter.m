//
//  BasePresenter.m
//  UberPiano
//
//  Created by Bui Quoc Viet on 9/1/17.
//  Copyright © 2017 Mobile Team. All rights reserved.
//

#import "BasePresenter.h"
#import "BaseViewController.h"
#import "DialogView.h"
#import "BaseView.h"
#import "AppError.h"

@interface BasePresenter()

@property (nonatomic, weak) id<BaseView> view;

@end

@implementation BasePresenter

- (id)initWithView:(id)view {
    self = [super init];
    if (self) {
        _view = view;
    }
    return self;
}

- (void)requestWithTask:(BaseTaskNetwork *)task completionSuccess:(BlockSuccess)success completionFailure:(BlockFailure)failure {
    __weak __typeof__(self) weakSelf = self;
    [task requestWithBlockSucess:^(id data) {
        if (success) {
            success(data);
        }
    } andBlockFailure:^(AppError *error) {
        [weakSelf handleError:error blockFailure:failure];
    }];
}

- (void)uploadWithTask:(BaseTaskNetwork *)task completionSuccess:(BlockSuccess)success andBlockProgress:(BlockProgress)progress andBlockFailure:(BlockFailure)failure {
    __weak __typeof__(self) weakSelf = self;
    [task uploadMultipartFormDataWithBlockSuccess:^(id data) {
        success(data);
    } andBlockProgress:^(NSProgress *pr) {
        progress(pr);
    } andBlockFailure:^(AppError *error) {
        [weakSelf handleError:error blockFailure:failure];
    }];
}

- (void)handleError:(AppError *)error blockFailure:(BlockFailure)failure {
    if ([self checkInvalidToken:error]) {
        [self tryToHideLoading];
        [self didInvalidToken];
    }else if([self checkNetworkError:error]) {
        [self tryToHideLoading];
        [self showDialogNetworkProblem];
    }else {
        if (failure) {
            failure(error);
        }
    }
}

- (void)showDialogNetworkProblem {
    if([_view respondsToSelector:@selector(didGotNetworkConnectProblem)]){
        [_view didGotNetworkConnectProblem];
    }
    DialogView *dialog = [DialogView getSingleDialog];
    [dialog setTitle:@"Network Error"];
    [dialog setDescription:@"Lost connection !!!"];
    [dialog hideNegativeButton];
    [dialog show];
}

- (void)didInvalidToken {
    
}

- (void)tryToHideLoading {
    if ([_view isKindOfClass:[UIViewController class]]
        && [((BaseViewController *)_view) canPerformAction:@selector(hideLoading) withSender:nil]) {
        [((BaseViewController *)_view) hideLoading];
    }
}


- (BOOL)checkNetworkError:(AppError *)error {
    if (error.errorCode == NO_INTERNET_CONNECTION || error.errorCode == REQUEST_TIME_OUT) {
        return true;
    }else {
        return false;
    }
}

- (BOOL)checkInvalidToken:(AppError *)error {
    if (error.errorCode == INVALID_TOKEN) {
        DLog(@"Invalid Token");
        return true;
    }else {
        return false;
    }
}

@end
