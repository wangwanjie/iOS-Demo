//
//  HomeViewController.m
//  HorseRaceLampDemo
//
//  Created by 铅笔 on 16/7/6.
//  Copyright © 2016年 铅笔. All rights reserved.
//

#import "HomeViewController.h"
#import "MarqueeDemoPage.h"//跑马灯

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"首页";
    
    [self initWithAllSubviews];
}

/**
 *  创建视图 总界面
 */
- (void) initWithAllSubviews
{
 
        UIButton *button_temp = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, self.view.frame.size.width-40,30)];
        [self.view addSubview:button_temp];
        button_temp.backgroundColor = [UIColor greenColor];
        [button_temp setTitle:@"SXMarquee跑马灯" forState:UIControlStateNormal];
        [button_temp setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
        [button_temp addTarget:self action:@selector(clickDifferentButton:) forControlEvents:UIControlEventTouchUpInside];

}

/**
 *  点击不同的按钮 执行任务
 */
- (void) clickDifferentButton:(UIButton *)sender
{
    
        //跑马灯
        MarqueeDemoPage *marqueeView = [[MarqueeDemoPage alloc] init];
        [self.navigationController pushViewController:marqueeView animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
