//
//  NSDictionary+Extensions.m
//
//  Created by Le Cong on 5/13/16.
//
//

#import "NSMutableDictionary+Extensions.h"

@implementation NSMutableDictionary (Extensions)

- (void)addDictionary:(NSDictionary *)dic {
    for (NSString *key in [dic allKeys]) {
        self[key] = dic[key];
    }
}

@end
