//
//  XTYRandomKeyboard.m
//  KewBoard
//
//  Created by XuTianyu on 16/4/1.
//  Copyright © 2016年 Lakala. All rights reserved.
//

#import "XTYRandomKeyboard.h"
static const CGFloat btnAlpha = 0.7;
static const CGFloat btnRadius = 5;
@interface XTYRandomKeyboard ()
{
    NSMutableArray *_titleArray;
    id inputView;
}
@property(strong,nonatomic)UIImageView *backgroundImageView;
@end

@implementation XTYRandomKeyboard
#pragma mark -
#pragma mark lazyGet
-(UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.frame];
    }
    return _backgroundImageView;
}
/**
 *  设置输入源的inputView
 *
 *  @param view
 */
-(void)setInputView:(UIView *)view
{
    if ([view isKindOfClass:[UITextField class]]) {
        UITextField *m =  (UITextField *)  view;
        m.inputView  = self;
    }
    if ([view isKindOfClass:[UITextView class]]) {
        UITextView *m =  (UITextView *)  view;
        m.inputView  = self;
    }
    inputView = view;
}
/**
 *  完成
 */
-(void)finishedBTN
{
    [inputView endEditing:YES];
}
/**
 *  删除
 */
-(void)deleteBTN{
    if ([inputView isFirstResponder]) {
        [inputView deleteBackward];
    }
}
/**
 *  点击输入
 *
 *  @param btn
 */
-(void)BTNclick:(UIButton *)btn{
    if ([inputView isFirstResponder]) {
        [inputView insertText:btn.titleLabel.text];
    }
    
}
/**
 *  长按删除，全部删除
 */
-(void)longpressGesture{
    
    [inputView setText:nil];
    
}
/**
 *  初始化界面
 */
-(void)setUpViews
{
    CGFloat alpha = 1;
    if (self.backgroundImage) {
        self.backgroundImageView.image = self.backgroundImage;
        self.backgroundImageView.userInteractionEnabled = YES;
        alpha = btnAlpha;
        [self addSubview:self.backgroundImageView];
    }
    if (_keyboardColor) {
        self.backgroundColor = _keyboardColor;
    }
    if (!_numberBackgroundColor) {
        _numberBackgroundColor = [UIColor whiteColor];
    }
    _titleArray = [NSMutableArray arrayWithCapacity:0];
    while (_titleArray.count<9) {
        NSInteger titlerNum = arc4random()%9 + 1;
        NSString *titleString = [NSString stringWithFormat:@"%ld",titlerNum];
        if (![_titleArray containsObject:titleString]) {
            [_titleArray addObject:titleString];
        }
    }
    for (int i = 0; i<12; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.alpha = btnAlpha;
        if (self.font) {
            btn.titleLabel.font = self.font;
        }
        [btn setTitleColor:self.titleColor forState:UIControlStateNormal];
        btn.layer.cornerRadius = btnRadius;
        [btn setBackgroundColor:_numberBackgroundColor];
        btn.showsTouchWhenHighlighted = YES;
        NSString *titleStr;
        switch (i) {
            case 11:
                titleStr = @"完成";
                [btn setTitle: titleStr forState:UIControlStateNormal];
                [ btn addTarget:self action:@selector(finishedBTN) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 10:
                titleStr = @"0";
                [btn setTitle: titleStr forState:UIControlStateNormal];
                
                [ btn addTarget:self action:@selector(BTNclick:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 9:
                titleStr = @"删除";
                [btn setTitle: titleStr forState:UIControlStateNormal];
                [ btn addTarget:self action:@selector(deleteBTN) forControlEvents:UIControlEventTouchUpInside];
                [btn addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longpressGesture)]];
                break;
            default:
                [ btn addTarget:self action:@selector(BTNclick:) forControlEvents:UIControlEventTouchUpInside];
                
                break;
        }
        if (i < 9) {
            [btn setTitle:_titleArray[i] forState:UIControlStateNormal];
        }
        CGFloat dis = 10;
        CGFloat btnW =(self.frame.size.width - (4*dis))/3 ;
        CGFloat btnH =(self.frame.size.height - (5*dis))/4 ;
        CGFloat btnY = (i/3)*(btnH + dis)+dis;
        CGFloat btnX = (i%3)*(btnW + dis)+dis;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        if (self.backgroundImage) {
            [self.backgroundImageView addSubview:btn];
        }else
            [self addSubview:btn];
    }
    
}
/**
 *  设置frame
 */
-(void)lockFrame
{
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 250);
}
/**
 *  初始化按钮颜色，背景图片
 *
 *  @param color     按钮颜色
 *  @param imageName 背景图名称
 *  @param view 需要用到键盘的view（UITextField，UITextView）
 *  @return
 */
-(instancetype)initWithTitleColor:(UIColor *)color backGroundImage:(UIImage *)image
{
    
    self = [[XTYRandomKeyboard alloc] init];
    
    self.titleColor = color?color:[UIColor blackColor];
    self.backgroundImage = image;
    [self setUpViews];
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self lockFrame];
    }
    return self;
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        [self lockFrame];
    }
    return self;
}
@end
