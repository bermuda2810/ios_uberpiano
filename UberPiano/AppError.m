//
//  AppError.m
//
//  Created by Le Cong on 5/31/16.
//  Copyright © 2016 Nal. All rights reserved.
//

#import "AppError.h"
#import <AFNetworking.h>

@implementation AppError

- (id)initWithError:(NSError *)error {
    self = [super init];
    if (self) {
        NSInteger statusCode = [[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        NSString *message = [self messageWithCode:statusCode];
        _failureTitle = @"";
        if(message == nil){
            _errorCode = -1;
            _failureMessage = @"Something went wrong";
        }else {
            _errorCode = statusCode;
            _failureMessage = message;
        }
    }
    return self;
}

- (id)initWithErrorCode:(ErrorCode)code {
    self = [super init];
    if (self) {
        _failureMessage = [self messageWithCode:code];
        if(_failureMessage == nil){
            _failureMessage = [NSString stringWithFormat:@"Error %lu !!!", (unsigned long)code];
        }
        _failureTitle = @"Error";
        _errorCode = code;
    }
    return self;
}

- (NSString *)messageWithCode:(ErrorCode)code {
    NSString *message = @"";
    switch (code) {
        case NO_INTERNET_CONNECTION:
            message = @"インターネット接続がオフラインのようです。";
            break;
        case INVALID_TOKEN:
            message = @"Token invalid";
            break;
        case REQUEST_TIME_OUT:
            message = @"The request timed out";
            break;
        case SERVER_ERROR:
            message = @"Server error 500";
            break;
        case REQUEST_NOT_FOUND:
            message = @"Request not found";
            break;
        default:
            message = nil;
            break;
    }
    
    return message;
}

@end
