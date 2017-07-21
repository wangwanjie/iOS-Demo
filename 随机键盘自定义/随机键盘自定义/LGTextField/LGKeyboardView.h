//
//  LGKeyboardView.h
//  随机键盘自定义
//
//  Created by mac on 15/12/15.
//  Copyright (c) 2015年 杨林贵. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LGKeyboardViewDelegate <NSObject>

@optional
-(void)inputKeyboard :(NSString *)inputString;
-(void)deleteBtnAction ;
-(void)finishedAction;
-(void)changeABCKeyboard;
-(void)changeabcKeyboard;
@end
@interface LGKeyboardView : UIView

typedef  enum{
    
    NumberKeyboard,
    ABCKeyboard,
    abcKeyBoard,
    otherKeyboard
    
} KeyboardType;

@property(nonatomic,assign) KeyboardType  keyType;

@property(nonatomic,assign) id<LGKeyboardViewDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame  keyboardType :(KeyboardType)type;
@end
