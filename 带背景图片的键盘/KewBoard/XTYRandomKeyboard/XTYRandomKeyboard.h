//
//  XTYRandomKeyboard.h
//  KewBoard
//
//  Created by XuTianyu on 16/4/1.
//  Copyright © 2016年 Lakala. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XTYRandomKeyboard : UIView
@property (strong, nonatomic)UIColor *titleColor;//文字颜色
@property (strong, nonatomic)UIFont *font;//字体
@property (strong, nonatomic)UIColor *numberBackgroundColor;//按钮块的北京颜色
@property (strong, nonatomic)UIColor *keyboardColor;//键盘背景颜色
@property (strong, nonatomic)UIImage *backgroundImage;//北京图片
/**
 *  初始化方法
 *
 *  @param color 按键文字颜色可传nil
 *  @param image 背景图片可传nil
 *
 *  @return
 */
-(instancetype)initWithTitleColor:(UIColor *)color backGroundImage:(UIImage *)image;
/**
 *  设置输入源的inputView
 *
 *  @param view
 */
-(void)setInputView:(UIView *)view;
@end
