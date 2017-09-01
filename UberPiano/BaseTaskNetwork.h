//
//  BaseTaskNetwork.h
//
//  Created by Le Cong on 5/13/16.
//
//

#import <Foundation/Foundation.h>
#import "NetworkAPI.h"

@class AppError;

#ifdef DEBUG
#define BASE_URL  @"http://api.dev.piano.com"
#else
#define BASE_URL  @"http://api.piano.com"
#endif

#define METHOD_POST  @"POST";
#define METHOD_GET    @"GET";

#define MAKE_API_URL(API) [NSString stringWithFormat:@"%@/%@", BASE_URL, API]

typedef void (^BlockSuccess)(id data);
typedef void (^BlockFailure)(AppError *error);
typedef void (^FailureData)(NSDictionary *data);
typedef void (^BlockFailureWithData)(AppError *error, NSDictionary *data);
typedef void (^BlockProgress)(NSProgress *progress);

@interface BaseTaskNetwork : NSObject

- (void)requestWithBlockSucess:(BlockSuccess)sucess andBlockFailure:(BlockFailure)failure;
- (void)requestWithBlockSucess:(BlockSuccess)sucess andBlockFailureWithData:(BlockFailureWithData)failure;
- (void)uploadMultipartFormDataWithBlockSuccess:(BlockSuccess)success andBlockFailure:(BlockFailure)failure;
- (void)uploadMultipartFormDataWithBlockSuccess:(BlockSuccess)success blockFailure:(BlockFailure)failure andFailureData:(BlockFailureWithData)data;
- (void)uploadMultipartFormDataWithBlockSuccess:(BlockSuccess)success andBlockProgress:(BlockProgress)progress andBlockFailure:(BlockFailure)failure;
- (void)cancelRequest;
#pragma mark - Method Override Subclass

- (NSString *)path;
- (NSString *)method;
- (NSDictionary *)parameters;
- (id)dataWithResponse:(id)response;
- (id)dataWhenError:(id)response errorCode:(int)errorCode;
- (NSData *)data;
- (NSString *)fileName;

@end
