//
//  ViewController.m
//  随机键盘自定义
//
//  Created by mac on 15/12/14.
//  Copyright (c) 2015年 杨林贵. All rights reserved.
//

#import "ViewController.h"
#import "LGMenuSegView.h"
#import "LGTextFieldView.h"
#define KeyboardHeight 216
#define KScreenWidth    [UIScreen mainScreen].bounds.size.width
#define KScreenHeight   [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITextFieldDelegate>

@property(nonatomic,strong) LGTextFieldView *textField;
@property(nonatomic,strong) UITextField *phoneTextField;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      // [self addTextView];
    
   //密码
    LGTextFieldView *lgtextField = [[LGTextFieldView alloc] initWithFrame:CGRectMake(40, 70, KScreenWidth-80, 50)];
    [self.view addSubview:lgtextField];
    lgtextField.tag = 100;
    lgtextField.delegate = self;
     self.textField = lgtextField;
    
    
    _phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(40,140, KScreenWidth-80,50)];
    _phoneTextField.borderStyle = UITextBorderStyleRoundedRect;
    _phoneTextField.delegate = self;
    _phoneTextField.placeholder = @"输入手机号";
    _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_phoneTextField];
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
   // NSLog(@"textFieldShouldBeginEditing");
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isKindOfClass:[LGTextFieldView class]]) {
//        LGTextFieldView *textF = (LGTextFieldView *)textField;
//        [textF showNumberKeyboardWhenBeginEditing];
        NSLog(@"LGTextFieldView");
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
   
}
//自定义键盘时不走这个方法
-(BOOL)textField:(LGTextFieldView *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isKindOfClass:[LGTextFieldView class]]) {
        LGTextFieldView *lgTextF = (LGTextFieldView *)textField;
        NSLog(@"文字为%@",textField.text);
        if ([lgTextF isRightPassWord:string]) {
            return YES;
        }else{
            return NO;
        }
    }else
        return YES;
    
    
//    if (range.location>= 11 ){
//        return NO;
//    }else
//    
//    return YES;
    
    
//    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    
//    if (toBeString.length > 11) {
//        
//        textField.text = [toBeString substringToIndex:11];
//        
//        return NO;
//        
//    }else{
//        
//        if ([textField isRightPassWord:string]) {
//                        return YES;
//        }else{
//                        return NO;
//        }
//    }
//    
//    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
 //   NSLog(@"输入文字为：%@",self.textField.text);
    [self.phoneTextField resignFirstResponder];
    
//   BOOL isright =  [self.textField isRightPassWord];
//    if (isright) {
//        NSLog(@"合法");
//    }else{
//        NSLog(@"不合法");
//    }
}

@end
