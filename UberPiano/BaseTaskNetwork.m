//
//  BaseTaskNetwork.m
//
//  Created by Le Cong on 5/13/16.
//
//

#import "BaseTaskNetwork.h"
#import "AFNetworking.h"
#import "NSMutableDictionary+Extensions.h"
#import "AppError.h"

@interface BaseTaskNetwork()

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSURLSessionConfiguration *configuration;

@end

@implementation BaseTaskNetwork {
    NSURLSessionDataTask *_task;
    BOOL _requestCanceled;
    BlockProgress _progress;
}

- (id)init {
    self = [super init];
    if (self) {
        _manager = [AFHTTPSessionManager manager];
        AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        _manager.requestSerializer = requestSerializer;
       AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
         responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
        _manager.responseSerializer = responseSerializer;
        _progress = nil;
    }
    return self;
}

- (void)requestWithBlockSucess:(BlockSuccess)sucess andBlockFailureWithData:(BlockFailureWithData)failure {
    NSMutableURLRequest *request = [self getRequest];
    
    _task = [_manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (_requestCanceled) {
            return;
        }
        
        if (error) {
            if (failure) {
                failure([[AppError alloc] initWithError:error], nil);
            }
            return;
        }
        
        NSError *errorJSon;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:&errorJSon];
        
        int code = [json[@"code"] intValue];
        if (code != OK) {
            if (failure) {
                id dataError = [self dataWhenError:json[@"data"] errorCode:code];
                failure([[AppError alloc] initWithErrorCode:code], dataError);
            }
            return;
        }
        
        id data = [self dataWithResponse:json[@"data"]];
        if (sucess && data) {
            sucess(data);
        }
    }];
    [_task resume];
}

- (void)requestWithBlockSucess:(BlockSuccess)success andBlockFailure:(BlockFailure)failure {
    NSMutableURLRequest *request = [self getRequest];
    _task = [_manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (_requestCanceled) {
            return;
        }
        
        if (error) {
            if (failure) {
                failure([[AppError alloc] initWithError:error]);
            }
            return;
        }
        
        NSError *errorJSon;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:&errorJSon];
        int code = [json[@"code"] intValue];
        if (code != OK) {
            if (failure) {
                failure([[AppError alloc] initWithErrorCode:code]);
            }
            return;
        }
        
        id data = [self dataWithResponse:json[@"data"]];
        if (success && data) {
            success(data);
        }
    }];
    [_task resume];
}

- (void)cancelRequest {
    _requestCanceled = YES;
    if (_task) {
        [_task cancel];
    }
}

- (void)uploadMultipartFormDataWithBlockSuccess:(BlockSuccess)success blockFailure:(BlockFailure)failure andFailureData:(BlockFailureWithData)failureData {
    NSData *fileData = [self data];
    NSError *error;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:[self getMethod] URLString:[self getUrl] parameters:[self getParameters] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:fileData name:@"file" fileName:[self fileName] mimeType:@""];
    } error:&error];
    
    if (error) {
        if (failure) {
            failure([[AppError alloc] initWithError:error]);
        }
        return;
    }
    
    AFHTTPResponseSerializer *response  = [AFHTTPResponseSerializer serializer];
    response.acceptableContentTypes     = [NSSet setWithObject:@"application/json"];;
    _manager.responseSerializer         = response;
    
    NSURLSessionUploadTask *uploadTask  = [_manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        if (_progress) _progress(uploadProgress);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if (failure) {
                failure([[AppError alloc] initWithError:error]);
            }
            if (failureData) {
                failureData([[AppError alloc] initWithError:error], @{});
            }
            return;
        }
        
        id json = [self jsonFromData:responseObject];
        int code = [json[@"code"] intValue];
        
        if (code != OK) {
            if (failure) {
                failure([[AppError alloc] initWithErrorCode:code]);
            }
            
            if (failureData) {
                id dataError = [self dataWhenError:json[@"data"] errorCode:code];
                failureData([[AppError alloc] initWithErrorCode:code], dataError);
            }
            return;
        }
        
        id data = [self dataWithResponse:json[@"data"]];
        if (success && data) {
            success(data);
        }
        
    }];
    [uploadTask resume];
}

- (void)uploadMultipartFormDataWithBlockSuccess:(BlockSuccess)success andBlockFailure:(BlockFailure)failure {
    [self uploadMultipartFormDataWithBlockSuccess:success blockFailure:failure andFailureData:nil];
}

- (void)uploadMultipartFormDataWithBlockSuccess:(BlockSuccess)success andBlockProgress:(BlockProgress)progress andBlockFailure:(BlockFailure)failure {
    _progress = progress;
    [self uploadMultipartFormDataWithBlockSuccess:success andBlockFailure:failure];
}

#pragma mark - Private Method

- (id)jsonFromData:(NSData *)data {
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSData *dataJson = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:dataJson options:0 error:nil];
}

- (NSMutableURLRequest *)getRequest {
    NSString *urlString             = [self getUrl];
    NSDictionary *parameters        = [self getParameters];
    NSString *method                = [self getMethod];
    NSMutableURLRequest *request    = [self requestWithMethod:method
                                                    urlString:urlString
                                                andParameters:parameters];
    return request;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 urlString:(NSString *)urlString
                             andParameters:(NSDictionary *)parameters {
    return [[AFHTTPRequestSerializer serializer] requestWithMethod:method
                                                         URLString:urlString
                                                        parameters:parameters error:nil];
}

- (NSString *)getMethod {
    return [self method];
}

- (NSDictionary *)getParameters {
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:[self parameters]];
    [param addDictionary:[self commonParameters]];
    return param;
}

- (NSDictionary *)commonParameters {
    return @{@"auth_id": @"AUTH_TOKEN", @"device_id": @"DEVICE_ID", @"platform":@(1)};
}

- (NSString *)getUrl {
    NSString *url = [self urlWithPath:[self path]];
    DLog(@"URL Request %@", url);
    return url;
}

- (NSString *)urlWithPath:(NSString *)path {
    return MAKE_API_URL(path);
}

#pragma mark - Method Override Sub Class

- (NSString *)path {
    return @"";
}

- (NSString *)method {
    return METHOD_GET;
}

- (NSDictionary *)parameters {
    return nil;
}

- (id)dataWithResponse:(id)response {
    return response;
}

- (id)dataWhenError:(id)response errorCode:(int)errorCode {
    return response;
}

-(void)uploadUpdateWithProgress:(NSProgress *)uploadProgress {
    DLog(@"Upload Inprogress: %f percent", uploadProgress.fractionCompleted);
}

#pragma mark - Upload Task 

- (NSData *)data {
    return nil;
}

- (NSString *)fileName {
    return @"sip";
}

@end
