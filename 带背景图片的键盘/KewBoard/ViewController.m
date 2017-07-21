//
//  ViewController.m
//  KewBoard
//
//  Created by XuTianyu on 16/4/1.
//  Copyright © 2016年 Lakala. All rights reserved.
//

#import "ViewController.h"
#import "XTYRandomKeyboard.h"
@interface ViewController ()<UITextFieldDelegate>

@end

@implementation ViewController
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    /*不建议每次点击都随机键盘，随机键盘只是为了避免键盘监控的，同一输入点每次都随机，会给用户造成学习成本*/
    XTYRandomKeyboard *keyBoad = [[XTYRandomKeyboard alloc] initWithTitleColor:[UIColor blackColor] backGroundImage:[UIImage imageNamed:@"bg.jpg"]];
    [keyBoad setInputView:textField];
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 100, 44)];
    textField.backgroundColor = [UIColor lightGrayColor];
    textField.delegate = self;
    
    XTYRandomKeyboard *keyBoad = [[XTYRandomKeyboard alloc] initWithTitleColor:[UIColor blackColor] backGroundImage:[UIImage imageNamed:@"bg.jpg"]];
    [keyBoad setInputView:textField];
    [self.view addSubview:textField];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
