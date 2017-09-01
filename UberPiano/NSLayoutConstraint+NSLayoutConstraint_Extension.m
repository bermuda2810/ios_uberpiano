//
//  NSLayoutConstraint+NSLayoutConstraint_Extension.m
//  Sip
//
//  Created by Bui Quoc Viet on 2/15/17.
//  Copyright © 2017 Nal. All rights reserved.
//

#import "NSLayoutConstraint+NSLayoutConstraint_Extension.h"

@implementation NSLayoutConstraint (NSLayoutConstraint_Extension)

- (NSLayoutConstraint *)setMultiplier:(CGFloat)multiplier {
    [NSLayoutConstraint deactivateConstraints:@[self]];
    NSLayoutConstraint *newLayoutContraint = [NSLayoutConstraint constraintWithItem:self.firstItem
                                                                          attribute:self.firstAttribute relatedBy:self.relation
                                                                             toItem:self.secondItem
                                                                          attribute:self.secondAttribute multiplier:multiplier
                                                                           constant:self.constant];
    newLayoutContraint.priority = self.priority;
    newLayoutContraint.shouldBeArchived = self.shouldBeArchived;
    newLayoutContraint.identifier = self.identifier;
    [NSLayoutConstraint activateConstraints:@[newLayoutContraint]];
    return newLayoutContraint;
}

@end
