//
//  LGTextFieldView.h
//  随机键盘自定义
//
//  Created by mac on 15/12/16.
//  Copyright (c) 2015年 杨林贵. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGMenuSegView.h"

@protocol LGTextFieldViewDelegate <NSObject>

-(void)clickReturnBtn;
-(void)changeDefaultKeyboard;

@end
@interface LGTextFieldView : UITextField<LGMenuSegViewDelegate>
@property(nonatomic,strong) UIView *keyBgBoardView;
@property(nonatomic,assign) id<LGTextFieldViewDelegate> mydelegate;
@property(nonatomic,strong) UIColor *PlaceholderColor;

-(BOOL) isRightPassWord :(NSString *)text;//判断你输入的密码是否匹配
-(NSString *)VerificationTextField;

@end
