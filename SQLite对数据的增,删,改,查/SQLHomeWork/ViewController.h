//
//  ViewController.h
//  SQLHomeWork
//
//  Created by mac on 16/8/16.
//  Copyright © 2016年 huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameLabel;

@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;

@property (weak, nonatomic) IBOutlet UITextField *ageLabel;

@property(nonatomic,strong)UserModel *model;
@end

