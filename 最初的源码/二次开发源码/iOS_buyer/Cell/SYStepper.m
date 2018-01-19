//
//  SYStepper.m
//  My_App
//
//  Created by shiyuwudi on 16/2/17.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

#import "SYStepper.h"

@interface SYStepper ()<UITextFieldDelegate>

@property (weak, nonatomic) UITextField *textField;
@property (nonatomic, weak) UIView *superView;
@property (weak, nonatomic) UIButton *decrementButton;
@property (weak, nonatomic) UIButton *incrementButton;

@end

@implementation SYStepper

-(instancetype)initWithFrame:(CGRect)frame max:(NSInteger)max min:(NSInteger)min step:(NSInteger)step tintColor:(UIColor *)tint buttonWidth:(CGFloat)width superView:(UIView *)superView{
    if (self = [super initWithFrame:frame]) {
        
        _max = max;
        _min = min;
        _step = step;
        _superView = superView;
        
        CGColorRef tintColor = [tint CGColor];
        UIButton *decrementButton = [UIButton new];
        UIButton *incrementButton = [UIButton new];
        [self addSubview:decrementButton];
        [self addSubview:incrementButton];
        _decrementButton = decrementButton;
        _incrementButton = incrementButton;
        
        CGFloat buttonWidth = width;
        decrementButton.frame = CGRectMake(0, 0, buttonWidth * self.width, self.height);
        incrementButton.frame = CGRectMake(self.width - decrementButton.width, 0, buttonWidth * self.width, self.height);
        [decrementButton setTitle:@"-" forState:UIControlStateNormal];
        [incrementButton setTitle:@"+" forState:UIControlStateNormal];
        decrementButton.layer.borderColor = tintColor;
        incrementButton.layer.borderColor = tintColor;
        [decrementButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [incrementButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        decrementButton.layer.borderWidth = 1;
        incrementButton.layer.borderWidth = 1;
        decrementButton.layer.masksToBounds = YES;
        incrementButton.layer.masksToBounds = YES;
        [decrementButton addTarget:self action:@selector(decrease) forControlEvents:UIControlEventTouchUpInside];
        [incrementButton addTarget:self action:@selector(increase) forControlEvents:UIControlEventTouchUpInside];
        
        self.layer.borderColor = tintColor;
        self.layer.borderWidth = 1;
        self.layer.masksToBounds = YES;
        
        UITextField *textField = [[UITextField alloc]init];
        _textField = textField;
        textField.textColor = [UIColor redColor];
        

        
        WDInputView *inputView=[[WDInputView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 34) leftTitle:@"取消" leftTarget:self leftAction:@selector(dismissKeyBoard1) rightTitle:@"完成" rightTarget:self rightAction:@selector(dismissKeyBoard)];
        [textField setInputAccessoryView:inputView];
        
        textField.frame = CGRectMake(decrementButton.right, 0, (1.0 - 2 * buttonWidth) * self.width, self.height);
        textField.textAlignment = NSTextAlignmentCenter;
        [self addSubview:textField];
        textField.text = [NSString stringWithFormat:@"%ld",(long)_min];
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.font = [UIFont systemFontOfSize:15];
        [self updateButtonStatus];
        textField.delegate = self;
    }
    return self;
}

-(void)setNum:(NSInteger)num{
    _num = num;
    _textField.text = [SYObject toStr:num];
    [self updateButtonStatus];
}
-(void)setMin:(NSInteger)min{
    _min = min;
    [self updateButtonStatus];
}
-(void)setMax:(NSInteger)max{
    _max = max;
    [self updateButtonStatus];
}
-(void)setStep:(NSInteger)step{
    _step = step;
    [self updateButtonStatus];
}
+(NSString *)notifName{
    return @"syStepperNumberDidChangeNotification";
}
+(NSString *)startNotifName{
    return @"syStepperStartNotification";
}
+(NSString *)keyForNumber{
    return @"keyForNumber";
}
+(NSString *)keyForSuperview{
    return @"I'm the pretty key of the damn super view!!ohoh!";
}
-(void)dismissKeyBoard {
    [_textField resignFirstResponder];
    if (self.value==0) {
        self.num = self.min;
    } else if (self.value > self.max){
        self.num = self.max;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:[SYStepper notifName] object:self userInfo:[self userInfo]];
    [self updateButtonStatus];
}
-(void)dismissKeyBoard1
{
  [_textField resignFirstResponder];

}
-(NSDictionary *)userInfo{
    return @{
             [SYStepper keyForNumber]:_textField.text,
             [SYStepper keyForSuperview]:_superView
             };
}
-(void)decrease {
    NSString *text = _textField.text;
    NSInteger num = text.integerValue;
    if (num - _step >= _min) {
        _textField.text = [SYObject toStr:num - _step];
        [[NSNotificationCenter defaultCenter]postNotificationName:[SYStepper notifName] object:self userInfo:[self userInfo]];
    }
    [self updateButtonStatus];
}
-(void)increase {
    NSString *text = _textField.text;
    NSInteger num = text.integerValue;
    if (num + _step <= _max) {
        _textField.text = [SYObject toStr:num + _step];
        [[NSNotificationCenter defaultCenter]postNotificationName:[SYStepper notifName] object:self userInfo:[self userInfo]];
    }
    [self updateButtonStatus];
}
-(void)updateButtonStatus {
    NSString *text = _textField.text;
    NSInteger num = text.integerValue;
    if (num - _step < _min){
        [_decrementButton setBackgroundColor:BACKGROUNDCOLOR];
    }else {
        [_decrementButton setBackgroundColor:[UIColor whiteColor]];
    }
    if (num + _step > _max) {
        [_incrementButton setBackgroundColor:BACKGROUNDCOLOR];
    }else {
        [_incrementButton setBackgroundColor:[UIColor whiteColor]];
    }
}
-(NSInteger)value{
    return self.textField.text.integerValue;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [[NSNotificationCenter defaultCenter]postNotificationName:[SYStepper startNotifName] object:self userInfo:nil];
    return YES;
}

@end
