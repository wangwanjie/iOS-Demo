//
//  LGTextFieldView.m
//  随机键盘自定义
//
//  Created by mac on 15/12/16.
//  Copyright (c) 2015年 杨林贵. All rights reserved.
//

#import "LGTextFieldView.h"
#import "LGKeyboardView.h"
#define KeyboardHeight 216
#define KScreenWidth    [UIScreen mainScreen].bounds.size.width
#define KScreenHeight   [UIScreen mainScreen].bounds.size.height
#define DeleteBtnGrayColor  [UIColor colorWithRed:154.0/255.0 green:163.0/255.0 blue:176.0/255.0 alpha:1.0]
#define KeyboardBackgroundView [UIColor colorWithRed:198.0/255.0 green:203.0/255.0 blue:210.0/255.0 alpha:1.0]
//文本框里默认提示文字颜色
#define TextField_Placeholder_Color [UIColor colorWithRed:202.0/255.0 green:216.0/255.0 blue:221.0/255.0 alpha:1]
@interface LGTextFieldView ()<LGKeyboardViewDelegate>
@property(nonatomic,strong) LGKeyboardView *numberKeyboardView;
@property(nonatomic,strong) LGKeyboardView *abcKeyboardView;
@property(nonatomic,strong) LGKeyboardView *otherKeyboardView;
@property(nonatomic,strong) LGMenuSegView *menuSgView;

@end
@implementation LGTextFieldView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self addtextView];
        //通知的话集成到项目的会崩溃
     //   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow :) name:UIKeyboardWillShowNotification object:nil];
    }
    
    return self;
}

