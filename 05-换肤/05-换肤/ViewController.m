//
//  ViewController.m
//  05-换肤
//
//  Created by xiaomage on 15/11/7.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "ViewController.h"
#import "SkinTool.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backView;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // 2. 设置图片
        [self setImage];
}



//切换中秋主题
- (IBAction)zhongqiu:(id)sender {
    // 设置主题
    [SkinTool setSkin:kThemeTypeZQ];
    
    // 根据主题, 设置图片
      [self setImage];
    
}

//切换国庆
- (IBAction)guoqing:(id)sender {
    // 设置主题
    [SkinTool setSkin:kThemeTypeGQ];
    
    // 根据主题, 设置图片
    [self setImage];
}


//切换春节
- (IBAction)chunjie:(id)sender {
    
    // 设置主题
    [SkinTool setSkin:kThemeTypeCJ];
    
    // 根据主题, 设置图片
    [self setImage];
}


- (void)setImage
{

    // 当前主题下的背景图片
    self.backView.image = [SkinTool getImageWithType:kImageTypeBack];
    
    // 当前主题下的按钮图片
    [self.btn setBackgroundImage:[SkinTool getImageWithType:kImageTypeIcon] forState:UIControlStateNormal];
    
    // 根据当前的主题, 设置不同的文本颜色
    self.label.textColor = [SkinTool getColor:kColorTypeLabel];

 
}




@end
