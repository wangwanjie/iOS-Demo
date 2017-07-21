//
//  ViewController.m
//  SQLHomeWork
//
//  Created by mac on 16/8/16.
//  Copyright © 2016年 huang. All rights reserved.
//

#import "ViewController.h"
#import "DatabaseManager.h"
#import "UserModel.h"


@interface ViewController (){
    DatabaseManager *manager;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:160.0/255
                                                     green:255.0/255
                                                      blue:234.0/255 alpha:1];
    
    manager = [DatabaseManager shareManager];
    

}

- (void) changeNavBarStyle{
    NSDictionary *attribute = @{
                                NSForegroundColorAttributeName:[UIColor whiteColor]
                                };
    self.navigationController.navigationBar.backgroundColor = [UIColor greenColor];
    self.navigationController.navigationBar.titleTextAttributes = attribute;
}

- (IBAction)addDatabase:(id)sender {
    _model = [[UserModel alloc] init];
    self.model.username = _usernameLabel.text;
    self.model.password = _passwordLabel.text;
    self.model.age = [_ageLabel.text intValue];
//
        [manager addUserModel:_model];
    
    [self changeNavBarStyle];

        [self.navigationController popViewControllerAnimated:YES];
    
    
}

@end
