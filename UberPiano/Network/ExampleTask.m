//
//  ExampleTask.m
//  UberPiano
//
//  Created by Bui Quoc Viet on 9/1/17.
//  Copyright © 2017 Mobile Team. All rights reserved.
//

#import "ExampleTask.h"

@implementation ExampleTask

- (NSString *)method {
    return METHOD_GET;
}

- (NSString *)path {
    return API_EXAMPLE;
}

- (NSDictionary *)parameters {
    return @{@"key1": @"value1"};
}

- (id)dataWithResponse:(id)response {
    NSDictionary *data = response[0];
    return data;
}

@end
