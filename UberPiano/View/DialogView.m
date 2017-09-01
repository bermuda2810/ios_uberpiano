//
//  DialogView.m
//  UberPiano
//
//  Created by Bui Quoc Viet on 9/1/17.
//  Copyright © 2017 Mobile Team. All rights reserved.
//

#import "DialogView.h"

#import "NSLayoutConstraint+NSLayoutConstraint_Extension.h"

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@interface DialogView()

@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *buttonPositive;
@property (weak, nonatomic) IBOutlet UIButton *buttonNegative;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ctWrapperPositiveButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ctPositiveButton;

//@property (strong, nonatomic) BlockPositive blockPositive;
//@property (strong, nonatomic) BlockNegative blockNegative;
@property (nonatomic) BOOL only_instance;
@property (nonatomic) BOOL showing;
@end

static DialogView *instance;

@implementation DialogView {
    BOOL _negativeClick;
    NSString *_title;
    NSString *_description;
    NSString *_titlePositive;
    BlockNegative _blockNegative;
    BlockPositive _blockPositive;
    NSString *_textNegative;
    NSString *_textPositive;
    
}

+ (UIView *)getViewFromNib {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil];
    return nibs.firstObject;
}

+ (instancetype)getDialog {
    DialogView *dialog = (DialogView *)[DialogView getViewFromNib];
    return dialog;
}

+ (instancetype)getSingleDialog {
    if (!instance) {
        instance = (DialogView *)[self getViewFromNib];
        instance.only_instance = YES;
    }
    return instance;
}

- (id)initWithTitle:(NSString *)title andMessage:(NSString *)message {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"DialogView" owner:self options:nil];
    self = nibs.firstObject;
    _titleView.text = title;
    _descriptionView.text = message;
    return self;
}

- (instancetype)setTitle:(NSString *)title {
    _title = title;
    _titleView.text = _title;
    return self;
}

- (instancetype)setTitlePositive:(NSString *)titlePositive {
    _titlePositive = titlePositive;
    [_buttonPositive setTitle:_titlePositive forState:UIControlStateNormal];
    return self;
}

- (instancetype)setTitleNegative:(NSString *)titleNegative {
    [_buttonNegative setTitle:titleNegative forState:UIControlStateNormal];
    return self;
}

- (void)hideNegativeButton {
    _buttonNegative.hidden = true;
    _ctWrapperPositiveButton = [_ctWrapperPositiveButton setMultiplier:1.0];
    _ctPositiveButton.constant = 10.0f;
    [self layoutIfNeeded];
}

- (instancetype)setDescription:(NSString *)description {
    _description = description;
    _descriptionView.text = description;
    return self;
}

- (instancetype)addPositiveBlock:(BlockPositive)blockPositive {
    _blockPositive = blockPositive;
    return self;
}

- (instancetype)addNegativeBlock:(BlockNegative)blockNegative {
    _blockNegative = blockNegative;
    return self;
}

- (instancetype)setImageNegativeButton:(UIImage *)imgNegative {
    [_buttonNegative setBackgroundImage:imgNegative forState:UIControlStateNormal];
    return self;
}

- (instancetype)setImagePositiveButton:(UIImage *)imgPositive {
    [_buttonPositive setBackgroundImage:imgPositive forState:UIControlStateNormal];
    return self;
}

- (instancetype)show {
    if (self.only_instance && !self.showing) {
        self.showing = true;
        [self showWithView:_contentView];
    }else {
        [self showWithView:_contentView];
    }
    return self;
}

- (void)dismiss {
    [self dismissWithView:_contentView completion:nil];
}

- (IBAction)actionPositive:(id)sender {
    [self dismissWithView:_contentView completion:^(BOOL finished) {
        self.showing = false;
        if (_blockPositive) {
            _blockPositive();
        }
    }];
}

- (IBAction)actionNegative:(id)sender {
    [self dismissWithView:_contentView completion:^(BOOL finished) {
        self.showing = false;
        if (_blockNegative) {
            _blockNegative();
        }
    }];
}

- (void)showWithView:(UIView *)view {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    UIWindow *windown = [[[UIApplication sharedApplication] delegate] window];
    [windown addSubview:self];
    
    view.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.0f options:0 animations:^{
        view.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)dismissWithView:(UIView *)view completion:(void (^ __nullable)(BOOL finished))completion{
    view.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.2 delay:0 options:0 animations:^{
        view.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished){
        if (completion) {
            completion(finished);
        }
        [self removeFromSuperview];
        
    }];
}
@end
