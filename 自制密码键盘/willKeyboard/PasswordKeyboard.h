//
//  PasswordKeyboard.h
//  willKeyboard
//
//  Created by 电脑的密码是admin on 15/12/3.
//  Copyright (c) 2015年 wille. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordKeyboard : UIViewController
@property (weak, nonatomic)  UITextView *myKeyboard;
@property(weak,nonatomic)UITextField *myKeyField;
@property (nonatomic,strong) UIImageView * keyboard;
@property(nonatomic,strong)NSMutableArray *titleArray;
@end
