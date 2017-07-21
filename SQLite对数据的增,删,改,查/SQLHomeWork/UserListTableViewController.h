//
//  UserListTableViewController.h
//  SQLHomeWork
//
//  Created by mac on 16/8/16.
//  Copyright © 2016年 huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpdatViewController.h"

@interface UserListTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UpdatViewController *updateVC;

@end
