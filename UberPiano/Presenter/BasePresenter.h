//
//  BasePresenter.h
//  UberPiano
//
//  Created by Bui Quoc Viet on 9/1/17.
//  Copyright © 2017 Mobile Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseTaskNetwork.h"

@interface BasePresenter : NSObject

- (id)initWithView:(id)view;

- (void)requestWithTask:(BaseTaskNetwork *)task completionSuccess:(BlockSuccess)success completionFailure:(BlockFailure)failure;

- (void)uploadWithTask:(BaseTaskNetwork *)task completionSuccess:(BlockSuccess)success andBlockProgress:(BlockProgress)progress andBlockFailure:(BlockFailure)failure;

@end
