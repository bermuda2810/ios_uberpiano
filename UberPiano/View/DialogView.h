//
//  DialogView.h
//  UberPiano
//
//  Created by Bui Quoc Viet on 9/1/17.
//  Copyright © 2017 Mobile Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DialogView : UIView

typedef void(^BlockNegative)(void);
typedef void(^BlockPositive)(void);

- (instancetype)initWithTitle:(NSString *)title andMessage:(NSString *)message;
+ (instancetype)getDialog;
+ (instancetype)getSingleDialog;
- (instancetype)setTitlePositive:(NSString *)titlePositive;
- (instancetype)setTitleNegative:(NSString *)titleNegative;
- (instancetype)setTitle:(NSString *)title;
- (instancetype)setDescription:(NSString *)description;
- (instancetype)addNegativeBlock:(BlockNegative)blockNegative;
- (instancetype)addPositiveBlock:(BlockPositive)blockPositive;
- (instancetype)setImageNegativeButton:(UIImage *)imgNegative;
- (instancetype)setImagePositiveButton:(UIImage *)imgPositive;
- (instancetype)show;
- (void)hideNegativeButton;
- (void)dismiss;

@end
