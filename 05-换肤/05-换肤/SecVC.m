//
//  SecVC.m
//  05-换肤
//
//  Created by xiaomage on 15/11/7.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "SecVC.h"
#import "SkinTool.h"

#define theme @"theme"

@interface SecVC ()

@property (weak, nonatomic) IBOutlet UIImageView *backView;

@property (weak, nonatomic) IBOutlet UIButton *btn;


@end

@implementation SecVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setImage];

}

- (void)setImage
{
    
    // 当前主题下的背景图片
    self.backView.image = [SkinTool getImageWithType:kImageTypeBack];
    
    // 当前主题下的按钮图片
    [self.btn setBackgroundImage:[SkinTool getImageWithType:kImageTypeIcon] forState:UIControlStateNormal];
 
}


@end
