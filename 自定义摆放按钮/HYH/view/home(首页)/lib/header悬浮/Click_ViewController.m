//
//  Click_ViewController.m
//  header
//
//  Created by yu on 15/8/26.
//  Copyright (c) 2015年 yu. All rights reserved.
//

#import "Click_ViewController.h"

@interface Click_ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *clickImage;

@end

@implementation Click_ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //默认是不能与用户交互
    self.clickImage.userInteractionEnabled = YES;
    
    //手势识别器
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    
    //创建手势，因为imageView的父类有一个加识别器的方法
    [self.clickImage addGestureRecognizer:tap];
    
    //点击一次就有相应
    tap.numberOfTapsRequired = 1;
    
    //有一根手指就有相应
    tap.numberOfTouchesRequired = 1;
    
    //监听手势识别器
    [tap addTarget:self action:@selector(addClick)];
    
}

- (void) addClick{
    
    NSLog(@"点击");
}


@end
