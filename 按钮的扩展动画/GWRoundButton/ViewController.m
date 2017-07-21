//
//  ViewController.m
//  GWRoundButton
//
//  Created by mac on 16/8/3.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ViewController.h"

#import "GWRoundView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self setGWRoundButtonView];
    
    
}

//添加自定义视图
-(void)setGWRoundButtonView{
    
    GWRoundView *roundView = [[GWRoundView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.width)];
    [self.view addSubview:roundView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
