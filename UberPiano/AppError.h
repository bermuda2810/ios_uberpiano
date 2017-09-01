//
//  AppError.h
//
//  Created by Le Cong on 5/31/16.
//  Copyright © 2016 Nal. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    OK = 200,
    INVALID_TOKEN = 501,
    NO_INTERNET_CONNECTION = -1,
    REQUEST_TIME_OUT = -2102,
    SERVER_ERROR = 500,
    REQUEST_NOT_FOUND = 404
} ErrorCode;

@interface AppError : NSObject

@property NSString *failureMessage;
@property NSString *failureTitle;
@property ErrorCode errorCode;

- (id)initWithError:(NSError *)error;
- (id)initWithErrorCode:(ErrorCode)code;

@end
