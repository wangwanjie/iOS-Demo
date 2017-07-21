//
//  GQTopSegView.m
//  iGuiQuan
//
//  Created by jintang on 15/5/5.
//  Copyright (c) 2015年 iMiner. All rights reserved.
//

#import "LGMenuSegView.h"
#define GQColor_DefaultRed  [UIColor redColor]
#define KscreenWidth [UIScreen mainScreen].bounds.size.width
#define LineGrayColor  [UIColor colorWithRed:154.0/255.0 green:163.0/255.0 blue:176.0/255.0 alpha:1.0]

@implementation LGMenuSegView


-(id)initWithFrame : (CGRect)frame  TitleArray :(NSArray *)titleArray
{
    self = [super initWithFrame:frame];
    if (self) {
         _titleArray = [NSArray array];
        currentIndex = 0;
        _titleArray = titleArray;
        float btnWidth = KscreenWidth/titleArray.count;
        for (int i =0; i<titleArray.count; i++) {
            UIButton *topButton = [[UIButton alloc]initWithFrame:CGRectMake(i*btnWidth,0,btnWidth,frame.size.height)];
            topButton.tag = 30+i;
            topButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            
            [topButton setTitle:titleArray[i] forState:UIControlStateNormal];
            topButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
            [topButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:topButton];
        
            if (i == 0) {
                [topButton setTitleColor:GQColor_DefaultRed forState:UIControlStateNormal];

            }else{
                [topButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        
//            //添加分割线
//            if (i != 0) {
//                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(KscreenWidth/3*i, 0, 0.7, self.frame.size.height)];
//                lineView.backgroundColor = LineGrayColor;
//                [self addSubview:lineView];
//            }
            
        }
    }
        return self;
}
-(void)buttonAction:(UIButton *)button
{
    if (currentIndex == button.tag-30) {
        return;
    }
    UIButton *choiceButton = (UIButton *)[self viewWithTag:30+currentIndex];
    [choiceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    currentIndex = button.tag-30;
    [button setTitleColor:GQColor_DefaultRed forState:UIControlStateNormal];
    if (_delegate && [_delegate respondsToSelector:@selector(clickButton:)]) {
        [_delegate clickButton:button.tag-30];
    }
}
#pragma mark 点击某个按钮
-(void)clickButton:(int)scrollIndex
{
    if (currentIndex==scrollIndex) {
        return;
    }
    UIButton *choiceButton = (UIButton *)[self viewWithTag:30+currentIndex];
    [choiceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIView *lineView = [self viewWithTag:50+currentIndex];
    lineView.backgroundColor = [UIColor clearColor];
    
    currentIndex = scrollIndex;
    UIButton *curentButton = (UIButton *)[self viewWithTag:30+currentIndex];
    [curentButton setTitleColor:GQColor_DefaultRed forState:UIControlStateNormal];
    
    UIView *lineViews = [self viewWithTag:currentIndex+50];
    lineViews.backgroundColor = GQColor_DefaultRed;
    
    if (_delegate && [_delegate respondsToSelector:@selector(clickButton:)]) {
        [_delegate clickButton:curentButton.tag-30];
    }

}

@end
