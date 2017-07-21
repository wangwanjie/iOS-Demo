//
//  UpdatViewController.h
//  SQLHomeWork
//
//  Created by mac on 16/8/17.
//  Copyright © 2016年 huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface UpdatViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *ageTF;

@property(nonatomic,strong) UserModel *model;

@end
