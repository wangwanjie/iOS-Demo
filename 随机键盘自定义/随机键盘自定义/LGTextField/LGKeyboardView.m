//
//  LGKeyboardView.m
//  随机键盘自定义
//
//  Created by mac on 15/12/15.
//  Copyright (c) 2015年 杨林贵. All rights reserved.
//

#import "LGKeyboardView.h"

#define KeyboardHeight 216
#define KScreenWidth    [UIScreen mainScreen].bounds.size.width
#define KScreenHeight   [UIScreen mainScreen].bounds.size.height

#define DeleteBtnGrayColor  [UIColor colorWithRed:154.0/255.0 green:163.0/255.0 blue:176.0/255.0 alpha:1.0]
#define FinishedBtnBlueColor  [UIColor colorWithRed:75.0/255.0 green:141.0/255.0 blue:244.0/255.0 alpha:1.0]
#define SelectBtnBackGroundView  [UIColor colorWithRed:154.0/255.0 green:163.0/255.0 blue:176.0/255.0 alpha:1.0]
@implementation LGKeyboardView

-(instancetype)initWithFrame:(CGRect)frame keyboardType :(KeyboardType)type
{
    if (self = [super initWithFrame:frame]) {
        if (type == NumberKeyboard) {
            [self addNumberBoard];
         }
        
        if (type ==abcKeyBoard) {
            [self addEnglishKeyboard:@"abc"];
        }
        
        if (type ==ABCKeyboard) {
            [self addEnglishKeyboard:@"ABC"];
        }
        if (type == otherKeyboard) {
            [self addOtherKeyboardView];
        }
    self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
-(void)addNumberBoard
{

    //已经生成的title
    NSMutableArray *numberKeyboardArray = [NSMutableArray arrayWithArray:@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"]];
    NSMutableArray *randomBtnTitle = [NSMutableArray array];
    
    while (numberKeyboardArray.count>0) {
        int random = arc4random()%(numberKeyboardArray.count);
        NSString *title =numberKeyboardArray[random];
        [randomBtnTitle addObject:title];
        [numberKeyboardArray removeObjectAtIndex:random];
    }
    [randomBtnTitle insertObject:@"删除" atIndex:8];
    [randomBtnTitle insertObject:@"完成" atIndex :randomBtnTitle.count];
    
    int rowCount = 3;
    float leftX = 3.0;
    float distanse = 3.0;
    
    float top = 3.0;
    float btnWidth = (KScreenWidth-2*leftX-(rowCount-1)*distanse)/rowCount;
    float btnHeight = (KeyboardHeight-2*top-3*distanse)/4;
    
    for (int i=0; i<12; i++) {
        
        float kx ;
        float ky ;
        kx = leftX+i%rowCount*(distanse + btnWidth);
        ky = top + i/rowCount*(distanse +btnHeight);
        
        if (i ==8 || i == 11) {
            if (i ==8) {
                UIButton *deletebtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [deletebtn setFrame:CGRectMake(kx, ky, btnWidth, btnHeight)];
                deletebtn.backgroundColor = [UIColor whiteColor];
                
                [deletebtn setTitle:@"删除" forState:UIControlStateNormal];
                [deletebtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                deletebtn.layer.masksToBounds = YES;
                deletebtn.layer.cornerRadius = 8;
                deletebtn.backgroundColor = DeleteBtnGrayColor;
                [deletebtn addTarget:self action:@selector(deleteButtonAction :) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:deletebtn];
                
            }
            if (i == 11) {
                UIButton *finishedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [finishedBtn setFrame:CGRectMake(kx, ky, btnWidth, btnHeight)];
                finishedBtn.backgroundColor = FinishedBtnBlueColor;
                [finishedBtn setTitle:@"完成" forState:UIControlStateNormal];
                [finishedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                finishedBtn.layer.masksToBounds = YES;
                finishedBtn.layer.cornerRadius = 8;
                [finishedBtn addTarget:self action:@selector(finished) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:finishedBtn];
                
            }
            continue;
        }
        
        UIButton *keyBoardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [keyBoardBtn setFrame:CGRectMake(kx, ky, btnWidth, btnHeight)];
        keyBoardBtn.backgroundColor = [UIColor whiteColor];
        [keyBoardBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        keyBoardBtn.layer.masksToBounds = YES;
        keyBoardBtn.layer.cornerRadius = 8;
        [keyBoardBtn setTitle:randomBtnTitle[i] forState:UIControlStateNormal];
        [keyBoardBtn addTarget:self action:@selector(keyBoardInputAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:keyBoardBtn];
    }
    
    
}
-(void)addEnglishKeyboard :(NSString *)type
{
    NSMutableArray *titleArray = nil;
    NSMutableArray *newArr = [NSMutableArray array];
    if ([type isEqualToString:@"ABC"]) {
        titleArray = [NSMutableArray arrayWithArray:@[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"]];
        while (titleArray.count>0) {
            int random = arc4random()%(titleArray.count);
            [newArr addObject:titleArray[random]];
            [titleArray removeObjectAtIndex:random];
        }
        
    }else{
        titleArray = [NSMutableArray arrayWithArray:@[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z"]];
        
        while (titleArray.count>0) {
            int random = arc4random()%(titleArray.count);
            [newArr addObject:titleArray[random]];
            [titleArray removeObjectAtIndex:random];
        }
    }
    
    int rowCount = 10;
    float leftX = 3.0;    //距离左边
    float distanse = 5.0;  //左右两按钮距离
    float distanseTop = 10;  //上下两按钮距离
    float top = 5.0;        //距离上面
    float btnWidth = (KScreenWidth-2*leftX-(rowCount-1)*distanse)/rowCount;
    float btnHeight = (KeyboardHeight-2*top-3*distanseTop)/4;
    
    //第一排
    for (int i = 0; i<10; i++) {
        float kx = leftX+(distanse + btnWidth)*i;
        UIButton *keyBoardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [keyBoardBtn setFrame:CGRectMake(kx, top, btnWidth, btnHeight)];
        keyBoardBtn.backgroundColor = [UIColor whiteColor];
        [keyBoardBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        keyBoardBtn.layer.masksToBounds = YES;
        keyBoardBtn.layer.cornerRadius = 6;
        [keyBoardBtn addTarget:self action:@selector(keyBoardInputAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [keyBoardBtn setTitle:newArr[i] forState:UIControlStateNormal];
        [self addSubview:keyBoardBtn];
    }
    
    //第二排
    float leftX2 = (KScreenWidth-9*btnWidth-8*distanse)/2;
    for (int i = 10; i<19; i++) {
        float kx = leftX2+(distanse + btnWidth)*(i-10);
        UIButton *keyBoardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [keyBoardBtn setFrame:CGRectMake(kx, top+distanseTop+btnHeight, btnWidth, btnHeight)];
        keyBoardBtn.backgroundColor = [UIColor whiteColor];
        [keyBoardBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        keyBoardBtn.layer.masksToBounds = YES;
        keyBoardBtn.layer.cornerRadius = 6;
        [keyBoardBtn setTitle:newArr[i] forState:UIControlStateNormal];
        [keyBoardBtn addTarget:self action:@selector(keyBoardInputAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:keyBoardBtn];
    }
    //第三排按钮第一个离左边距的距离
    float leftX3 = (KScreenWidth-7*btnWidth-6*distanse)/2;
    for (int i = 19; i<26; i++) {
        float kx = leftX3+(distanse + btnWidth)*(i-19);
        UIButton *keyBoardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [keyBoardBtn setFrame:CGRectMake(kx, top+(distanseTop+btnHeight)*2, btnWidth, btnHeight)];
        keyBoardBtn.layer.masksToBounds = YES;
        keyBoardBtn.layer.cornerRadius = 6;
        keyBoardBtn.backgroundColor = [UIColor whiteColor];
        [keyBoardBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [keyBoardBtn setTitle:newArr[i] forState:UIControlStateNormal];
        [keyBoardBtn addTarget:self action:@selector(keyBoardInputAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:keyBoardBtn];
    }
    //切换按钮
    UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    changeButton.frame = CGRectMake(leftX, top+(distanseTop+btnHeight)*2, leftX3-leftX-distanse, btnHeight);
    [changeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    changeButton.layer.masksToBounds = YES;
    changeButton.layer.cornerRadius = 6;
    changeButton.backgroundColor = DeleteBtnGrayColor;
    if ([type isEqualToString:@"abc"]) {
        [changeButton setTitle:@"ABC" forState:UIControlStateNormal];
        [changeButton addTarget:self action:@selector(changeABCKeyBoardStypeAction) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        [changeButton setTitle:@"abc" forState:UIControlStateNormal];
        [changeButton addTarget:self action:@selector(changeabckeyboardAction) forControlEvents:UIControlEventTouchUpInside];
    }
    [self addSubview:changeButton];
    
    //删除按钮
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame = CGRectMake(leftX3+btnWidth*7+distanse*7, top+(distanseTop+btnHeight)*2, leftX3-leftX-distanse, btnHeight);
    [deleteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    deleteButton.layer.masksToBounds = YES;
    deleteButton.layer.cornerRadius = 6;
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    deleteButton.backgroundColor = DeleteBtnGrayColor;
    [deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteButton];
    
    
    //第四列的按钮
    UIButton *defaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    defaultBtn.frame = CGRectMake(leftX, top+(distanseTop+btnHeight)*3,KScreenWidth-leftX*2-distanse-60, btnHeight);
    [defaultBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    defaultBtn.layer.masksToBounds = YES;
    defaultBtn.layer.cornerRadius = 8;
    [defaultBtn setTitle:@"安全键盘" forState:UIControlStateNormal];
    defaultBtn.backgroundColor = [UIColor whiteColor];
    // [defaultBtn addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:defaultBtn];
    
    
    //完成的按钮
    UIButton *finishedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    finishedButton.frame = CGRectMake(KScreenWidth-leftX-60, top+(distanseTop+btnHeight)*3,60, btnHeight);
    [finishedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [finishedButton setTitle:@"完成" forState:UIControlStateNormal];
    finishedButton.backgroundColor = FinishedBtnBlueColor;
    finishedButton.layer.masksToBounds = YES;
    finishedButton.layer.cornerRadius = 8;
    [finishedButton addTarget:self action:@selector(finished) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:finishedButton];
    
}

-(void)addOtherKeyboardView
{
    NSMutableArray *newArr = [NSMutableArray array];
    NSMutableArray *titleArray = [NSMutableArray arrayWithArray:@[@"[",@"]",@"{",@"}",@"#",@"%",@"^",@"*",@"+",@"=",@"_",@"-",@"/",@":",@";",@"(",@")",@"$",@"&",@"@",@".",@",",@"?",@"!",@"'",@"|",@"~",@"`",@"<",@">",@"£",@"€",@"¥",@"\\",@"\""]];
    while (titleArray.count>0) {
        int random = arc4random()%(titleArray.count);
        [newArr addObject:titleArray[random]];
        [titleArray removeObjectAtIndex:random];
    }
    
    int rowCount = 10;
    float leftX = 3.0;
    float distanse = 5.0;
    float distanseTop = 10.0;
    float top = 5.0;
    float btnWidth = (KScreenWidth-2*leftX-(rowCount-1)*distanse)/rowCount;
    float btnHeight = (KeyboardHeight-2*top-3*distanseTop)/4;
    
    //第一排,第二排，第三排
    for (int i = 0; i<28; i++) {
        float kx = leftX+(distanse + btnWidth)*(i%rowCount);
        float ky = top+(distanseTop+btnHeight)*(i/rowCount);
        UIButton *keyBoardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [keyBoardBtn setFrame:CGRectMake(kx, ky, btnWidth, btnHeight)];
        keyBoardBtn.backgroundColor = [UIColor whiteColor];
        [keyBoardBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [keyBoardBtn addTarget:self action:@selector(keyBoardInputAction:) forControlEvents:UIControlEventTouchUpInside];
        keyBoardBtn.layer.masksToBounds = YES;
        keyBoardBtn.layer.cornerRadius = 6;
        [keyBoardBtn setTitle:newArr[i] forState:UIControlStateNormal];
        [self addSubview:keyBoardBtn];
    }
    
    for (int j = 28; j<35; j++) {
        float kx = leftX+(distanse + btnWidth)*(j-28);
        UIButton *keyBoardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [keyBoardBtn setFrame:CGRectMake(kx, top+3*(distanseTop + btnHeight), btnWidth, btnHeight)];
        keyBoardBtn.backgroundColor = [UIColor whiteColor];
        [keyBoardBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        keyBoardBtn.layer.masksToBounds = YES;
        keyBoardBtn.layer.cornerRadius = 6;
        [keyBoardBtn addTarget:self action:@selector(keyBoardInputAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [keyBoardBtn setTitle:newArr[j] forState:UIControlStateNormal];
        [self addSubview:keyBoardBtn];
        
    }
    
    
    //删除按钮
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame = CGRectMake(KScreenWidth-leftX-distanse-2*btnWidth, top+2*(btnHeight+distanseTop),2*btnWidth+distanse, btnHeight);
    [deleteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    deleteButton.backgroundColor = DeleteBtnGrayColor;
    deleteButton.layer.masksToBounds = YES;
    deleteButton.layer.cornerRadius = 8;
    [deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteButton];
    
    
    
    //完成的按钮
    UIButton *finishedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    finishedButton.frame = CGRectMake(KScreenWidth-leftX-3*btnWidth-2*distanse, top+(distanseTop+btnHeight)*3,3*btnWidth+2*distanse, btnHeight);
    [finishedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [finishedButton setTitle:@"完成" forState:UIControlStateNormal];
    finishedButton.backgroundColor = FinishedBtnBlueColor;
    finishedButton.layer.masksToBounds = YES;
    finishedButton.layer.cornerRadius = 8;
    [finishedButton addTarget:self action:@selector(finished) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:finishedButton];
}

#pragma mark  点击完成按钮
-(void)finished{
    if (_delegate && [_delegate respondsToSelector:@selector(finishedAction)]) {
        [_delegate finishedAction];
    }
}
#pragma mark  点击删除按钮
-(void)deleteButtonAction :(UIButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(deleteBtnAction)]) {
        [_delegate deleteBtnAction];
    }
}
#pragma mark  点击键盘输入按钮
-(void)keyBoardInputAction :(UIButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(inputKeyboard:)]) {
        [_delegate inputKeyboard:button.titleLabel.text];
    }
}
#pragma mark  点击切换大写字母按钮
-(void)changeABCKeyBoardStypeAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(changeABCKeyboard)]) {
        [_delegate changeABCKeyboard];
    }
}
#pragma mark  点击切换小写字母按钮
-(void)changeabckeyboardAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(changeabcKeyboard)]) {
        [_delegate changeabcKeyboard];
    }
}
@end