#pragma mark - 设置 PlaceholderColor 字体颜色
- (void) drawPlaceholderInRect:(CGRect)rect {
    [self.PlaceholderColor setFill];
    [[self placeholder] drawInRect:CGRectMake(0, (rect.size.height-22)/2, rect.size.width, rect.size.height) withFont:[UIFont systemFontOfSize:17]];
}
-(void)addtextView
{
    self.placeholder = @"请输入密码";
//    
//    if ([[UIDevice currentDevice].systemVersion floatValue] >=7.0) {
//        self.delegate = self;
//    }
    self.borderStyle = UITextBorderStyleRoundedRect;
    self.secureTextEntry = YES;
    self.clearsOnBeginEditing = NO;
    self.PlaceholderColor = TextField_Placeholder_Color;
    //ios6 文字，默认为顶部对其，设置文字居中。
    self.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    
    [self addTarget:self action:@selector(textFiledDidChangeText:) forControlEvents:UIControlEventEditingChanged];
    
    if (isDefaultKeyboard) {
        LGMenuSegView *toolView = [[LGMenuSegView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40) TitleArray:@[@"系统键盘",@"数字",@"字母",@"符号"]];
        toolView.delegate = self;
        toolView.backgroundColor = [UIColor whiteColor];
        self.inputAccessoryView = toolView;
        UIView *toplineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 0.6)];
        toplineView.backgroundColor = DeleteBtnGrayColor;
        [toolView addSubview:toplineView];
        self.menuSgView = toolView;
        
        [self addTextFieldInputView];
        
        [self.menuSgView clickButton:1];
    }
    
}
-(void)textFiledDidChangeText :(LGTextFieldView *)textField;
{
    if (textField.text.length > 20) {
            textField.text = [textField.text substringToIndex:20];
    }
}
-(void)addTextFieldInputView{

    _keyBgBoardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth,KeyboardHeight)];
    _keyBgBoardView.backgroundColor = KeyboardBackgroundView;
    self.inputView = self.keyBgBoardView;
}
#pragma mark 添加数字键盘
-(void)addNumberBoard
{
    if (!_numberKeyboardView) {
        _numberKeyboardView = [[LGKeyboardView alloc] initWithFrame:self.keyBgBoardView.bounds keyboardType:NumberKeyboard];
        _numberKeyboardView.delegate = self;
        [self.keyBgBoardView addSubview:_numberKeyboardView];
    }
}
#pragma mark 添加英文字母键盘
-(void)addEnglishKeyboardView :(KeyboardType)type
{
    if (!_abcKeyboardView) {
        _abcKeyboardView = [[LGKeyboardView alloc] initWithFrame:self.keyBgBoardView.bounds keyboardType:type];
        _abcKeyboardView.delegate = self;
        [self.keyBgBoardView addSubview:_abcKeyboardView];
    }
}
#pragma mark 添加特殊符号键盘
-(void)addOtherKeyboardView
{
    if (!_otherKeyboardView) {
        _otherKeyboardView = [[LGKeyboardView alloc] initWithFrame:self.keyBgBoardView.bounds keyboardType:otherKeyboard];
        _otherKeyboardView.delegate = self;
        [self.keyBgBoardView addSubview:_otherKeyboardView];
    }
}
#pragma mark LGKeyboardViewDelegate 输入数字字母
-(void)inputKeyboard :(NSString *)inputString
{
    if (self.text.length>19) { //限制输入20位
        return;
    }
//    NSString *inputStr = inputString;
//    NSString *pattern = @"^[a-zA-Z0-9~!@#$%^&*_]";
//    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
//    BOOL iscaninput = [predicate evaluateWithObject:inputStr];
//    
//    if (iscaninput) {
//        
//       [self insertText:inputString];
//        
//    }else{
//      //  NSLog(@"不允许输入的字符");
//    }
    [self insertText:inputString];
}
#pragma mark 删除按钮事件
-(void)deleteBtnAction
{
    [self deleteBackward];
}
#pragma mark 完成按钮事件
-(void)finishedAction
{
    [self resignFirstResponder];
    if (_mydelegate && [_mydelegate respondsToSelector:@selector(clickReturnBtn)]) {
        [_mydelegate clickReturnBtn];
    }
}
#pragma mark 切换大写字母事件
-(void)changeABCKeyboard
{
    if (_abcKeyboardView) {
        [_abcKeyboardView removeFromSuperview];
        _abcKeyboardView = nil;
    }
    [self addEnglishKeyboardView:ABCKeyboard];
}
#pragma mark 切换小写字母事件
-(void)changeabcKeyboard
{
    if (_abcKeyboardView) {
        [_abcKeyboardView removeFromSuperview];
        _abcKeyboardView = nil;
    }
    
    [self addEnglishKeyboardView:abcKeyBoard];
}
#pragma mark 菜单LGMenuSegView点击代理事件
-(void)clickButton:(NSInteger)clickIndex
{
    //注意：这里要在系统键盘和自定义键盘之间切换的话，必须要先将键盘注销然后再弹出，再切换相应的键盘。
    switch (clickIndex) {
        case 0:
            if (_numberKeyboardView) {
                [_numberKeyboardView removeFromSuperview];
                _numberKeyboardView = nil;
            }
            if (_abcKeyboardView) {
                [_abcKeyboardView removeFromSuperview];
                _abcKeyboardView = nil;
            }
            if (_otherKeyboardView) {
                [_otherKeyboardView removeFromSuperview];
                 _otherKeyboardView = nil;
            }

            self.keyBgBoardView = nil;
            self.inputView = nil;
            
            [self resignFirstResponder];
            [self performSelector:@selector(showDefaultKeyboard) withObject:self afterDelay:0.2];
            break;
        case 1:
            if (_abcKeyboardView) {
                [_abcKeyboardView removeFromSuperview];
                _abcKeyboardView = nil;
            }
            if (_otherKeyboardView) {
                [_otherKeyboardView removeFromSuperview];
                 _otherKeyboardView = nil;
            }
            if (!self.keyBgBoardView) {
                [self resignFirstResponder];
                [self performSelector:@selector(showDefaultKeyboard) withObject:self afterDelay:0.2];
                
                [self addTextFieldInputView];
            }
            [self addNumberBoard];
            break;
        case 2:
            if (_numberKeyboardView) {
                [_numberKeyboardView removeFromSuperview];
                _numberKeyboardView = nil;
            }
            if (_otherKeyboardView) {
                [_otherKeyboardView removeFromSuperview];
                _otherKeyboardView = nil;
            }
            if (!self.keyBgBoardView) {
                
                [self resignFirstResponder];
                [self performSelector:@selector(showDefaultKeyboard) withObject:self afterDelay:0.2];
                
                [self addTextFieldInputView];
            }
            [self addEnglishKeyboardView:abcKeyBoard];
            break;
        case 3:
            if (_abcKeyboardView) {
                [_abcKeyboardView removeFromSuperview];
                _abcKeyboardView = nil;
            }
            if (_numberKeyboardView) {
                [_numberKeyboardView removeFromSuperview];
                _numberKeyboardView = nil;
            }
            if (!self.keyBgBoardView) {
                [self resignFirstResponder];
                [self performSelector:@selector(showDefaultKeyboard) withObject:self afterDelay:0.2];
                [self addTextFieldInputView];
            }
            [self addOtherKeyboardView];
            break;
        default:
            break;
    }
}
-(void)showDefaultKeyboard
{      self.clearsOnBeginEditing = NO;

    [self becomeFirstResponder];
    self.clearsOnBeginEditing = NO;

}

#pragma mark 判断输入密码是否合理
-(BOOL) isRightPassWord :(NSString *)text{
    
    if (![text isEqualToString:@""]) {
        NSString *pattern = @"^[a-zA-Z0-9~!@#$%^&*_]";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
        BOOL isRight = [predicate evaluateWithObject:text];
        return isRight;
    }
    return YES;
}
-(NSString *)VerificationTextField
{
    //6至20位数字
    NSString *pattern =@"^[a-zA-Z0-9~!@#$%^&*_]{1,20}$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    NSString *texts = self.text;

    BOOL isRight = [predicate evaluateWithObject:self.text];
    if (isRight ==YES) {
        return @"OK";
    }else
        return @"NO";
}

@end
